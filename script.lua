-- BARON GUI v2 (FULL ESP + OPEN/CLOSE + EFFECTS)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ======= GUI CREATION =======
local function createGUI()
    if LocalPlayer.PlayerGui:FindFirstChild("BaronGUI") then
        LocalPlayer.PlayerGui.BaronGUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BaronGUI"
    ScreenGui.Parent = LocalPlayer.PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 450)
    Frame.Position = UDim2.new(0.5, -150, 0.4, -225)
    Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Frame.BorderSizePixel = 0
    Frame.Visible = true
    Frame.Parent = ScreenGui

    -- RGB Border
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Parent = Frame
    RunService.RenderStepped:Connect(function()
        local t = tick()*2
        UIStroke.Color = Color3.fromHSV(t%1,1,1)
    end)

    -- Scroll Frame
    local Scroller = Instance.new("ScrollingFrame")
    Scroller.Size = UDim2.new(1,0,1,0)
    Scroller.BackgroundTransparency = 1
    Scroller.ScrollBarThickness = 6
    Scroller.CanvasSize = UDim2.new(0,0,0,600)
    Scroller.Parent = Frame

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40)
    Title.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Title.Text = "BARON"
    Title.TextColor3 = Color3.fromRGB(255,0,0)
    Title.TextScaled = true
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = Scroller

    -- Button creator
    local function NewBtn(text,y,callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,260,0,40)
        btn.Position = UDim2.new(0,20,0,y)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 20
        btn.Text = text
        btn.Parent = Scroller

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,0,200)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(50,50,50)}):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local yPos = 50

    -- ===== INFINITE JUMP =====
    local infJump=false
    NewBtn("Toggle Infinite Jump",yPos,function() infJump = not infJump end)
    yPos = yPos + 60
    UIS.JumpRequest:Connect(function()
        if infJump then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end
    end)

    -- ===== SPEED =====
    local speedOn=false
    local speedValue=50
    NewBtn("Toggle Speed Hack",yPos,function()
        speedOn = not speedOn
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speedOn and speedValue or 16 end
    end)
    yPos = yPos + 60

    -- ===== NOCLIP =====
    local noclipOn=false
    NewBtn("Toggle Noclip",yPos,function() noclipOn = not noclipOn end)
    yPos = yPos + 60
    RunService.Stepped:Connect(function()
        if noclipOn and LocalPlayer.Character then
            for _,part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end)

    -- ===== FULLBRIGHT =====
    local fullbrightOn=false
    local oldLighting={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,FogEnd=Lighting.FogEnd,Ambient=Lighting.Ambient}
    NewBtn("Toggle Fullbright",yPos,function()
        fullbrightOn = not fullbrightOn
        if fullbrightOn then
            Lighting.Brightness=2
            Lighting.ClockTime=14
            Lighting.FogEnd=100000
            Lighting.Ambient=Color3.fromRGB(255,255,255)
        else
            Lighting.Brightness=oldLighting.Brightness
            Lighting.ClockTime=oldLighting.ClockTime
            Lighting.FogEnd=oldLighting.FogEnd
            Lighting.Ambient=oldLighting.Ambient
        end
    end)
    yPos = yPos + 60

    -- ===== ESP BOX =====
    local espOn=false
    local boxes={}
    local function createBox(plr)
        if plr==LocalPlayer then return end
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local box = Drawing.new("Square")
            box.Color = Color3.fromRGB(0,255,0)
            box.Thickness = 2
            box.Filled = false
            boxes[plr] = box
        end
    end
    local function removeBox(plr)
        if boxes[plr] then boxes[plr]:Remove() boxes[plr]=nil end
    end
    NewBtn("Toggle ESP Box",yPos,function()
        espOn = not espOn
        for _,plr in ipairs(Players:GetPlayers()) do
            if espOn then createBox(plr) else removeBox(plr) end
        end
    end)
    yPos = yPos + 60
    RunService.RenderStepped:Connect(function()
        if espOn then
            for plr,box in pairs(boxes) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local root=plr.Character.HumanoidRootPart
                    local pos,vis = Camera:WorldToViewportPoint(root.Position)
                    box.Position = Vector2.new(pos.X,pos.Y)
                    box.Size = Vector2.new(50,100)
                    box.Visible=vis
                end
            end
        end
    end)

    Scroller.CanvasSize = UDim2.new(0,0,yPos+50)

    -- ===== OPEN/CLOSE GUI =====
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode==Enum.KeyCode.RightShift then
            Frame.Visible = not Frame.Visible
        end
    end)
end

createGUI()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    createGUI()
end)
