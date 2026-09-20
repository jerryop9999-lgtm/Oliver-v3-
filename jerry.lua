-- ==========================================
-- DELTA EXECUTOR CUSTOM GUI SCRIPT
-- LOGO ID: 128290087536397
-- UPDATED: ESP BOX & LINE + PLAYER AVATARS
-- ==========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local CUSTOM_LOGO_ID = "rbxassetid://128290087536397"

-- 1. ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCustomHub"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
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
MainFrame.Size = UDim2.new(0, 420, 0, 300)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
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
TitleLabel.Size = UDim2.new(0, 150, 1, 0)
TitleLabel.Position = UDim2.new(0, 45, 0, 0)
TitleLabel.Text = "Delta Premium Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TopBar

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
PageMain.CanvasSize = UDim2.new(0, 0, 0, 320)
PageMain.ScrollBarThickness = 4
PageMain.Parent = PagesFolder

local MainList = Instance.new("UIListLayout")
MainList.Padding = UDim.new(0, 8)
MainList.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainList.Parent = PageMain

local isFlying = false
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

-- Fly
createToggleBtn("Fly", PageMain, function(state)
    isFlying = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if isFlying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
        
        task.spawn(function()
            while isFlying do
                RunService.RenderStepped:Wait()
                bv.Velocity = Camera.CFrame.LookVector * 50
            end
            bv:Destroy()
        end)
    end
end)

-- Noclip
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

-- ==========================================
-- REAL 2D BOX & TRACER LINE ESP SYSTEM
-- ==========================================
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

-- Speed Input Only (Removed Jump)
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

createInput("Speed _______", function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- Custom Name Tag
createInput("Name Tag ______", function(text)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        local head = LocalPlayer.Character.Head
        if head:FindFirstChild("CustomNameTag") then head.CustomNameTag:Destroy() end
        
        local bb = Instance.new("BillboardGui")
        bb.Name = "CustomNameTag"
        bb.Size = UDim2.new(0, 100, 0, 30)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = head
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
        lbl.TextScaled = true
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.SourceSansBold
        lbl.Parent = bb
    end
end)

-- ==========================================
-- PAGE 2: PLAYER PAGE (WITH AVATAR IMAGES)
-- ==========================================
local PagePlayer = Instance.new("Frame")
PagePlayer.Size = UDim2.new(1, 0, 1, 0)
PagePlayer.BackgroundTransparency = 1
PagePlayer.Visible = false
PagePlayer.Parent = PagesFolder

-- Local Player Info Header
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

-- Player List Scroll Container
local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(0.95, 0, 1, -105)
PlayerListScroll.Position = UDim2.new(0.025, 0, 0, 100)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.ScrollBarThickness = 4
PlayerListScroll.Parent = PagePlayer

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 5)
PlayerListLayout.Parent = PlayerListScroll

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
            
            -- រូបភាព Avatar Headshot របស់ Player នីមួយៗ
            local pAvatar = Instance.new("ImageLabel")
            pAvatar.Size = UDim2.new(0, 28, 0, 28)
            pAvatar.Position = UDim2.new(0, 5, 0, 5)
            pAvatar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            pAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. targetPlayer.UserId .. "&w=150&h=150"
            pAvatar.Parent = card
            
            local pAvatarCorner = Instance.new("UICorner")
            pAvatarCorner.CornerRadius = UDim.new(0, 6)
            pAvatarCorner.Parent = pAvatar
            
            -- ឈ្មោះ Player
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
            
            -- ប៊ូតុង Goto
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
end

updatePlayerList()
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(SearchBox.Text)
end)
Players.PlayerAdded:Connect(function() updatePlayerList(SearchBox.Text) end)
Players.PlayerRemoving:Connect(function() updatePlayerList(SearchBox.Text) end)

-- ==========================================
-- TAB SWITCHING SYSTEM
-- ==========================================
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
