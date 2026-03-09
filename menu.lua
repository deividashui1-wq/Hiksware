--[[
╔═══════════════════════════════════════════════════════════╗
║  P H A N T O M   U I   ·   v3.0                          ║
║  Tabs: COMBAT · VISUALS · MISC                            ║
║  Toggle: INSERT key                                       ║
╚═══════════════════════════════════════════════════════════╝
]]

-- ══════════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

-- ══════════════════════════════════════════
--  THEME  (dark military-terminal aesthetic)
-- ══════════════════════════════════════════
local C = {
    BG        = Color3.fromRGB( 9,   9,  14),   -- near-black base
    Panel     = Color3.fromRGB(14,  14,  22),   -- sidebar
    Card      = Color3.fromRGB(18,  18,  30),   -- row background
    CardHov   = Color3.fromRGB(24,  24,  40),   -- row hover
    Border    = Color3.fromRGB(36,  36,  58),   -- subtle border
    Accent    = Color3.fromRGB(56, 189, 248),   -- cyan glow accent
    AccentDim = Color3.fromRGB(18,  70, 100),   -- accent dimmed
    Track     = Color3.fromRGB(30,  30,  50),   -- slider track bg
    Fill      = Color3.fromRGB(56, 189, 248),   -- slider fill
    Thumb     = Color3.fromRGB(224, 245, 255),  -- slider thumb
    Text      = Color3.fromRGB(220, 230, 255),  -- primary text
    TextDim   = Color3.fromRGB(100, 110, 145),  -- muted text
    TabAct    = Color3.fromRGB(56, 189, 248),   -- active tab text
    TabIdle   = Color3.fromRGB(80,  85, 115),   -- idle tab text
    TabActBG  = Color3.fromRGB(14,  45,  65),   -- active tab bg
    Header    = Color3.fromRGB(12,  12,  20),   -- header bar
    White     = Color3.fromRGB(255, 255, 255),
}

-- ══════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════
local State = {
    Open   = true,
    Tab    = "COMBAT",
    Values = {},  -- slider values keyed by label
}

-- ══════════════════════════════════════════
--  CLEANUP old instance
-- ══════════════════════════════════════════
pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("PhantomMenu")
    if old then old:Destroy() end
end)

-- ══════════════════════════════════════════
--  ROOT ScreenGui
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "PhantomMenu"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
--  UTILITIES
-- ══════════════════════════════════════════
local function N(cls, t, par)
    local o = Instance.new(cls)
    for k, v in pairs(t or {}) do o[k] = v end
    if par then o.Parent = par end
    return o
end

local function Corner(r, p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
end

local function Stroke(col, th, p)
    local s = Instance.new("UIStroke")
    s.Color = col; s.Thickness = th
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
end

local function Pad(t, b, l, r, p)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p
end

local function List(dir, sp, ha, p)
    local l = Instance.new("UIListLayout")
    l.FillDirection      = dir or Enum.FillDirection.Vertical
    l.Padding            = UDim.new(0, sp or 0)
    l.HorizontalAlignment = ha or Enum.HorizontalAlignment.Left
    l.SortOrder          = Enum.SortOrder.LayoutOrder
    l.Parent = p
end

local function Tween(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(
        dur   or 0.18,
        style or Enum.EasingStyle.Quart,
        dir   or Enum.EasingDirection.Out
    ), props):Play()
end

-- ══════════════════════════════════════════
--  MAIN WINDOW
-- ══════════════════════════════════════════
local Win = N("Frame", {
    Name              = "Window",
    Size              = UDim2.new(0, 700, 0, 460),
    Position          = UDim2.new(0.5, -350, 0.5, -230),
    BackgroundColor3  = C.BG,
    BorderSizePixel   = 0,
    ClipsDescendants  = false,
}, ScreenGui)
Corner(12, Win)
Stroke(C.Border, 1.2, Win)

-- Subtle top-left tinted glow panel
N("Frame", {
    Size              = UDim2.new(0.45, 0, 0.5, 0),
    BackgroundColor3  = Color3.fromRGB(25, 60, 90),
    BackgroundTransparency = 0.88,
    BorderSizePixel   = 0,
    ZIndex            = 0,
}, Win)

-- ══════════════════════════════════════════
--  TITLE BAR
-- ══════════════════════════════════════════
local TitleBar = N("Frame", {
    Size              = UDim2.new(1, 0, 0, 48),
    BackgroundColor3  = C.Header,
    BorderSizePixel   = 0,
    ZIndex            = 10,
}, Win)
Corner(12, TitleBar)
-- mask bottom corners
N("Frame", {
    Size              = UDim2.new(1, 0, 0, 12),
    Position          = UDim2.new(0, 0, 1, -12),
    BackgroundColor3  = C.Header,
    BorderSizePixel   = 0,
    ZIndex            = 10,
}, TitleBar)

-- Accent left bar
N("Frame", {
    Size              = UDim2.new(0, 3, 0, 26),
    Position          = UDim2.new(0, 14, 0.5, -13),
    BackgroundColor3  = C.Accent,
    BorderSizePixel   = 0,
    ZIndex            = 11,
}, TitleBar)

-- Logo square
local Logo = N("Frame", {
    Size              = UDim2.new(0, 28, 0, 28),
    Position          = UDim2.new(0, 24, 0.5, -14),
    BackgroundColor3  = C.AccentDim,
    BorderSizePixel   = 0,
    ZIndex            = 11,
}, TitleBar)
Corner(6, Logo)
N("TextLabel", {
    Size              = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text              = "⬡",
    TextColor3        = C.Accent,
    TextSize          = 16,
    Font              = Enum.Font.GothamBold,
    ZIndex            = 12,
}, Logo)

-- Title text
N("TextLabel", {
    Size              = UDim2.new(0, 160, 1, 0),
    Position          = UDim2.new(0, 60, 0, 0),
    BackgroundTransparency = 1,
    Text              = "PHANTOM",
    TextColor3        = C.Text,
    TextSize          = 17,
    Font              = Enum.Font.GothamBold,
    TextXAlignment    = Enum.TextXAlignment.Left,
    ZIndex            = 11,
}, TitleBar)

N("TextLabel", {
    Size              = UDim2.new(0, 160, 0, 16),
    Position          = UDim2.new(0, 60, 0.5, 2),
    BackgroundTransparency = 1,
    Text              = "v3.0  ·  INSERT = toggle",
    TextColor3        = C.TextDim,
    TextSize          = 10,
    Font              = Enum.Font.Gotham,
    TextXAlignment    = Enum.TextXAlignment.Left,
    ZIndex            = 11,
}, TitleBar)

-- Close button
local CloseBtn = N("TextButton", {
    Size              = UDim2.new(0, 30, 0, 30),
    Position          = UDim2.new(1, -44, 0.5, -15),
    BackgroundColor3  = Color3.fromRGB(50, 20, 20),
    Text              = "✕",
    TextColor3        = Color3.fromRGB(255, 120, 120),
    TextSize          = 14,
    Font              = Enum.Font.GothamBold,
    ZIndex            = 12,
}, TitleBar)
Corner(8, CloseBtn)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(80, 25, 25)}, 0.1)
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(50, 20, 20)}, 0.1)
end)

-- ══════════════════════════════════════════
--  BODY  (sidebar + content)
-- ══════════════════════════════════════════
local Body = N("Frame", {
    Size              = UDim2.new(1, 0, 1, -48),
    Position          = UDim2.new(0, 0, 0, 48),
    BackgroundTransparency = 1,
    ZIndex            = 5,
}, Win)

-- ── SIDEBAR ──────────────────────────────
local Sidebar = N("Frame", {
    Size              = UDim2.new(0, 140, 1, 0),
    BackgroundColor3  = C.Panel,
    BorderSizePixel   = 0,
    ZIndex            = 6,
}, Body)
Corner(0, Sidebar)
-- right border line
N("Frame", {
    Size              = UDim2.new(0, 1, 1, 0),
    Position          = UDim2.new(1, -1, 0, 0),
    BackgroundColor3  = C.Border,
    BorderSizePixel   = 0,
    ZIndex            = 7,
}, Sidebar)

local TabList = N("Frame", {
    Size              = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex            = 7,
}, Sidebar)
List(Enum.FillDirection.Vertical, 2, Enum.HorizontalAlignment.Center, TabList)
Pad(12, 12, 8, 8, TabList)

-- ── CONTENT AREA ─────────────────────────
local Content = N("Frame", {
    Size              = UDim2.new(1, -140, 1, 0),
    Position          = UDim2.new(0, 140, 0, 0),
    BackgroundTransparency = 1,
    ZIndex            = 5,
    ClipsDescendants  = true,
}, Body)

-- ══════════════════════════════════════════
--  TAB SYSTEM
-- ══════════════════════════════════════════
local TabBtns  = {}
local TabPages = {}

local TABS = {
    { id = "COMBAT",  icon = "◎", label = "COMBAT"  },
    { id = "VISUALS", icon = "◈", label = "VISUALS" },
    { id = "MISC",    icon = "◉", label = "MISC"    },
}

-- Create page scroll frames
for _, t in ipairs(TABS) do
    local page = N("ScrollingFrame", {
        Name                  = t.id,
        Size                  = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel       = 0,
        ScrollBarThickness    = 3,
        ScrollBarImageColor3  = C.Accent,
        CanvasSize            = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize   = Enum.AutomaticSize.Y,
        ScrollingDirection    = Enum.ScrollingDirection.Y,
        Visible               = false,
        ZIndex                = 5,
    }, Content)
    Pad(14, 20, 18, 18, page)
    List(Enum.FillDirection.Vertical, 7, Enum.HorizontalAlignment.Left, page)
    TabPages[t.id] = page
end

-- Activate tab
local function ActivateTab(id)
    State.Tab = id
    for _, t in ipairs(TABS) do
        local btn  = TabBtns[t.id]
        local page = TabPages[t.id]
        local active = t.id == id

        page.Visible = active

        local bg  = btn:FindFirstChild("BG")
        local lbl = btn:FindFirstChild("Lbl")
        local bar = btn:FindFirstChild("Bar")
        local ico = btn:FindFirstChild("Ico")

        if active then
            Tween(bg,  {BackgroundColor3 = C.TabActBG,  BackgroundTransparency = 0},   0.2)
            Tween(lbl, {TextColor3 = C.TabAct}, 0.2)
            Tween(ico, {TextColor3 = C.Accent}, 0.2)
            Tween(bar, {BackgroundTransparency = 0}, 0.2)
        else
            Tween(bg,  {BackgroundColor3 = C.Panel, BackgroundTransparency = 1}, 0.2)
            Tween(lbl, {TextColor3 = C.TabIdle}, 0.2)
            Tween(ico, {TextColor3 = C.TabIdle}, 0.2)
            Tween(bar, {BackgroundTransparency = 1}, 0.2)
        end
    end
end

-- Build tab buttons
for i, t in ipairs(TABS) do
    local Btn = N("Frame", {
        Name          = t.id .. "_btn",
        Size          = UDim2.new(1, 0, 0, 46),
        BackgroundTransparency = 1,
        LayoutOrder   = i,
        ZIndex        = 8,
    }, TabList)

    local BG = N("Frame", {
        Name              = "BG",
        Size              = UDim2.new(1, 0, 1, 0),
        BackgroundColor3  = C.Panel,
        BackgroundTransparency = 1,
        ZIndex            = 8,
    }, Btn)
    Corner(8, BG)

    -- Active indicator bar (left side)
    local Bar = N("Frame", {
        Name              = "Bar",
        Size              = UDim2.new(0, 3, 0, 22),
        Position          = UDim2.new(0, 0, 0.5, -11),
        BackgroundColor3  = C.Accent,
        BackgroundTransparency = 1,
        ZIndex            = 10,
    }, Btn)
    Corner(2, Bar)

    local Ico = N("TextLabel", {
        Name              = "Ico",
        Size              = UDim2.new(0, 22, 1, 0),
        Position          = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text              = t.icon,
        TextColor3        = C.TabIdle,
        TextSize          = 15,
        Font              = Enum.Font.GothamBold,
        ZIndex            = 9,
    }, Btn)

    local Lbl = N("TextLabel", {
        Name              = "Lbl",
        Size              = UDim2.new(1, -38, 1, 0),
        Position          = UDim2.new(0, 36, 0, 0),
        BackgroundTransparency = 1,
        Text              = t.label,
        TextColor3        = C.TabIdle,
        TextSize          = 12,
        Font              = Enum.Font.GothamBold,
        TextXAlignment    = Enum.TextXAlignment.Left,
        LetterSpacing     = 1,
        ZIndex            = 9,
    }, Btn)

    local Click = N("TextButton", {
        Size              = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text              = "",
        ZIndex            = 11,
    }, Btn)

    Click.MouseEnter:Connect(function()
        if State.Tab ~= t.id then
            Tween(BG, {BackgroundTransparency = 0.6}, 0.12)
        end
    end)
    Click.MouseLeave:Connect(function()
        if State.Tab ~= t.id then
            Tween(BG, {BackgroundTransparency = 1}, 0.12)
        end
    end)
    Click.MouseButton1Click:Connect(function()
        ActivateTab(t.id)
    end)

    TabBtns[t.id] = Btn
end

-- Sidebar bottom version tag
N("TextLabel", {
    Size              = UDim2.new(1, 0, 0, 24),
    Position          = UDim2.new(0, 0, 1, -28),
    BackgroundTransparency = 1,
    Text              = "PHANTOM  v3.0",
    TextColor3        = C.TextDim,
    TextSize          = 9,
    Font              = Enum.Font.Gotham,
    TextXAlignment    = Enum.TextXAlignment.Center,
    LetterSpacing     = 2,
    ZIndex            = 7,
}, Sidebar)

-- ══════════════════════════════════════════
--  CONTENT HEADER
-- ══════════════════════════════════════════
-- (each page gets its own header inside the scroll frame via first child)

-- ══════════════════════════════════════════
--  WIDGET: PAGE HEADER
-- ══════════════════════════════════════════
local function AddHeader(page, tabId, subtitle)
    -- header container
    local H = N("Frame", {
        Size              = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        LayoutOrder       = 0,
        ZIndex            = 6,
    }, page)

    -- top accent line
    N("Frame", {
        Size              = UDim2.new(0, 34, 0, 2),
        Position          = UDim2.new(0, 0, 0, 0),
        BackgroundColor3  = C.Accent,
        BorderSizePixel   = 0,
        ZIndex            = 7,
    }, H)

    N("TextLabel", {
        Size              = UDim2.new(1, 0, 0, 28),
        Position          = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Text              = "CURRENT: " .. tabId,
        TextColor3        = C.Text,
        TextSize          = 17,
        Font              = Enum.Font.GothamBold,
        TextXAlignment    = Enum.TextXAlignment.Left,
        ZIndex            = 7,
    }, H)

    N("TextLabel", {
        Size              = UDim2.new(1, 0, 0, 16),
        Position          = UDim2.new(0, 0, 0, 34),
        BackgroundTransparency = 1,
        Text              = subtitle,
        TextColor3        = C.TextDim,
        TextSize          = 10,
        Font              = Enum.Font.Gotham,
        TextXAlignment    = Enum.TextXAlignment.Left,
        ZIndex            = 7,
    }, H)

    -- bottom divider
    N("Frame", {
        Size              = UDim2.new(1, 0, 0, 1),
        Position          = UDim2.new(0, 0, 1, -1),
        BackgroundColor3  = C.Border,
        BorderSizePixel   = 0,
        ZIndex            = 7,
    }, H)
end

-- ══════════════════════════════════════════
--  WIDGET: SLIDER ROW
-- ══════════════════════════════════════════
local function AddSlider(page, order, label, min, max, default, unit, onChange)
    default = default or min
    unit    = unit    or ""
    State.Values[label] = default

    local Row = N("Frame", {
        Size              = UDim2.new(1, 0, 0, 56),
        BackgroundColor3  = C.Card,
        BorderSizePixel   = 0,
        LayoutOrder       = order,
        ZIndex            = 6,
    }, page)
    Corner(8, Row)
    Stroke(C.Border, 1, Row)

    -- Left label block
    local NameLbl = N("TextLabel", {
        Size              = UDim2.new(0, 180, 0, 18),
        Position          = UDim2.new(0, 14, 0, 9),
        BackgroundTransparency = 1,
        Text              = label,
        TextColor3        = C.Text,
        TextSize          = 12,
        Font              = Enum.Font.GothamMedium,
        TextXAlignment    = Enum.TextXAlignment.Left,
        ZIndex            = 7,
    }, Row)

    -- Value label (right of name)
    local ValLbl = N("TextLabel", {
        Size              = UDim2.new(0, 70, 0, 18),
        Position          = UDim2.new(1, -84, 0, 9),
        BackgroundTransparency = 1,
        Text              = tostring(default) .. unit,
        TextColor3        = C.Accent,
        TextSize          = 11,
        Font              = Enum.Font.GothamBold,
        TextXAlignment    = Enum.TextXAlignment.Right,
        ZIndex            = 7,
    }, Row)

    -- Range labels
    N("TextLabel", {
        Size              = UDim2.new(0, 30, 0, 12),
        Position          = UDim2.new(0, 14, 1, -16),
        BackgroundTransparency = 1,
        Text              = tostring(min),
        TextColor3        = C.TextDim,
        TextSize          = 9,
        Font              = Enum.Font.Gotham,
        TextXAlignment    = Enum.TextXAlignment.Left,
        ZIndex            = 7,
    }, Row)

    N("TextLabel", {
        Size              = UDim2.new(0, 30, 0, 12),
        Position          = UDim2.new(1, -44, 1, -16),
        BackgroundTransparency = 1,
        Text              = tostring(max),
        TextColor3        = C.TextDim,
        TextSize          = 9,
        Font              = Enum.Font.Gotham,
        TextXAlignment    = Enum.TextXAlignment.Right,
        ZIndex            = 7,
    }, Row)

    -- Track background
    local TrackBG = N("Frame", {
        Size              = UDim2.new(1, -28, 0, 5),
        Position          = UDim2.new(0, 14, 0, 33),
        BackgroundColor3  = C.Track,
        BorderSizePixel   = 0,
        ZIndex            = 7,
    }, Row)
    Corner(3, TrackBG)

    -- Track fill
    local fillPct = (default - min) / math.max(max - min, 1)
    local TrackFill = N("Frame", {
        Size              = UDim2.new(fillPct, 0, 1, 0),
        BackgroundColor3  = C.Fill,
        BorderSizePixel   = 0,
        ZIndex            = 8,
    }, TrackBG)
    Corner(3, TrackFill)

    -- Thumb
    local Thumb = N("Frame", {
        Size              = UDim2.new(0, 13, 0, 13),
        Position          = UDim2.new(fillPct, -7, 0.5, -7),
        BackgroundColor3  = C.Thumb,
        BorderSizePixel   = 0,
        ZIndex            = 9,
    }, TrackBG)
    Corner(7, Thumb)
    Stroke(C.Accent, 1.5, Thumb)

    -- Glow dot inside thumb
    N("Frame", {
        Size              = UDim2.new(0, 5, 0, 5),
        Position          = UDim2.new(0.5, -3, 0.5, -3),
        BackgroundColor3  = C.Accent,
        BorderSizePixel   = 0,
        ZIndex            = 10,
    }, Thumb):FindFirstChildWhichIsA("UICorner") or (function()
        Corner(3, Thumb:FindFirstChild("Frame") or Thumb)
    end)()

    -- Inner glow on thumb center
    local ThumbDot = N("Frame", {
        Size              = UDim2.new(0, 5, 0, 5),
        Position          = UDim2.new(0.5, -3, 0.5, -3),
        BackgroundColor3  = C.Accent,
        BorderSizePixel   = 0,
        ZIndex            = 10,
    }, Thumb)
    Corner(3, ThumbDot)

    -- Transparent hit area over entire row for dragging
    local Drag = false
    local HitArea = N("TextButton", {
        Size              = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text              = "",
        ZIndex            = 11,
    }, TrackBG)

    local function UpdateVal(mx)
        local rel = math.clamp(
            (mx - TrackBG.AbsolutePosition.X) / TrackBG.AbsoluteSize.X,
            0, 1
        )
        local v = math.floor(min + (max - min) * rel + 0.5)
        State.Values[label] = v
        ValLbl.Text = tostring(v) .. unit
        Tween(TrackFill, {Size  = UDim2.new(rel, 0, 1, 0)}, 0.05)
        Tween(Thumb,     {Position = UDim2.new(rel, -7, 0.5, -7)}, 0.05)
        if onChange then onChange(v) end
    end

    HitArea.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            Drag = true
            UpdateVal(i.Position.X)
        end
    end)
    HitArea.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            Drag = false
        end
    end)
    HitArea.InputChanged:Connect(function(i)
        if Drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateVal(i.Position.X)
        end
    end)

    -- Row hover effect
    Row.MouseEnter:Connect(function()
        Tween(Row, {BackgroundColor3 = C.CardHov}, 0.12)
    end)
    Row.MouseLeave:Connect(function()
        Tween(Row, {BackgroundColor3 = C.Card}, 0.12)
        Drag = false
    end)

    return Row
end

-- ══════════════════════════════════════════
--  WIDGET: SECTION DIVIDER
-- ══════════════════════════════════════════
local function AddDivider(page, order, text)
    local D = N("Frame", {
        Size              = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder       = order,
        ZIndex            = 6,
    }, page)

    N("Frame", {
        Size              = UDim2.new(1, 0, 0, 1),
        Position          = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3  = C.Border,
        BorderSizePixel   = 0,
        ZIndex            = 6,
    }, D)

    local Pill = N("Frame", {
        Size              = UDim2.new(0, 0, 1, -4),
        Position          = UDim2.new(0, 0, 0.5, -9),
        AutomaticSize     = Enum.AutomaticSize.X,
        BackgroundColor3  = C.Card,
        BorderSizePixel   = 0,
        ZIndex            = 7,
    }, D)
    Corner(4, Pill)
    Stroke(C.Border, 1, Pill)
    Pad(0, 0, 8, 8, Pill)

    N("TextLabel", {
        Size              = UDim2.new(0, 0, 1, 0),
        AutomaticSize     = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text              = text,
        TextColor3        = C.TextDim,
        TextSize          = 9,
        Font              = Enum.Font.GothamBold,
        LetterSpacing     = 2,
        ZIndex            = 8,
    }, Pill)
end

-- ══════════════════════════════════════════
--  POPULATE: COMBAT
-- ══════════════════════════════════════════
local cp = TabPages["COMBAT"]
AddHeader(cp, "COMBAT", "Aim assistance & recoil configuration")
AddDivider(cp, 1, "AIMBOT")
AddSlider(cp, 2,  "Aim Assist Strength",   0,   100,  50, "%")
AddSlider(cp, 3,  "Field of View (FOV)",   1,   180,  30, "°")
AddSlider(cp, 4,  "Smooth Speed",          1,   100,  70, "")
AddDivider(cp, 5, "HITBOX")
AddSlider(cp, 6,  "Hitbox Head Priority",  0,   100,  45, "%")
AddSlider(cp, 7,  "Hitbox Body Priority",  0,   100,  70, "%")
AddDivider(cp, 8, "RECOIL")
AddSlider(cp, 9,  "Recoil Compensation",   0,   100,  50, "%")

-- ══════════════════════════════════════════
--  POPULATE: VISUALS
-- ══════════════════════════════════════════
local vp = TabPages["VISUALS"]
AddHeader(vp, "VISUALS", "ESP wallhack rendering & display options")
AddDivider(vp, 1, "WALLHACK")
AddSlider(vp, 2,  "Wallhack Opacity",      0,   100,  50, "%")
AddSlider(vp, 3,  "Skeleton Thickness",    1,    10,   2, "px")
AddDivider(vp, 4, "BOX ESP")
AddSlider(vp, 5,  "Box Corner Size",       1,    50,  35, "px")
AddSlider(vp, 6,  "Max Render Distance",   10, 1000, 300, "m")
AddDivider(vp, 7, "HEALTH")
AddSlider(vp, 8,  "Health Bar Height",     2,    30,  20, "px")

-- ══════════════════════════════════════════
--  POPULATE: MISC
-- ══════════════════════════════════════════
local mp = TabPages["MISC"]
AddHeader(mp, "MISC", "Movement tweaks, cloud sync & UI settings")
AddDivider(mp, 1, "MOVEMENT")
AddSlider(mp, 2,  "Movement Speed Mult",  10,   200, 100, "%")
AddSlider(mp, 3,  "Bunnyhop Velocity",     0,   100,  20, "")
AddDivider(mp, 4, "CLOUD / SYNC")
AddSlider(mp, 5,  "Cloud Sync Interval",   1,    60,  10, "s")
AddDivider(mp, 6, "INTERFACE")
AddSlider(mp, 7,  "UI Transparency",       0,   100,  10, "%", function(v)
    -- Live update window transparency
    Tween(Win, {BackgroundTransparency = v / 100}, 0.12)
end)

-- ══════════════════════════════════════════
--  DRAGGABLE TITLE BAR
-- ══════════════════════════════════════════
do
    local dragging, dragStart, winStart = false, nil, nil
    local DragBtn = N("TextButton", {
        Size              = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text              = "",
        ZIndex            = 13,
    }, TitleBar)

    DragBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            winStart  = Win.Position
        end
    end)
    DragBtn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            Win.Position = UDim2.new(
                winStart.X.Scale, winStart.X.Offset + d.X,
                winStart.Y.Scale, winStart.Y.Offset + d.Y
            )
        end
    end)
end

-- ══════════════════════════════════════════
--  OPEN / CLOSE ANIMATION
-- ══════════════════════════════════════════
local function SetOpen(open)
    State.Open = open
    if open then
        Win.Visible = true
        Win.Size    = UDim2.new(0, 660, 0, 430)
        Win.BackgroundTransparency = 1
        Tween(Win, {
            Size                  = UDim2.new(0, 700, 0, 460),
            BackgroundTransparency = 0,
        }, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        Tween(Win, {
            Size                  = UDim2.new(0, 660, 0, 430),
            BackgroundTransparency = 1,
        }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.21, function()
            if not State.Open then Win.Visible = false end
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function() SetOpen(false) end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        SetOpen(not State.Open)
    end
end)

-- ══════════════════════════════════════════
--  WATERMARK  (top-left corner)
-- ══════════════════════════════════════════
local WMark = N("Frame", {
    Size              = UDim2.new(0, 192, 0, 28),
    Position          = UDim2.new(0, 16, 0, 16),
    BackgroundColor3  = C.BG,
    BackgroundTransparency = 0.18,
    ZIndex            = 2,
}, ScreenGui)
Corner(7, WMark)
Stroke(C.Border, 1, WMark)

N("Frame", {
    Size              = UDim2.new(0, 2, 0, 14),
    Position          = UDim2.new(0, 10, 0.5, -7),
    BackgroundColor3  = C.Accent,
    BorderSizePixel   = 0,
    ZIndex            = 3,
}, WMark)

N("TextLabel", {
    Size              = UDim2.new(1, -20, 1, 0),
    Position          = UDim2.new(0, 18, 0, 0),
    BackgroundTransparency = 1,
    Text              = "PHANTOM  ·  INSERT = toggle",
    TextColor3        = C.TextDim,
    TextSize          = 10,
    Font              = Enum.Font.GothamMedium,
    TextXAlignment    = Enum.TextXAlignment.Left,
    ZIndex            = 3,
}, WMark)

-- ══════════════════════════════════════════
--  INIT
-- ══════════════════════════════════════════
ActivateTab("COMBAT")

-- Entrance animation
Win.BackgroundTransparency = 1
Win.Size = UDim2.new(0, 660, 0, 430)
task.delay(0.1, function()
    SetOpen(true)
end)

print("✦ PhantomMenu v3.0 loaded  |  INSERT = open/close")
