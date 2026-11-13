
-- PLAYER ESP - YOUR OWN ROBLOX EXPERIENCE
-- Box + Name + Distance + Health

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local ESP = {}

local function removeESP(player)
    if ESP[player] then
        ESP[player].Highlight:Destroy()
        ESP[player].Billboard:Destroy()
        ESP[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end

    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not head or not humanoid then return end

    removeESP(player)

    -- Box ESP
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 60, 60)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    -- Name + Distance + Health
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(180, 55)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = billboard

    ESP[player] = {
        Highlight = highlight,
        Billboard = billboard,
        Label = label
    }
end

local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        createESP(player)
    end)

    if player.Character then
        createESP(player)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")

    if not myRoot then return end

    for player, data in pairs(ESP) do
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if root and humanoid then
            local distance = (myRoot.Position - root.Position).Magnitude
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)

            data.Label.Text = string.format(
                "%s\n%d studs | HP: %d/%d",
                player.Name,
                distance,
                health,
                maxHealth
            )
        end
    end
end)
