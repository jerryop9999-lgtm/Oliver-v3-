-- ==========================================================
-- OLIVER V3  |  REDESIGNED UI
-- Features kept: Fly, Walk Speed, Spin, Noclip, ESP,
-- Animation Packs, Player list + Goto, Reset / Rejoin / Restore All
-- Tip: press RightShift (PC) or tap the round logo to show/hide.
-- ==========================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local GUI_NAME = "OLIVER V3"
local LOGO = "rbxassetid://128290087536397"
local ICON_MAIN = "rbxassetid://111648653308842"
local ICON_PLAYER = "rbxassetid://99191727508887"
local ICON_ANIM = "rbxassetid://105863394969753"

local Theme = {
    Bg = Color3.fromRGB(13, 14, 21),
    Panel = Color3.fromRGB(18, 20, 30),
    Card = Color3.fromRGB(26, 29, 42),
    CardHover = Color3.fromRGB(33, 37, 54),
    Stroke = Color3.fromRGB(44, 49, 70),
    Text = Color3.fromRGB(240, 243, 252),
    Sub = Color3.fromRGB(135, 143, 168),
    Accent = Color3.fromRGB(0, 190, 255),
    Accent2 = Color3.fromRGB(124, 92, 255),
    Good = Color3.fromRGB(52, 211, 140),
    Warn = Color3.fromRGB(255, 196, 70),
    Bad = Color3.fromRGB(255, 92, 108),
    Off = Color3.fromRGB(52, 57, 80),
    White = Color3.new(1, 1, 1),
}

-- connections we own (disconnected when the UI is closed)
local Connections = {}
local function keep(conn)
    table.insert(Connections, conn)
    return conn
end

-- ---------- tiny UI helpers ----------
local function create(class, props, children)
    local inst = Instance.new(class)
    local parent
    for k, v in pairs(props or {}) do
        if k == "Parent" then parent = v else inst[k] = v end
    end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    if parent then inst.Parent = parent end
    return inst
end

local function round(inst, r)
    return create("UICorner", { CornerRadius = UDim.new(0, r), Parent = inst })
end

local function outline(inst, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = inst,
    })
end

local function pad(inst, l, t, r, b)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or 0),
        PaddingRight = UDim.new(0, r or 0), PaddingBottom = UDim.new(0, b or 0),
        Parent = inst,
    })
end

local function tween(inst, props, time, style)
    local t = TweenService:Create(inst, TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Label(parent, props)
    local p = {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }
    for k, v in pairs(props) do p[k] = v end
    p.Parent = parent
    return create("TextLabel", p)
end

-- ---------- ScreenGui ----------
local function getGuiParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    return CoreGui
end

do -- remove older copies (old V3 or this one)
    local parent = getGuiParent()
    for _, g in ipairs(parent:GetChildren()) do
        if g.Name == GUI_NAME or g.Name == "OLIVER V4" then g:Destroy() end
    end
end

local ScreenGui = create("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    DisplayOrder = 10000,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
if syn and syn.protect_gui then pcall(syn.protect_gui, ScreenGui) end
do
    local ok = pcall(function() ScreenGui.Parent = getGuiParent() end)
    if not ok then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

-- ---------- toasts (small feedback messages) ----------
local ToastHolder = create("Frame", {
    Name = "Toasts", BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 16),
    Size = UDim2.new(0, 320, 0, 160), ZIndex = 50, Parent = ScreenGui,
})
create("UIListLayout", {
    Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = ToastHolder,
})

local toastCount = 0
local function notify(msg, kind)
    local color = (kind == "good" and Theme.Good) or (kind == "bad" and Theme.Bad) or (kind == "warn" and Theme.Warn) or Theme.Accent
    toastCount += 1
    local t = create("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 32),
        BackgroundColor3 = Theme.Panel, BackgroundTransparency = 1,
        Text = msg, TextColor3 = Theme.Text, TextTransparency = 1,
        Font = Enum.Font.GothamMedium, TextSize = 13,
        LayoutOrder = toastCount, ZIndex = 51, Parent = ToastHolder,
    })
    round(t, 16)
    pad(t, 16, 0, 16, 0)
    local st = outline(t, color, 1.2, 1)
    tween(t, { BackgroundTransparency = 0.05, TextTransparency = 0 }, 0.2)
    tween(st, { Transparency = 0.1 }, 0.2)

    -- keep at most 3 toasts on screen
    local toasts = {}
    for _, c in ipairs(ToastHolder:GetChildren()) do
        if c:IsA("TextLabel") then table.insert(toasts, c) end
    end
    table.sort(toasts, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
    while #toasts > 3 do
        table.remove(toasts, 1):Destroy()
    end

    task.delay(2.2, function()
        if t and t.Parent then
            tween(t, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.25)
            tween(st, { Transparency = 1 }, 0.25)
            task.wait(0.3)
            if t then t:Destroy() end
        end
    end)
end

-- ---------- dragging (works for mouse + touch; tap detection for the logo) ----------
local function makeDraggable(target, handle, onTap)
    local dragging, moved = false, false
    local dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, moved = true, false
            dragStart, startPos = input.Position, target.Position
        end
    end)
    keep(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if d.Magnitude > 5 then moved = true end
            if moved then
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end))
    keep(UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            if not moved and onTap then onTap() end
        end
    end))
end

-- ---------- window ----------
local Window = create("CanvasGroup", {
    Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(520, 370), BackgroundColor3 = Theme.Bg, BorderSizePixel = 0, Parent = ScreenGui,
})
round(Window, 14)
outline(Window, Theme.Stroke, 1, 0)

local Header = create("Frame", {
    Name = "Header", Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Theme.Panel, BorderSizePixel = 0, Parent = Window,
})
create("Frame", {
    AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = Header,
})
round(create("ImageLabel", {
    Position = UDim2.fromOffset(12, 9), Size = UDim2.fromOffset(28, 28), Image = LOGO,
    BackgroundColor3 = Theme.Card, Parent = Header,
}), 8)
Label(Header, { Position = UDim2.fromOffset(50, 0), Size = UDim2.new(0, 66, 1, 0), Text = "OLIVER", Font = Enum.Font.GothamBold, TextSize = 16 })
local VersionChip = create("Frame", {
    Position = UDim2.fromOffset(118, 14), Size = UDim2.fromOffset(28, 18),
    BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.82, BorderSizePixel = 0, Parent = Header,
})
round(VersionChip, 9)
Label(VersionChip, { Size = UDim2.fromScale(1, 1), Text = "V3", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Center })

local function headerButton(text, xOffset, hoverColor)
    local b = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOffset, 0.5, 0), Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0, AutoButtonColor = false,
        Text = text, TextColor3 = Theme.Sub, Font = Enum.Font.GothamBold, TextSize = 18, Parent = Header,
    })
    round(b, 8)
    b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = hoverColor, TextColor3 = Theme.White }, 0.12) end)
    b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = Theme.Card, TextColor3 = Theme.Sub }, 0.12) end)
    return b
end
local CloseBtn = headerButton("×", -10, Theme.Bad)
local MinBtn = headerButton("–", -46, Theme.CardHover)

local Stats = create("Frame", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -84, 0.5, 0), Size = UDim2.fromOffset(128, 26),
    BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = Header,
})
round(Stats, 13)
local StatsLabel = Label(Stats, {
    Size = UDim2.fromScale(1, 1), Text = "-- FPS · -- ms", Font = Enum.Font.GothamMedium,
    TextSize = 12, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Center,
})

makeDraggable(Window, Header)

-- sidebar
local Sidebar = create("Frame", {
    Name = "Sidebar", Position = UDim2.fromOffset(0, 46), Size = UDim2.new(0, 112, 1, -46),
    BackgroundColor3 = Theme.Panel, BorderSizePixel = 0, Parent = Window,
})
create("Frame", {
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = Sidebar,
})
local TabList = create("Frame", {
    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -56), Parent = Sidebar,
})
pad(TabList, 8, 10, 9, 0)
create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabList })

local Profile = create("Frame", {
    AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, -1, 0, 54),
    BackgroundTransparency = 1, Parent = Sidebar,
})
create("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = Profile })
round(create("ImageLabel", {
    Position = UDim2.fromOffset(10, 15), Size = UDim2.fromOffset(30, 30), BackgroundColor3 = Theme.Card,
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150", Parent = Profile,
}), 15)
Label(Profile, { Position = UDim2.fromOffset(46, 13), Size = UDim2.new(1, -50, 0, 16), Text = LocalPlayer.DisplayName, Font = Enum.Font.GothamBold, TextSize = 12 })
Label(Profile, { Position = UDim2.fromOffset(46, 29), Size = UDim2.new(1, -50, 0, 14), Text = "@" .. LocalPlayer.Name, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.Sub })

local Content = create("Frame", {
    Name = "Content", Position = UDim2.fromOffset(112, 46), Size = UDim2.new(1, -112, 1, -46),
    BackgroundTransparency = 1, ClipsDescendants = true, Parent = Window,
})

-- tabs
local Tabs = {}
local function selectTab(name)
    for tabName, t in pairs(Tabs) do
        local on = (tabName == name)
        t.page.Visible = on
        tween(t.button, { BackgroundTransparency = on and 0.86 or 1 }, 0.15)
        tween(t.label, { TextColor3 = on and Theme.Accent or Theme.Sub }, 0.15)
        tween(t.icon, { ImageTransparency = on and 0 or 0.45 }, 0.15)
        t.bar.Visible = on
    end
end

local tabOrder = 0
local function addTab(name, iconId, page)
    tabOrder += 1
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1,
        BorderSizePixel = 0, AutoButtonColor = false, Text = "", LayoutOrder = tabOrder, Parent = TabList,
    })
    round(btn, 9)
    local bar = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 18),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Visible = false, Parent = btn,
    })
    round(bar, 2)
    local icon = create("ImageLabel", {
        Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1,
        Image = iconId, ImageTransparency = 0.45, Parent = btn,
    })
    local label = Label(btn, {
        Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -44, 1, 0), Text = name,
        Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Sub,
    })
    Tabs[name] = { button = btn, label = label, icon = icon, bar = bar, page = page }
    btn.Activated:Connect(function() selectTab(name) end)
end

-- ---------- reusable components ----------
local function newScrollPage()
    local sf = create("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Stroke,
        ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false, Parent = Content,
    })
    create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sf })
    pad(sf, 12, 6, 14, 14)
    local ctx = { frame = sf, n = 0 }
    function ctx.next()
        ctx.n += 1
        return ctx.n
    end
    return ctx
end

local function Section(ctx, title)
    return Label(ctx.frame, {
        Size = UDim2.new(1, 0, 0, 24), Text = title, Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = Theme.Accent, TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = ctx.next(),
    })
end

local function Card(ctx, height, clickable)
    local props = {
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, height), LayoutOrder = ctx.next(), Parent = ctx.frame,
    }
    if clickable then
        props.Text = ""
        props.AutoButtonColor = false
    end
    local card = create(clickable and "TextButton" or "Frame", props)
    round(card, 10)
    outline(card, Theme.Stroke, 1, 0.3)
    if clickable then
        card.MouseEnter:Connect(function() tween(card, { BackgroundColor3 = Theme.CardHover }, 0.12) end)
        card.MouseLeave:Connect(function() tween(card, { BackgroundColor3 = Theme.Card }, 0.12) end)
    end
    return card
end

local function makeSwitch(parent)
    local sw = create("TextButton", {
        Name = "Switch", Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.fromOffset(44, 24), BackgroundColor3 = Theme.Off, BorderSizePixel = 0, Parent = parent,
    })
    round(sw, 12)
    local knob = create("Frame", {
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.White, BorderSizePixel = 0, Parent = sw,
    })
    round(knob, 9)
    local function visual(on)
        tween(sw, { BackgroundColor3 = on and Theme.Accent or Theme.Off }, 0.18)
        tween(knob, { Position = on and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3) }, 0.18)
    end
    return sw, visual
end

-- on/off state holder. callback(on) may return false to refuse the change.
local function makeStateful(callback, visual)
    local state = false
    local obj = {}
    function obj:Get() return state end
    function obj:Set(v, silent)
        v = v and true or false
        if v == state then return end
        if not silent and callback then
            local ok, res = pcall(callback, v)
            if not ok then
                warn("[OLIVER] " .. tostring(res))
                notify("Something went wrong", "bad")
                return
            end
            if res == false then return end
        end
        state = v
        visual(v)
    end
    return obj
end

local function Toggle(ctx, opts)
    local row = Card(ctx, 56, true)
    Label(row, { Position = UDim2.fromOffset(14, 10), Size = UDim2.new(1, -86, 0, 18), Text = opts.title, Font = Enum.Font.GothamBold })
    Label(row, {
        Position = UDim2.fromOffset(14, 30), Size = UDim2.new(1, -86, 0, 14), Text = opts.desc or "",
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub,
    })
    local sw, visual = makeSwitch(row)
    sw.Position = UDim2.new(1, -14, 0.5, 0)
    local obj = makeStateful(opts.callback, visual)
    row.Activated:Connect(function() obj:Set(not obj:Get()) end)
    sw.Activated:Connect(function() obj:Set(not obj:Get()) end)
    return obj
end

-- switch + slider + number box (used for Fly / Walk Speed / Spin)
local function SpeedControl(ctx, opts)
    local card = Card(ctx, 98, false)
    Label(card, { Position = UDim2.fromOffset(14, 10), Size = UDim2.new(1, -86, 0, 18), Text = opts.title, Font = Enum.Font.GothamBold })
    Label(card, {
        Position = UDim2.fromOffset(14, 29), Size = UDim2.new(1, -86, 0, 14), Text = opts.desc or "",
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub,
    })
    local sw, visual = makeSwitch(card)
    sw.Position = UDim2.new(1, -14, 0, 24)
    local obj = makeStateful(opts.onToggle, visual)
    sw.Activated:Connect(function() obj:Set(not obj:Get()) end)

    local min, max = opts.min, opts.max
    local value = opts.default

    local box = create("TextBox", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 56), Size = UDim2.fromOffset(60, 28),
        BackgroundColor3 = Theme.Panel, BorderSizePixel = 0, Text = tostring(value), TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium, TextSize = 13, ClearTextOnFocus = false, Parent = card,
    })
    round(box, 7)
    outline(box, Theme.Stroke, 1, 0.2)

    local hit = create("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 54), Size = UDim2.new(1, -100, 0, 32), Parent = card,
    })
    local rail = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Theme.Off, BorderSizePixel = 0, Parent = hit,
    })
    round(rail, 3)
    local fill = create("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.White, BorderSizePixel = 0, Parent = rail })
    round(fill, 3)
    create("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Parent = fill })
    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = Theme.White, BorderSizePixel = 0, ZIndex = 2, Parent = rail,
    })
    round(knob, 8)

    local function render(v)
        box.Text = tostring(v)
        local a = math.clamp((v - min) / (max - min), 0, 1)
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
    end
    local function commit(v)
        v = math.floor(v + 0.5)
        value = v
        render(v)
        if opts.onChange then opts.onChange(v) end
    end
    render(value)

    local dragging = false
    local function fromX(x)
        local a = math.clamp((x - rail.AbsolutePosition.X) / math.max(rail.AbsoluteSize.X, 1), 0, 1)
        commit(min + (max - min) * a)
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            ctx.frame.ScrollingEnabled = false
            fromX(input.Position.X)
        end
    end)
    keep(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            fromX(input.Position.X)
        end
    end))
    keep(UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            ctx.frame.ScrollingEnabled = true
        end
    end))

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            n = math.max(n, min)
            if not opts.softMax then n = math.min(n, max) end
            commit(n)
        else
            render(value)
        end
    end)

    return obj
end

local function Button(ctx, text, kind, callback)
    local base, hover, txt, strokeColor
    if kind == "danger" then
        base, hover, txt, strokeColor = Color3.fromRGB(52, 28, 36), Color3.fromRGB(72, 34, 45), Theme.Bad, Color3.fromRGB(110, 50, 62)
    elseif kind == "primary" then
        base, hover, txt, strokeColor = Theme.Accent, Color3.fromRGB(80, 214, 255), Color3.fromRGB(8, 18, 28), Theme.Accent
    else
        base, hover, txt, strokeColor = Theme.Card, Theme.CardHover, Theme.Text, Theme.Stroke
    end
    local b = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = base, BorderSizePixel = 0, AutoButtonColor = false,
        Text = text, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = txt,
        LayoutOrder = ctx.next(), Parent = ctx.frame,
    })
    round(b, 10)
    outline(b, strokeColor, 1, 0.2)
    b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = hover }, 0.12) end)
    b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = base }, 0.12) end)
    b.Activated:Connect(callback)
    return b
end

-- ---------- show / hide ----------
local isOpen = true
local function setOpen(v)
    if v == isOpen then return end
    isOpen = v
    if v then
        Window.Visible = true
        Window.GroupTransparency = 1
        tween(Window, { GroupTransparency = 0 }, 0.18)
    else
        tween(Window, { GroupTransparency = 1 }, 0.15)
        task.delay(0.16, function()
            if not isOpen then Window.Visible = false end
        end)
    end
end

local Launcher = create("ImageButton", {
    Name = "Launcher", Size = UDim2.fromOffset(46, 46), Position = UDim2.new(0, 16, 0.35, 0),
    Image = LOGO, ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = Theme.Panel,
    AutoButtonColor = false, Parent = ScreenGui,
})
round(Launcher, 23)
outline(Launcher, Theme.Accent, 2, 0.15)
makeDraggable(Launcher, Launcher, function() setOpen(not isOpen) end)
MinBtn.Activated:Connect(function() setOpen(false) end)

keep(UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then setOpen(not isOpen) end
end))

-- fit the window to the screen (phones are small)
local function fit()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local w = math.clamp(vp.X - 40, 340, 520)
    local h = math.clamp(vp.Y - 40, 270, 380)
    Window.Size = UDim2.fromOffset(w, h)
    Stats.Visible = w >= 430
end
fit()
if workspace.CurrentCamera then
    keep(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit))
end

local cleanup -- defined at the bottom
CloseBtn.Activated:Connect(function()
    if cleanup then cleanup() end
end)


-- ======== SPIN LOGIC (unchanged) ========
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


-- ======== FLY LOGIC (unchanged) ========
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

-- ======== ANIMATION LOGIC (unchanged) ========
-- Adidas Community animation assets used by the controller.
-- One shared logo for every animation pack card.
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

local ZombieAnimations = {
    Idle     = "rbxassetid://616158929",
    Idle2    = "rbxassetid://616160636",
    Walk     = "rbxassetid://616168032",
    Run      = "rbxassetid://616163682",
    Jump     = "rbxassetid://616161997",
    Fall     = "rbxassetid://616157476",
    Climb    = "rbxassetid://616156119",
    Swim     = "rbxassetid://616165109",
    SwimIdle = "rbxassetid://616166655",
}

-- Ninja animation pack (official Roblox Ninja pack IDs).
-- Full set: Idle, Idle2, Walk, Run, Jump, Fall, Climb, Swim, SwimIdle.
local NinjaAnimations = {
    Idle     = "rbxassetid://656117400",
    Idle2    = "rbxassetid://656118341",
    Walk     = "rbxassetid://656121766",
    Run      = "rbxassetid://656118852",
    Jump     = "rbxassetid://656117878",
    Fall     = "rbxassetid://656115606",
    Climb    = "rbxassetid://656114359",
    Swim     = "rbxassetid://656119721",
    SwimIdle = "rbxassetid://656121397",
}

local activePack = AdidasCommunity
local activePackName = "Adidas Community"

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

    -- Clean up the previous pack (connections + tracks) so packs can be switched.
    if animationCleanup then
        pcall(animationCleanup)
        animationCleanup = nil
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
        if not id then return end
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

    -- If the pack has no Idle, borrow the game's default idle animation.
    local idleId = activePack.Idle
    if not idleId and animate then
        local idleFolder = animate:FindFirstChild("idle")
        local idleAnim = idleFolder and idleFolder:FindFirstChild("Animation1")
        if idleAnim then idleId = idleAnim.AnimationId end
    end

    loadTrack("Idle", idleId, Enum.AnimationPriority.Idle, true)
    loadTrack("Walk", activePack.Walk, Enum.AnimationPriority.Movement, true)
    loadTrack("Run", activePack.Run, Enum.AnimationPriority.Movement, true)
    loadTrack("Jump", activePack.Jump, Enum.AnimationPriority.Movement, false)
    loadTrack("Fall", activePack.Fall, Enum.AnimationPriority.Movement, true)
    loadTrack("Climb", activePack.Climb, Enum.AnimationPriority.Movement, true)
    loadTrack("Swim", activePack.Swim, Enum.AnimationPriority.Movement, true)
    loadTrack("SwimIdle", activePack.SwimIdle, Enum.AnimationPriority.Movement, true)

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

    local FALLBACKS = {
        Run = "Walk", Fall = "Jump", Swim = "Walk",
        SwimIdle = "Idle", Climb = "Idle",
    }

    local function play(name, speed)
        if not tracks[name] and FALLBACKS[name] then
            name = FALLBACKS[name]
        end
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

local function enableAdidas(pack, packName)
    if pack then
        activePack = pack
        activePackName = packName or activePackName
    end
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

-- ==========================================================
-- PAGES
-- ==========================================================
local allToggles = {}
local quiet = false
local function say(msg, kind)
    if not quiet then notify(msg, kind) end
end

local flyCtl
local setPackHighlight = function() end

local isNoclip, isESP = false, false
local walkSpeedEnabled, walkSpeedValue = false, 50

local function applyWalkSpeed()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = walkSpeedEnabled and walkSpeedValue or 16
    end
end

keep(LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.1)
        applyWalkSpeed()
    end
    if flyCtl and flyCtl:Get() then
        NOFLY()
        flyCtl:Set(false, true)
        notify("Fly turned off after respawn", "warn")
    end
end))

-- Noclip
keep(RunService.Stepped:Connect(function()
    if isNoclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))

-- ESP (needs Drawing API from the executor)
local HAS_DRAWING = Drawing ~= nil and type(Drawing.new) == "function"
local espCleanups = {}

local function createESPForPlayer(plr)
    if not HAS_DRAWING or plr == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Color = Color3.fromRGB(255, 50, 50)
    box.Filled = false
    box.Visible = false

    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Visible = false

    local conn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        if isESP and cam and hrp and head then
            local hrpPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.65

                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
                box.Visible = true

                line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                line.Visible = true
                return
            end
        end
        box.Visible = false
        line.Visible = false
    end)

    local function destroy()
        conn:Disconnect()
        pcall(function() box:Remove() end)
        pcall(function() line:Remove() end)
    end
    table.insert(espCleanups, destroy)

    plr.AncestryChanged:Connect(function(_, parent)
        if not parent then destroy() end
    end)
end

if HAS_DRAWING then
    for _, p in ipairs(Players:GetPlayers()) do createESPForPlayer(p) end
    keep(Players.PlayerAdded:Connect(createESPForPlayer))
end

-- ---------------------------------------------------------
-- MAIN PAGE
-- ---------------------------------------------------------
do
    local ctx = newScrollPage()
    addTab("Main", ICON_MAIN, ctx.frame)

    Section(ctx, "MOVEMENT")

    flyCtl = SpeedControl(ctx, {
        title = "Fly", desc = "WASD move · E up · Q down",
        min = 1, max = 500, default = flySpeed,
        onToggle = function(on)
            if on then
                sFLY()
                if not FLYING then
                    say("Can't fly yet - character not found", "bad")
                    return false
                end
                say("Fly enabled", "good")
            else
                NOFLY()
                say("Fly disabled")
            end
        end,
        onChange = function(v) flySpeed = v end,
    })
    table.insert(allToggles, flyCtl)

    table.insert(allToggles, SpeedControl(ctx, {
        title = "Walk Speed", desc = "Run faster than normal",
        min = 1, max = 500, default = walkSpeedValue,
        onToggle = function(on)
            walkSpeedEnabled = on
            applyWalkSpeed()
            say(on and "Walk Speed enabled" or "Walk Speed disabled", on and "good" or nil)
        end,
        onChange = function(v)
            walkSpeedValue = v
            if walkSpeedEnabled then applyWalkSpeed() end
        end,
    }))

    table.insert(allToggles, SpeedControl(ctx, {
        title = "Spin", desc = "Spin your character (degrees per second)",
        min = 1, max = 720, softMax = true, default = spinSpeed,
        onToggle = function(on)
            if on then
                startSpin()
                if not spinEnabled then
                    say("Can't spin yet - character not found", "bad")
                    return false
                end
                say("Spin enabled", "good")
            else
                stopSpin()
                say("Spin disabled")
            end
        end,
        onChange = function(v) spinSpeed = math.max(v, 1) end,
    }))

    Section(ctx, "TOOLS")

    table.insert(allToggles, Toggle(ctx, {
        title = "Noclip", desc = "Walk through walls and parts",
        callback = function(on)
            isNoclip = on
            say(on and "Noclip enabled" or "Noclip disabled", on and "good" or nil)
        end,
    }))

    table.insert(allToggles, Toggle(ctx, {
        title = "ESP", desc = HAS_DRAWING and "Box + line to every player" or "Not supported by your executor",
        callback = function(on)
            if on and not HAS_DRAWING then
                say("ESP needs the Drawing API", "bad")
                return false
            end
            isESP = on
            say(on and "ESP enabled" or "ESP disabled", on and "good" or nil)
        end,
    }))

    Section(ctx, "SYSTEM")

    Button(ctx, "Reset Character", "neutral", function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            notify("Character reset")
        end
    end)

    Button(ctx, "Rejoin Server", "neutral", function()
        notify("Rejoining...", "warn")
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
    end)

    Button(ctx, "Restore All", "danger", function()
        if _G.__OLIVER_RESTORE then _G.__OLIVER_RESTORE() end
    end)
end

-- ---------------------------------------------------------
-- ANIMATIONS PAGE
-- ---------------------------------------------------------
do
    local ctx = newScrollPage()
    addTab("Animations", ICON_ANIM, ctx.frame)
    Section(ctx, "ANIMATION PACKS")

    local packs = {
        { name = "Adidas Community", data = AdidasCommunity, sub = "Community animation set" },
        { name = "Zombie", data = ZombieAnimations, sub = "Zombie animation pack" },
        { name = "Ninja", data = NinjaAnimations, sub = "Official Roblox Ninja pack" },
    }
    local cards = {}

    setPackHighlight = function(activeName)
        for name, c in pairs(cards) do
            local on = (name == activeName)
            tween(c.stroke, { Color = on and Theme.Accent or Theme.Stroke, Transparency = on and 0 or 0.3 }, 0.15)
            tween(c.ring, { Color = on and Theme.Accent or Theme.Sub }, 0.15)
            tween(c.dot, { BackgroundTransparency = on and 0 or 1 }, 0.15)
        end
    end

    for _, pack in ipairs(packs) do
        local card = Card(ctx, 62, true)
        round(create("ImageLabel", {
            Position = UDim2.fromOffset(10, 11), Size = UDim2.fromOffset(40, 40), Image = AdidasAnimationLogoId,
            BackgroundColor3 = Theme.Panel, Parent = card,
        }), 10)
        Label(card, { Position = UDim2.fromOffset(60, 12), Size = UDim2.new(1, -110, 0, 20), Text = pack.name, Font = Enum.Font.GothamBold, TextSize = 14 })
        Label(card, { Position = UDim2.fromOffset(60, 33), Size = UDim2.new(1, -110, 0, 16), Text = pack.sub .. " · tap to use", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub })

        local ringFrame = create("Frame", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(20, 20),
            BackgroundTransparency = 1, Parent = card,
        })
        round(ringFrame, 10)
        local ring = outline(ringFrame, Theme.Sub, 2, 0)
        local dot = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(10, 10),
            BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = ringFrame,
        })
        round(dot, 5)

        cards[pack.name] = { stroke = card:FindFirstChildOfClass("UIStroke"), ring = ring, dot = dot }

        card.Activated:Connect(function()
            enableAdidas(pack.data, pack.name)
            setPackHighlight(pack.name)
            notify(pack.name .. " animation applied", "good")
        end)
    end

    Section(ctx, "RESET")
    Button(ctx, "Restore Default Animation", "neutral", function()
        disableAdidas()
        setPackHighlight(nil)
        notify("Default animation restored")
    end)
end

-- ---------------------------------------------------------
-- PLAYER PAGE
-- ---------------------------------------------------------
do
    local page = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = Content })
    pad(page, 12, 10, 12, 0)
    addTab("Player", ICON_PLAYER, page)

    local header = create("Frame", { Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = page })
    round(header, 10)
    outline(header, Theme.Stroke, 1, 0.3)
    round(create("ImageLabel", {
        Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(40, 40), BackgroundColor3 = Theme.Panel,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150", Parent = header,
    }), 10)
    Label(header, { Position = UDim2.fromOffset(60, 10), Size = UDim2.new(1, -70, 0, 20), Text = "@" .. LocalPlayer.Name, Font = Enum.Font.GothamBold, TextSize = 14 })
    local countLabel = Label(header, {
        Position = UDim2.fromOffset(60, 31), Size = UDim2.new(1, -70, 0, 16), Text = "0 players in server",
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub,
    })

    local search = create("TextBox", {
        Position = UDim2.fromOffset(0, 66), Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.Card, BorderSizePixel = 0,
        PlaceholderText = "Search players...", PlaceholderColor3 = Theme.Sub, Text = "", ClearTextOnFocus = false,
        TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = page,
    })
    round(search, 10)
    outline(search, Theme.Stroke, 1, 0.3)
    pad(search, 12, 0, 12, 0)

    local list = create("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 108), Size = UDim2.new(1, 0, 1, -108), BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Stroke,
        ScrollingDirection = Enum.ScrollingDirection.Y, Parent = page,
    })
    create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })
    pad(list, 0, 0, 4, 12)

    local empty = Label(page, {
        Position = UDim2.fromOffset(0, 130), Size = UDim2.new(1, 0, 0, 24), Text = "No players found",
        Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Center, Visible = false,
    })

    local function gotoPlayer(target)
        local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot and myRoot then
            myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
            notify("Teleported to @" .. target.Name, "good")
        else
            notify("Can't reach @" .. target.Name .. " right now", "bad")
        end
    end

    local function refresh()
        for _, item in ipairs(list:GetChildren()) do
            if item:IsA("Frame") then item:Destroy() end
        end

        local q = search.Text:lower()
        local shown, total, order = 0, 0, 0

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                total += 1
                if q == "" or p.Name:lower():find(q, 1, true) or p.DisplayName:lower():find(q, 1, true) then
                    shown += 1
                    order += 1
                    local card = create("Frame", {
                        Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.Card, BorderSizePixel = 0,
                        LayoutOrder = order, Parent = list,
                    })
                    round(card, 10)
                    outline(card, Theme.Stroke, 1, 0.3)
                    round(create("ImageLabel", {
                        Position = UDim2.fromOffset(8, 9), Size = UDim2.fromOffset(36, 36), BackgroundColor3 = Theme.Panel,
                        Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=150&h=150", Parent = card,
                    }), 9)
                    Label(card, { Position = UDim2.fromOffset(54, 9), Size = UDim2.new(1, -140, 0, 18), Text = p.DisplayName, Font = Enum.Font.GothamBold, TextSize = 13 })
                    Label(card, { Position = UDim2.fromOffset(54, 28), Size = UDim2.new(1, -140, 0, 16), Text = "@" .. p.Name, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub })

                    local go = create("TextButton", {
                        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0), Size = UDim2.fromOffset(64, 32),
                        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, AutoButtonColor = false, Text = "Goto",
                        Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(8, 18, 28), Parent = card,
                    })
                    round(go, 8)
                    go.Activated:Connect(function() gotoPlayer(p) end)
                end
            end
        end

        countLabel.Text = total .. (total == 1 and " player" or " players") .. " in server"
        empty.Visible = (shown == 0)
        empty.Text = (total == 0) and "You're alone in this server" or "No players found"
    end

    refresh()
    search:GetPropertyChangedSignal("Text"):Connect(refresh)
    keep(Players.PlayerAdded:Connect(function() task.defer(refresh) end))
    keep(Players.PlayerRemoving:Connect(function() task.defer(refresh) end))
end

-- ==========================================================
-- RESTORE ALL / CLEANUP / STATS
-- ==========================================================
local function restoreAll()
    quiet = true
    for _, ctl in ipairs(allToggles) do
        pcall(function() ctl:Set(false) end)
    end
    if animationEnabled then
        pcall(disableAdidas)
    end
    setPackHighlight(nil)
    quiet = false
    notify("Everything restored", "good")
end
_G.__OLIVER_RESTORE = restoreAll

cleanup = function()
    pcall(function()
        quiet = true
        for _, ctl in ipairs(allToggles) do ctl:Set(false) end
        if animationEnabled then disableAdidas() end
    end)
    for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
    for _, d in ipairs(espCleanups) do pcall(d) end
    _G.__OLIVER_RESTORE = nil
    ScreenGui:Destroy()
end

-- FPS / ping pill
do
    local frames, elapsed = 0, 0
    keep(RunService.RenderStepped:Connect(function(dt)
        frames += 1
        elapsed += dt
        if elapsed >= 0.5 then
            local fps = math.floor(frames / elapsed + 0.5)
            local ping = 0
            pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) end)
            StatsLabel.Text = fps .. " FPS · " .. ping .. " ms"
            StatsLabel.TextColor3 = (fps >= 50 and Theme.Good) or (fps >= 30 and Theme.Warn) or Theme.Bad
            frames, elapsed = 0, 0
        end
    end))
end

selectTab("Main")
notify("OLIVER V3 loaded", "good")
