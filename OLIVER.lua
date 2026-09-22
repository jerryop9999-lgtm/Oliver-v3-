--[[
    OLIVER V3 - NEW UI
    UI rebuilt from the approved mockup.

    Page logos:
      Main       = 111648653308842
      Player     = 99191727508887
      Animations = 105863394969753

    Removed:
      Anti-AFK
      Infinite Jump
      Name Tag
      Kalech

    Includes:
      Main / Player / Animations
      Camera-direction Fly + mobile joystick
      WalkSpeed ON/OFF
      Noclip
      ESP Box + Line
      Reset / Rejoin / Restore
      Player search + Goto
      FPS / Ping header
      RGB Coming Soon
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local LOGO_MAIN = "rbxassetid://111648653308842"
local LOGO_PLAYER = "rbxassetid://99191727508887"
local LOGO_ANIM = "rbxassetid://105863394969753"

-- Remove an older OLIVER V3 UI if it exists.
pcall(function()
    local old = PlayerGui:FindFirstChild("OLIVER_V3_NEW_UI")
    if old then old:Destroy() end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "OLIVER_V3_NEW_UI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- ============================================================
-- Helpers
-- ============================================================

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function padding(parent, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = parent
    return p
end

local function makeLabel(parent, text, size, position, fontSize, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Size = size
    l.Position = position
    l.TextColor3 = color or Color3.fromRGB(235,240,255)
    l.Font = Enum.Font.GothamMedium
    l.TextSize = fontSize or 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- ============================================================
-- Main window
-- ============================================================

local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.new(0, 760, 0, 500)
Main.Position = UDim2.new(0.5, -380, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(7, 17, 34)
Main.BackgroundTransparency = 0.06
Main.BorderSizePixel = 0
Main.Parent = Gui
corner(Main, 16)
stroke(Main, Color3.fromRGB(0, 145, 255), 1.5, 0.15)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 72)
Header.BackgroundColor3 = Color3.fromRGB(5, 14, 29)
Header.BorderSizePixel = 0
Header.Parent = Main
corner(Header, 16)

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 18)
HeaderCover.Position = UDim2.new(0, 0, 1, -18)
HeaderCover.BackgroundColor3 = Header.BackgroundColor3
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 50, 0, 50)
HeaderLogo.Position = UDim2.new(0, 14, 0.5, -25)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = LOGO_MAIN
HeaderLogo.Parent = Header
corner(HeaderLogo, 12)

local Title = makeLabel(Header, "OLIVER V3", UDim2.new(0, 240, 0, 28), UDim2.new(0, 76, 0, 9), 22, Color3.fromRGB(60, 220, 255))
Title.Font = Enum.Font.GothamBold

local Subtitle = makeLabel(Header, "SIMPLE  •  CLEAN  •  POWERFUL", UDim2.new(0, 300, 0, 20), UDim2.new(0, 77, 0, 38), 10, Color3.fromRGB(130, 165, 200))

local HeaderStats = makeLabel(Header, "FPS --  |  PING -- ms", UDim2.new(0, 220, 0, 28), UDim2.new(1, -235, 0, 22), 15, Color3.fromRGB(245,250,255))
HeaderStats.TextXAlignment = Enum.TextXAlignment.Right
HeaderStats.Font = Enum.Font.GothamBold

-- ============================================================
-- Draggable window
-- ============================================================

local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ============================================================
-- Sidebar
-- ============================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 175, 1, -82)
Sidebar.Position = UDim2.new(0, 10, 0, 78)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 22, 43)
Sidebar.BackgroundTransparency = 0.12
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
corner(Sidebar, 12)
stroke(Sidebar, Color3.fromRGB(30, 90, 150), 1, 0.3)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 8)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar
padding(Sidebar, 10, 10, 12, 12)

local function makeTab(name, assetId, order)
    local b = Instance.new("TextButton")
    b.Name = name .. "Tab"
    b.Size = UDim2.new(1, 0, 0, 50)
    b.LayoutOrder = order
    b.Text = ""
    b.BackgroundColor3 = Color3.fromRGB(10, 35, 62)
    b.BorderSizePixel = 0
    b.Parent = Sidebar
    corner(b, 10)

    local icon = Instance.new("ImageLabel")
    icon.Name = "Logo"
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 9, 0.5, -16)
    icon.BackgroundTransparency = 1
    icon.Image = assetId
    icon.Parent = b

    local label = makeLabel(b, name, UDim2.new(1, -52, 1, 0), UDim2.new(0, 50, 0, 0), 15, Color3.fromRGB(225,235,250))
    label.Font = Enum.Font.GothamBold

    return b
end

local TabMain = makeTab("Main", LOGO_MAIN, 1)
local TabPlayer = makeTab("Player", LOGO_PLAYER, 2)
local TabAnimations = makeTab("Animations", LOGO_ANIM, 3)

local SideFooter = makeLabel(Sidebar, "OLIVER V3", UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 1, -34), 11, Color3.fromRGB(100, 140, 180))
SideFooter.TextXAlignment = Enum.TextXAlignment.Center

-- ============================================================
-- Pages
-- ============================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -195, 1, -82)
Content.Position = UDim2.new(0, 185, 0, 78)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function newPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 5
    p.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.Parent = Content
    padding(p, 8, 8, 8, 16)
    return p
end

local MainPage = newPage("MainPage")
local PlayerPage = newPage("PlayerPage")
local AnimPage = newPage("AnimationsPage")

-- ============================================================
-- Feature state
-- ============================================================

local flyEnabled = false
local flySpeed = 50
local flyConnection
local flyBV
local flyBG

local noclipEnabled = false
local noclipConnection

local walkSpeedEnabled = false
local walkSpeedValue = 50
local walkConnection

local espEnabled = false
local espObjects = {}

local function characterParts()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return char, root, hum
end

local function setWalkSpeed()
    local _, _, hum = characterParts()
    if hum then
        hum.WalkSpeed = walkSpeedEnabled and walkSpeedValue or 16
    end
end

local function setToggleStyle(button, enabled)
    button.BackgroundColor3 = enabled
        and Color3.fromRGB(0, 130, 255)
        or Color3.fromRGB(16, 38, 66)
end

local function makeSectionTitle(parent, title, subtitle, order)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 58)
    f.LayoutOrder = order
    f.BackgroundTransparency = 1
    f.Parent = parent

    makeLabel(f, title, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 0), 23, Color3.fromRGB(245,250,255)).Font = Enum.Font.GothamBold
    makeLabel(f, subtitle, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 32), 11, Color3.fromRGB(120,155,190))
    return f
end

local function makeInput(parent, placeholder, defaultText, order)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 42)
    box.LayoutOrder = order
    box.BackgroundColor3 = Color3.fromRGB(12, 31, 55)
    box.TextColor3 = Color3.fromRGB(240,245,255)
    box.PlaceholderColor3 = Color3.fromRGB(110,140,175)
    box.PlaceholderText = placeholder
    box.Text = defaultText or ""
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.BorderSizePixel = 0
    box.Parent = parent
    corner(box, 10)
    stroke(box, Color3.fromRGB(25, 75, 120), 1, 0.25)
    padding(box, 14, 14, 0, 0)
    return box
end

local function makeToggle(parent, title, desc, order, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 62)
    b.LayoutOrder = order
    b.Text = ""
    b.BackgroundColor3 = Color3.fromRGB(12, 31, 55)
    b.BorderSizePixel = 0
    b.Parent = parent
    corner(b, 12)
    stroke(b, Color3.fromRGB(25, 75, 120), 1, 0.25)

    local t = makeLabel(b, title, UDim2.new(1, -75, 0, 25), UDim2.new(0, 16, 0, 9), 15, Color3.fromRGB(240,245,255))
    t.Font = Enum.Font.GothamBold
    makeLabel(b, desc, UDim2.new(1, -75, 0, 20), UDim2.new(0, 16, 0, 34), 10, Color3.fromRGB(120,155,190))

    local state = false
    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 48, 0, 26)
    pill.Position = UDim2.new(1, -62, 0.5, -13)
    pill.BackgroundColor3 = Color3.fromRGB(45, 60, 80)
    pill.BorderSizePixel = 0
    pill.Parent = b
    corner(pill, 20)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 20, 0, 20)
    dot.Position = UDim2.new(0, 3, 0.5, -10)
    dot.BackgroundColor3 = Color3.fromRGB(220,230,240)
    dot.BorderSizePixel = 0
    dot.Parent = pill
    corner(dot, 20)

    local function render()
        pill.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 60, 80)
        dot.Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    end

    b.MouseButton1Click:Connect(function()
        state = not state
        render()
        callback(state)
    end)

    return b, function(value)
        state = value
        render()
    end
end

-- ============================================================
-- MAIN PAGE
-- ============================================================

makeSectionTitle(MainPage, "Main", "Useful tools for your game", 1)

local FlySpeed = makeInput(MainPage, "Fly speed...", "50", 2)
FlySpeed.FocusLost:Connect(function()
    local n = tonumber(FlySpeed.Text)
    if n then flySpeed = math.clamp(n, 1, 500) end
    FlySpeed.Text = tostring(flySpeed)
end)

local WalkSpeed = makeInput(MainPage, "WalkSpeed value...", "50", 3)
WalkSpeed.FocusLost:Connect(function()
    local n = tonumber(WalkSpeed.Text)
    if n then walkSpeedValue = math.clamp(n, 1, 500) end
    WalkSpeed.Text = tostring(walkSpeedValue)
    if walkSpeedEnabled then setWalkSpeed() end
end)

-- Camera-direction Fly. Mobile thumbstick values are read from Humanoid.MoveDirection.
local function stopFly()
    flyEnabled = false
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

local function startFly()
    stopFly()
    flyEnabled = true

    flyConnection = RunService.RenderStepped:Connect(function()
        local char, root, hum = characterParts()
        local camera = workspace.CurrentCamera
        if not (char and root and hum and camera) then return end

        if not flyBV then
            flyBV = Instance.new("BodyVelocity")
            flyBV.Name = "OLIVER_FlyVelocity"
            flyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            flyBV.P = 10000
            flyBV.Parent = root
        end

        if not flyBG then
            flyBG = Instance.new("BodyGyro")
            flyBG.Name = "OLIVER_FlyGyro"
            flyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            flyBG.P = 10000
            flyBG.Parent = root
        end

        -- Mobile joystick / keyboard input follows the camera direction.
        local move = hum.MoveDirection
        local camForward = camera.CFrame.LookVector
        local camRight = camera.CFrame.RightVector

        local x = move:Dot(camRight)
        local z = move:Dot(camForward)

        -- Vertical camera angle controls climb/descent when moving forward.
        local direction = camRight * x + camForward * z
        if direction.Magnitude > 1 then direction = direction.Unit end

        flyBV.Velocity = direction * flySpeed
        flyBG.CFrame = CFrame.lookAt(root.Position, root.Position + camForward)
        hum.AutoRotate = false
    end)
end

local FlyToggle = makeToggle(MainPage, "Fly", "Camera direction + mobile joystick", 4, function(on)
    if on then startFly() else stopFly() end
end)

local NoclipToggle = makeToggle(MainPage, "Noclip", "Walk through your character collision", 5, function(on)
    noclipEnabled = on

    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end

    if on then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

local ESPToggle = makeToggle(MainPage, "ESP", "Box + line for players", 6, function(on)
    espEnabled = on

    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}

    if on then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local h = Instance.new("Highlight")
                h.Name = "OLIVER_ESP_" .. p.UserId
                h.Adornee = p.Character
                h.FillTransparency = 1
                h.OutlineColor = Color3.fromRGB(0, 180, 255)
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = Gui
                espObjects[p.UserId] = h
            end
        end
    end
end)

local WalkToggle = makeToggle(MainPage, "WalkSpeed", "Custom movement speed", 7, function(on)
    walkSpeedEnabled = on
    if on and not walkConnection then
        walkConnection = RunService.Heartbeat:Connect(setWalkSpeed)
    elseif not on and walkConnection then
        walkConnection:Disconnect()
        walkConnection = nil
    end
    setWalkSpeed()
end)

local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(1, 0, 0, 52)
ResetButton.LayoutOrder = 8
ResetButton.Text = "RESET CHARACTER"
ResetButton.BackgroundColor3 = Color3.fromRGB(15, 65, 105)
ResetButton.TextColor3 = Color3.fromRGB(255,255,255)
ResetButton.Font = Enum.Font.GothamBold
ResetButton.TextSize = 14
ResetButton.BorderSizePixel = 0
ResetButton.Parent = MainPage
corner(ResetButton, 10)
ResetButton.MouseButton1Click:Connect(function()
    local _, _, hum = characterParts()
    if hum then hum.Health = 0 end
end)

local RejoinButton = ResetButton:Clone()
RejoinButton.Name = "RejoinServer"
RejoinButton.LayoutOrder = 9
RejoinButton.Text = "REJOIN SERVER"
RejoinButton.Parent = MainPage
RejoinButton.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

local RestoreButton = ResetButton:Clone()
RestoreButton.Name = "RestoreAll"
RestoreButton.LayoutOrder = 10
RestoreButton.Text = "RESTORE ALL"
RestoreButton.BackgroundColor3 = Color3.fromRGB(35, 45, 62)
RestoreButton.Parent = MainPage
RestoreButton.MouseButton1Click:Connect(function()
    stopFly()
    noclipEnabled = false
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    walkSpeedEnabled = false
    if walkConnection then walkConnection:Disconnect(); walkConnection = nil end
    setWalkSpeed()
    espEnabled = false
    for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
    espObjects = {}
end)

-- ============================================================
-- PLAYER PAGE
-- ============================================================

makeSectionTitle(PlayerPage, "Player", "Teleport to a player", 1)

local Search = makeInput(PlayerPage, "Search player...", "", 2)

local Count = makeLabel(PlayerPage, "Players: 0", UDim2.new(1,0,0,24), UDim2.new(0,0,0,0), 11, Color3.fromRGB(100,160,210))
Count.LayoutOrder = 3

local PlayerList = Instance.new("Frame")
PlayerList.Size = UDim2.new(1,0,0,0)
PlayerList.AutomaticSize = Enum.AutomaticSize.Y
PlayerList.LayoutOrder = 4
PlayerList.BackgroundTransparency = 1
PlayerList.Parent = PlayerPage

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0, 8)
PlayerLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerLayout.Parent = PlayerList

local function updatePlayers()
    for _, c in ipairs(PlayerList:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    local q = Search.Text:lower()
    local count = 0
    local order = 0

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local matches = q == ""
                or p.Name:lower():find(q, 1, true)
                or p.DisplayName:lower():find(q, 1, true)

            if matches then
                count += 1
                order += 1

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1,0,0,62)
                card.LayoutOrder = order
                card.BackgroundColor3 = Color3.fromRGB(10, 31, 54)
                card.BorderSizePixel = 0
                card.Parent = PlayerList
                corner(card, 10)
                stroke(card, Color3.fromRGB(25,75,120), 1, 0.25)

                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0,44,0,44)
                av.Position = UDim2.new(0,9,0.5,-22)
                av.BackgroundTransparency = 1
                av.Image = "rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"
                av.Parent = card
                corner(av, 10)

                local dn = makeLabel(card, p.DisplayName, UDim2.new(1,-180,0,23), UDim2.new(0,62,0,8), 14, Color3.fromRGB(245,250,255))
                dn.Font = Enum.Font.GothamBold

                makeLabel(card, "@"..p.Name, UDim2.new(1,-180,0,18), UDim2.new(0,62,0,32), 10, Color3.fromRGB(120,155,190))

                local goto = Instance.new("TextButton")
                goto.Size = UDim2.new(0,72,0,34)
                goto.Position = UDim2.new(1,-82,0.5,-17)
                goto.Text = "Goto"
                goto.BackgroundColor3 = Color3.fromRGB(0,145,255)
                goto.TextColor3 = Color3.fromRGB(255,255,255)
                goto.Font = Enum.Font.GothamBold
                goto.TextSize = 12
                goto.BorderSizePixel = 0
                goto.Parent = card
                corner(goto, 9)

                goto.MouseButton1Click:Connect(function()
                    local myChar = LocalPlayer.Character
                    local targetChar = p.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                    if myRoot and targetRoot then
                        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0,0,3)
                    end
                end)
            end
        end
    end

    Count.Text = "Players: " .. count .. " / " .. math.max(#Players:GetPlayers()-1,0)
end

Search:GetPropertyChangedSignal("Text"):Connect(updatePlayers)
Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)

-- ============================================================
-- ANIMATIONS PAGE
-- ============================================================

makeSectionTitle(AnimPage, "Animations", "Play and enjoy animations", 1)

local Coming = Instance.new("TextLabel")
Coming.Size = UDim2.new(1,0,0,150)
Coming.LayoutOrder = 2
Coming.BackgroundColor3 = Color3.fromRGB(12,25,48)
Coming.Text = "COMING SOON"
Coming.TextColor3 = Color3.fromRGB(255,0,255)
Coming.Font = Enum.Font.GothamBlack
Coming.TextSize = 38
Coming.TextStrokeTransparency = 0.45
Coming.BorderSizePixel = 0
Coming.Parent = AnimPage
corner(Coming, 14)
stroke(Coming, Color3.fromRGB(0,130,255), 1, 0.2)

local rgbHue = 0
RunService.RenderStepped:Connect(function(dt)
    rgbHue = (rgbHue + dt * 0.3) % 1
    Coming.TextColor3 = Color3.fromHSV(rgbHue, 0.9, 1)
end)

-- ============================================================
-- Tab switching
-- ============================================================

local pages = {
    Main = MainPage,
    Player = PlayerPage,
    Animations = AnimPage,
}

local tabs = {
    Main = TabMain,
    Player = TabPlayer,
    Animations = TabAnimations,
}

local function selectPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = (pageName == name)
    end

    for tabName, tab in pairs(tabs) do
        tab.BackgroundColor3 = (tabName == name)
            and Color3.fromRGB(0, 115, 235)
            or Color3.fromRGB(10, 35, 62)
    end
end

TabMain.MouseButton1Click:Connect(function() selectPage("Main") end)
TabPlayer.MouseButton1Click:Connect(function() selectPage("Player") end)
TabAnimations.MouseButton1Click:Connect(function() selectPage("Animations") end)

-- ============================================================
-- Floating toggle button
-- ============================================================

local Toggle = Instance.new("ImageButton")
Toggle.Name = "FloatingToggle"
Toggle.Size = UDim2.new(0, 58, 0, 58)
Toggle.Position = UDim2.new(0, 20, 0.5, -29)
Toggle.BackgroundColor3 = Color3.fromRGB(5,20,40)
Toggle.Image = LOGO_MAIN
Toggle.BorderSizePixel = 0
Toggle.ZIndex = 50
Toggle.Parent = Gui
corner(Toggle, 29)
stroke(Toggle, Color3.fromRGB(0,150,255), 2, 0.1)

local toggleDragging = false
local toggleStart
local togglePos

Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleStart = input.Position
        togglePos = Toggle.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - toggleStart
        Toggle.Position = UDim2.new(
            togglePos.X.Scale, togglePos.X.Offset + d.X,
            togglePos.Y.Scale, togglePos.Y.Offset + d.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = false
    end
end)

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ============================================================
-- FPS / Ping
-- ============================================================

local frames = 0
local elapsed = 0

RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt

    if elapsed >= 0.5 then
        local fps = math.floor(frames / elapsed + 0.5)
        local ping = 0

        pcall(function()
            ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)
        end)

        HeaderStats.Text = "FPS " .. fps .. "  |  PING " .. ping .. " ms"
        frames = 0
        elapsed = 0
    end
end)

-- Character respawn support
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.25)
    if walkSpeedEnabled then setWalkSpeed() end
end)

-- Start
selectPage("Main")
updatePlayers()
