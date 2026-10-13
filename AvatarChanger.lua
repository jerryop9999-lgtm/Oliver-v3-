-- ====================================================
-- Ultimate Avatar Changer v3 + Korblox
-- UI អូសបាន + Button អណ្ដែត + Search + Apply + 🦴 Korblox
-- ====================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local TAG = "[AvatarChanger] "
local busy = false
local selectedName = ""
local korbloxOn = false

local KORBLOX_LEG = 139607718
local LEG_PARTS = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
local VISUAL = {"SurfaceAppearance", "SpecialMesh", "Texture", "Decal", "FaceControls"}

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
applyBtn.Size = UDim2.fromOffset(160, 34)
applyBtn.Position = UDim2.fromOffset(10, 226)
applyBtn.BackgroundColor3 = Color3.fromRGB(60, 170, 90)
applyBtn.Text = "✅ Apply"
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 15
applyBtn.Parent = main
corner(applyBtn, 8)

local korBtn = Instance.new("TextButton")
korBtn.Size = UDim2.fromOffset(114, 34)
korBtn.Position = UDim2.fromOffset(176, 226)
korBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
korBtn.Text = "🦴 Korblox: OFF"
korBtn.TextColor3 = Color3.new(1, 1, 1)
korBtn.Font = Enum.Font.GothamBold
korBtn.TextSize = 12
korBtn.Parent = main
corner(korBtn, 8)

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

korBtn.MouseButton1Click:Connect(function()
    korbloxOn = not korbloxOn
    korBtn.Text = korbloxOn and "🦴 Korblox: ON" or "🦴 Korblox: OFF"
    korBtn.BackgroundColor3 = korbloxOn and Color3.fromRGB(60, 170, 90) or Color3.fromRGB(55, 55, 70)
end)

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
-- Helpers
-- ====================================================
local STEP_DELAY = 0.2

local function step(n, text)
    log(("ជំហាន %d: %s"):format(n, text))
    task.wait(STEP_DELAY)
end

local function isVisual(c)
    for _, cls in ipairs(VISUAL) do
        if c:IsA(cls) then return true end
    end
    return false
end

local function scaleCF(cf, f)
    return CFrame.new(cf.Position * f) * (cf - cf.Position)
end

-- គណនា Joint ទាំងអស់ពី RigAttachment (ដៃជើងមិនដាច់)
local function fixJoints(character)
    local joints = 0
    for _, m in ipairs(character:GetDescendants()) do
        if m:IsA("Motor6D") and m.Part0 and m.Part1 then
            local an = m.Name .. "RigAttachment"
            local a0, a1 = m.Part0:FindFirstChild(an), m.Part1:FindFirstChild(an)
            if a0 and a1 and a0:IsA("Attachment") and a1:IsA("Attachment") then
                m.C0 = a0.CFrame
                m.C1 = a1.CFrame
                joints += 1
            end
        end
    end
    return joints
end

-- ====================================================
-- Korblox Deathspeaker (ជើងស្តាំ)
-- ====================================================
local function getKorbloxParts()
    -- វិធី ១: ទាញពី Asset ផ្ទាល់
    local ok, objs = pcall(function()
        return game:GetObjects("rbxassetid://" .. KORBLOX_LEG)
    end)
    if ok and objs and objs[1] then
        local parts = {}
        for _, d in ipairs(objs[1]:GetDescendants()) do
            if d:IsA("BasePart") and table.find(LEG_PARTS, d.Name) then
                local better = d.Parent and d.Parent.Name == "R15ArtistIntent"
                if not parts[d.Name] or better then parts[d.Name] = d end
            end
        end
        if next(parts) then return parts, objs[1], "Asset", 1 end
    end

    -- វិធី ២: រក Player ក្នុង server ដែលពាក់ Korblox
    for _, p in ipairs(Players:GetPlayers()) do
        local ok2, d = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(p.UserId)
        end)
        if ok2 and d and d.RightLeg == KORBLOX_LEG then
            local ok3, m = pcall(function()
                return Players:CreateHumanoidModelFromUserId(p.UserId)
            end)
            if ok3 and m then
                local parts = {}
                for _, n in ipairs(LEG_PARTS) do
                    local v = m:FindFirstChild(n)
                    if v then parts[n] = v end
                end
                local th = m:FindFirstChildOfClass("Humanoid")
                local hs = th and th:FindFirstChild("BodyHeightScale")
                return parts, m, "Player " .. p.Name, (hs and hs.Value) or 1
            end
        end
    end
    return nil
end

local function applyKorblox(character, humanoid)
    if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
        log("   ❌ Korblox គាំទ្រតែ R15", true)
        return
    end
    local parts, holder, source, base = getKorbloxParts()
    if not parts then
        log("   ❌ រកជើង Korblox មិនឃើញ (GetObjects មិនគាំទ្រ ហើយគ្មានអ្នកពាក់ក្នុង server)", true)
        return
    end
    log("   ✔ ប្រភព Korblox: " .. source)

    local hs = humanoid:FindFirstChild("BodyHeightScale")
    local f = ((hs and hs:IsA("NumberValue")) and hs.Value or 1) / math.max(base, 0.01)
    local done = 0

    for _, name in ipairs(LEG_PARTS) do
        local v, lp = parts[name], character:FindFirstChild(name)
        if v and lp then
            local ok, err = pcall(function()
                lp.Size = v.Size * f
                lp.Color = v.Color
                lp.Material = v.Material
                if v:IsA("MeshPart") and lp:IsA("MeshPart") then
                    lp.MeshId = v.MeshId
                    lp.TextureID = v.TextureID
                end
                for _, c in ipairs(lp:GetChildren()) do
                    if isVisual(c) then c:Destroy() end
                end
                for _, c in ipairs(v:GetChildren()) do
                    if isVisual(c) then c:Clone().Parent = lp end
                end
                for _, a in ipairs(v:GetChildren()) do
                    if a:IsA("Attachment") then
                        local la = lp:FindFirstChild(a.Name)
                        if la and la:IsA("Attachment") then
                            la.CFrame = scaleCF(a.CFrame, f)
                        else
                            local c = a:Clone()
                            c.CFrame = scaleCF(a.CFrame, f)
                            c.Parent = lp
                        end
                    end
                end
            end)
            if ok then
                done += 1
                log("   ✔ Korblox " .. name)
            else
                log("   ❌ " .. name .. ": " .. tostring(err), true)
            end
        end
    end

    log("   ✔ Joint កែ: " .. fixJoints(character))
    pcall(function() holder:Destroy() end)
    log(("   🦴 Korblox ដាក់រួច %d/3 ដុំ"):format(done))
end

-- ====================================================
-- Avatar copy
-- ====================================================
local function applyAvatar(targetUsername)
    -- ដាក់តែជើង Korblox (Username ទទេ)
    if targetUsername == "" then
        if not korbloxOn then
            log("❌ សូមវាយ ឬជ្រើសរើស Username សិន (ឬបើក 🦴 Korblox)", true)
            return
        end
        clearLog()
        log("🦴 ដាក់តែជើង Korblox លើ Avatar បច្ចុប្បន្ន")
        local ch = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hm = ch:WaitForChild("Humanoid")
        applyKorblox(ch, hm)
        log("🎉 រួចរាល់")
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
        log("❌ មិនអាចបង្កើត Model បានទេ", true)
        return
    end
    log("   ✔ Model បានបង្កើត")

    -- ជំហាន ៣: ព័ត៌មាន Description
    step(3, "អានព័ត៌មាន Description...")
    local okDesc, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    if okDesc and desc then
        log(("   Head=%s Torso=%s"):format(tostring(desc.Head), tostring(desc.Torso)))
        log(("   LeftArm=%s RightArm=%s"):format(tostring(desc.LeftArm), tostring(desc.RightArm)))
        log(("   LeftLeg=%s RightLeg=%s"):format(tostring(desc.LeftLeg), tostring(desc.RightLeg)))
        log(("   Face=%s Shirt=%s Pants=%s"):format(tostring(desc.Face), tostring(desc.Shirt), tostring(desc.Pants)))
        local okAcc, accList = pcall(function() return desc:GetAccessories(true) end)
        if okAcc and accList then
            for _, a in ipairs(accList) do
                log(("   📦 Accessory %s [%s]"):format(tostring(a.AssetId), tostring(a.AccessoryType)))
            end
        end
        log(("   📏 H=%.2f W=%.2f D=%.2f Head=%.2f Prop=%.2f"):format(
            desc.HeightScale, desc.WidthScale, desc.DepthScale, desc.HeadScale, desc.ProportionScale))
    else
        log("   ⚠ មិនអាចអាន Description បានទេ (រំលង)", true)
    end

    -- Scales មុន
    local tHum0 = model:FindFirstChildOfClass("Humanoid")
    if tHum0 then
        for _, name in ipairs({"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale", "ProportionScale", "BodyTypeScale"}) do
            local ts, ls = tHum0:FindFirstChild(name), humanoid:FindFirstChild(name)
            if ts and ls and ts:IsA("NumberValue") and ls:IsA("NumberValue") then
                ls.Value = ts.Value
            end
        end
        task.wait(0.3)
    end

    -- ជំហាន ៤: កែ Body Parts នៅនឹងកន្លែង
    step(4, "កែរាងកាយ (Body Parts) នៅនឹងកន្លែង...")
    local partCount = 0
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            local lp = character:FindFirstChild(v.Name)
            if lp and lp:IsA("BasePart") then
                local okPart, errPart = pcall(function()
                    lp.Size = v.Size
                    lp.Color = v.Color
                    lp.Material = v.Material
                    lp.Transparency = v.Transparency

                    if v:IsA("MeshPart") and lp:IsA("MeshPart") then
                        local okMesh = pcall(function()
                            lp.MeshId = v.MeshId
                            lp.TextureID = v.TextureID
                        end)
                        if not okMesh then
                            log("   ⚠ " .. v.Name .. ": ប្តូរ MeshId មិនបាន", true)
                        end
                    end

                    for _, c in ipairs(lp:GetChildren()) do
                        if isVisual(c) then c:Destroy() end
                    end
                    for _, c in ipairs(v:GetChildren()) do
                        if isVisual(c) then c:Clone().Parent = lp end
                    end

                    for _, att in ipairs(v:GetChildren()) do
                        if att:IsA("Attachment") then
                            local la = lp:FindFirstChild(att.Name)
                            if la and la:IsA("Attachment") then
                                la.CFrame = att.CFrame
                            else
                                att:Clone().Parent = lp
                            end
                        end
                    end
                end)
                if okPart then
                    partCount += 1
                    log("   ✔ " .. v.Name .. " (" .. v.ClassName .. ")")
                else
                    log("   ❌ " .. v.Name .. ": " .. tostring(errPart), true)
                end
                task.wait(0.05)
            end
        end
    end
    log("   សរុប Body Parts ដែលកែ: " .. partCount)

    local tHRP = model:FindFirstChild("HumanoidRootPart")
    local lHRP = character:FindFirstChild("HumanoidRootPart")
    if tHRP and lHRP then
        for _, a in ipairs(tHRP:GetChildren()) do
            if a:IsA("Attachment") then
                local la = lHRP:FindFirstChild(a.Name)
                if la and la:IsA("Attachment") then
                    la.CFrame = a.CFrame
                else
                    a:Clone().Parent = lHRP
                end
            end
        end
    end

    log("   ✔ Joint ដែលកែ: " .. fixJoints(character))
    if tHum0 then
        pcall(function() humanoid.HipHeight = tHum0.HipHeight end)
    end

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

    -- ជំហាន ៧: Accessories
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
            log("   ℹ ប្រើ Dynamic Head — មុខមកជាមួយក្បាលរួចហើយ")
        end
    end

    -- ជំហាន ១០: Scales
    step(10, "Copy ទំហំរាងកាយ (Scales)...")
    if tHum0 then
        for _, name in ipairs({"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale", "ProportionScale", "BodyTypeScale"}) do
            local ts = tHum0:FindFirstChild(name)
            local ls = humanoid:FindFirstChild(name)
            if ts and ls and ts:IsA("NumberValue") and ls:IsA("NumberValue") then
                ls.Value = ts.Value
                log(("   ✔ %s = %.3f"):format(name, ts.Value))
            end
        end
    else
        log("   ⚠ គ្មាន Humanoid ក្នុង Model", true)
    end

    -- ជំហាន ១១: Korblox (បើបើក)
    if korbloxOn then
        step(11, "ដាក់ជើង Korblox Deathspeaker...")
        applyKorblox(character, humanoid)
    end

    model:Destroy()
    log("🎉 ជោគជ័យ! Copy Avatar របស់ " .. targetUsername .. " រួចរាល់")
end

applyBtn.MouseButton1Click:Connect(function()
    if busy then return end
    busy = true
    applyBtn.Text = "⏳ ..."
    local ok, err = pcall(applyAvatar, box.Text)
    if not ok then log("❌ Error: " .. tostring(err), true) end
    applyBtn.Text = "✅ Apply"
    busy = false
end)

log("ត្រៀមរួចរាល់ — ជ្រើស Username (ឬបើក 🦴) រួចចុច Apply")