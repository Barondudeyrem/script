-- ROBLOX LOCAL SCRIPT
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Toggle dəyişənləri
local infJumpEnabled = false
local speedEnabled = false
local espEnabled = false
local speedValue = 50

-- ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Aç/Bağla düyməsi
local toggleMenuButton = Instance.new("TextButton", screenGui)
toggleMenuButton.Size = UDim2.new(0, 50, 0, 50)
toggleMenuButton.Position = UDim2.new(0, 10, 0, 10)
toggleMenuButton.Text = "≡"
toggleMenuButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleMenuButton.TextColor3 = Color3.fromRGB(255,255,255)

-- Menu Frame
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 200, 0, 200)
menuFrame.Position = UDim2.new(0, 10, 0, 70)
menuFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
menuFrame.Visible = false

-- Aç/Bağla funksiyası
toggleMenuButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Funksiya: toggle düymə yaratmaq
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton", menuFrame)
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name .. ": OFF"
    
    btn.MouseButton1Click:Connect(function()
        callback()
        if btn.Text:find("OFF") then
            btn.Text = name .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            btn.Text = name .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end
    end)
end

-- Inf Jump toggle
createToggle("Inf Jump", 10, function()
    infJumpEnabled = not infJumpEnabled
end)

-- Speed toggle
createToggle("Speed", 60, function()
    speedEnabled = not speedEnabled
end)

-- ESP toggle (sadəcə nümunə, oyununa görə dəyişəcək)
createToggle("ESP", 110, function()
    espEnabled = not espEnabled
end)

-- İnfinite jump sistemi
UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed sistemi
RunService.RenderStepped:Connect(function()
    if speedEnabled then
        humanoid.WalkSpeed = speedValue
    else
        humanoid.WalkSpeed = 16
    end
end)

-- ESP sistemi (sadəcə nümunə)
RunService.RenderStepped:Connect(function()
    if espEnabled then
        -- Buraya ESP kodunu əlavə edə bilərsən
    end
end)
