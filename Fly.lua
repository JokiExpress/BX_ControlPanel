-- ==========================
-- Modul Fly
-- ==========================
local FlyModule = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variabel Fly
local flying = false
local normalSpeed = 50
local fastSpeed = 150
local bodyVelocity
local bodyGyro
local keys = {W=false, A=false, S=false, D=false, Space=false, LeftShift=false}

-- Noclip
local function setNoclip(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- Start Fly
local function startFlying()
    if flying then return end
    flying = true
    setNoclip(true)

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    humanoid.WalkSpeed = 0
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bodyGyro.P = 3000
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
end

-- Stop Fly
local function stopFlying()
    flying = false
    setNoclip(false)

    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.PlatformStand = false
        end
    end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity=nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro=nil end
end

-- Input tracking
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift = false end
end)

-- Fly update per frame
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and bodyGyro then
        local moveDir = Vector3.new(0,0,0)
        local camCFrame = Camera.CFrame
        local forward = camCFrame.LookVector
        local right = camCFrame.RightVector

        if keys.W then moveDir = moveDir + forward end
        if keys.S then moveDir = moveDir - forward end
        if keys.D then moveDir = moveDir + right end
        if keys.A then moveDir = moveDir - right end
        if keys.Space then moveDir = moveDir + Vector3.new(0,1,0) end
        if keys.LeftShift then moveDir = moveDir - Vector3.new(0,1,0) end

        if moveDir.Magnitude > 0 then
            local speed = keys.LeftShift and fastSpeed or normalSpeed
            bodyVelocity.Velocity = moveDir.Unit * speed
            bodyGyro.CFrame = CFrame.new(bodyVelocity.Parent.Position, bodyVelocity.Parent.Position + moveDir)
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyGyro.CFrame = CFrame.new(bodyVelocity.Parent.Position, bodyVelocity.Parent.Position + Camera.CFrame.LookVector)
        end
    end
end)

-- ==========================
-- Modul API
-- ==========================
function FlyModule.Enable()
    startFlying()
end

function FlyModule.Disable()
    stopFlying()
end

return FlyModule
