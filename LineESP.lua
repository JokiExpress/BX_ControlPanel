-- ==========================
-- Modul LineESP
-- ==========================
local LineESPModule = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================
-- Table untuk garis
-- ==========================
local lines = {}

-- ==========================
-- Fungsi buat garis untuk pemain
-- ==========================
local function createLineForPlayer(player)
    if player == LocalPlayer then return end
    local line = Drawing.new("Line")
    line.Visible = true
    line.Color = Color3.fromRGB(255,255,255)
    line.Thickness = 1.5
    line.Transparency = 1
    lines[player] = line
end

-- Buat garis untuk semua pemain yang sudah ada
for _, p in ipairs(Players:GetPlayers()) do
    createLineForPlayer(p)
end

-- Update saat pemain join
Players.PlayerAdded:Connect(createLineForPlayer)

-- Hapus garis saat pemain keluar
Players.PlayerRemoving:Connect(function(p)
    if lines[p] then
        lines[p]:Remove()
        lines[p] = nil
    end
end)

-- ==========================
-- Update setiap frame
-- ==========================
local function updateLines()
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for player, line in pairs(lines) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local myPos, myOnScreen = Camera:WorldToViewportPoint(myHRP.Position)
            local theirPos, theirOnScreen = Camera:WorldToViewportPoint(hrp.Position)
            if myOnScreen and theirOnScreen then
                line.From = Vector2.new(myPos.X, myPos.Y)
                line.To = Vector2.new(theirPos.X, theirPos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

-- ==========================
-- Modul API
-- ==========================
local connection
function LineESPModule.Enable()
    connection = RunService.RenderStepped:Connect(updateLines)
    print("LineESP Enabled")
end

function LineESPModule.Disable()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    -- Hapus semua garis
    for _, line in pairs(lines) do
        line:Remove()
    end
    lines = {}
    print("LineESP Disabled")
end

return LineESPModule
