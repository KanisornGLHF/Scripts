local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI เดิม
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

-- ระบบ Record
local recording = false
local actions = {}
local startedAt = 0
local inputConnection
local MAX_ACTIONS = 5000

local function addAction(action)
    if not recording then
        return
    end

    if #actions >= MAX_ACTIONS then
        recording = false
        status.Text = "Limit reached | Stopped"
        return
    end

    action.t = os.clock() - startedAt
    table.insert(actions, action)

    status.Text = "Recording | Actions: " .. #actions
end

local function startRecording()
    if recording then
        return
    end

    actions = {}
    startedAt = os.clock()
    recording = true

    status.Text = "Recording | Actions: 0"
end

local function stopRecording()
    recording = false
    status.Text = "Stopped | Actions: " .. #actions
end

-- เริ่มบันทึกเมื่อกดเมาส์ซ้ายในพื้นที่เกม
-- ไม่บันทึกอินพุตที่ Roblox ระบุว่าถูก UI ใช้งานแล้ว
local function onInputBegan(input, gameProcessed)
    if not recording or gameProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local screen = UserInputService:GetMouseLocation()

        local action = {
            type = "click",
            screen = {
                x = screen.X,
                y = screen.Y
            }
        }

        -- พิกัดโลก: ใช้ตำแหน่งจุดที่เมาส์ชี้
        -- เฉพาะเมื่อได้ตำแหน่งที่เข้าถึงได้จริง
        local ok, hitPosition = pcall(function()
            return mouse.Hit.Position
        end)

        if ok and typeof(hitPosition) == "Vector3" then
            action.world = {
                x = hitPosition.X,
                y = hitPosition.Y,
                z = hitPosition.Z
            }
        end

        addAction(action)

    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name

        -- บันทึกเฉพาะปุ่มตัวเลข 1–6
        if keyName:match("^[1-6]$") then
            addAction({
                type = "key",
                key = keyName
            })
        end
    end
end

inputConnection =
    UserInputService.InputBegan:Connect(onInputBegan)

makeButton("Record", function()
    startRecording()
end)

makeButton("Stop", function()
    stopRecording()
end)

makeButton("Replay", function()
    if recording then
        status.Text = "Stop recording first"
        return
    end

    status.Text = "Recorded: " .. #actions
        .. " | Replay not connected"
end)

makeButton("Save / Load", function()
    status.Text = "Storage not connected"
end)

-- ดูข้อมูลที่บันทึกไว้ใน Output
-- ใช้สำหรับตรวจสอบข้อมูลเท่านั้น
_G.ASTDGetRecordedActions = function()
    local snapshot = {}

    for i, action in ipairs(actions) do
        snapshot[i] = action
    end

    return snapshot
end

_G.ASTDPrintRecordedActions = function()
    for i, action in ipairs(actions) do
        print(i, action.type, action.t, action.key)
        if action.screen then
            print("Screen:", action.screen.x, action.screen.y)
        end
        if action.world then
            print(
                "World:",
                action.world.x,
                action.world.y,
                action.world.z
            )
        end
    end
end
