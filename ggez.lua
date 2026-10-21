
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ASTDMacroUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(240, 205)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = frame

local function makeLabel(text, height)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.92, 0, 0, height)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 16
    label.Parent = frame
    return label
end

local status = makeLabel("ASTD Macro | Ready", 32)

local function makeButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.92, 0, 0, 30)
    button.Text = text
    button.TextSize = 14
    button.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    button.Activated:Connect(callback)
end

local recording = false
local actions = {}

makeButton("Record", function()
    actions = {}
    recording = true
    status.Text = "Status: Recording"
end)

makeButton("Stop", function()
    recording = false
    status.Text = "Status: Stopped"
end)

makeButton("Replay", function()
    if recording then
        status.Text = "Stop recording first"
        return
    end

    status.Text = "Actions: " .. #actions
    print("Replay prototype: no game actions executed")
end)

makeButton("Save / Load", function()
    status.Text = "Storage not connected"
end)
