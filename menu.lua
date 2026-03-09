-- ██████╗  ██████╗ ██████╗ ██╗      ██████╗ ██╗  ██╗
-- ██╔══██╗██╔═══██╗██╔══██╗██║     ██╔═══██╗╚██╗██╔╝
-- ██████╔╝██║   ██║██████╔╝██║     ██║   ██║ ╚███╔╝ 
-- ██╔══██╗██║   ██║██╔══██╗██║     ██║   ██║ ██╔██╗ 
-- ██║  ██║╚██████╔╝██████╔╝███████╗╚██████╔╝██╔╝ ██╗
-- ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝
-- Beautiful Roblox GUI Menu | Toggle: INSERT key

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════
--              CONFIGURATION
-- ═══════════════════════════════════════════
local CONFIG = {
    ToggleKey = Enum.KeyCode.Insert,
    MenuTitle = "ROBLOX",
    MenuSubtitle = "v2.0 | Menu",
    AccentColor = Color3.fromRGB(99, 102, 241),   -- Indigo
    AccentColor2 = Color3.fromRGB(168, 85, 247),  -- Purple
    BackgroundColor = Color3.fromRGB(10, 10, 15),
    SurfaceColor = Color3.fromRGB(16, 16, 24),
    SurfaceColor2 = Color3.fromRGB(22, 22, 34),
    BorderColor = Color3.fromRGB(40, 40, 60),
    TextColor = Color3.fromRGB(240, 240, 255),
    TextMuted = Color3.fromRGB(120, 120, 160),
    SuccessColor = Color3.fromRGB(52, 211, 153),
    DangerColor = Color3.fromRGB(248, 113, 113),
    WarningColor = Color3.fromRGB(251, 191, 36),
}

-- ═══════════════════════════════════════════
--               STATE
-- ═══════════════════════════════════════════
local State = {
    IsOpen = true,
    ActiveTab = "Combat",
    Toggles = {},
    Sliders = {},
    Dropdowns = {},
    Binds = {},
}

-- ═══════════════════════════════════════════
--            SCREEN GUI SETUP
-- ═══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════
--            UTILITY FUNCTIONS
-- ═══════════════════════════════════════════
local function CreateInstance(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function Tween(obj, props, duration, style, dir)
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function MakeGradient(colors, rotation)
    local g = Instance.new("UIGradient")
    local seq = {}
    for i, c in ipairs(colors) do
        seq[i] = ColorSequenceKeypoint.new((i-1)/(#colors-1), c)
    end
    g.Color = ColorSequence.new(seq)
    g.Rotation = rotation or 90
    return g
end

local function MakeCorner(radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

local function MakeStroke(color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or CONFIG.BorderColor
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function MakePadding(t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    return p
end

local function MakeListLayout(dir, align, spacing)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.HorizontalAlignment = align or Enum.HorizontalAlignment.Center
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, spacing or 6)
    return l
end

-- ═══════════════════════════════════════════
--            GLOW / SHADOW EFFECT
-- ═══════════════════════════════════════════
local function AddGlow(parent, color, size)
    local glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, size or 40, 1, size or 40),
        Position = UDim2.new(0, -(size or 20), 0, -(size or 20)),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = color or CONFIG.AccentColor,
        ImageTransparency = 0.7,
        ZIndex = 0,
        Parent = parent,
    })
    return glow
end

-- ═══════════════════════════════════════════
--            MAIN WINDOW
-- ═══════════════════════════════════════════
local MainFrame = CreateInstance("Frame", {
    Name = "MainWindow",
    Size = UDim2.new(0, 720, 0, 480),
    Position = UDim2.new(0.5, -360, 0.5, -240),
    BackgroundColor3 = CONFIG.BackgroundColor,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
MakeCorner(14).Parent = MainFrame
MakeStroke(CONFIG.BorderColor, 1).Parent = MainFrame

-- Background gradient overlay
local BgGrad = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(20, 15, 40),
    BackgroundTransparency = 0.6,
    ZIndex = 0,
    Parent = MainFrame,
})
MakeCorner(14).Parent = BgGrad
MakeGradient({
    Color3.fromRGB(99, 60, 180),
    Color3.fromRGB(10, 10, 20),
    Color3.fromRGB(10, 10, 20),
}, 145).Parent = BgGrad

-- Noise / dot pattern overlay
local Pattern = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 1,
    Parent = MainFrame,
})

-- ═══════════════════════════════════════════
--            TITLE BAR
-- ═══════════════════════════════════════════
local TitleBar = CreateInstance("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundColor3 = CONFIG.SurfaceColor,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = MainFrame,
})

local TitleGrad = MakeGradient({
    Color3.fromRGB(30, 20, 60),
    Color3.fromRGB(16, 16, 24),
}, 90)
TitleGrad.Parent = TitleBar

-- Accent line under title
local AccentLine = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = CONFIG.AccentColor,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = TitleBar,
})
MakeGradient({CONFIG.AccentColor, CONFIG.AccentColor2, CONFIG.AccentColor}, 0).Parent = AccentLine

-- Logo icon area
local LogoFrame = CreateInstance("Frame", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 12, 0.5, -20),
    BackgroundColor3 = CONFIG.AccentColor,
    ZIndex = 6,
    Parent = TitleBar,
})
MakeCorner(10).Parent = LogoFrame
MakeGradient({CONFIG.AccentColor, CONFIG.AccentColor2}, 135).Parent = LogoFrame

local LogoText = CreateInstance("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "✦",
    TextColor3 = Color3.fromRGB(255,255,255),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LogoFrame,
})

-- Title text
local TitleLabel = CreateInstance("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 62, 0, 0),
    BackgroundTransparency = 1,
    Text = CONFIG.MenuTitle,
    TextColor3 = CONFIG.TextColor,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = TitleBar,
})

local SubLabel = CreateInstance("TextLabel", {
    Size = UDim2.new(0, 200, 0, 18),
    Position = UDim2.new(0, 62, 0.5, 2),
    BackgroundTransparency = 1,
    Text = CONFIG.MenuSubtitle,
    TextColor3 = CONFIG.TextMuted,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = TitleBar,
})

-- Close button
local CloseBtn = CreateInstance("TextButton", {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(1, -44, 0.5, -16),
    BackgroundColor3 = Color3.fromRGB(248, 113, 113),
    BackgroundTransparency = 0.5,
    Text = "✕",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = TitleBar,
})
MakeCorner(8).Parent = CloseBtn

-- INSERT key hint
local KeyHint = CreateInstance("TextLabel", {
    Size = UDim2.new(0, 120, 0, 22),
    Position = UDim2.new(1, -170, 0.5, -11),
    BackgroundColor3 = Color3.fromRGB(30, 30, 50),
    Text = "INSERT  ·  toggle",
    TextColor3 = CONFIG.TextMuted,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    ZIndex = 6,
    Parent = TitleBar,
})
MakeCorner(6).Parent = KeyHint
MakeStroke(CONFIG.BorderColor).Parent = KeyHint

-- ═══════════════════════════════════════════
--            SIDEBAR (Tabs)
-- ═══════════════════════════════════════════
local Sidebar = CreateInstance("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 150, 1, -56),
    Position = UDim2.new(0, 0, 0, 56),
    BackgroundColor3 = CONFIG.SurfaceColor,
    BorderSizePixel = 0,
    ZIndex = 4,
    Parent = MainFrame,
})

local SidebarGrad = MakeGradient({
    Color3.fromRGB(14, 14, 22),
    Color3.fromRGB(18, 18, 28),
}, 180)
SidebarGrad.Parent = Sidebar

-- Sidebar border right
CreateInstance("Frame", {
    Size = UDim2.new(0, 1, 1, 0),
    Position = UDim2.new(1, -1, 0, 0),
    BackgroundColor3 = CONFIG.BorderColor,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = Sidebar,
})

local TabList = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = Sidebar,
})
MakeListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, 4).Parent = TabList
MakePadding(12, 12, 8, 8).Parent = TabList

-- ═══════════════════════════════════════════
--            CONTENT AREA
-- ═══════════════════════════════════════════
local ContentArea = CreateInstance("Frame", {
    Name = "ContentArea",
    Size = UDim2.new(1, -150, 1, -56),
    Position = UDim2.new(0, 150, 0, 56),
    BackgroundTransparency = 1,
    ZIndex = 3,
    Parent = MainFrame,
})

-- ═══════════════════════════════════════════
--            TAB BUTTON FACTORY
-- ═══════════════════════════════════════════
local TabButtons = {}
local TabPages = {}

local TabData = {
    { name = "Combat",  icon = "⚔" },
    { name = "ESP",     icon = "👁" },
    { name = "Moment",  icon = "⚡" },
    { name = "Visuals", icon = "🎨" },
    { name = "Misc",    icon = "🔧" },
    { name = "Settings",icon = "⚙" },
    { name = "Binds",   icon = "⌨" },
}

local function SwitchTab(tabName)
    State.ActiveTab = tabName
    for name, btn in pairs(TabButtons) do
        local isActive = (name == tabName)
        local bg = btn:FindFirstChild("Background")
        local label = btn:FindFirstChild("Label")
        local icon = btn:FindFirstChild("Icon")
        local indicator = btn:FindFirstChild("Indicator")

        if isActive then
            Tween(bg, {BackgroundColor3 = Color3.fromRGB(40, 35, 80), BackgroundTransparency = 0}, 0.2)
            Tween(label, {TextColor3 = CONFIG.TextColor}, 0.2)
            Tween(icon, {TextColor3 = CONFIG.AccentColor2}, 0.2)
            Tween(indicator, {BackgroundTransparency = 0}, 0.2)
        else
            Tween(bg, {BackgroundColor3 = Color3.fromRGB(16,16,24), BackgroundTransparency = 0.5}, 0.2)
            Tween(label, {TextColor3 = CONFIG.TextMuted}, 0.2)
            Tween(icon, {TextColor3 = CONFIG.TextMuted}, 0.2)
            Tween(indicator, {BackgroundTransparency = 1}, 0.2)
        end
    end
    for name, page in pairs(TabPages) do
        page.Visible = (name == tabName)
    end
end

local function CreateTabButton(tabInfo, order)
    local Btn = CreateInstance("Frame", {
        Name = tabInfo.name .. "Tab",
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        ZIndex = 5,
        Parent = TabList,
    })

    local Bg = CreateInstance("Frame", {
        Name = "Background",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(16,16,24),
        BackgroundTransparency = 0.5,
        ZIndex = 5,
        Parent = Btn,
    })
    MakeCorner(8).Parent = Bg

    -- Active indicator bar
    local Indicator = CreateInstance("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = CONFIG.AccentColor,
        BackgroundTransparency = 1,
        ZIndex = 7,
        Parent = Btn,
    })
    MakeCorner(4).Parent = Indicator
    MakeGradient({CONFIG.AccentColor, CONFIG.AccentColor2}, 90).Parent = Indicator

    local IconLabel = CreateInstance("TextLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = tabInfo.icon,
        TextColor3 = CONFIG.TextMuted,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        ZIndex = 6,
        Parent = Btn,
    })

    local TextLabel = CreateInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -46, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundTransparency = 1,
        Text = tabInfo.name,
        TextColor3 = CONFIG.TextMuted,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = Btn,
    })

    local ClickBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 8,
        Parent = Btn,
    })

    ClickBtn.MouseEnter:Connect(function()
        if State.ActiveTab ~= tabInfo.name then
            Tween(Bg, {BackgroundTransparency = 0.2}, 0.15)
        end
    end)
    ClickBtn.MouseLeave:Connect(function()
        if State.ActiveTab ~= tabInfo.name then
            Tween(Bg, {BackgroundTransparency = 0.5}, 0.15)
        end
    end)
    ClickBtn.MouseButton1Click:Connect(function()
        SwitchTab(tabInfo.name)
    end)

    TabButtons[tabInfo.name] = Btn
    return Btn
end

for i, tab in ipairs(TabData) do
    CreateTabButton(tab, i)
end

-- ═══════════════════════════════════════════
--            PAGE FACTORY
-- ═══════════════════════════════════════════
local function CreatePage(tabName)
    local Page = CreateInstance("ScrollingFrame", {
        Name = tabName .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CONFIG.AccentColor,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 4,
        Parent = ContentArea,
    })
    MakePadding(14, 14, 16, 16).Parent = Page
    MakeListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, 8).Parent = Page
    TabPages[tabName] = Page
    return Page
end

for _, tab in ipairs(TabData) do
    CreatePage(tab.name)
end

-- ═══════════════════════════════════════════
--            WIDGET COMPONENTS
-- ═══════════════════════════════════════════

-- SECTION HEADER
local function AddSection(page, title)
    local Section = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = page,
    })
    local Line = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = CONFIG.BorderColor,
        ZIndex = 4,
        Parent = Section,
    })
    local SLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = CONFIG.BackgroundColor,
        BackgroundTransparency = 0,
        Text = "  " .. title .. "  ",
        TextColor3 = CONFIG.AccentColor2,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        ZIndex = 5,
        Parent = Section,
    })
    return Section
end

-- TOGGLE
local function AddToggle(page, labelText, default, callback)
    default = default or false
    State.Toggles[labelText] = default

    local Row = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = CONFIG.SurfaceColor2,
        ZIndex = 4,
        Parent = page,
    })
    MakeCorner(8).Parent = Row
    MakeStroke(CONFIG.BorderColor, 1).Parent = Row

    local Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = CONFIG.TextColor,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = Row,
    })

    local ToggleTrack = CreateInstance("Frame", {
        Size = UDim2.new(0, 44, 0, 24),
        Position = UDim2.new(1, -58, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(40, 40, 60),
        ZIndex = 5,
        Parent = Row,
    })
    MakeCorner(12).Parent = ToggleTrack

    local ToggleThumb = CreateInstance("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(130, 130, 160),
        ZIndex = 6,
        Parent = ToggleTrack,
    })
    MakeCorner(9).Parent = ToggleThumb

    local function SetToggle(val)
        State.Toggles[labelText] = val
        if val then
            Tween(ToggleTrack, {BackgroundColor3 = CONFIG.AccentColor}, 0.2)
            Tween(ToggleThumb, {Position = UDim2.new(0, 23, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255)}, 0.2)
        else
            Tween(ToggleTrack, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}, 0.2)
            Tween(ToggleThumb, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(130,130,160)}, 0.2)
        end
        if callback then callback(val) end
    end

    SetToggle(default)

    local ClickBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 7,
        Parent = Row,
    })
    ClickBtn.MouseButton1Click:Connect(function()
        SetToggle(not State.Toggles[labelText])
    end)
    ClickBtn.MouseEnter:Connect(function()
        Tween(Row, {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}, 0.15)
    end)
    ClickBtn.MouseLeave:Connect(function()
        Tween(Row, {BackgroundColor3 = CONFIG.SurfaceColor2}, 0.15)
    end)

    return Row
end

-- SLIDER
local function AddSlider(page, labelText, min, max, default, suffix, callback)
    default = default or min
    suffix = suffix or ""
    State.Sliders[labelText] = default

    local Row = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = CONFIG.SurfaceColor2,
        ZIndex = 4,
        Parent = page,
    })
    MakeCorner(8).Parent = Row
    MakeStroke(CONFIG.BorderColor, 1).Parent = Row

    local LabelFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0, 6),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = Row,
    })
    local Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = CONFIG.TextColor,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = LabelFrame,
    })
    local ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0.4, -14, 1, 0),
        Position = UDim2.new(0.6, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default) .. suffix,
        TextColor3 = CONFIG.AccentColor2,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 5,
        Parent = LabelFrame,
    })

    local TrackBg = CreateInstance("Frame", {
        Size = UDim2.new(1, -28, 0, 6),
        Position = UDim2.new(0, 14, 0, 36),
        BackgroundColor3 = Color3.fromRGB(35, 35, 55),
        ZIndex = 5,
        Parent = Row,
    })
    MakeCorner(3).Parent = TrackBg

    local TrackFill = CreateInstance("Frame", {
        Size = UDim2.new((default - min)/(max - min), 0, 1, 0),
        BackgroundColor3 = CONFIG.AccentColor,
        ZIndex = 6,
        Parent = TrackBg,
    })
    MakeCorner(3).Parent = TrackFill
    MakeGradient({CONFIG.AccentColor, CONFIG.AccentColor2}, 0).Parent = TrackFill

    local Thumb = CreateInstance("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((default - min)/(max - min), -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 7,
        Parent = TrackBg,
    })
    MakeCorner(7).Parent = Thumb

    local Dragging = false
    local function UpdateSlider(x)
        local rel = math.clamp((x - TrackBg.AbsolutePosition.X) / TrackBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        State.Sliders[labelText] = val
        ValueLabel.Text = tostring(val) .. suffix
        Tween(TrackFill, {Size = UDim2.new(rel, 0, 1, 0)}, 0.05)
        Tween(Thumb, {Position = UDim2.new(rel, -7, 0.5, -7)}, 0.05)
        if callback then callback(val) end
    end

    local SliderBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 8,
        Parent = TrackBg,
    })
    SliderBtn.MouseButton1Down:Connect(function(x) Dragging = true; UpdateSlider(x) end)
    SliderBtn.MouseButton1Up:Connect(function() Dragging = false end)
    SliderBtn.MouseMoved:Connect(function(x) if Dragging then UpdateSlider(x) end end)
    SliderBtn.MouseLeave:Connect(function() Dragging = false end)

    return Row
end

-- DROPDOWN
local function AddDropdown(page, labelText, options, default, callback)
    default = default or options[1]
    State.Dropdowns[labelText] = default

    local isOpen = false
    local DropHeight = 44
    local ItemHeight = 32

    local Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, DropHeight),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 10,
        Parent = page,
    })

    local Row = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, DropHeight),
        BackgroundColor3 = CONFIG.SurfaceColor2,
        ZIndex = 10,
        Parent = Container,
    })
    MakeCorner(8).Parent = Row
    MakeStroke(CONFIG.BorderColor, 1).Parent = Row

    local Label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = CONFIG.TextColor,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
        Parent = Row,
    })
    local ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        TextColor3 = CONFIG.AccentColor2,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 11,
        Parent = Row,
    })
    local Arrow = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -26, 0, 0),
        BackgroundTransparency = 1,
        Text = "▾",
        TextColor3 = CONFIG.TextMuted,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 11,
        Parent = Row,
    })

    local DropList = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, #options * ItemHeight + 8),
        Position = UDim2.new(0, 0, 0, DropHeight + 2),
        BackgroundColor3 = Color3.fromRGB(20, 20, 32),
        Visible = false,
        ZIndex = 20,
        Parent = Container,
    })
    MakeCorner(8).Parent = DropList
    MakeStroke(CONFIG.BorderColor, 1).Parent = DropList
    MakePadding(4, 4, 6, 6).Parent = DropList
    MakeListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, 2).Parent = DropList

    for _, opt in ipairs(options) do
        local Item = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, ItemHeight),
            BackgroundColor3 = Color3.fromRGB(28, 28, 44),
            BackgroundTransparency = 0.5,
            Text = opt,
            TextColor3 = (opt == default) and CONFIG.AccentColor2 or CONFIG.TextColor,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            ZIndex = 21,
            Parent = DropList,
        })
        MakeCorner(6).Parent = Item

        Item.MouseEnter:Connect(function() Tween(Item, {BackgroundTransparency = 0}, 0.1) end)
        Item.MouseLeave:Connect(function() Tween(Item, {BackgroundTransparency = 0.5}, 0.1) end)
        Item.MouseButton1Click:Connect(function()
            State.Dropdowns[labelText] = opt
            ValueLabel.Text = opt
            isOpen = false
            DropList.Visible = false
            Tween(Arrow, {Rotation = 0}, 0.2)
            if callback then callback(opt) end
        end)
    end

    local ClickBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 12,
        Parent = Row,
    })
    ClickBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropList.Visible = isOpen
        Tween(Arrow, {Rotation = isOpen and 180 or 0}, 0.2)
    end)
    ClickBtn.MouseEnter:Connect(function()
        Tween(Row, {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}, 0.15)
    end)
    ClickBtn.MouseLeave:Connect(function()
        Tween(Row, {BackgroundColor3 = CONFIG.SurfaceColor2}, 0.15)
    end)

    return Container
end

-- BUTTON
local function AddButton(page, labelText, desc, callback)
    local Row = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = CONFIG.SurfaceColor2,
        ZIndex = 4,
        Parent = page,
    })
    MakeCorner(8).Parent = Row
    MakeStroke(CONFIG.BorderColor, 1).Parent = Row

    local Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = CONFIG.TextColor,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = Row,
    })

    local BtnEl = CreateInstance("TextButton", {
        Size = UDim2.new(0, 74, 0, 28),
        Position = UDim2.new(1, -84, 0.5, -14),
        BackgroundColor3 = CONFIG.AccentColor,
        Text = "Run",
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        ZIndex = 6,
        Parent = Row,
    })
    MakeCorner(6).Parent = BtnEl
    MakeGradient({CONFIG.AccentColor, CONFIG.AccentColor2}, 45).Parent = BtnEl

    BtnEl.MouseButton1Click:Connect(function()
        Tween(BtnEl, {BackgroundTransparency = 0.4}, 0.07)
        task.delay(0.07, function() Tween(BtnEl, {BackgroundTransparency = 0}, 0.1) end)
        if callback then callback() end
    end)
    BtnEl.MouseEnter:Connect(function() Tween(BtnEl, {Size = UDim2.new(0, 76, 0, 30), Position = UDim2.new(1, -86, 0.5, -15)}, 0.1) end)
    BtnEl.MouseLeave:Connect(function() Tween(BtnEl, {Size = UDim2.new(0, 74, 0, 28), Position = UDim2.new(1, -84, 0.5, -14)}, 0.1) end)

    return Row
end

-- BIND WIDGET
local function AddBind(page, labelText, defaultKey, callback)
    defaultKey = defaultKey or "None"
    State.Binds[labelText] = defaultKey
    local listening = false

    local Row = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = CONFIG.SurfaceColor2,
        ZIndex = 4,
        Parent = page,
    })
    MakeCorner(8).Parent = Row
    MakeStroke(CONFIG.BorderColor, 1).Parent = Row

    local Label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -110, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = CONFIG.TextColor,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = Row,
    })

    local KeyBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 90, 0, 28),
        Position = UDim2.new(1, -100, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(30, 30, 50),
        Text = "[" .. defaultKey .. "]",
        TextColor3 = CONFIG.AccentColor2,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        ZIndex = 6,
        Parent = Row,
    })
    MakeCorner(6).Parent = KeyBtn
    MakeStroke(CONFIG.BorderColor).Parent = KeyBtn

    KeyBtn.MouseButton1Click:Connect(function()
        listening = true
        KeyBtn.Text = "..."
        Tween(KeyBtn, {BackgroundColor3 = Color3.fromRGB(50, 40, 80)}, 0.1)
    end)

    UserInputService.InputBegan:Connect(function(input)
        if listening then
            listening = false
            local keyName = input.KeyCode.Name
            State.Binds[labelText] = keyName
            KeyBtn.Text = "[" .. keyName .. "]"
            Tween(KeyBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}, 0.1)
            if callback then callback(input.KeyCode) end
        end
    end)

    return Row
end

-- ═══════════════════════════════════════════
--            POPULATE TABS
-- ═══════════════════════════════════════════

-- COMBAT TAB
local combatPage = TabPages["Combat"]
AddSection(combatPage, "AIMBOT")
AddToggle(combatPage, "Aimbot Enabled", false)
AddToggle(combatPage, "Silent Aim", false)
AddDropdown(combatPage, "Aim Part", {"Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm"}, "Head")
AddSlider(combatPage, "FOV Size", 1, 500, 120, "px")
AddSlider(combatPage, "Smoothness", 1, 50, 10, "x")
AddToggle(combatPage, "FOV Circle", true)
AddSection(combatPage, "COMBAT MISC")
AddToggle(combatPage, "Auto Parry", false)
AddToggle(combatPage, "No Spread", false)
AddSlider(combatPage, "Hit Chance", 1, 100, 85, "%")
AddToggle(combatPage, "Auto Block", false)

-- ESP TAB
local espPage = TabPages["ESP"]
AddSection(espPage, "PLAYER ESP")
AddToggle(espPage, "Player ESP", true)
AddToggle(espPage, "Box ESP", false)
AddToggle(espPage, "Skeleton ESP", false)
AddToggle(espPage, "Head Dot", true)
AddToggle(espPage, "Name ESP", true)
AddToggle(espPage, "Distance ESP", true)
AddToggle(espPage, "Health Bar", true)
AddSection(espPage, "CHAMS")
AddToggle(espPage, "Player Chams", false)
AddDropdown(espPage, "Chams Style", {"Flat", "Neon", "Glass", "Outline"}, "Flat")
AddSection(espPage, "WORLD ESP")
AddToggle(espPage, "Dropped Items ESP", false)
AddToggle(espPage, "Interact ESP", false)

-- MOMENT TAB
local momentPage = TabPages["Moment"]
AddSection(momentPage, "MOVEMENT")
AddToggle(momentPage, "Speed Hack", false)
AddSlider(momentPage, "Speed Multiplier", 1, 10, 2, "x")
AddToggle(momentPage, "Fly Hack", false)
AddSlider(momentPage, "Fly Speed", 10, 200, 50, "")
AddToggle(momentPage, "No Clip", false)
AddToggle(momentPage, "Infinite Jump", false)
AddSection(momentPage, "PHYSICS")
AddSlider(momentPage, "Jump Power", 1, 200, 50, "")
AddSlider(momentPage, "Gravity", 1, 200, 100, "%")
AddToggle(momentPage, "No Fall Damage", true)
AddToggle(momentPage, "Anti-Knockback", false)

-- VISUALS TAB
local visualsPage = TabPages["Visuals"]
AddSection(visualsPage, "RENDERING")
AddToggle(visualsPage, "Full Bright", false)
AddToggle(visualsPage, "No Fog", false)
AddToggle(visualsPage, "No Shadows", false)
AddDropdown(visualsPage, "FOV Preset", {"60", "75", "90", "100", "110", "120"}, "90")
AddSection(visualsPage, "CROSSHAIR")
AddToggle(visualsPage, "Custom Crosshair", false)
AddDropdown(visualsPage, "Crosshair Style", {"Cross", "Dot", "Circle", "Dynamic"}, "Cross")
AddSection(visualsPage, "PLAYER")
AddToggle(visualsPage, "Third Person", false)
AddToggle(visualsPage, "Wireframe", false)

-- MISC TAB
local miscPage = TabPages["Misc"]
AddSection(miscPage, "UTILITIES")
AddButton(miscPage, "Rejoin Server", "Reconnects to server", function() print("Rejoining...") end)
AddButton(miscPage, "Copy Server ID", "Copies job ID", function()
    setclipboard(game.JobId)
    print("Copied!")
end)
AddButton(miscPage, "Teleport to Spawn", "", function()
    local char = LocalPlayer.Character
    if char then char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(0, 5, 0) end
end)
AddSection(miscPage, "GAME")
AddToggle(miscPage, "Anti AFK", true)
AddToggle(miscPage, "Chat Bypass", false)
AddToggle(miscPage, "Hide GUI", false)
AddSlider(miscPage, "Time of Day", 0, 24, 14, "h")

-- SETTINGS TAB
local settingsPage = TabPages["Settings"]
AddSection(settingsPage, "INTERFACE")
AddToggle(settingsPage, "Notifications", true)
AddToggle(settingsPage, "Watermark", true)
AddDropdown(settingsPage, "Menu Theme", {"Indigo", "Crimson", "Emerald", "Amber", "Cyan"}, "Indigo")
AddSlider(settingsPage, "Menu Opacity", 10, 100, 95, "%")
AddSection(settingsPage, "SAVE / LOAD")
AddButton(settingsPage, "Save Config", "", function() print("Config saved!") end)
AddButton(settingsPage, "Load Config", "", function() print("Config loaded!") end)
AddButton(settingsPage, "Reset Config", "", function() print("Config reset!") end)

-- BINDS TAB
local bindsPage = TabPages["Binds"]
AddSection(bindsPage, "HOTKEYS")
AddBind(bindsPage, "Aimbot Toggle",    "E")
AddBind(bindsPage, "Silent Aim Toggle","R")
AddBind(bindsPage, "Fly Toggle",       "G")
AddBind(bindsPage, "Speed Toggle",     "H")
AddBind(bindsPage, "No Clip Toggle",   "V")
AddBind(bindsPage, "ESP Toggle",       "Z")
AddBind(bindsPage, "Full Bright",      "F")
AddBind(bindsPage, "Third Person",     "T")
AddSection(bindsPage, "INFO")
AddButton(bindsPage, "Clear All Binds", "Reset all binds to None", function()
    for k, _ in pairs(State.Binds) do
        State.Binds[k] = "None"
    end
    print("All binds cleared!")
end)

-- ═══════════════════════════════════════════
--            DRAGGABLE
-- ═══════════════════════════════════════════
do
    local dragging, dragStart, startPos = false, nil, nil
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ═══════════════════════════════════════════
--            OPEN / CLOSE ANIMATION
-- ═══════════════════════════════════════════
local function SetMenuVisible(visible)
    State.IsOpen = visible
    if visible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 720, 0, 480)
        MainFrame.BackgroundTransparency = 1
        Tween(MainFrame, {BackgroundTransparency = 0, Size = UDim2.new(0, 720, 0, 480)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        Tween(MainFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, 680, 0, 440)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.25, function()
            if not State.IsOpen then
                MainFrame.Visible = false
            end
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function()
    SetMenuVisible(false)
end)

-- INSERT key toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == CONFIG.ToggleKey then
        SetMenuVisible(not State.IsOpen)
    end
end)

-- ═══════════════════════════════════════════
--            INIT - Show first tab
-- ═══════════════════════════════════════════
SwitchTab("Combat")

-- Open animation on load
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 680, 0, 440)
task.delay(0.2, function()
    SetMenuVisible(true)
end)

-- ═══════════════════════════════════════════
--            WATERMARK
-- ═══════════════════════════════════════════
local Watermark = CreateInstance("Frame", {
    Size = UDim2.new(0, 180, 0, 30),
    Position = UDim2.new(0, 14, 0, 14),
    BackgroundColor3 = Color3.fromRGB(10, 10, 20),
    BackgroundTransparency = 0.2,
    ZIndex = 2,
    Parent = ScreenGui,
})
MakeCorner(8).Parent = Watermark
MakeStroke(CONFIG.BorderColor).Parent = Watermark

local WMLabel = CreateInstance("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "✦ ROBLOX  |  INSERT = toggle",
    TextColor3 = CONFIG.TextMuted,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    ZIndex = 3,
    Parent = Watermark,
})

print("✦ [RobloxMenu] Loaded | Press INSERT to toggle")
