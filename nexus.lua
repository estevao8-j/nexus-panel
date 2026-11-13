
-- NEXUS PANEL | STUDIO TEST VERSION

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
    warn("NEXUS: use somente no ambiente de testes.")
    return
end

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NexusPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(310, 300)
frame.Position = UDim2.new(0.5, -155, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "NEXUS | MOVEMENT"
title.TextColor3 = Color3.fromRGB(0, 220, 170)
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.Parent = frame

local function label(text, y)
    local obj = Instance.new("TextLabel")
    obj.Size = UDim2.new(1, -30, 0, 25)
    obj.Position = UDim2.fromOffset(15, y)
    obj.BackgroundTransparency = 1
    obj.Text = text
    obj.TextColor3 = Color3.new(1, 1, 1)
    obj.Font = Enum.Font.GothamBold
    obj.TextSize = 13
    obj.TextXAlignment = Enum.TextXAlignment.Left
    obj.Parent = frame
    return obj
end

local function slider(y, min, max, initial, callback)
    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(15, y)
    bar.Size = UDim2.new(1, -30, 0, 8)
    bar.BackgroundColor3 = Color3.fromRGB(60, 65, 80)
    bar.BorderSizePixel = 0
    bar.Parent = frame

    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale((initial-min)/(max-min), 1)
    fill.BackgroundColor3 = Color3.fromRGB(0, 220, 170)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((initial-min)/(max-min), 0, 0.5, 0)
    knob.Text = ""
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = bar

    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function update(x)
        local p = math.clamp(
            (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1
        )
        local value = math.floor(min + (max-min)*p)

        fill.Size = UDim2.fromScale(p, 1)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        callback(value)
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

label("WALK SPEED", 60)
local walkLabel = label("16", 85)
walkLabel.TextColor3 = Color3.fromRGB(0, 220, 170)

slider(120, 0, 100, 16, function(value)
    walkLabel.Text = tostring(value)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

label("FLY SPEED", 155)
local flyLabel = label("50", 180)
flyLabel.TextColor3 = Color3.fromRGB(0, 220, 170)

local flySpeed = 50

slider(215, 0, 200, 50, function(value)
    flySpeed = value
    flyLabel.Text = tostring(value)
end)

local flyButton = Instance.new("TextButton")
flyButton.Position = UDim2.fromOffset(15, 245)
flyButton.Size = UDim2.new(1, -30, 0, 40)
flyButton.BackgroundColor3 = Color3.fromRGB(35, 45, 55)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Text = "FLY: OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 14
flyButton.Parent = frame

Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 7)

-- Interface inicializada
print("NEXUS PANEL carregado com sucesso!")
print("WalkSpeed e Fly Speed disponíveis.")
