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
Main.Size = UDim2.new(0, 620, 0, 410)
Main.Position = UDim2.new(0.5, -310, 0.5, -205)
Main.BackgroundColor3 = Color3.fromRGB(7, 17, 34)
Main.BackgroundTransparency = 0.06
Main.BorderSizePixel = 0
Main.Parent = Gui
corner(Main, 16)
stroke(Main, Color3.fromRGB(0, 145, 255), 1.5, 0.15)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
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
Sidebar.Size = UDim2.new(0, 135, 1, -68)
Sidebar.Position = UDim2.new(0, 8, 0, 64)
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
    local b = Instance.new("ImageButton")
    b.Name = name .. "Tab"
    b.Size = UDim2.new(1, 0, 0, 50)
    b.LayoutOrder = order
    b.BackgroundColor3 = Color3.fromRGB(10, 35, 62)
    b.BorderSizePixel = 0
    b.Image = assetId
    b.ScaleType = Enum.ScaleType.Fit
    b.Parent = Sidebar
    corner(b, 10)
    stroke(b, Color3.fromRGB(25, 75, 120), 1, 0.25)
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
Content.Size = UDim2.new(1, -153, 1, -68)
Content.Position = UDim2.new(0, 145, 0, 64)
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


local FLYING = false
local flySpeed = 50
local flyKeyDown, flyKeyUp, flyRender
local flyControlsGui

local function clearFly()
    FLYING = false

    if flyKeyDown then flyKeyDown:Disconnect(); flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect(); flyKeyUp = nil end
    if flyRender then flyRender:Disconnect(); flyRender = nil end

    if flyControlsGui then
        flyControlsGui:Destroy()
        flyControlsGui = nil
    end

    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then
            hum.PlatformStand = false
            hum.AutoRotate = true
        end
        if root then
            for _, obj in ipairs(root:GetChildren()) do
                if obj.Name == "OliverFlyVelocity" or obj.Name == "OliverFlyGyro" then
                    obj:Destroy()
                end
            end
        end
    end
end

local function makeFlyMobileButton(parent, text, pos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 58, 0, 42)
    b.Position = pos
    b.Text = text
    b.TextSize = 18
    b.Font = Enum.Font.SourceSansBold
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,45)
    b.BackgroundTransparency = 0.15
    b.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

local function showFlyMobileControls(control)
    if flyControlsGui then flyControlsGui:Destroy() end

    flyControlsGui = Instance.new("Frame")
    flyControlsGui.Name = "FlyMobileControls"
    flyControlsGui.Size = UDim2.new(0, 210, 0, 150)
    flyControlsGui.Position = UDim2.new(1, -225, 1, -165)
    flyControlsGui.BackgroundTransparency = 1
    flyControlsGui.ZIndex = 100
    flyControlsGui.Parent = Gui

    local function holdButton(textValue, pos, key)
        local b = makeFlyMobileButton(flyControlsGui, textValue, pos)

        b.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                control[key] = 1
            end
        end)

        b.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                control[key] = 0
            end
        end)
    end

    holdButton("▲", UDim2.new(0, 72, 0, 0), "Up")
    holdButton("▼", UDim2.new(0, 72, 0, 50), "Down")
    holdButton("◀", UDim2.new(0, 8, 0, 50), "Left")
    holdButton("▶", UDim2.new(0, 136, 0, 50), "Right")
    holdButton("↑", UDim2.new(0, 72, 0, 100), "Forward")
end

local function sFLY()
    clearFly()

    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local control = {
        F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0,
        Up = 0, Down = 0, Left = 0, Right = 0, Forward = 0
    }

    local gyro = Instance.new("BodyGyro")
    gyro.Name = "OliverFlyGyro"
    gyro.P = 9e4
    gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    gyro.CFrame = workspace.CurrentCamera.CFrame
    gyro.Parent = root

    local velocity = Instance.new("BodyVelocity")
    velocity.Name = "OliverFlyVelocity"
    velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    velocity.Velocity = Vector3.zero
    velocity.Parent = root

    FLYING = true
    hum.PlatformStand = false
    hum.AutoRotate = false

    flyKeyDown = UIS.InputBegan:Connect(function(input, processed)
        if processed then return end

        local k = input.KeyCode
        if k == Enum.KeyCode.W then control.F = 1
        elseif k == Enum.KeyCode.S then control.B = -1
        elseif k == Enum.KeyCode.A then control.L = -1
        elseif k == Enum.KeyCode.D then control.R = 1
        elseif k == Enum.KeyCode.E then control.Q = 1
        elseif k == Enum.KeyCode.Q then control.E = -1
        end
    end)

    flyKeyUp = UIS.InputEnded:Connect(function(input)
        local k = input.KeyCode
        if k == Enum.KeyCode.W then control.F = 0
        elseif k == Enum.KeyCode.S then control.B = 0
        elseif k == Enum.KeyCode.A then control.L = 0
        elseif k == Enum.KeyCode.D then control.R = 0
        elseif k == Enum.KeyCode.E then control.Q = 0
        elseif k == Enum.KeyCode.Q then control.E = 0
        end
    end)

    showFlyMobileControls(control)

    flyRender = RunService.RenderStepped:Connect(function()
        if not FLYING or not root.Parent then
            clearFly()
            return
        end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local direction = Vector3.zero
        local joystickDirection = hum.MoveDirection

        local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        local flatRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)

        if flatLook.Magnitude > 0.001 then flatLook = flatLook.Unit end
        if flatRight.Magnitude > 0.001 then flatRight = flatRight.Unit end

        if joystickDirection.Magnitude > 0.05 then
            local forwardAmount = joystickDirection:Dot(flatLook)
            local sideAmount = joystickDirection:Dot(flatRight)

            direction += cam.CFrame.LookVector * forwardAmount
            direction += flatRight * sideAmount
        else
            local forward = control.F + control.B + control.Forward
            local side = control.L + control.R + control.Left + control.Right

            if forward ~= 0 then
                direction += cam.CFrame.LookVector * forward
            end
            if side ~= 0 then
                direction += flatRight * side
            end
        end

        local vertical = control.Q + control.E + control.Up - control.Down
        if vertical ~= 0 then
            direction += Vector3.yAxis * vertical
        end

        if direction.Magnitude > 0 then
            velocity.Velocity = direction.Unit * flySpeed
        else
            velocity.Velocity = Vector3.zero
        end

        gyro.CFrame = cam.CFrame
    end)
end

local function NOFLY()
    clearFly()
end

local FlyToggle = makeToggle(MainPage, "Fly (IY Style)", "Camera direction + mobile joystick", 5, function(on)
    if on then
        sFLY()
    else
        NOFLY()
    end
end)

local NoclipToggle = makeToggle(MainPage, "Noclip All Part", "Walk through character parts", 5, function(on)
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

local ESPToggle = makeToggle(MainPage, "Box Line (ESP)", "Box + tracer line for players", 7, function(on)
    espEnabled = on
    if not on then
        clearESP()
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not espObjects[p.UserId] then
                createESPForPlayer(p)
            end
        end
    end
end)


local function createESPForPlayer(plr)
    if not Drawing or not Drawing.new then return end

    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Color = Color3.fromRGB(255, 50, 50)
    box.Filled = false
    box.Visible = false

    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Visible = false

    local conn
    conn = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        local character = plr.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")

        if espEnabled and plr ~= LocalPlayer and hrp and head and camera then
            local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.65

                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
                box.Visible = true

                line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                line.Visible = true
            else
                box.Visible = false
                line.Visible = false
            end
        else
            box.Visible = false
            line.Visible = false
        end
    end)

    plr.AncestryChanged:Connect(function(_, parent)
        if not parent then
            pcall(function() box:Remove() end)
            pcall(function() line:Remove() end)
            if conn then conn:Disconnect() end
        end
    end)

    espObjects[plr.UserId] = {box = box, line = line, conn = conn}
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function()
            if obj.conn then obj.conn:Disconnect() end
            if obj.box then obj.box:Remove() end
            if obj.line then obj.line:Remove() end
        end)
    end
    espObjects = {}
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESPForPlayer(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then createESPForPlayer(p) end
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
    NOFLY()
    noclipEnabled = false
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    walkSpeedEnabled = false
    if walkConnection then walkConnection:Disconnect(); walkConnection = nil end
    setWalkSpeed()
    espEnabled = false
    clearESP()
end)


local MainStatus = makeLabel(
    MainPage,
    "FUNCTIONS: FLY  •  NOCLIP  •  ESP  •  WALKSPEED  •  RESET  •  REJOIN  •  RESTORE",
    UDim2.new(1, 0, 0, 22),
    UDim2.new(0, 0, 0, 0),
    9,
    Color3.fromRGB(80, 145, 190)
)
MainStatus.LayoutOrder = 11
MainStatus.TextXAlignment = Enum.TextXAlignment.Center

-- ============================================================
-- PLAYER PAGE
-- ============================================================

makeSectionTitle(PlayerPage, "Players", "Search and select a player", 1)

local Search = makeInput(PlayerPage, "🔎  Search player...", "", 2)

local Count = makeLabel(
    PlayerPage,
    "0",
    UDim2.new(1, 0, 0, 34),
    UDim2.new(0, 0, 0, 0),
    22,
    Color3.fromRGB(65, 205, 255)
)
Count.LayoutOrder = 3
Count.Font = Enum.Font.GothamBold
Count.TextXAlignment = Enum.TextXAlignment.Center

local CountCaption = makeLabel(
    PlayerPage,
    "PLAYER IN SERVER",
    UDim2.new(1, 0, 0, 18),
    UDim2.new(0, 0, 0, 0),
    9,
    Color3.fromRGB(115, 155, 195)
)
CountCaption.LayoutOrder = 3.5
CountCaption.TextXAlignment = Enum.TextXAlignment.Center

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
                card.Size = UDim2.new(1,0,0,54)
                card.LayoutOrder = order
                card.BackgroundColor3 = Color3.fromRGB(10, 31, 54)
                card.BorderSizePixel = 0
                card.Parent = PlayerList
                corner(card, 10)
                stroke(card, Color3.fromRGB(25,75,120), 1, 0.25)

                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0,38,0,38)
                av.Position = UDim2.new(0,8,0.5,-19)
                av.BackgroundTransparency = 1
                av.Image = "rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"
                av.Parent = card
                corner(av, 10)

                local dn = makeLabel(card, p.DisplayName, UDim2.new(1,-165,0,20), UDim2.new(0,54,0,6), 13, Color3.fromRGB(245,250,255))
                dn.Font = Enum.Font.GothamBold

                makeLabel(card, "@"..p.Name, UDim2.new(1,-165,0,17), UDim2.new(0,54,0,27), 9, Color3.fromRGB(120,155,190))

                local goto = Instance.new("TextButton")
                goto.Size = UDim2.new(0,64,0,30)
                goto.Position = UDim2.new(1,-73,0.5,-15)
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

    Count.Text = tostring(#Players:GetPlayers())
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
