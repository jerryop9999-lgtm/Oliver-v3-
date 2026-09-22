-- ==========================================
-- SCRIPT NAME: OLIVER V3
-- FLY SYSTEM: AUTHENTIC INFINITE YIELD ENGINE
-- ==========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local CUSTOM_LOGO_ID = "rbxassetid://128290087536397"

-- 1. ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OLIVER V3"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
ScreenGui.DisplayOrder = 10000
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Smooth Drag Function
local function makeSmoothDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(frame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

-- 2. Toggle UI Button
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "OpenCloseLogo"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Image = CUSTOM_LOGO_ID
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.Parent = ScreenGui

local BtnUICorner = Instance.new("UICorner")
BtnUICorner.CornerRadius = UDim.new(0.5, 0)
BtnUICorner.Parent = ToggleBtn

makeSmoothDraggable(ToggleBtn)

-- 3. Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 360)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

makeSmoothDraggable(MainFrame)

-- 4. Top Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
TopBar.Parent = MainFrame

local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 30, 0, 30)
HeaderLogo.Position = UDim2.new(0, 8, 0, 5)
HeaderLogo.Image = CUSTOM_LOGO_ID
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 45, 0, 0)
TitleLabel.Text = "OLIVER V3 HUB"
TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopBar

local HeaderStats = Instance.new("TextLabel")
HeaderStats.Size = UDim2.new(0, 170, 1, 0)
HeaderStats.Position = UDim2.new(1, -175, 0, 0)
HeaderStats.Text = "FPS --  |  PING --"
HeaderStats.TextColor3 = Color3.fromRGB(235, 235, 235)
HeaderStats.TextXAlignment = Enum.TextXAlignment.Right
HeaderStats.Font = Enum.Font.SourceSansBold
HeaderStats.TextSize = 14
HeaderStats.BackgroundTransparency = 1
HeaderStats.Parent = TopBar

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 5. Tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 100, 1, -40)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabBar.Parent = MainFrame

local TabMainBtn = Instance.new("TextButton")
TabMainBtn.Size = UDim2.new(1, -10, 0, 35)
TabMainBtn.Position = UDim2.new(0, 5, 0, 10)
TabMainBtn.Text = "Main"
TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMainBtn.Font = Enum.Font.SourceSansBold
TabMainBtn.TextSize = 14
TabMainBtn.Parent = TabBar

local TabPlayerBtn = Instance.new("TextButton")
TabPlayerBtn.Size = UDim2.new(1, -10, 0, 35)
TabPlayerBtn.Position = UDim2.new(0, 5, 0, 50)
TabPlayerBtn.Text = "Player"
TabPlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TabPlayerBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
TabPlayerBtn.Font = Enum.Font.SourceSansBold
TabPlayerBtn.TextSize = 14
TabPlayerBtn.Parent = TabBar

-- 6. Content Pages Container
local PagesFolder = Instance.new("Frame")
PagesFolder.Size = UDim2.new(1, -100, 1, -40)
PagesFolder.Position = UDim2.new(0, 100, 0, 40)
PagesFolder.BackgroundTransparency = 1
PagesFolder.Parent = MainFrame

-- ==========================================
-- PAGE 1: MAIN PAGE
-- ==========================================
local PageMain = Instance.new("ScrollingFrame")
PageMain.Size = UDim2.new(1, 0, 1, 0)
PageMain.BackgroundTransparency = 1
PageMain.CanvasSize = UDim2.new(0, 0, 0, 0)
PageMain.AutomaticCanvasSize = Enum.AutomaticSize.Y
PageMain.ScrollingDirection = Enum.ScrollingDirection.Y
PageMain.ScrollBarThickness = 5
PageMain.ScrollBarImageTransparency = 0.15
PageMain.Parent = PagesFolder

local MainList = Instance.new("UIListLayout")
MainList.Padding = UDim.new(0, 8)
MainList.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainList.SortOrder = Enum.SortOrder.LayoutOrder
MainList.Parent = PageMain

local MainPagePadding = Instance.new("UIPadding")
MainPagePadding.PaddingTop = UDim.new(0, 10)
MainPagePadding.PaddingBottom = UDim.new(0, 12)
MainPagePadding.Parent = PageMain

local isNoclip = false
local isESP = false

local function createToggleBtn(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(45, 45, 60)
        callback(state)
    end)
    return btn
end

-- ==========================================
-- FLY SYSTEM - IY-STYLE
-- Keyboard: W/A/S/D = move, E = up, Q = down
-- Mobile: on-screen direction controls
-- ==========================================
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
    flyControlsGui.Parent = ScreenGui

    local function holdButton(text, pos, key)
        local b = makeFlyMobileButton(flyControlsGui, text, pos)

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
    gyro.CFrame = Camera.CFrame
    gyro.Parent = root

    local velocity = Instance.new("BodyVelocity")
    velocity.Name = "OliverFlyVelocity"
    velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    velocity.Velocity = Vector3.zero
    velocity.Parent = root

    FLYING = true
    -- Keep Humanoid active so the mobile joystick supplies MoveDirection.
    hum.PlatformStand = false
    hum.AutoRotate = false

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
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

    flyKeyUp = UserInputService.InputEnded:Connect(function(input)
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

        -- Camera-relative flight:
        -- Mobile joystick forward/back follows the camera pitch too,
        -- so looking up makes the player fly up and looking down makes
        -- the player fly down. Side movement stays camera-relative.
        local direction = Vector3.zero
        local joystickDirection = hum.MoveDirection

        local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        local flatRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)

        if flatLook.Magnitude > 0.001 then
            flatLook = flatLook.Unit
        end
        if flatRight.Magnitude > 0.001 then
            flatRight = flatRight.Unit
        end

        if joystickDirection.Magnitude > 0.05 then
            -- Convert the normal Roblox joystick direction into
            -- camera-relative forward/side input.
            local forwardAmount = joystickDirection:Dot(flatLook)
            local sideAmount = joystickDirection:Dot(flatRight)

            direction += cam.CFrame.LookVector * forwardAmount
            direction += flatRight * sideAmount
        else
            local forward = control.F + control.B + control.Forward
            local side = control.L + control.R + control.Left + control.Right

            if forward ~= 0 then
                -- Keyboard forward/back also follows camera up/down.
                direction += cam.CFrame.LookVector * forward
            end

            if side ~= 0 then
                direction += flatRight * side
            end
        end

        -- E/Q and mobile up/down buttons remain available.
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

createToggleBtn("Fly (IY Style)", PageMain, function(state)
    if state then
        sFLY()
    else
        NOFLY()
    end
end)

-- Noclip All Parts
createToggleBtn("Noclip All Part", PageMain, function(state)
    isNoclip = state
end)

RunService.Stepped:Connect(function()
    if isNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 2D Box & Tracer Line ESP System
createToggleBtn("Box Line (ESP)", PageMain, function(state)
    isESP = state
end)

local function createESPForPlayer(plr)
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
        if isESP and plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
            local hrp = plr.Character.HumanoidRootPart
            local head = plr.Character.Head
            
            local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.65
                
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
                box.Visible = true

                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
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
            box:Remove()
            line:Remove()
            if conn then conn:Disconnect() end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESPForPlayer(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then createESPForPlayer(p) end
end)

-- Speed Input Box
local function createInput(placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 32)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.Parent = PageMain
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box
    
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) end
    end)
end

createInput("Fly Speed (Default 50) ______", function(val)
    flySpeed = math.clamp(val, 1, 500)
end)

local walkSpeedEnabled = false
local walkSpeedValue = 50
local walkSpeedBtn

local function applyWalkSpeed()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = walkSpeedEnabled and walkSpeedValue or 16
    end
end

walkSpeedBtn = createToggleBtn("WalkSpeed", PageMain, function(state)
    walkSpeedEnabled = state
    applyWalkSpeed()
end)

createInput("WalkSpeed Value (Default 50) ______", function(val)
    walkSpeedValue = math.clamp(val, 1, 500)
    if walkSpeedEnabled then
        applyWalkSpeed()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.1)
        applyWalkSpeed()
    end
end)

-- ==========================================
-- PAGE 2: PLAYER PAGE
-- ==========================================
local PagePlayer = Instance.new("Frame")
PagePlayer.Size = UDim2.new(1, 0, 1, 0)
PagePlayer.BackgroundTransparency = 1
PagePlayer.Visible = false
PagePlayer.Parent = PagesFolder

-- Local Player Avatar Header
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 45, 0, 45)
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImage.Parent = PagePlayer

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 8)
AvatarCorner.Parent = AvatarImage

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(0, 200, 0, 45)
UsernameLabel.Position = UDim2.new(0, 62, 0, 10)
UsernameLabel.Text = "@" .. LocalPlayer.Name
UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameLabel.Font = Enum.Font.SourceSansBold
UsernameLabel.TextSize = 16
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Parent = PagePlayer

-- Search Player Box
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.95, 0, 0, 30)
SearchBox.Position = UDim2.new(0.025, 0, 0, 65)
SearchBox.PlaceholderText = "Search player name..."
SearchBox.Text = ""
SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 14
SearchBox.Parent = PagePlayer

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBox

-- Player Scroll List
local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(0.95, 0, 1, -105)
PlayerListScroll.Position = UDim2.new(0.025, 0, 0, 100)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.BorderSizePixel = 0
PlayerListScroll.ScrollBarThickness = 5
PlayerListScroll.ScrollingDirection = Enum.ScrollingDirection.Y
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerListScroll.ElasticBehavior = Enum.ElasticBehavior.Always
PlayerListScroll.Parent = PagePlayer

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 5)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Parent = PlayerListScroll

local PlayerListPadding = Instance.new("UIPadding")
PlayerListPadding.PaddingBottom = UDim.new(0, 8)
PlayerListPadding.Parent = PlayerListScroll

local function updatePlayerCanvas()
    task.defer(function()
        PlayerListScroll.CanvasSize = UDim2.new(
            0, 0,
            0, PlayerListLayout.AbsoluteContentSize.Y + 12
        )
    end)
end

local function updatePlayerList(searchText)
    for _, item in pairs(PlayerListScroll:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    
    searchText = searchText and searchText:lower() or ""
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer and (searchText == "" or targetPlayer.Name:lower():find(searchText)) then
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, -8, 0, 38)
            card.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            card.Parent = PlayerListScroll
            
            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 6)
            cCorner.Parent = card
            
            -- Avatar Headshot Icon
            local pAvatar = Instance.new("ImageLabel")
            pAvatar.Size = UDim2.new(0, 28, 0, 28)
            pAvatar.Position = UDim2.new(0, 5, 0, 5)
            pAvatar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            pAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. targetPlayer.UserId .. "&w=150&h=150"
            pAvatar.Parent = card
            
            local pAvatarCorner = Instance.new("UICorner")
            pAvatarCorner.CornerRadius = UDim.new(0, 6)
            pAvatarCorner.Parent = pAvatar
            
            -- Player Name
            local pName = Instance.new("TextLabel")
            pName.Size = UDim2.new(0.5, 0, 1, 0)
            pName.Position = UDim2.new(0, 40, 0, 0)
            pName.Text = targetPlayer.Name
            pName.TextColor3 = Color3.fromRGB(255, 255, 255)
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.Font = Enum.Font.SourceSans
            pName.TextSize = 13
            pName.TextTruncate = Enum.TextTruncate.AtEnd
            pName.BackgroundTransparency = 1
            pName.Parent = card
            
            -- Goto Button
            local gotoBtn = Instance.new("TextButton")
            gotoBtn.Size = UDim2.new(0.28, 0, 0.75, 0)
            gotoBtn.Position = UDim2.new(0.7, 0, 0.125, 0)
            gotoBtn.Text = "Goto"
            gotoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            gotoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            gotoBtn.Font = Enum.Font.SourceSansBold
            gotoBtn.TextSize = 12
            gotoBtn.Parent = card
            
            local gCorner = Instance.new("UICorner")
            gCorner.CornerRadius = UDim.new(0, 4)
            gCorner.Parent = gotoBtn
            
            gotoBtn.MouseButton1Click:Connect(function()
                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end)
        end
    end

    updatePlayerCanvas()
end

updatePlayerList()
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(SearchBox.Text)
end)
Players.PlayerAdded:Connect(function() updatePlayerList(SearchBox.Text) end)
Players.PlayerRemoving:Connect(function() updatePlayerList(SearchBox.Text) end)

-- Tab Navigation System
TabMainBtn.MouseButton1Click:Connect(function()
    PageMain.Visible = true
    PagePlayer.Visible = false
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabPlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    TabPlayerBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

TabPlayerBtn.MouseButton1Click:Connect(function()
    PageMain.Visible = false
    PagePlayer.Visible = true
    TabPlayerBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    TabPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    TabMainBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- ============================================================
-- OLIVER V3 - UPDATED EXTRAS
-- Infinite Jump: removed
-- Name Tag: removed
-- Anti-AFK: toggle
-- WalkSpeed: toggle + value
-- Fly: mobile joystick supported
-- FPS/Ping: shown in header
-- ============================================================

local OliverExtraFolder = Instance.new("Frame")
OliverExtraFolder.Name = "OLIVER_V3_Extras"
OliverExtraFolder.Size = UDim2.new(0.9, 0, 0, 160)
OliverExtraFolder.BackgroundTransparency = 1
OliverExtraFolder.Parent = PageMain

local ExtraList = Instance.new("UIListLayout")
ExtraList.Padding = UDim.new(0, 8)
ExtraList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ExtraList.SortOrder = Enum.SortOrder.LayoutOrder
ExtraList.Parent = OliverExtraFolder

local function createExtraButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.Parent = OliverExtraFolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

local antiAFKEnabled = false
local antiAFKConnection
local antiAFKHeartbeat
local VirtualUser = game:GetService("VirtualUser")

local function setAntiAFK(state)
    antiAFKEnabled = state

    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end

    if antiAFKHeartbeat then
        antiAFKHeartbeat:Disconnect()
        antiAFKHeartbeat = nil
    end

    if state then
        antiAFKConnection = LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end)

        -- Periodic idle-reset attempt while enabled.
        local elapsed = 0
        antiAFKHeartbeat = RunService.Heartbeat:Connect(function(dt)
            elapsed += dt
            if elapsed >= 30 then
                elapsed = 0
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)
            end
        end)
    end
end

local antiAFKBtn = createExtraButton("Anti-AFK: OFF", function(btn)
    setAntiAFK(not antiAFKEnabled)
    btn.Text = "Anti-AFK: " .. (antiAFKEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = antiAFKEnabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(45, 45, 60)
end)

createExtraButton("Reset Character", function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

createExtraButton("Rejoin Server", function()
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end)

createExtraButton("RESTORE ALL", function()
    pcall(function() NOFLY() end)

    isNoclip = false
    isESP = false
    setAntiAFK(false)

    walkSpeedEnabled = false
    applyWalkSpeed()

    if antiAFKBtn then
        antiAFKBtn.Text = "Anti-AFK: OFF"
        antiAFKBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    end
end)

-- Header FPS / Ping monitor
local fpsFrames = 0
local fpsElapsed = 0

RunService.RenderStepped:Connect(function(dt)
    fpsFrames += 1
    fpsElapsed += dt

    if fpsElapsed >= 0.5 then
        local fps = math.floor(fpsFrames / fpsElapsed + 0.5)
        local ping = 0

        pcall(function()
            ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)
        end)

        HeaderStats.Text = "FPS " .. fps .. "  |  PING " .. ping .. " ms"

        fpsFrames = 0
        fpsElapsed = 0
    end
end)

-- Canvas size is automatic; all controls remain reachable by vertical scrolling.
-- Clean, predictable Main-page order
local function setOliverOrder()
    local order = {
        ["Fly Speed (Default 50) ______"] = 10,
        ["WalkSpeed Value (Default 50) ______"] = 20,
        ["Fly (IY Style): OFF"] = 30,
        ["Noclip All Part: OFF"] = 40,
        ["Box Line (ESP): OFF"] = 50,
        ["OLIVER_V3_Extras"] = 60,
    }

    for _, child in ipairs(PageMain:GetChildren()) do
        if child:IsA("TextBox") then
            child.LayoutOrder = order[child.PlaceholderText] or 100
        elseif child:IsA("TextButton") then
            child.LayoutOrder = order[child.Text] or 100
        elseif child.Name == "OLIVER_V3_Extras" then
            child.LayoutOrder = order[child.Name]
        end
    end
end
setOliverOrder()

