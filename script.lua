-- BARON MENU v2 (Infinite Jump, Speed, ESP, NoClip, FullBright)

-- GUI yarat
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local InfiniteJumpBtn = Instance.new("TextButton")
local SpeedBtn = Instance.new("TextButton")
local ESPBtn = Instance.new("TextButton")
local NoClipBtn = Instance.new("TextButton")
local FullBrightBtn = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

Frame.Size = UDim2.new(0, 200, 0, 280)
Frame.Position = UDim2.new(0, 20, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.Parent = ScreenGui

Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🎭 BARON MENU"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Parent = Frame

-- BUTTON CREATOR
function makeButton(btn, txt, y)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = txt
    btn.Parent = Frame
end

makeButton(InfiniteJumpBtn, "Infinite Jump", 50)
makeButton(SpeedBtn, "Speed x2", 95)
makeButton(ESPBtn, "ESP ON", 140)
makeButton(NoClipBtn, "NoClip", 185)
makeButton(FullBrightBtn, "FullBright", 230)

--------------------------------------------
-- INFINITE JUMP
--------------------------------------------
local InfiniteJump = false
InfiniteJumpBtn.MouseButton1Click:Connect(function()
    InfiniteJump = not InfiniteJump
    InfiniteJumpBtn.Text = InfiniteJump and "Infinite Jump ✓" or "Infinite Jump"
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJump then
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
        end
    end
end)


--------------------------------------------
-- SPEED
--------------------------------------------
local SpeedOn = false
SpeedBtn.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn
    SpeedBtn.Text = SpeedOn and "Speed ✓" or "Speed x2"
    if SpeedOn then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)


--------------------------------------------
-- ESP
--------------------------------------------
local ESPEnabled = false

function createESP(player)
    if player == game.Players.LocalPlayer then return end
    local Highlight = Instance.new("Highlight")
    Highlight.FillColor = Color3.fromRGB(255,0,0)
    Highlight.OutlineColor = Color3.fromRGB(0,0,0)
    Highlight.Parent = player.Character
end

ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPBtn.Text = ESPEnabled and "ESP ✓" or "ESP ON"

    if ESPEnabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then createESP(plr) end
        end
        game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if ESPEnabled then createESP(plr) end
            end)
        end)
    else
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Highlight") then
                plr.Character.Highlight:Destroy()
            end
        end
    end
end)


--------------------------------------------
-- NOCLIP
--------------------------------------------
local noclip = false

NoClipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoClipBtn.Text = noclip and "NoClip ✓" or "NoClip"
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)


--------------------------------------------
-- FULLBRIGHT
--------------------------------------------
local FullBright = false
local Lighting = game.Lighting

FullBrightBtn.MouseButton1Click:Connect(function()
    FullBright = not FullBright
    FullBrightBtn.Text = FullBright and "FullBright ✓" or "FullBright"

    if FullBright then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
    else
        Lighting.Ambient = Color3.fromRGB(0,0,0)
        Lighting.Brightness = 1
    end
end)
