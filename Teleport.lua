-- ==========================
-- Modul Teleport
-- ==========================
local TeleportModule = {}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================
-- Fungsi teleport ke pemain
-- ==========================
local function teleportToPlayer(targetName)
    for _, player in pairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(targetName) then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = player.Character.HumanoidRootPart.CFrame
                    print("Teleported ke "..player.Name)
                end
                return
            end
        end
    end
    print("Pemain "..targetName.." tidak ditemukan atau karakter belum siap!")
end

-- ==========================
-- Chat Command Listener
-- ==========================
local chatConnection
function TeleportModule.Enable()
    if chatConnection then return end
    chatConnection = LocalPlayer.Chatted:Connect(function(msg)
        local targetName = string.match(msg, "!tele%s+(%S+)")
        if targetName then
            teleportToPlayer(targetName)
        end
    end)
    print("Teleport Module Enabled")
end

function TeleportModule.Disable()
    if chatConnection then
        chatConnection:Disconnect()
        chatConnection = nil
    end
    print("Teleport Module Disabled")
end

return TeleportModule
