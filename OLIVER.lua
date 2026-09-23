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
TitleLabel.Size = UDim2.new(0, 180, 1, 0)
TitleLabel.Position = UDim2.new(0, 45, 0, 0)
TitleLabel.Text = "OLIVER V3 HUB"
TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopBar

local HeaderStats = Instance.new("TextLabel")
HeaderStats.Size = UDim2.new(0, 150, 1, 0)
HeaderStats.Position = UDim2.new(1, -155, 0, 0)
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
TabMainBtn.Text = ""
TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMainBtn.Font = Enum.Font.SourceSansBold
TabMainBtn.TextSize = 14
TabMainBtn.Parent = TabBar

local TabPlayerBtn = Instance.new("TextButton")
TabPlayerBtn.Size = UDim2.new(1, -10, 0, 35)
TabPlayerBtn.Position = UDim2.new(0, 5, 0, 50)
TabPlayerBtn.Text = ""
TabPlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TabPlayerBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
TabPlayerBtn.Font = Enum.Font.SourceSansBold
TabPlayerBtn.TextSize = 14
TabPlayerBtn.Parent = TabBar


local TabAnimationsBtn = Instance.new("TextButton")
TabAnimationsBtn.Size = UDim2.new(1, -10, 0, 35)
TabAnimationsBtn.Position = UDim2.new(0, 5, 0, 90)
TabAnimationsBtn.Text = ""
TabAnimationsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TabAnimationsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
TabAnimationsBtn.Font = Enum.Font.SourceSansBold
TabAnimationsBtn.TextSize = 14
TabAnimationsBtn.Parent = TabBar

local function setPageButtonLogo(tabButton, assetId)
    local tabLogo = Instance.new("ImageLabel")
    tabLogo.Name = "Logo"
    tabLogo.Size = UDim2.new(0, 30, 0, 30)
    tabLogo.Position = UDim2.new(0.5, -15, 0.5, -15)
    tabLogo.BackgroundTransparency = 1
    tabLogo.Image = assetId
    tabLogo.Parent = tabButton
end

setPageButtonLogo(TabMainBtn, "rbxassetid://111648653308842")
setPageButtonLogo(TabPlayerBtn, "rbxassetid://99191727508887")
setPageButtonLogo(TabAnimationsBtn, "rbxassetid://105863394969753")

-- 6. Content Pages Container
local PagesFolder = Instance.new("Frame")
PagesFolder.Size = UDim2.new(1, -100, 1, -40)
PagesFolder.Position = UDim2.new(0, 100, 0, 40)
PagesFolder.BackgroundTransparency = 1
PagesFolder.Parent = MainFrame


-- ==========================================
-- PAGE 1: MAIN PAGE
-- ==========================================

--// SPIN FUNCTION
local spinEnabled = false
local spinSpeed = 10
local spinConnection
local spinCharacterConnection
local spinAngle = 0
local spinBaseRotation
local spinSavedAutoRotate

local function getSpinCharacter()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return char, root, hum
end

local function applySpin(root, dt)
    if not root or not root.Parent or not spinBaseRotation then return end

    -- The angle is accumulated from RenderStepped time, so walking cannot
    -- reset it or make it slower.
    spinAngle = (spinAngle + math.rad(spinSpeed) * dt) % (math.pi * 2)

    -- Keep the current position/movement, but use the rotation captured when
    -- Spin was enabled. Humanoid movement therefore cannot fight the spin.
    root.CFrame = CFrame.new(root.Position) * spinBaseRotation * CFrame.Angles(0, spinAngle, 0)

    -- Do not let physics add a second rotation on top of the requested speed.
    root.AssemblyAngularVelocity = Vector3.zero
end

local function restoreSpinCharacter()
    local _, root, hum = getSpinCharacter()

    if hum and spinSavedAutoRotate ~= nil then
        hum.AutoRotate = spinSavedAutoRotate
    end

    if root then
        root.AssemblyAngularVelocity = Vector3.zero
    end

    spinSavedAutoRotate = nil
    spinBaseRotation = nil
    spinAngle = 0
end

local function stopSpin()
    spinEnabled = false

    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end

    if spinCharacterConnection then
        spinCharacterConnection:Disconnect()
        spinCharacterConnection = nil
    end

    restoreSpinCharacter()
end

local function startSpin()
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end

    if spinCharacterConnection then
        spinCharacterConnection:Disconnect()
        spinCharacterConnection = nil
    end

    local _, root, hum = getSpinCharacter()
    if not root or not hum then return end

    spinEnabled = true
    spinAngle = 0

    -- Save the player's current facing once. Walking will continue normally,
    -- but AutoRotate cannot overwrite the Spin rotation every frame.
    spinBaseRotation = root.CFrame - root.Position
    spinSavedAutoRotate = hum.AutoRotate
    hum.AutoRotate = false

    spinConnection = RunService.RenderStepped:Connect(function(dt)
        if not spinEnabled then return end

        local _, currentRoot, currentHum = getSpinCharacter()
        if not currentRoot or not currentHum then return end

        applySpin(currentRoot, dt)
    end)

    -- Re-apply Spin to a new character after respawn.
    spinCharacterConnection = LocalPlayer.CharacterAdded:Connect(function(char)
        if not spinEnabled then return end

        local newRoot = char:WaitForChild("HumanoidRootPart", 5)
        local newHum = char:WaitForChild("Humanoid", 5)

        if newRoot and newHum and spinEnabled then
            spinAngle = 0
            spinBaseRotation = newRoot.CFrame - newRoot.Position
            spinSavedAutoRotate = newHum.AutoRotate
            newHum.AutoRotate = false
        end
    end)
end


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
MainPagePadding.PaddingTop = UDim.new(0, 50)
MainPagePadding.PaddingBottom = UDim.new(0, 12)
MainPagePadding.Parent = PageMain


--// SPIN - MAIN PAGE FUNCTION
local SpinRow = Instance.new("Frame")
SpinRow.Name = "Spin"
SpinRow.Size = UDim2.new(0.9, 0, 0, 74)
SpinRow.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
SpinRow.BorderSizePixel = 0
SpinRow.LayoutOrder = -8
SpinRow.Parent = PageMain

local SpinRowCorner = Instance.new("UICorner")
SpinRowCorner.CornerRadius = UDim.new(0, 7)
SpinRowCorner.Parent = SpinRow

local SpinTitle = Instance.new("TextLabel")
SpinTitle.BackgroundTransparency = 1
SpinTitle.Position = UDim2.new(0, 12, 0, 7)
SpinTitle.Size = UDim2.new(0.5, 0, 0, 25)
SpinTitle.Font = Enum.Font.SourceSansBold
SpinTitle.Text = "Spin"
SpinTitle.TextSize = 15
SpinTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinTitle.TextXAlignment = Enum.TextXAlignment.Left
SpinTitle.Parent = SpinRow

local SpinButton = Instance.new("TextButton")
SpinButton.Size = UDim2.new(0, 86, 0, 28)
SpinButton.Position = UDim2.new(1, -98, 0, 7)
SpinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
SpinButton.BorderSizePixel = 0
SpinButton.Font = Enum.Font.SourceSansBold
SpinButton.Text = "Spin: OFF"
SpinButton.TextSize = 13
SpinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinButton.Parent = SpinRow

local SpinButtonCorner = Instance.new("UICorner")
SpinButtonCorner.CornerRadius = UDim.new(0, 6)
SpinButtonCorner.Parent = SpinButton

local SpinSpeedBox = Instance.new("TextBox")
SpinSpeedBox.Size = UDim2.new(0, 86, 0, 27)
SpinSpeedBox.Position = UDim2.new(1, -98, 0, 40)
SpinSpeedBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
SpinSpeedBox.BorderSizePixel = 0
SpinSpeedBox.Font = Enum.Font.SourceSans
SpinSpeedBox.PlaceholderText = "Speed..."
SpinSpeedBox.Text = tostring(spinSpeed)
SpinSpeedBox.TextSize = 12
SpinSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinSpeedBox.Parent = SpinRow

local SpinSpeedCorner = Instance.new("UICorner")
SpinSpeedCorner.CornerRadius = UDim.new(0, 6)
SpinSpeedCorner.Parent = SpinSpeedBox

local SpinSpeedLabel = Instance.new("TextLabel")
SpinSpeedLabel.BackgroundTransparency = 1
SpinSpeedLabel.Position = UDim2.new(0, 12, 0, 40)
SpinSpeedLabel.Size = UDim2.new(0.5, 0, 0, 25)
SpinSpeedLabel.Font = Enum.Font.SourceSans
SpinSpeedLabel.Text = "Spin Speed"
SpinSpeedLabel.TextSize = 12
SpinSpeedLabel.TextColor3 = Color3.fromRGB(175, 175, 190)
SpinSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpinSpeedLabel.Parent = SpinRow

SpinButton.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled

    if spinEnabled then
        startSpin()
        SpinButton.Text = "Spin: ON"
        SpinButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    else
        stopSpin()
        SpinButton.Text = "Spin: OFF"
        SpinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    end
end)

SpinSpeedBox.FocusLost:Connect(function()
    local value = tonumber(SpinSpeedBox.Text)

    if value then
        -- Normal Spin Speed input range.
        spinSpeed = math.max(value, 1)
        SpinSpeedBox.Text = tostring(spinSpeed)
    else
        SpinSpeedBox.Text = tostring(spinSpeed)
    end
end)

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

-- OLIVER_MAIN_FUNCTIONS_LABEL
local MainFunctionsLabel = Instance.new("TextLabel")
MainFunctionsLabel.Name = "OLIVER_MAIN_FUNCTIONS_LABEL"
MainFunctionsLabel.BackgroundTransparency = 1
MainFunctionsLabel.Size = UDim2.new(1, 0, 0, 22)
MainFunctionsLabel.Font = Enum.Font.GothamBold
MainFunctionsLabel.Text = "MOVEMENT & TOOLS"
MainFunctionsLabel.TextSize = 10
MainFunctionsLabel.TextColor3 = Color3.fromRGB(70, 200, 245)
MainFunctionsLabel.TextXAlignment = Enum.TextXAlignment.Left
MainFunctionsLabel.LayoutOrder = -9
MainFunctionsLabel.Parent = MainPage

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

    -- Keep fly physics off the character while seated in a vehicle.
    -- A full BodyGyro on the seated assembly can force cars/bikes to spin.
    local gyro = nil
    local velocity = nil
    local wasSeated = false

    local function enableCharacterFlyPhysics()
        if velocity and velocity.Parent then return end

        gyro = Instance.new("BodyGyro")
        gyro.Name = "OliverFlyGyro"
        gyro.P = 9e4
        gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.CFrame = Camera.CFrame
        gyro.Parent = root

        velocity = Instance.new("BodyVelocity")
        velocity.Name = "OliverFlyVelocity"
        velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        velocity.Velocity = Vector3.zero
        velocity.Parent = root
    end

    local function disableCharacterFlyPhysics()
        if velocity then
            velocity:Destroy()
            velocity = nil
        end
        if gyro then
            gyro:Destroy()
            gyro = nil
        end
        root.AssemblyAngularVelocity = Vector3.zero
    end

    enableCharacterFlyPhysics()

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

        -- IMPORTANT: when sitting in a car/bike/vehicle, pause the fly
        -- physics completely. This prevents BodyGyro from fighting the
        -- vehicle's own orientation and making it spin.
        local seatPart = hum.SeatPart
        if seatPart then
            if not wasSeated then
                wasSeated = true
                -- Keep BodyVelocity so the vehicle can still fly.
                -- Remove only the orientation controller so it cannot spin.
                if gyro then
                    gyro:Destroy()
                    gyro = nil
                end
                hum.AutoRotate = true
            end

            -- Never allow the seated vehicle assembly to accumulate spin.
            if root and root.Parent then
                root.AssemblyAngularVelocity = Vector3.zero
            end
        elseif wasSeated then
            wasSeated = false
            hum.AutoRotate = false
            enableCharacterFlyPhysics()
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

        if gyro and gyro.Parent and not wasSeated then
            gyro.CFrame = cam.CFrame
        end

        if wasSeated and root and root.Parent then
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

local function NOFLY()
    clearFly()
end

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

-- Compact speed rows styled like the Spin control.
local function createSpeedRow(title, defaultValue, minValue, maxValue, onToggle, onSpeedChanged)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.9, 0, 0, 74)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    row.BorderSizePixel = 0
    row.Parent = PageMain

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = row

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 12, 0, 7)
    titleLabel.Size = UDim2.new(0.5, 0, 0, 25)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Text = title
    titleLabel.TextSize = 15
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 86, 0, 28)
    toggle.Position = UDim2.new(1, -98, 0, 7)
    toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    toggle.BorderSizePixel = 0
    toggle.Font = Enum.Font.SourceSansBold
    toggle.Text = title .. ": OFF"
    toggle.TextSize = 13
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Parent = row

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 86, 0, 27)
    speedBox.Position = UDim2.new(1, -98, 0, 40)
    speedBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    speedBox.BorderSizePixel = 0
    speedBox.Font = Enum.Font.SourceSans
    speedBox.PlaceholderText = "Speed..."
    speedBox.Text = tostring(defaultValue)
    speedBox.TextSize = 12
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.Parent = row

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 6)
    speedCorner.Parent = speedBox

    local speedLabel = Instance.new("TextLabel")
    speedLabel.BackgroundTransparency = 1
    speedLabel.Position = UDim2.new(0, 12, 0, 40)
    speedLabel.Size = UDim2.new(0.5, 0, 0, 25)
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.Text = title .. " Speed"
    speedLabel.TextSize = 12
    speedLabel.TextColor3 = Color3.fromRGB(175, 175, 190)
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = row

    local enabled = false

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.Text = title .. ": " .. (enabled and "ON" or "OFF")
        toggle.BackgroundColor3 = enabled
            and Color3.fromRGB(0, 170, 100)
            or Color3.fromRGB(45, 45, 60)
        onToggle(enabled)
    end)

    speedBox.FocusLost:Connect(function()
        local value = tonumber(speedBox.Text)
        if value then
            value = math.clamp(value, minValue, maxValue)
            speedBox.Text = tostring(value)
            onSpeedChanged(value)
        else
            speedBox.Text = tostring(defaultValue)
        end
    end)

    return row
end

createSpeedRow("Fly", flySpeed, 1, 500,
    function(state)
        if state then
            sFLY()
        else
            NOFLY()
        end
    end,
    function(value)
        flySpeed = value
    end
)

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

walkSpeedBtn = createSpeedRow("Walk Speed", walkSpeedValue, 1, 500,
    function(state)
        walkSpeedEnabled = state
        applyWalkSpeed()
    end,
    function(value)
        walkSpeedValue = value
        if walkSpeedEnabled then
            applyWalkSpeed()
        end
    end
)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.1)
        applyWalkSpeed()
    end
end)

-- ==========================================
-- PAGE 2: ANIMATIONS PAGE - ADIDAS COMMUNITY (REAL CONTROLLER)
local PageAnimations = Instance.new("Frame")
PageAnimations.Name = "PageAnimations"
PageAnimations.Size = UDim2.new(1, 0, 1, 0)
PageAnimations.BackgroundTransparency = 1
PageAnimations.Visible = false
PageAnimations.Parent = PagesFolder

-- Adidas Community animation assets used by the controller.
local AdidasAnimationLogoId = "rbxassetid://105863394969753"

local AdidasCommunity = {
    Idle     = "rbxassetid://122257458498464",
    Idle2    = "rbxassetid://122257458498464",
    Walk     = "rbxassetid://122150855457006",
    Run      = "rbxassetid://82598234841035",
    Jump     = "rbxassetid://75290611992385",
    Fall     = "rbxassetid://98600215928904",
    Climb    = "rbxassetid://88763136693023",
    Swim     = "rbxassetid://133308483266208",
    SwimIdle = "rbxassetid://133308483266208",
}

local animationEnabled = false
local animationCleanup = nil
local animationRespawnConnection = nil

local function stopAdidasAnimations(character)
    if animationCleanup then
        pcall(animationCleanup)
        animationCleanup = nil
    end

    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animate = character:FindFirstChild("Animate")
    local folder = character:FindFirstChild("__OLIVER_AdidasAnimation")

    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                pcall(function()
                    track:Stop(0.08)
                end)
            end
        end
    end

    if folder then
        folder:Destroy()
    end

    if animate then
        animate.Enabled = false
        task.wait(0.08)
        animate.Enabled = true
    end
end

local function applyAdidasAnimations(character)
    if not animationEnabled or not character or not character.Parent then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animate = character:FindFirstChild("Animate")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

    if not humanoid or not animator then
        return false
    end

    local oldFolder = character:FindFirstChild("__OLIVER_AdidasAnimation")
    if oldFolder then
        oldFolder:Destroy()
    end

    if animate then
        animate.Enabled = false
    end

    local folder = Instance.new("Folder")
    folder.Name = "__OLIVER_AdidasAnimation"
    folder.Parent = character

    local tracks = {}

    local function loadTrack(name, id, priority, looped)
        local anim = Instance.new("Animation")
        anim.Name = name
        anim.AnimationId = id
        anim.Parent = folder

        local ok, track = pcall(function()
            return animator:LoadAnimation(anim)
        end)

        if ok and track then
            track.Priority = priority
            track.Looped = looped
            tracks[name] = track
        end
    end

    loadTrack("Idle", AdidasCommunity.Idle, Enum.AnimationPriority.Idle, true)
    loadTrack("Walk", AdidasCommunity.Walk, Enum.AnimationPriority.Movement, true)
    loadTrack("Run", AdidasCommunity.Run, Enum.AnimationPriority.Movement, true)
    loadTrack("Jump", AdidasCommunity.Jump, Enum.AnimationPriority.Movement, false)
    loadTrack("Fall", AdidasCommunity.Fall, Enum.AnimationPriority.Movement, true)
    loadTrack("Climb", AdidasCommunity.Climb, Enum.AnimationPriority.Movement, true)
    loadTrack("Swim", AdidasCommunity.Swim, Enum.AnimationPriority.Movement, true)
    loadTrack("SwimIdle", AdidasCommunity.SwimIdle, Enum.AnimationPriority.Movement, true)

    local currentTrack = nil
    local stateConnection
    local moveConnection
    local ancestryConnection

    local function stopAll(fade)
        for _, track in pairs(tracks) do
            if track.IsPlaying then
                track:Stop(fade or 0.1)
            end
        end
    end

    local function play(name, speed)
        local track = tracks[name]
        if not track then return end

        if currentTrack ~= track then
            stopAll(0.1)
            currentTrack = track
            track:Play(0.1, 1, speed or 1)
        elseif speed then
            track:AdjustSpeed(speed)
        end
    end

    local function update()
        if not animationEnabled or not humanoid.Parent then
            return
        end

        local state = humanoid:GetState()
        local moving = humanoid.MoveDirection.Magnitude > 0.05
        local speed = humanoid.WalkSpeed

        if state == Enum.HumanoidStateType.Jumping then
            play("Jump", 1)
        elseif state == Enum.HumanoidStateType.Freefall then
            play("Fall", 1)
        elseif state == Enum.HumanoidStateType.Climbing then
            play("Climb", math.max(speed / 8, 0.5))
        elseif state == Enum.HumanoidStateType.Swimming then
            if moving then
                play("Swim", math.max(speed / 8, 0.5))
            else
                play("SwimIdle", 1)
            end
        elseif moving then
            if speed >= 14 and tracks.Run then
                play("Run", math.max(speed / 16, 0.5))
            else
                play("Walk", math.max(speed / 8, 0.5))
            end
        else
            play("Idle", 1)
        end
    end

    stateConnection = humanoid.StateChanged:Connect(function()
        task.defer(update)
    end)

    moveConnection = humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
        task.defer(update)
    end)

    ancestryConnection = character.AncestryChanged:Connect(function(_, parent)
        if parent then return end
        if animationCleanup then
            pcall(animationCleanup)
            animationCleanup = nil
        end
    end)

    animationCleanup = function()
        if stateConnection then stateConnection:Disconnect(); stateConnection = nil end
        if moveConnection then moveConnection:Disconnect(); moveConnection = nil end
        if ancestryConnection then ancestryConnection:Disconnect(); ancestryConnection = nil end

        for _, track in pairs(tracks) do
            pcall(function()
                track:Stop(0.08)
                track:Destroy()
            end)
        end
        currentTrack = nil
    end

    update()
    return next(tracks) ~= nil
end


-- ==========================================
-- ZOMBIE ANIMATIONS
-- ==========================================
local ZombieAnimations = {
    Run      = "rbxassetid://616163682",
    Walk     = "rbxassetid://616168032",
    Jump     = "rbxassetid://616161997",
    Idle1    = "rbxassetid://616158929",
    Idle2    = "rbxassetid://616160636",
    Fall     = "rbxassetid://616157476",
    Swim     = "rbxassetid://616165109",
    SwimIdle = "rbxassetid://616166655",
    Climb    = "rbxassetid://616156119",
}

local function applyZombieAnimations(character)
    if not character or not character.Parent then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

    if animationCleanup then pcall(animationCleanup); animationCleanup = nil end
    animationEnabled = true
    activeAnimationPack = "Zombie"

    local folder = Instance.new("Folder")
    folder.Name = "__OLIVER_ZombieAnimation"
    folder.Parent = character

    local tracks = {}
    local function load(name, id, looped)
        local a = Instance.new("Animation")
        a.Name = "Zombie_" .. name
        a.AnimationId = id
        a.Parent = folder
        local ok, tr = pcall(function() return animator:LoadAnimation(a) end)
        if ok and tr then
            tr.Priority = Enum.AnimationPriority.Action
            tr.Looped = looped
            tracks[name] = tr
        end
    end

    load("Idle1", ZombieAnimations.Idle1, true)
    load("Idle2", ZombieAnimations.Idle2, true)
    load("Walk", ZombieAnimations.Walk, true)
    load("Run", ZombieAnimations.Run, true)
    load("Jump", ZombieAnimations.Jump, false)
    load("Fall", ZombieAnimations.Fall, true)
    load("Climb", ZombieAnimations.Climb, true)
    load("Swim", ZombieAnimations.Swim, true)
    load("SwimIdle", ZombieAnimations.SwimIdle, true)

    local current
    local function stopAll()
        for _, tr in pairs(tracks) do
            if tr.IsPlaying then pcall(function() tr:Stop(0.08) end) end
        end
    end
    local function play(name, speed)
        local tr = tracks[name]
        if not tr then return end
        if current ~= tr then
            stopAll()
            current = tr
            tr:Play(0.08, 1, speed or 1)
        elseif speed then
            tr:AdjustSpeed(speed)
        end
    end
    local function update()
        if not animationEnabled or activeAnimationPack ~= "Zombie" then return end
        local s = humanoid:GetState()
        local moving = humanoid.MoveDirection.Magnitude > 0.05
        local speed = humanoid.WalkSpeed
        if s == Enum.HumanoidStateType.Jumping then
            play("Jump", 1)
        elseif s == Enum.HumanoidStateType.Freefall then
            play("Fall", 1)
        elseif s == Enum.HumanoidStateType.Climbing then
            play("Climb", math.max(speed / 8, .5))
        elseif s == Enum.HumanoidStateType.Swimming then
            play(moving and "Swim" or "SwimIdle", math.max(speed / 8, .5))
        elseif moving then
            play(speed >= 14 and "Run" or "Walk", math.max(speed / (speed >= 14 and 16 or 8), .5))
        else
            play("Idle1", 1)
        end
    end

    local c1 = humanoid.StateChanged:Connect(function() task.defer(update) end)
    local c2 = humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function() task.defer(update) end)
    animationCleanup = function()
        pcall(function() c1:Disconnect() end)
        pcall(function() c2:Disconnect() end)
        for _, tr in pairs(tracks) do pcall(function() tr:Stop(.08); tr:Destroy() end) end
        if folder.Parent then folder:Destroy() end
    end
    update()
    return next(tracks) ~= nil
end


local function enableAdidas()
    animationEnabled = true

    local character = LocalPlayer.Character
    if character then
        applyAdidasAnimations(character)
    end
end

local function disableAdidas()
    animationEnabled = false

    local character = LocalPlayer.Character
    if character then
        stopAdidasAnimations(character)
    end
end

if animationRespawnConnection then
    animationRespawnConnection:Disconnect()
end

animationRespawnConnection = LocalPlayer.CharacterAdded:Connect(function(character)
    if not animationEnabled then return end
    task.wait(0.5)
    if animationEnabled then
        applyAdidasAnimations(character)
    end
end)

-- UI
local AdidasHeader = Instance.new("Frame")
AdidasHeader.Size = UDim2.new(0.95, 0, 0, 64)
AdidasHeader.Position = UDim2.new(0.025, 0, 0, 8)
AdidasHeader.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
AdidasHeader.BorderSizePixel = 0
AdidasHeader.Parent = PageAnimations
AdidasHeader.Visible = false
Instance.new("UICorner", AdidasHeader).CornerRadius = UDim.new(0, 8)

local AdidasLogo = Instance.new("ImageLabel")
AdidasLogo.Size = UDim2.new(0, 46, 0, 46)
AdidasLogo.Position = UDim2.new(0, 9, 0.5, -23)
AdidasLogo.BackgroundTransparency = 1
AdidasLogo.Image = AdidasAnimationLogoId
AdidasLogo.Parent = AdidasHeader

local AdidasTitle = Instance.new("TextLabel")
AdidasTitle.Size = UDim2.new(1, -70, 0, 25)
AdidasTitle.Position = UDim2.new(0, 65, 0, 8)
AdidasTitle.BackgroundTransparency = 1
AdidasTitle.Text = "Adidas Community"
AdidasTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AdidasTitle.Font = Enum.Font.GothamBold
AdidasTitle.TextSize = 17
AdidasTitle.TextXAlignment = Enum.TextXAlignment.Left
AdidasTitle.Parent = AdidasHeader

local AdidasSubtitle = Instance.new("TextLabel")
AdidasSubtitle.Size = UDim2.new(1, -70, 0, 20)
AdidasSubtitle.Position = UDim2.new(0, 65, 0, 34)
AdidasSubtitle.BackgroundTransparency = 1
AdidasSubtitle.Text = "Real Animation Pack"
AdidasSubtitle.TextColor3 = Color3.fromRGB(150, 155, 170)
AdidasSubtitle.Font = Enum.Font.SourceSans
AdidasSubtitle.TextSize = 13
AdidasSubtitle.TextXAlignment = Enum.TextXAlignment.Left
AdidasSubtitle.Parent = AdidasHeader

-- Click the Adidas Community card itself to enable the animation.
local AdidasCommunityButton = Instance.new("TextButton")
AdidasCommunityButton.Name = "AdidasCommunityButton"
AdidasCommunityButton.Size = UDim2.new(0.95, 0, 0, 64)
AdidasCommunityButton.Position = UDim2.new(0.025, 0, 0, 8)
AdidasCommunityButton.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
AdidasCommunityButton.BackgroundTransparency = 0
AdidasCommunityButton.BorderSizePixel = 0
AdidasCommunityButton.Text = ""
AdidasCommunityButton.AutoButtonColor = true
AdidasCommunityButton.Active = true
AdidasCommunityButton.ZIndex = 30
AdidasCommunityButton.Parent = PageAnimations

local AdidasButtonCorner = Instance.new("UICorner")
AdidasButtonCorner.CornerRadius = UDim.new(0, 8)
AdidasButtonCorner.Parent = AdidasCommunityButton

local AdidasButtonLogo = Instance.new("ImageLabel")
AdidasButtonLogo.Size = UDim2.new(0, 46, 0, 46)
AdidasButtonLogo.Position = UDim2.new(0, 9, 0.5, -23)
AdidasButtonLogo.BackgroundTransparency = 1
AdidasButtonLogo.Image = AdidasAnimationLogoId
AdidasButtonLogo.ZIndex = 31
AdidasButtonLogo.Parent = AdidasCommunityButton

local AdidasButtonTitle = Instance.new("TextLabel")
AdidasButtonTitle.Size = UDim2.new(1, -70, 0, 25)
AdidasButtonTitle.Position = UDim2.new(0, 65, 0, 8)
AdidasButtonTitle.BackgroundTransparency = 1
AdidasButtonTitle.Text = "Adidas Community"
AdidasButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AdidasButtonTitle.Font = Enum.Font.GothamBold
AdidasButtonTitle.TextSize = 17
AdidasButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
AdidasButtonTitle.ZIndex = 31
AdidasButtonTitle.Parent = AdidasCommunityButton

local AdidasButtonSubtitle = Instance.new("TextLabel")
AdidasButtonSubtitle.Size = UDim2.new(1, -70, 0, 20)
AdidasButtonSubtitle.Position = UDim2.new(0, 65, 0, 34)
AdidasButtonSubtitle.BackgroundTransparency = 1
AdidasButtonSubtitle.Text = "Animations • Tap to use"
AdidasButtonSubtitle.TextColor3 = Color3.fromRGB(150, 155, 170)
AdidasButtonSubtitle.Font = Enum.Font.SourceSans
AdidasButtonSubtitle.TextSize = 13
AdidasButtonSubtitle.TextXAlignment = Enum.TextXAlignment.Left
AdidasButtonSubtitle.ZIndex = 31
AdidasButtonSubtitle.Parent = AdidasCommunityButton

local ZombieCard = makeAnimationCard(
    PageAnimations,
    "Zombie",
    "Zombie Animations • Tap to use",
    AdidasAnimationLogoId,
    80
)

ZombieCard.Activated:Connect(function()
    local ok = applyZombieAnimations(LocalPlayer.Character)
    if ok then
        AnimationStatus.Text = "Zombie • Active"
        AnimationStatus.TextColor3 = Color3.fromRGB(70, 200, 245)
    else
        AnimationStatus.Text = "Zombie animation could not load"
        AnimationStatus.TextColor3 = Color3.fromRGB(255, 120, 120)
    end
end)

local RestoreAnimation = Instance.new("TextButton")
RestoreAnimation.Name = "RestoreAnimation"
RestoreAnimation.Size = UDim2.new(0.95, 0, 0, 42)
RestoreAnimation.Position = UDim2.new(0.025, 0, 0, 82)
RestoreAnimation.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
RestoreAnimation.BorderSizePixel = 0
RestoreAnimation.Font = Enum.Font.GothamBold
RestoreAnimation.Text = "Restore"
RestoreAnimation.TextSize = 14
RestoreAnimation.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreAnimation.AutoButtonColor = true
RestoreAnimation.Active = true
RestoreAnimation.ZIndex = 30
RestoreAnimation.Parent = PageAnimations
Instance.new("UICorner", RestoreAnimation).CornerRadius = UDim.new(0, 7)

local AdidasStatus = Instance.new("TextLabel")
AdidasStatus.Size = UDim2.new(0.95, 0, 0, 25)
AdidasStatus.Position = UDim2.new(0.025, 0, 0, 132)
AdidasStatus.BackgroundTransparency = 1
AdidasStatus.Text = "Adidas Community Animations"
AdidasStatus.Font = Enum.Font.SourceSans
AdidasStatus.TextSize = 13
AdidasStatus.TextColor3 = Color3.fromRGB(150, 155, 170)
AdidasStatus.TextXAlignment = Enum.TextXAlignment.Center
AdidasStatus.ZIndex = 30
AdidasStatus.Parent = PageAnimations

AdidasCommunityButton.Activated:Connect(function()
    animationEnabled = true
    enableAdidas()
    AdidasStatus.Text = "Adidas Community • Active"
    AdidasStatus.TextColor3 = Color3.fromRGB(70, 200, 245)
end)

RestoreAnimation.Activated:Connect(function()
    disableAdidas()
    AdidasStatus.Text = "Restored • Default Animation"
    AdidasStatus.TextColor3 = Color3.fromRGB(170, 175, 190)
end)


-- PAGE 3: PLAYER PAGE (UPDATED UI)
-- ==========================================
local PagePlayer = Instance.new("Frame")
PagePlayer.Name = "PagePlayer"
PagePlayer.Size = UDim2.new(1, 0, 1, 0)
PagePlayer.BackgroundTransparency = 1
PagePlayer.Visible = false
PagePlayer.Parent = PagesFolder

-- Player header
local PlayerHeader = Instance.new("Frame")
PlayerHeader.Size = UDim2.new(0.95, 0, 0, 58)
PlayerHeader.Position = UDim2.new(0.025, 0, 0, 8)
PlayerHeader.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
PlayerHeader.BorderSizePixel = 0
PlayerHeader.Parent = PagePlayer

local PlayerHeaderCorner = Instance.new("UICorner")
PlayerHeaderCorner.CornerRadius = UDim.new(0, 8)
PlayerHeaderCorner.Parent = PlayerHeader

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 44, 0, 44)
AvatarImage.Position = UDim2.new(0, 7, 0.5, -22)
AvatarImage.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImage.Parent = PlayerHeader

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 8)
AvatarCorner.Parent = AvatarImage

local OnlineDot = Instance.new("Frame")
OnlineDot.Size = UDim2.new(0, 10, 0, 10)
OnlineDot.Position = UDim2.new(0, 42, 1, -15)
OnlineDot.BackgroundColor3 = Color3.fromRGB(60, 220, 110)
OnlineDot.BorderSizePixel = 0
OnlineDot.Parent = PlayerHeader

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = OnlineDot

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(1, -65, 0, 24)
UsernameLabel.Position = UDim2.new(0, 60, 0, 8)
UsernameLabel.Text = "@" .. LocalPlayer.Name
UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameLabel.Font = Enum.Font.SourceSansBold
UsernameLabel.TextSize = 16
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Parent = PlayerHeader

local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Size = UDim2.new(1, -65, 0, 18)
PlayerCountLabel.Position = UDim2.new(0, 60, 0, 31)
PlayerCountLabel.Text = "Players in server: 0"
PlayerCountLabel.TextColor3 = Color3.fromRGB(155, 160, 175)
PlayerCountLabel.Font = Enum.Font.SourceSans
PlayerCountLabel.TextSize = 12
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Parent = PlayerHeader

-- Search box
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.95, 0, 0, 34)
SearchBox.Position = UDim2.new(0.025, 0, 0, 73)
SearchBox.PlaceholderText = "Search player name..."
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(145, 145, 160)
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 14
SearchBox.Parent = PagePlayer

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 7)
SearchCorner.Parent = SearchBox

local SearchPadding = Instance.new("UIPadding")
SearchPadding.PaddingLeft = UDim.new(0, 12)
SearchPadding.PaddingRight = UDim.new(0, 12)
SearchPadding.Parent = SearchBox

-- Player scroll list
local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(0.95, 0, 1, -117)
PlayerListScroll.Position = UDim2.new(0.025, 0, 0, 113)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.BorderSizePixel = 0
PlayerListScroll.ScrollBarThickness = 4
PlayerListScroll.ScrollingDirection = Enum.ScrollingDirection.Y
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerListScroll.ElasticBehavior = Enum.ElasticBehavior.Always
PlayerListScroll.Parent = PagePlayer

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 6)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Parent = PlayerListScroll

local PlayerListPadding = Instance.new("UIPadding")
PlayerListPadding.PaddingBottom = UDim.new(0, 10)
PlayerListPadding.Parent = PlayerListScroll

local function updatePlayerCanvas()
    task.defer(function()
        PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y + 12)
        PlayerCountLabel.Text = "Players in server: " .. tostring(math.max(#Players:GetPlayers() - 1, 0))
    end)
end

local function updatePlayerList(searchText)
    for _, item in ipairs(PlayerListScroll:GetChildren()) do
        if item:IsA("Frame") then
            item:Destroy()
        end
    end

    searchText = tostring(searchText or ""):lower()
    local layoutOrder = 0

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            local nameMatch = targetPlayer.Name:lower():find(searchText, 1, true)
            local displayMatch = targetPlayer.DisplayName:lower():find(searchText, 1, true)

            if searchText == "" or nameMatch or displayMatch then
                layoutOrder += 1

                local card = Instance.new("Frame")
                card.Name = "Player_" .. targetPlayer.UserId
                card.Size = UDim2.new(1, -8, 0, 48)
                card.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                card.BorderSizePixel = 0
                card.LayoutOrder = layoutOrder
                card.Parent = PlayerListScroll

                local cCorner = Instance.new("UICorner")
                cCorner.CornerRadius = UDim.new(0, 7)
                cCorner.Parent = card

                local pAvatar = Instance.new("ImageLabel")
                pAvatar.Size = UDim2.new(0, 36, 0, 36)
                pAvatar.Position = UDim2.new(0, 6, 0.5, -18)
                pAvatar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                pAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. targetPlayer.UserId .. "&w=150&h=150"
                pAvatar.Parent = card

                local pAvatarCorner = Instance.new("UICorner")
                pAvatarCorner.CornerRadius = UDim.new(0, 7)
                pAvatarCorner.Parent = pAvatar

                local pName = Instance.new("TextLabel")
                pName.Size = UDim2.new(1, -145, 0, 21)
                pName.Position = UDim2.new(0, 50, 0, 5)
                pName.Text = targetPlayer.DisplayName
                pName.TextColor3 = Color3.fromRGB(255, 255, 255)
                pName.TextXAlignment = Enum.TextXAlignment.Left
                pName.Font = Enum.Font.SourceSansBold
                pName.TextSize = 14
                pName.TextTruncate = Enum.TextTruncate.AtEnd
                pName.BackgroundTransparency = 1
                pName.Parent = card

                local pUser = Instance.new("TextLabel")
                pUser.Size = UDim2.new(1, -145, 0, 17)
                pUser.Position = UDim2.new(0, 50, 0, 26)
                pUser.Text = "@" .. targetPlayer.Name
                pUser.TextColor3 = Color3.fromRGB(150, 155, 170)
                pUser.TextXAlignment = Enum.TextXAlignment.Left
                pUser.Font = Enum.Font.SourceSans
                pUser.TextSize = 11
                pUser.TextTruncate = Enum.TextTruncate.AtEnd
                pUser.BackgroundTransparency = 1
                pUser.Parent = card

                local gotoBtn = Instance.new("TextButton")
                gotoBtn.Size = UDim2.new(0, 72, 0, 32)
                gotoBtn.Position = UDim2.new(1, -80, 0.5, -16)
                gotoBtn.Text = "Goto"
                gotoBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
                gotoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                gotoBtn.Font = Enum.Font.SourceSansBold
                gotoBtn.TextSize = 13
                gotoBtn.AutoButtonColor = true
                gotoBtn.Parent = card

                local gCorner = Instance.new("UICorner")
                gCorner.CornerRadius = UDim.new(0, 6)
                gCorner.Parent = gotoBtn

                gotoBtn.MouseButton1Click:Connect(function()
                    local targetCharacter = targetPlayer.Character
                    local localCharacter = LocalPlayer.Character
                    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
                    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

                    if targetRoot and localRoot then
                        localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                    end
                end)
            end
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
local function selectTab(tab)
    PageMain.Visible = (tab == "Main")
    PagePlayer.Visible = (tab == "Player")
    PageAnimations.Visible = (tab == "Animations")

    local active = Color3.fromRGB(0, 140, 255)
    local inactive = Color3.fromRGB(40, 40, 55)
    local activeText = Color3.fromRGB(255, 255, 255)
    local inactiveText = Color3.fromRGB(200, 200, 200)

    TabMainBtn.BackgroundColor3 = (tab == "Main") and active or inactive
    TabPlayerBtn.BackgroundColor3 = (tab == "Player") and active or inactive
    TabAnimationsBtn.BackgroundColor3 = (tab == "Animations") and active or inactive

    TabMainBtn.TextColor3 = (tab == "Main") and activeText or inactiveText
    TabPlayerBtn.TextColor3 = (tab == "Player") and activeText or inactiveText
    TabAnimationsBtn.TextColor3 = (tab == "Animations") and activeText or inactiveText
end

TabMainBtn.Activated:Connect(function()
    selectTab("Main")
end)

TabPlayerBtn.Activated:Connect(function()
    selectTab("Player")
end)

TabAnimationsBtn.Activated:Connect(function()
    selectTab("Animations")
end)

-- ============================================================
-- OLIVER V3 - UPDATED EXTRAS
-- Infinite Jump: removed
-- Name Tag: removed
-- WalkSpeed: toggle + value
-- Fly: mobile joystick supported
-- FPS/Ping: shown in header
-- ============================================================

local OliverExtraFolder = Instance.new("Frame")
OliverExtraFolder.Name = "OLIVER_V3_Extras"
OliverExtraFolder.Size = UDim2.new(0.9, 0, 0, 120)
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

    walkSpeedEnabled = false
    applyWalkSpeed()
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

