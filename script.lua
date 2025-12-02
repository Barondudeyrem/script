local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Toggle dəyişənləri
local infJumpEnabled = false
local speedEnabled = false
local espEnabled = false
local noclipEnabled = false
local fullbrightEnabled = false
local speedValue = 50

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleMenuButton = Instance.new("TextButton", screenGui)
toggleMenuButton.Size = UDim2.new(0,50,0,50)
toggleMenuButton.Position = UDim2.new(0,10,0,10)
toggleMenuButton.Text = "≡"
toggleMenuButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleMenuButton.TextColor3 = Color3.fromRGB(255,255,255)

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0,200,0,300)
menuFrame.Position = UDim2.new(0,10,0,70)
menuFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
menuFrame.Visible = false

toggleMenuButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton", menuFrame)
    btn.Size = UDim2.new(0,180,0,40)
    btn.Position = UDim2.new(0,10,0,posY)
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

-- Toggles
createToggle("Inf Jump", 10, function() infJumpEnabled = not infJumpEnabled end)
createToggle("Speed", 60, function() speedEnabled = not speedEnabled end)
createToggle("ESP", 110, function() espEnabled = not espEnabled end)
createToggle("NoClip", 160, function() noclipEnabled = not noclipEnabled end)
createToggle("FullBright", 210, function()
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.new(0.5,0.5,0.5)
        Lighting.Brightness = 1
    end
end)

-- İnfinite Jump
UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed
RunService.RenderStepped:Connect(function()
    if speedEnabled then
        humanoid.WalkSpeed = speedValue
    else
        humanoid.WalkSpeed = 16
    end
end)

-- NoClip
RunService.RenderStepped:Connect(function()
    if noclipEnabled then
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

-- ESP (placeholder)
RunService.RenderStepped:Connect(function()
    if espEnabled then
        -- ESP kodunu buraya əlavə edə bilərsən
    end
end)
