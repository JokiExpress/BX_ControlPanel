-- ==========================
-- BX Control Panel GUI v2
-- ==========================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ==========================
-- ScreenGui
-- ==========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BX_Control"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- ==========================
-- LOGIN FRAME
-- ==========================
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 320, 0, 180)
loginFrame.Position = UDim2.new(0.5, -160, 0.4, -90)
loginFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
loginFrame.BorderSizePixel = 0
loginFrame.AnchorPoint = Vector2.new(0.5,0.5)
loginFrame.Parent = screenGui
loginFrame.ClipsDescendants = true
loginFrame.Visible = true

-- Drag GUI
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
loginFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = loginFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
loginFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        loginFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title
local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1,0,0,60)
loginTitle.Position = UDim2.new(0,0,0,0)
loginTitle.BackgroundColor3 = Color3.fromRGB(60,60,60)
loginTitle.Text = "🔑 BX Key Login"
loginTitle.Font = Enum.Font.SourceSansBold
loginTitle.TextSize = 24
loginTitle.TextColor3 = Color3.fromRGB(255,255,255)
loginTitle.Parent = loginFrame

-- Key Input
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.9,0,0,50)
keyBox.Position = UDim2.new(0.05,0,0.45,0)
keyBox.PlaceholderText = "Masukkan Key..."
keyBox.ClearTextOnFocus = true
keyBox.TextColor3 = Color3.fromRGB(0,0,0)
keyBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
keyBox.Font = Enum.Font.SourceSans
keyBox.TextSize = 20
keyBox.Parent = loginFrame

-- Login Button
local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(0.5,0,0,45)
loginBtn.Position = UDim2.new(0.25,0,0.75,0)
loginBtn.Text = "Login"
loginBtn.Font = Enum.Font.SourceSansBold
loginBtn.TextSize = 20
loginBtn.TextColor3 = Color3.fromRGB(255,255,255)
loginBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
loginBtn.Parent = loginFrame

-- ==========================
-- CONTROL PANEL FRAME
-- ==========================
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 400)
frame.Position = UDim2.new(0.5, -175, 0.4, -200)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Visible = false
frame.Parent = screenGui
frame.ClipsDescendants = true

-- Drag Control Panel
local dragging2, dragInput2, dragStart2, startPos2 = false, nil, nil, nil
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging2 = true
        dragStart2 = input.Position
        startPos2 = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging2 = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput2 = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput2 and dragging2 then
        local delta = input.Position - dragStart2
        frame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X,
                                    startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Text = "⚙️ BX Control Panel"
title.Size = UDim2.new(1,0,0,50)
title.BackgroundColor3 = Color3.fromRGB(60,60,60)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = frame

-- Tombol collapse & hapus GUI
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "-"
toggleBtn.Size = UDim2.new(0,40,0,40)
toggleBtn.Position = UDim2.new(1,-45,0,5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 22
toggleBtn.Parent = frame

local destroyBtn = Instance.new("TextButton")
destroyBtn.Text = "X"
destroyBtn.Size = UDim2.new(0,40,0,40)
destroyBtn.Position = UDim2.new(1,-90,0,5)
destroyBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
destroyBtn.TextColor3 = Color3.fromRGB(255,255,255)
destroyBtn.Font = Enum.Font.SourceSansBold
destroyBtn.TextSize = 22
destroyBtn.Parent = frame

local collapsed = false
toggleBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        TweenService:Create(frame, TweenInfo.new(0.3), {Size=UDim2.new(0,350,0,50)}):Play()
        scrollFrame.Visible = false
        toggleBtn.Text = "+"
    else
        TweenService:Create(frame, TweenInfo.new(0.3), {Size=UDim2.new(0,350,0,400)}):Play()
        scrollFrame.Visible = true
        toggleBtn.Text = "-"
    end
end)

destroyBtn.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.3), {Size=UDim2.new(0,0,0,0)}):Play()
    TweenService:Create(loginFrame, TweenInfo.new(0.3), {Size=UDim2.new(0,0,0,0)}):Play()
    task.wait(0.35)
    screenGui:Destroy()
end)

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1,0,1,-55)
scrollFrame.Position = UDim2.new(0,0,0,55)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
scrollFrame.CanvasSize = UDim2.new(0,0,0,600)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame

-- ==========================
-- Fitur List dan Modul
-- ==========================
local featureList = {
    {Name="Fly", Module="Fly"},
    {Name="ESP", Module="ESP"},
    {Name="LineESP", Module="LineESP"},
    {Name="Teleport", Module="Teleport"},
    {Name="AdminLabel", Module="AdminLabel"}
}

local features = {}

for i, f in ipairs(featureList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Position = UDim2.new(0.05,0,0,(i-1)*50)
    btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Text = f.Name.." : OFF"
    btn.Parent = scrollFrame

    features[f.Name] = {Button=btn, State=false, Module=nil}

    btn.MouseButton1Click:Connect(function()
        local feat = features[f.Name]
        feat.State = not feat.State
        if feat.State then
            -- ON
            btn.BackgroundColor3 = Color3.fromRGB(50,200,50)
            btn.Text = f.Name.." : ON"
            -- Require modul jika belum
            if not feat.Module then
                local success, mod = pcall(function()
                    return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild(f.Module))
                end)
                if success then
                    feat.Module = mod
                    if feat.Module.Enable then
                        feat.Module.Enable()
                    end
                else
                    warn("Gagal load modul: "..f.Module)
                end
            else
                if feat.Module.Enable then feat.Module.Enable() end
            end
        else
            -- OFF
            btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
            btn.Text = f.Name.." : OFF"
            if feat.Module and feat.Module.Disable then
                feat.Module.Disable()
            end
        end
    end)
end

-- ==========================
-- Login System
-- ==========================
local key = "12345"
loginBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == key then
        TweenService:Create(loginFrame,TweenInfo.new(0.3),{Size=UDim2.new(0,0,0,0)}):Play()
        task.wait(0.35)
        loginFrame.Visible = false
        frame.Visible = true
    else
        keyBox.Text = ""
        loginTitle.Text = "❌ Key Salah!"
        loginTitle.TextColor3 = Color3.fromRGB(255,50,50)
        task.wait(1.5)
        loginTitle.Text = "🔑 BX Key Login"
        loginTitle.TextColor3 = Color3.fromRGB(255,255,255)
    end
end)

-- ==========================
-- Return fitur untuk modul lain jika perlu
-- ==========================
return features
