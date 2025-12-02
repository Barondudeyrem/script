-- BARON STYLE MOBILE GUI (Infini Jump, Speed, Noclip, ESP)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "BaronGUI"

-- Frame (Menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Visible = false

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "BARON"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255,0,0)
title.Parent = frame

-- Düymələri yaratmaq funksiyası
local function createButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, positionY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = frame
    return btn
end

-- Funksiyaları aktivləşdirmək üçün flaglər
local infiniJump = false
local speedHack = false
local noclip = false
local esp = false

-- Infini Jump
local infiniJumpBtn = createButton("Infini Jump", 0.2)
uis.InputBegan:Connect(function(input, gameProcessed)
    if infiniJump and input.UserInputType == Enum.UserInputType.Touch then
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
infiniJumpBtn.MouseButton1Click:Connect(function()
    infiniJump = not infiniJump
    infiniJumpBtn.Text = infiniJump and "Infini Jump Açıq" or "Infini Jump Bağlı"
end)

-- Speed Hack
local speedBtn = createButton("Speed Hack", 0.4)
local normalSpeed = character.Humanoid.WalkSpeed
local speedAmount = 50
speedBtn.MouseButton1Click:Connect(function()
    speedHack = not speedHack
    speedBtn.Text = speedHack and "Speed Açıq" or "Speed Bağlı"
    if speedHack then
        character.Humanoid.WalkSpeed = speedAmount
    else
        character.Humanoid.WalkSpeed = normalSpeed
    end
end)

-- Noclip
local noclipBtn = createButton("Noclip", 0.6)
runService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "Noclip Açıq" or "Noclip Bağlı"
end)

-- ESP
local espBtn = createButton("ESP", 0.8)
local function createESP(player)
    if player ~= game.Players.LocalPlayer and player.Character and not player.Character:FindFirstChild("ESPBox") then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(2,3,1)
        box.Color3 = Color3.fromRGB(0,0,255)
        box.Transparency = 0.5
        box.Parent = player.Character:FindFirstChild("HumanoidRootPart")
        box.Name = "ESPBox"
    end
end
espBtn.MouseButton1Click:Connect(function()
    esp = not esp
    espBtn.Text = esp and "ESP Açıq" or "ESP Bağlı"
    if esp then
        for _, p in pairs(game.Players:GetPlayers()) do
            createESP(p)
        end
        game.Players.PlayerAdded:Connect(function(p)
            createESP(p)
        end)
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local box = p.Character.HumanoidRootPart:FindFirstChild("ESPBox")
                if box then box:Destroy() end
            end
        end
    end
end)

-- Menu açma düyməsi (mobil)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 80, 0, 40)
openButton.Position = UDim2.new(0.9, -80, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
openButton.Text = "Menu"
openButton.TextColor3 = Color3.fromRGB(255,255,255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 18
openButton.Parent = screenGui

local guiOpen = false
openButton.MouseButton1Click:Connect(function()
    guiOpen = not guiOpen
    frame.Visible = guiOpen
end)
