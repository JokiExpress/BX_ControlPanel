-- ==========================
-- Modul ESP
-- ==========================
local ESPModule = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ==========================
-- Fungsi ESP untuk satu pemain
-- ==========================
local function createESP(player)
    if player == LocalPlayer then return end

    local function onCharacter(char)
        if not char then return end

        -- Highlight merah
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.OutlineTransparency = 0
        highlight.FillTransparency = 0.6
        highlight.Parent = Workspace

        -- Nama pemain di atas kepala
        local head = char:FindFirstChild("Head")
        if head then
            if not head:FindFirstChild("ESPName") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPName"
                billboard.Adornee = head
                billboard.Size = UDim2.new(0,100,0,30)
                billboard.StudsOffset = Vector3.new(0,2,0)
                billboard.AlwaysOnTop = true
                billboard.Parent = char

                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "Label"
                textLabel.Size = UDim2.new(1,0,1,0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = player.Name
                textLabel.TextColor3 = Color3.fromRGB(255,0,0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.Parent = billboard
            end
        end
    end

    player.CharacterAdded:Connect(onCharacter)
    if player.Character then onCharacter(player.Character) end
end

-- ==========================
-- Setup ESP untuk semua pemain
-- ==========================
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(createESP)

-- ==========================
-- Modul API
-- ==========================
function ESPModule.Enable()
    -- Jika ingin toggle tambahan, bisa ditambahkan di sini
    print("ESP Enabled")
end

function ESPModule.Disable()
    -- Hapus semua ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then highlight:Destroy() end

            local head = player.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("ESPName")
                if billboard then billboard:Destroy() end
            end
        end
    end
    print("ESP Disabled")
end

return ESPModule
