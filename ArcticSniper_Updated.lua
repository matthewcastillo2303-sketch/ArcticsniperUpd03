-- ARCTIC SNIPER — UPDATED UI DEMO
-- UI/local settings only. This does not read another game's screen,
-- automatically redeem codes, or send webhooks. Parser only uses pasted text.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previous = playerGui:FindFirstChild("ArcticSniperUpdated")
if previous then previous:Destroy() end

local settings = {
    scanAnnouncements = true,
    autoScope = true,
    spamRedeem = false,
    hideUser = false,
    autoSubmit = 3,
    uiScale = 0.80,
}

local C = {
    bg = Color3.fromRGB(9, 10, 17),
    panel = Color3.fromRGB(17, 18, 29),
    row = Color3.fromRGB(25, 29, 43),
    border = Color3.fromRGB(57, 94, 125),
    blue = Color3.fromRGB(100, 199, 255),
    blueDark = Color3.fromRGB(37, 112, 161),
    white = Color3.fromRGB(245, 249, 255),
    muted = Color3.fromRGB(151, 170, 189),
    off = Color3.fromRGB(64, 72, 86),
}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local gui = make("ScreenGui", {
    Name = "ArcticSniperUpdated",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
}, playerGui)

local uiScale = make("UIScale", {Scale = settings.uiScale}, gui)
local panel = make("Frame", {
    Name = "MainPanel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(480, 600),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 18)}, panel)
make("UIStroke", {Color = C.blueDark, Thickness = 1.5}, panel)

local header = make("Frame", {
    Name = "Header", Size = UDim2.new(1, 0, 0, 64),
    BackgroundTransparency = 1,
}, panel)
make("TextLabel", {
    Position = UDim2.fromOffset(20, 9), Size = UDim2.new(1, -80, 0, 27),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
    Text = "ARCTIC SNIPER", TextColor3 = C.white, TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)
make("TextLabel", {
    Position = UDim2.fromOffset(21, 36), Size = UDim2.new(1, -80, 0, 15),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham,
    Text = "FROST UI  •  LOCAL DEMO", TextColor3 = C.blue, TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)
local minimize = make("TextButton", {
    Position = UDim2.new(1, -46, 0, 15), Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = C.row, Text = "–", TextColor3 = C.blue,
    Font = Enum.Font.GothamBold, TextSize = 20,
}, header)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, minimize)

local status = make("TextLabel", {
    Position = UDim2.fromOffset(16, 64), Size = UDim2.new(1, -32, 0, 26),
    BackgroundColor3 = C.row, Font = Enum.Font.GothamMedium,
    Text = "  ●  Ready — paste announcement text below",
    TextColor3 = C.white, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, status)

local codeCard = make("Frame", {
    Name = "CodeCard", Position = UDim2.fromOffset(16, 98),
    Size = UDim2.new(1, -32, 0, 156), BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, codeCard)
make("UIStroke", {Color = C.border, Thickness = 1}, codeCard)
make("TextLabel", {
    Position = UDim2.fromOffset(12, 8), Size = UDim2.new(1, -24, 0, 16),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
    Text = "SNIPED CODE / TEXT PARSER", TextColor3 = C.blue, TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
}, codeCard)
local codeDisplay = make("TextLabel", {
    Name = "CodeDisplay", Position = UDim2.fromOffset(12, 27),
    Size = UDim2.new(1, -24, 0, 32), BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold, Text = "NO CODE DETECTED",
    TextColor3 = C.white, TextSize = 18, TextWrapped = true,
}, codeCard)
local input = make("TextBox", {
    Name = "AnnouncementTextInput", Position = UDim2.fromOffset(10, 62),
    Size = UDim2.new(1, -20, 0, 42), BackgroundColor3 = C.row,
    ClearTextOnFocus = false, Font = Enum.Font.Gotham,
    PlaceholderText = "Paste an announcement here...",
    PlaceholderColor3 = C.muted, Text = "", TextColor3 = C.white,
    TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
}, codeCard)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, input)
make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, input)

local function button(parent, name, text, pos, size, color)
    local b = make("TextButton", {
        Name = name, Text = text, Position = pos, Size = size,
        BackgroundColor3 = color or C.row, TextColor3 = C.white,
        Font = Enum.Font.GothamBold, TextSize = 9,
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 7)}, b)
    return b
end
local parseButton = button(codeCard, "ParseText", "PARSE TEXT",
    UDim2.fromOffset(10, 112), UDim2.fromOffset(108, 27), C.blueDark)
local clearCode = button(codeCard, "ClearCode", "CLEAR BOX",
    UDim2.new(1, -118, 0, 112), UDim2.fromOffset(108, 27), C.row)

local list = make("Frame", {
    Name = "SettingsList", Position = UDim2.fromOffset(16, 264),
    Size = UDim2.new(1, -32, 0, 252), BackgroundTransparency = 1,
}, panel)
make("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, list)

local function row(title, subtitle, order)
    local r = make("Frame", {
        Name = title:gsub("%W", "") .. "Row", Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = C.row, BorderSizePixel = 0, LayoutOrder = order,
    }, list)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, r)
    make("UIStroke", {Color = C.border, Thickness = 1, Transparency = 0.4}, r)
    make("TextLabel", {
        Position = UDim2.fromOffset(10, 3), Size = UDim2.new(1, -125, 0, 15),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = title, TextColor3 = C.white, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, r)
    make("TextLabel", {
        Position = UDim2.fromOffset(10, 18), Size = UDim2.new(1, -125, 0, 12),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = subtitle, TextColor3 = C.muted, TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, r)
    return r
end

local toggleRefresh = {}
local function addToggle(key, title, subtitle, order)
    local r = row(title, subtitle, order)
    local b = make("TextButton", {
        Name = "Toggle", Position = UDim2.new(1, -57, 0.5, -10),
        Size = UDim2.fromOffset(43, 20),
        BackgroundColor3 = settings[key] and C.blue or C.off, Text = "",
    }, r)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, b)
    local knob = make("Frame", {
        Position = settings[key] and UDim2.new(1, -17, 0, 2) or UDim2.fromOffset(3, 2),
        Size = UDim2.fromOffset(16, 16), BackgroundColor3 = C.white,
        BorderSizePixel = 0,
    }, b)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)
    local function refresh()
        b.BackgroundColor3 = settings[key] and C.blue or C.off
        knob.Position = settings[key] and UDim2.new(1, -17, 0, 2) or UDim2.fromOffset(3, 2)
    end
    b.Activated:Connect(function()
        settings[key] = not settings[key]
        refresh()
        status.Text = "  ●  " .. title .. (settings[key] and " ON" or " OFF")
    end)
    toggleRefresh[key] = refresh
end

addToggle("scanAnnouncements", "scan announcements", "local setting • no live screen scanning", 1)
addToggle("autoScope", "auto scope", "parse pasted announcement text", 2)
addToggle("spamRedeem", "spam redeem", "setting only • no code redemption", 3)
addToggle("hideUser", "hide user", "local display setting", 4)

local submitRow = row("auto submit", "select a local value", 5)
local submitButtons = {}
for n = 1, 5 do
    local b = button(submitRow, "Value" .. n, tostring(n),
        UDim2.new(1, -150 + (n - 1) * 28, 0.5, -10),
        UDim2.fromOffset(24, 20), settings.autoSubmit == n and C.blueDark or C.panel)
    submitButtons[n] = b
    b.Activated:Connect(function()
        settings.autoSubmit = n
        for i, other in ipairs(submitButtons) do
            other.BackgroundColor3 = i == n and C.blueDark or C.panel
        end
        status.Text = "  ●  Auto Submit set to " .. n .. " (local demo)"
    end)
end

local scaleRow = row("ui scale", "adjust panel size", 6)
local scaleValue = make("TextLabel", {
    Position = UDim2.new(1, -113, 0.5, -10), Size = UDim2.fromOffset(52, 20),
    BackgroundColor3 = C.panel, Text = "80%", TextColor3 = C.white,
    Font = Enum.Font.GothamBold, TextSize = 10,
}, scaleRow)
make("UICorner", {CornerRadius = UDim.new(0, 5)}, scaleValue)
local minus = button(scaleRow, "ScaleMinus", "−", UDim2.new(1, -145, 0.5, -10),
    UDim2.fromOffset(25, 20), C.panel)
local plus = button(scaleRow, "ScalePlus", "+", UDim2.new(1, -54, 0.5, -10),
    UDim2.fromOffset(25, 20), C.blueDark)
local function setScale(v)
    settings.uiScale = math.clamp(v, 0.65, 1)
    uiScale.Scale = settings.uiScale
    scaleValue.Text = tostring(math.floor(settings.uiScale * 100 + 0.5)) .. "%"
end
minus.Activated:Connect(function() setScale(settings.uiScale - 0.05) end)
plus.Activated:Connect(function() setScale(settings.uiScale + 0.05) end)

local footer = make("Frame", {
    Name = "Footer", Position = UDim2.new(0, 16, 1, -66),
    Size = UDim2.new(1, -32, 0, 42), BackgroundTransparency = 1,
}, panel)
local feedback = button(footer, "Feedback", "FEEDBACK", UDim2.fromOffset(0, 0),
    UDim2.fromOffset(105, 36), C.row)
local clear = button(footer, "ClearBox", "CLEAR BOX", UDim2.fromOffset(113, 0),
    UDim2.fromOffset(105, 36), C.row)
local reset = button(footer, "Reset", "RESET", UDim2.fromOffset(226, 0),
    UDim2.fromOffset(105, 36), C.row)

local function parseCode(text)
    local lower = string.lower(text or "")
    for _, pattern in ipairs({
        "use%s+code%s*[:%-]?%s*([%w_%-]+)",
        "the%s+code%s+is%s*[:%-]?%s*([%w_%-]+)",
    }) do
        local result = string.match(lower, pattern)
        if result then return string.upper(result) end
    end
    return nil
end
local function clearBuffer()
    input.Text = ""
    codeDisplay.Text = "NO CODE DETECTED"
    status.Text = "  ●  Code box cleared"
end
parseButton.Activated:Connect(function()
    if not settings.autoScope then
        status.Text = "  ●  Auto Scope is OFF"
        return
    end
    local found = parseCode(input.Text)
    if found then
        codeDisplay.Text = found
        status.Text = "  ●  Found code in pasted text"
    else
        codeDisplay.Text = "NO CODE DETECTED"
        status.Text = "  ●  No matching phrase found"
    end
end)
clearCode.Activated:Connect(clearBuffer)
clear.Activated:Connect(clearBuffer)
feedback.Activated:Connect(function()
    status.Text = "  ●  Feedback: send your note to the developer"
end)
reset.Activated:Connect(function()
    settings.scanAnnouncements = true
    settings.autoScope = true
    settings.spamRedeem = false
    settings.hideUser = false
    settings.autoSubmit = 3
    setScale(0.8)
    for _, refresh in pairs(toggleRefresh) do refresh() end
    for i, b in ipairs(submitButtons) do
        b.BackgroundColor3 = i == 3 and C.blueDark or C.panel
    end
    clearBuffer()
    status.Text = "  ●  Local settings reset"
end)

local mini = button(gui, "FloatingASButton", "AS",
    UDim2.new(0, 20, 0.5, -25), UDim2.fromOffset(50, 50), C.panel)
mini.Visible = false
mini.TextColor3 = C.blue
mini.TextSize = 18
make("UIStroke", {Color = C.blue, Thickness = 2}, mini)
minimize.Activated:Connect(function()
    panel.Visible = false
    mini.Visible = true
end)
mini.Activated:Connect(function()
    panel.Visible = true
    mini.Visible = false
end)

-- Drag panel by its header (mouse/touch).
local dragging, dragStart, startPos, activeDrag = false, nil, nil, nil
header.InputBegan:Connect(function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseButton1
        or inputObj.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, inputObj.Position, panel.Position
        inputObj.Changed:Connect(function()
            if inputObj.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
header.InputChanged:Connect(function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseMovement
        or inputObj.UserInputType == Enum.UserInputType.Touch then activeDrag = inputObj end
end)
UserInputService.InputChanged:Connect(function(inputObj)
    if dragging and inputObj == activeDrag then
        local delta = inputObj.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Drag the floating button on mouse/touch; a tap still opens the panel.
local miniDragging, miniStart, miniPos, miniActive = false, nil, nil, nil
mini.InputBegan:Connect(function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseButton1
        or inputObj.UserInputType == Enum.UserInputType.Touch then
        miniDragging, miniStart, miniPos = true, inputObj.Position, mini.Position
        inputObj.Changed:Connect(function()
            if inputObj.UserInputState == Enum.UserInputState.End then miniDragging = false end
        end)
    end
end)
mini.InputChanged:Connect(function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseMovement
        or inputObj.UserInputType == Enum.UserInputType.Touch then miniActive = inputObj end
end)
UserInputService.InputChanged:Connect(function(inputObj)
    if miniDragging and inputObj == miniActive then
        local delta = inputObj.Position - miniStart
        mini.Position = UDim2.new(miniPos.X.Scale, miniPos.X.Offset + delta.X,
            miniPos.Y.Scale, miniPos.Y.Offset + delta.Y)
    end
end)
