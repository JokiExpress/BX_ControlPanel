-- ==========================
-- Modul AdminLabel
-- ==========================
local AdminLabelModule = {}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function addAdminLabel()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")

    if not head:FindFirstChild("AdminLabel") then
        local adminBillboard = Instance.new("BillboardGui")
        adminBillboard.Name = "AdminLabel"
        adminBillboard.Adornee = head
        adminBillboard.Size = UDim2.new(0,120,0,50)
        adminBillboard.StudsOffset = Vector3.new(0,3,0)
        adminBillboard.AlwaysOnTop = true
        adminBillboard.Parent = char

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "ADMIN"
        textLabel.TextColor3 = Color3.fromRGB(255,0,0)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Parent = adminBillboard
    end
end

local conn
function AdminLabelModule.Enable()
    if conn then return end
    addAdminLabel()
    conn = LocalPlayer.CharacterAdded:Connect(addAdminLabel)
    print("AdminLabel Module Enabled")
end

function AdminLabelModule.Disable()
    if conn then
        conn:Disconnect()
        conn = nil
    end
    -- Optional: Hapus label
    local char = LocalPlayer.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head and head:FindFirstChild("AdminLabel") then
            head.AdminLabel:Destroy()
        end
    end
    print("AdminLabel Module Disabled")
end

return AdminLabelModule
