-- ====================================================
-- Ultimate Avatar Changer v2
-- UI អូសបាន + Button អណ្ដែតអូសបាន + Search Username + Apply
-- ទាញយកម្ដងមួយជំហាន ហើយបង្ហាញក្នុង Console
-- ====================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local TAG = "[AvatarChanger] "
local busy = false
local selectedName = ""

-- ====================================================
-- UI
-- ====================================================
local parentGui
pcall(function() parentGui = (gethui and gethui()) end)
parentGui = parentGui or LocalPlayer:WaitForChild("PlayerGui")

local old = parentGui:FindFirstChild("AvatarChangerUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AvatarChangerUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parentGui

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

-- Draggable helper (onClick ត្រូវហៅតែពេលមិនបានអូស)
local function makeDraggable(handle, target, onClick)
    local dragging, moved, dragStart, startPos = false, false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging, moved = true, false
            dragStart, startPos = input.Position, target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if not moved and onClick then onClick() end
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if d.Magnitude > 5 then moved = true end
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- Main window
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 390)
main.Position = UDim2.new(0.5, -150, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui
corner(main, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
title.BorderSizePixel = 0
title.Text = "  🎭 Avatar Changer (អូសនៅទីនេះ)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main
corner(title, 10)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 22)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.Parent = title
corner(closeBtn, 6)

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -20, 0, 32)
box.Position = UDim2.fromOffset(10, 40)
box.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
box.PlaceholderText = "🔍 Search / វាយ Username..."
box.Text = ""
box.TextColor3 = Color3.new(1, 1, 1)
box.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.ClearTextOnFocus = false
box.Parent = main
corner(box, 8)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 0, 140)
list.Position = UDim2.fromOffset(10, 78)
list.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new()
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.Parent = main
corner(list, 8)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 3)
layout.Parent = list

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1, -20, 0, 34)
applyBtn.Position = UDim2.fromOffset(10, 226)
applyBtn.BackgroundColor3 = Color3.fromRGB(60, 170, 90)
applyBtn.Text = "✅ Apply"
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 15
applyBtn.Parent = main
corner(applyBtn, 8)

local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1, -20, 0, 112)
logFrame.Position = UDim2.fromOffset(10, 268)
logFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
logFrame.BorderSizePixel = 0
logFrame.ScrollBarThickness = 4
logFrame.CanvasSize = UDim2.new()
logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
logFrame.Parent = main
corner(logFrame, 8)

local logLayout = Instance.new("UIListLayout")
logLayout.Parent = logFrame

-- Floating button
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.fromOffset(52, 52)
floatBtn.Position = UDim2.new(0, 20, 0.5, -26)
floatBtn.BackgroundColor3 = Color3.fromRGB(90, 100, 240)
floatBtn.Text = "🎭"
floatBtn.TextSize = 26
floatBtn.Parent = gui
corner(floatBtn, 26)

makeDraggable(title, main)
makeDraggable(floatBtn, floatBtn, function() main.Visible = not main.Visible end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- ====================================================
-- Log (Console + UI)
-- ====================================================
local logCount = 0
local function log(msg, isWarn)
    if isWarn then warn(TAG .. msg) else print(TAG .. msg) end
    logCount += 1
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -6, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.Font = Enum.Font.Code
    l.TextSize = 12
    l.TextColor3 = isWarn and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(190, 255, 200)
    l.Text = msg
    l.LayoutOrder = logCount
    l.Parent = logFrame
    logFrame.CanvasPosition = Vector2.new(0, 99999)
end

local function clearLog()
    for _, c in ipairs(logFrame:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    logCount = 0
end

-- ====================================================
-- Player search list
-- ====================================================
local function refreshList()
    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local q = string.lower(box.Text)
    for _, p in ipairs(Players:GetPlayers()) do
        if q == "" or string.find(string.lower(p.Name), q, 1, true)
            or string.find(string.lower(p.DisplayName), q, 1, true) then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -6, 0, 28)
            b.BackgroundColor3 = (p.Name == selectedName) and Color3.fromRGB(80, 90, 220) or Color3.fromRGB(50, 50, 65)
            b.Text = p.DisplayName .. "  (@" .. p.Name .. ")"
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            b.Parent = list
            corner(b, 6)
            b.MouseButton1Click:Connect(function()
                selectedName = p.Name
                box.Text = p.Name
            end)
        end
    end
end

box:GetPropertyChangedSignal("Text"):Connect(function()
    selectedName = box.Text
    refreshList()
end)
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(function() task.defer(refreshList) end)
refreshList()

-- ====================================================
-- Avatar copy (ម្ដងមួយជំហាន)
-- ====================================================
local STEP_DELAY = 0.2

local function step(n, text)
    log(("ជំហាន %d: %s"):format(n, text))
    task.wait(STEP_DELAY)
end

local function applyAvatar(targetUsername)
    if targetUsername == "" then
        log("❌ សូមវាយ ឬជ្រើសរើស Username សិន", true)
        return
    end

    clearLog()
    log("🚀 ចាប់ផ្ដើមទាញយក Avatar របស់: " .. targetUsername)

    -- ជំហាន ១: UserId
    step(1, "រក UserId...")
    local ok, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUsername)
    end)
    if not ok or not userId then
        log("❌ រកមិនឃើញ Username នេះទេ", true)
        return
    end
    log("   ✔ UserId = " .. userId)

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- ជំហាន ២: Model គំរូ
    step(2, "បង្កើត Model គំរូ...")
    local okModel, model = pcall(function()
        return Players:CreateHumanoidModelFromUserId(userId)
    end)
    if not okModel or not model then
        model = nil
        log("   ⚠ មិនអាចបង្កើត Model បានទេ (នឹងប្រើ Description ជំនួស)", true)
    else
        log("   ✔ Model បានបង្កើត")
    end

    -- ជំហាន ៣: ព័ត៌មាន HumanoidDescription (សម្រាប់បង្ហាញក្នុង Console)
    step(3, "អានព័ត៌មាន Description...")
    local okDesc, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    if okDesc and desc then
        log(("   Head=%s Torso=%s"):format(tostring(desc.Head), tostring(desc.Torso)))
        log(("   LeftArm=%s RightArm=%s"):format(tostring(desc.LeftArm), tostring(desc.RightArm)))
        log(("   LeftLeg=%s RightLeg=%s"):format(tostring(desc.LeftLeg), tostring(desc.RightLeg)))
        log(("   Face=%s Shirt=%s Pants=%s"):format(tostring(desc.Face), tostring(desc.Shirt), tostring(desc.Pants)))
        log(("   Hair=%s Hat=%s FaceAcc=%s"):format(tostring(desc.HairAccessory), tostring(desc.HatAccessory), tostring(desc.FaceAccessory)))
    else
        log("   ⚠ មិនអាចអាន Description បានទេ (រំលង)", true)
    end

    if okDesc and desc then
        -- បង្ហាញ Accessories ទាំងអស់ដែលគេមាន
        local okAcc, accList = pcall(function() return desc:GetAccessories(true) end)
        if okAcc and accList then
            for _, a in ipairs(accList) do
                log(("   📦 Accessory %s [%s]"):format(tostring(a.AssetId), tostring(a.AccessoryType)))
            end
        end
        log(("   📏 Height=%.2f Width=%.2f Depth=%.2f Head=%.2f Prop=%.2f BodyType=%.2f"):format(
            desc.HeightScale, desc.WidthScale, desc.DepthScale,
            desc.HeadScale, desc.ProportionScale, desc.BodyTypeScale))

        -- វិធីត្រឹមត្រូវបំផុត: ApplyDescription (ដោះស្រាយ សក់ មុខ ក្បាល ដៃជើង Scales ទាំងអស់)
        step(4, "Apply HumanoidDescription (វិធីត្រឹមត្រូវ)...")
        local okApply, err = pcall(function()
            humanoid:ApplyDescriptionReset(desc)
        end)
        if not okApply then
            log("   ⚠ ApplyDescriptionReset: " .. tostring(err), true)
            okApply, err = pcall(function() humanoid:ApplyDescription(desc) end)
        end
        if okApply then
            task.wait(1)
            local n = 0
            for _, v in ipairs(character:GetChildren()) do
                if v:IsA("Accessory") then
                    n += 1
                    log("   ✔ បានដាក់: " .. v.Name)
                elseif v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
                    log("   ✔ បានដាក់: " .. v.ClassName)
                end
            end
            log("   ✔ Apply ជោគជ័យ — Accessories លើខ្លួន: " .. n)
            if model then model:Destroy() end
            log("🎉 ជោគជ័យ! Copy Avatar របស់ " .. targetUsername .. " រួចរាល់")
            return
        else
            log("   ❌ Apply មិនបាន: " .. tostring(err) .. " → ប្តូរទៅវិធី Manual", true)
        end
    end

    if not model then
        log("❌ គ្មានទាំង Model គ្មានទាំង Description — មិនអាចបន្តបាន", true)
        return
    end

    -- ជំហាន ៤ (Manual fallback): Body parts
    step(4, "Copy រាងកាយ (Body Parts)...")
    local partCount = 0
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("BasePart") then
            local localPart = character:FindFirstChild(v.Name)
            if localPart and localPart:IsA("BasePart") then
                pcall(function()
                    localPart.Color = v.Color
                    localPart.Material = v.Material
                end)
                for _, child in ipairs(v:GetChildren()) do
                    if (child:IsA("SpecialMesh") or child:IsA("SurfaceAppearance")
                        or child:IsA("Texture") or child:IsA("Decal"))
                        and not (child:IsA("Decal") and child.Name == "face") then
                        local ex = localPart:FindFirstChild(child.Name)
                        if ex then ex:Destroy() end
                        child:Clone().Parent = localPart
                    end
                end
                if v:IsA("MeshPart") and localPart:IsA("MeshPart") then
                    local okMesh = pcall(function()
                        localPart.MeshId = v.MeshId
                        localPart.TextureID = v.TextureID
                    end)
                    if not okMesh then
                        log("   ⚠ " .. v.Name .. ": ប្តូរ MeshId មិនបាន (Executor មិនគាំទ្រ)", true)
                    end
                end
                partCount += 1
                log("   ✔ " .. v.Name)
                task.wait(0.05)
            end
        end
    end
    log("   សរុប Body Parts: " .. partCount)

    -- ជំហាន ៥: BodyColors
    step(5, "Copy ពណ៌សម្បុរ (BodyColors)...")
    local targetBC = model:FindFirstChildOfClass("BodyColors")
    if targetBC then
        local bc = character:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors", character)
        bc.HeadColor = targetBC.HeadColor
        bc.TorsoColor = targetBC.TorsoColor
        bc.LeftArmColor = targetBC.LeftArmColor
        bc.RightArmColor = targetBC.RightArmColor
        bc.LeftLegColor = targetBC.LeftLegColor
        bc.RightLegColor = targetBC.RightLegColor
        log("   ✔ BodyColors បាន Copy")
    else
        log("   ⚠ គ្មាន BodyColors", true)
    end

    -- ជំហាន ៦: លុបរបស់ចាស់
    step(6, "លុប Accessories / អាវ / ខោ ចាស់...")
    local removed = 0
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic")
            or v:IsA("CharacterMesh") then
            v:Destroy()
            removed += 1
        end
    end
    log("   ✔ លុបបាន " .. removed .. " ធាតុ")

    -- ជំហាន ៧: Accessories (សក់ មួក ។ល។ រួមទាំង Layered Clothing)
    step(7, "ទាញ Accessories (សក់, មួក, Layered...)...")
    local accCount = 0
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("Accessory") then
            local typeName = "?"
            pcall(function() typeName = v.AccessoryType.Name end)
            local wraps = 0
            for _, d in ipairs(v:GetDescendants()) do
                if d:IsA("WrapLayer") then wraps += 1 end
            end
            local clone = v:Clone()
            local okAdd = pcall(function() humanoid:AddAccessory(clone) end)
            if not okAdd then clone.Parent = character end
            accCount += 1
            log(("   ✔ %s [%s]%s"):format(v.Name, typeName, wraps > 0 and (" +WrapLayer x" .. wraps) or ""))
            task.wait(0.05)
        end
    end
    log("   សរុប Accessories: " .. accCount)

    -- ជំហាន ៨: Clothing
    step(8, "ទាញអាវ ខោ និងរូប T-Shirt...")
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("CharacterMesh") then
            v:Clone().Parent = character
            log("   ✔ " .. v.ClassName .. " (" .. v.Name .. ")")
        end
    end

    -- ជំហាន ៩: មុខ
    step(9, "Copy មុខ (Face)...")
    local tHead = model:FindFirstChild("Head")
    local lHead = character:FindFirstChild("Head")
    if tHead and lHead then
        local tFace = tHead:FindFirstChildOfClass("Decal")
        if tFace then
            local lFace = lHead:FindFirstChildOfClass("Decal")
            if lFace then
                lFace.Texture = tFace.Texture
            else
                tFace:Clone().Parent = lHead
            end
            log("   ✔ Face: " .. tostring(tFace.Texture))
        else
            log("   ⚠ គ្មាន Face Decal", true)
        end
    end

    -- ជំហាន ១០: Scales
    step(10, "Copy ទំហំរាងកាយ (Scales)...")
    local tHum = model:FindFirstChildOfClass("Humanoid")
    if tHum then
        for _, name in ipairs({"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale", "ProportionScale", "BodyTypeScale"}) do
            local ts = tHum:FindFirstChild(name)
            local ls = humanoid:FindFirstChild(name)
            if ts and ls and ts:IsA("NumberValue") and ls:IsA("NumberValue") then
                ls.Value = ts.Value
                log(("   ✔ %s = %.3f"):format(name, ts.Value))
            end
        end
    else
        log("   ⚠ គ្មាន Humanoid ក្នុង Model", true)
    end

    model:Destroy()
    log("🎉 ជោគជ័យ! Copy Avatar របស់ " .. targetUsername .. " រួចរាល់")
end

applyBtn.MouseButton1Click:Connect(function()
    if busy then return end
    busy = true
    applyBtn.Text = "⏳ កំពុងដំណើរការ..."
    local ok, err = pcall(applyAvatar, box.Text)
    if not ok then log("❌ Error: " .. tostring(err), true) end
    applyBtn.Text = "✅ Apply"
    busy = false
end)

log("ត្រៀមរួចរាល់ — ជ្រើសរើស Username រួចចុច Apply")
