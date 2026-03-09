--[[
  ██████╗ ██╗  ██╗ █████╗ ███╗   ██╗████████╗ ██████╗ ███╗   ███╗
  ██╔══██╗██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗████╗ ████║
  ██████╔╝███████║███████║██╔██╗ ██║   ██║   ██║   ██║██╔████╔██║
  ██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║╚██╔╝██║
  ██║     ██║  ██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║ ╚═╝ ██║
  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝

  UI v4.0 — COMBAT · VISUALS · MISC
  Toggle: INSERT
]]

-- ═══════════════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

-- ═══════════════════════════════════════════════════
--  PALETTE  — obsidian / electric-cyan
-- ═══════════════════════════════════════════════════
local COL = {
    WIN_BG      = Color3.fromRGB( 8,   8,  13),  -- window
    SIDEBAR_BG  = Color3.fromRGB(11,  11,  18),  -- sidebar
    HEADER_BG   = Color3.fromRGB(10,  10,  16),  -- title bar
    ROW_BG      = Color3.fromRGB(15,  15,  24),  -- slider row
    ROW_HOV     = Color3.fromRGB(20,  20,  34),  -- slider hover
    BORDER      = Color3.fromRGB(32,  32,  52),  -- thin borders
    TRACK_BG    = Color3.fromRGB(25,  25,  42),  -- slider track
    TRACK_FILL  = Color3.fromRGB(0,  210, 255),  -- filled portion
    THUMB_COL   = Color3.fromRGB(255, 255, 255), -- thumb dot
    ACCENT      = Color3.fromRGB(0,  210, 255),  -- cyan accent
    ACCENT_DIM  = Color3.fromRGB(0,   60,  80),  -- dim accent bg
    TAB_ACT_BG  = Color3.fromRGB(0,   40,  55),  -- active tab bg
    TAB_ACT_TXT = Color3.fromRGB(0,  210, 255),  -- active tab text
    TAB_IDL_TXT = Color3.fromRGB(75,  80, 110),  -- idle tab text
    TEXT        = Color3.fromRGB(210, 220, 255),  -- main text
    TEXT_DIM    = Color3.fromRGB(85,  90, 125),  -- muted text
    TEXT_VAL    = Color3.fromRGB(0,  210, 255),  -- value text
    DIVIDER     = Color3.fromRGB(28,  28,  46),  -- section divider
    SEP_TEXT    = Color3.fromRGB(60,  65, 100),  -- section label
    CLOSE_BG    = Color3.fromRGB(40,  14,  14),
    CLOSE_TXT   = Color3.fromRGB(255, 80,  80),
}

-- ═══════════════════════════════════════════════════
--  STATE
-- ═══════════════════════════════════════════════════
local S = { Open = true, Tab = "COMBAT", Val = {} }

-- ═══════════════════════════════════════════════════
--  CLEANUP
-- ═══════════════════════════════════════════════════
pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("PhantomUI4")
    if old then old:Destroy() end
end)

-- ═══════════════════════════════════════════════════
--  ROOT
-- ═══════════════════════════════════════════════════
local GUI = Instance.new("ScreenGui")
GUI.Name           = "PhantomUI4"
GUI.ResetOnSpawn   = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent         = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════
--  HELPERS
-- ═══════════════════════════════════════════════════
local function N(cls, t, par)
    local o = Instance.new(cls)
    for k,v in pairs(t or {}) do o[k]=v end
    if par then o.Parent=par end
    return o
end
local function Rnd(r,p)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=p
end
local function Bdr(col,th,p)
    local s=Instance.new("UIStroke")
    s.Color=col; s.Thickness=th
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p
end
local function Pad(t,b,l,r,p)
    local u=Instance.new("UIPadding")
    u.PaddingTop=UDim.new(0,t); u.PaddingBottom=UDim.new(0,b)
    u.PaddingLeft=UDim.new(0,l); u.PaddingRight=UDim.new(0,r)
    u.Parent=p
end
local function VList(gap,p)
    local l=Instance.new("UIListLayout")
    l.FillDirection=Enum.FillDirection.Vertical
    l.SortOrder=Enum.SortOrder.LayoutOrder
    l.Padding=UDim.new(0,gap); l.Parent=p
end
local function Tw(o,props,dur,es,ed)
    TweenService:Create(o,TweenInfo.new(
        dur or 0.18,
        es  or Enum.EasingStyle.Quart,
        ed  or Enum.EasingDirection.Out
    ),props):Play()
end

-- ═══════════════════════════════════════════════════
--  WINDOW  720 × 468
-- ═══════════════════════════════════════════════════
local Win = N("Frame",{
    Name="Window",
    Size=UDim2.new(0,720,0,468),
    Position=UDim2.new(.5,-360,.5,-234),
    BackgroundColor3=COL.WIN_BG,
    BorderSizePixel=0,
    ClipsDescendants=true,
},GUI)
Rnd(12,Win)
Bdr(COL.BORDER,1.2,Win)

-- subtle top-corner tint
N("Frame",{
    Size=UDim2.new(.5,0,.4,0),
    BackgroundColor3=Color3.fromRGB(0,60,90),
    BackgroundTransparency=0.92, BorderSizePixel=0, ZIndex=0,
},Win)

-- ═══════════════════════════════════════════════════
--  TITLE BAR  (48 px)
-- ═══════════════════════════════════════════════════
local TBar = N("Frame",{
    Size=UDim2.new(1,0,0,48),
    BackgroundColor3=COL.HEADER_BG,
    BorderSizePixel=0, ZIndex=10,
},Win)
-- fill bottom-corner gap
N("Frame",{
    Size=UDim2.new(1,0,0,12),
    Position=UDim2.new(0,0,1,-12),
    BackgroundColor3=COL.HEADER_BG,
    BorderSizePixel=0, ZIndex=10,
},TBar)
-- bottom separator line
N("Frame",{
    Size=UDim2.new(1,0,0,1),
    Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=COL.BORDER,
    BorderSizePixel=0, ZIndex=11,
},TBar)
-- left cyan stripe
N("Frame",{
    Size=UDim2.new(0,3,0,28),
    Position=UDim2.new(0,14,.5,-14),
    BackgroundColor3=COL.ACCENT,
    BorderSizePixel=0, ZIndex=11,
},TBar)
-- icon box
local LogoBox=N("Frame",{
    Size=UDim2.new(0,28,0,28),
    Position=UDim2.new(0,24,.5,-14),
    BackgroundColor3=COL.ACCENT_DIM,
    BorderSizePixel=0, ZIndex=11,
},TBar)
Rnd(6,LogoBox)
N("TextLabel",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Text="⬡", TextColor3=COL.ACCENT,
    TextSize=15, Font=Enum.Font.GothamBold, ZIndex=12,
},LogoBox)
-- title
N("TextLabel",{
    Size=UDim2.new(0,160,1,0),
    Position=UDim2.new(0,60,0,0),
    BackgroundTransparency=1,
    Text="PHANTOM",
    TextColor3=COL.TEXT, TextSize=16,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
},TBar)
N("TextLabel",{
    Size=UDim2.new(0,220,0,14),
    Position=UDim2.new(0,60,.5,3),
    BackgroundTransparency=1,
    Text="v4.0  ·  INSERT = show / hide",
    TextColor3=COL.TEXT_DIM, TextSize=9.5,
    Font=Enum.Font.Gotham,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
},TBar)
-- close btn
local CloseBtn=N("TextButton",{
    Size=UDim2.new(0,30,0,30),
    Position=UDim2.new(1,-44,.5,-15),
    BackgroundColor3=COL.CLOSE_BG,
    Text="✕", TextColor3=COL.CLOSE_TXT,
    TextSize=13, Font=Enum.Font.GothamBold, ZIndex=12,
},TBar)
Rnd(8,CloseBtn)

-- ═══════════════════════════════════════════════════
--  BODY ROW  (sidebar 148 px  |  content rest)
-- ═══════════════════════════════════════════════════
local Body=N("Frame",{
    Size=UDim2.new(1,0,1,-48),
    Position=UDim2.new(0,0,0,48),
    BackgroundTransparency=1, ZIndex=5,
},Win)

-- ── SIDEBAR ──────────────────────────────────────
local Side=N("Frame",{
    Size=UDim2.new(0,148,1,0),
    BackgroundColor3=COL.SIDEBAR_BG,
    BorderSizePixel=0, ZIndex=6,
},Body)
-- right divider
N("Frame",{
    Size=UDim2.new(0,1,1,0),
    Position=UDim2.new(1,-1,0,0),
    BackgroundColor3=COL.BORDER,
    BorderSizePixel=0, ZIndex=7,
},Side)

local SideList=N("Frame",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1, ZIndex=7,
},Side)
VList(3,SideList)
Pad(12,12,8,8,SideList)

-- version footer in sidebar
N("TextLabel",{
    Size=UDim2.new(1,0,0,22),
    Position=UDim2.new(0,0,1,-26),
    BackgroundTransparency=1,
    Text="PHANTOM  4.0",
    TextColor3=COL.TEXT_DIM, TextSize=8.5,
    Font=Enum.Font.Gotham,
    TextXAlignment=Enum.TextXAlignment.Center, ZIndex=7,
},Side)

-- ── CONTENT ──────────────────────────────────────
local ContentArea=N("Frame",{
    Size=UDim2.new(1,-148,1,0),
    Position=UDim2.new(0,148,0,0),
    BackgroundTransparency=1,
    ClipsDescendants=true, ZIndex=5,
},Body)

-- ═══════════════════════════════════════════════════
--  TAB DEFINITIONS
-- ═══════════════════════════════════════════════════
local TABS={
    {id="COMBAT",  icon="◎", sub="Aim assistance & recoil control"},
    {id="VISUALS", icon="◈", sub="ESP · wallhack · render settings"},
    {id="MISC",    icon="◉", sub="Movement · cloud · interface"},
}

local TabBtns  = {}
local TabPages = {}

-- ═══════════════════════════════════════════════════
--  BUILD SCROLL PAGES
-- ═══════════════════════════════════════════════════
for _,t in ipairs(TABS) do
    local pg=N("ScrollingFrame",{
        Name=t.id,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=COL.ACCENT,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y,
        Visible=false, ZIndex=5,
    },ContentArea)
    Pad(16,20,18,18,pg)
    VList(6,pg)
    TabPages[t.id]=pg
end

-- ═══════════════════════════════════════════════════
--  ACTIVATE TAB
-- ═══════════════════════════════════════════════════
local function ActivateTab(id)
    S.Tab=id
    for _,t in ipairs(TABS) do
        local btn=TabBtns[t.id]
        local pg=TabPages[t.id]
        local on=(t.id==id)
        pg.Visible=on
        if not btn then continue end
        local bg  = btn:FindFirstChild("BG")
        local lbl = btn:FindFirstChild("LBL")
        local ico = btn:FindFirstChild("ICO")
        local bar = btn:FindFirstChild("BAR")
        if on then
            Tw(bg,  {BackgroundColor3=COL.TAB_ACT_BG, BackgroundTransparency=0}, 0.18)
            Tw(lbl, {TextColor3=COL.TAB_ACT_TXT}, 0.18)
            Tw(ico, {TextColor3=COL.ACCENT},       0.18)
            Tw(bar, {BackgroundTransparency=0},     0.18)
        else
            Tw(bg,  {BackgroundColor3=COL.SIDEBAR_BG, BackgroundTransparency=1}, 0.18)
            Tw(lbl, {TextColor3=COL.TAB_IDL_TXT}, 0.18)
            Tw(ico, {TextColor3=COL.TAB_IDL_TXT}, 0.18)
            Tw(bar, {BackgroundTransparency=1},    0.18)
        end
    end
end

-- ═══════════════════════════════════════════════════
--  BUILD TAB BUTTONS
-- ═══════════════════════════════════════════════════
for i,t in ipairs(TABS) do
    local Btn=N("Frame",{
        Name=t.id.."_btn",
        Size=UDim2.new(1,0,0,46),
        BackgroundTransparency=1,
        LayoutOrder=i, ZIndex=8,
    },SideList)

    local BG=N("Frame",{
        Name="BG",
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=COL.SIDEBAR_BG,
        BackgroundTransparency=1, ZIndex=8,
    },Btn)
    Rnd(8,BG)

    -- active bar (left edge)
    local BAR=N("Frame",{
        Name="BAR",
        Size=UDim2.new(0,3,0,22),
        Position=UDim2.new(0,0,.5,-11),
        BackgroundColor3=COL.ACCENT,
        BackgroundTransparency=1, ZIndex=10,
    },Btn)
    Rnd(2,BAR)

    local ICO=N("TextLabel",{
        Name="ICO",
        Size=UDim2.new(0,20,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=t.icon, TextColor3=COL.TAB_IDL_TXT,
        TextSize=14, Font=Enum.Font.GothamBold, ZIndex=9,
    },Btn)

    local LBL=N("TextLabel",{
        Name="LBL",
        Size=UDim2.new(1,-36,1,0),
        Position=UDim2.new(0,34,0,0),
        BackgroundTransparency=1,
        Text=t.id, TextColor3=COL.TAB_IDL_TXT,
        TextSize=12, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=9,
    },Btn)

    local Click=N("TextButton",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text="", ZIndex=11,
    },Btn)
    Click.MouseEnter:Connect(function()
        if S.Tab~=t.id then Tw(BG,{BackgroundTransparency=0.55},0.1) end
    end)
    Click.MouseLeave:Connect(function()
        if S.Tab~=t.id then Tw(BG,{BackgroundTransparency=1},0.1) end
    end)
    Click.MouseButton1Click:Connect(function() ActivateTab(t.id) end)
    TabBtns[t.id]=Btn
end

-- ═══════════════════════════════════════════════════
--  WIDGET FACTORIES
-- ═══════════════════════════════════════════════════

-- ── PAGE HEADER ──────────────────────────────────
local function MkHeader(page, tabId, subtitle, order)
    local H=N("Frame",{
        Size=UDim2.new(1,0,0,56),
        BackgroundTransparency=1,
        LayoutOrder=order or 0, ZIndex=6,
    },page)
    -- top accent bar
    N("Frame",{
        Size=UDim2.new(0,30,0,2),
        BackgroundColor3=COL.ACCENT,
        BorderSizePixel=0, ZIndex=7,
    },H)
    N("TextLabel",{
        Size=UDim2.new(1,0,0,26),
        Position=UDim2.new(0,0,0,7),
        BackgroundTransparency=1,
        Text="CURRENT: "..tabId,
        TextColor3=COL.TEXT, TextSize=16,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7,
    },H)
    N("TextLabel",{
        Size=UDim2.new(1,0,0,14),
        Position=UDim2.new(0,0,0,35),
        BackgroundTransparency=1,
        Text=subtitle,
        TextColor3=COL.TEXT_DIM, TextSize=9.5,
        Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7,
    },H)
    -- bottom line
    N("Frame",{
        Size=UDim2.new(1,0,0,1),
        Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=COL.DIVIDER,
        BorderSizePixel=0, ZIndex=7,
    },H)
end

-- ── SECTION SEPARATOR ────────────────────────────
local function MkSection(page, label, order)
    local D=N("Frame",{
        Size=UDim2.new(1,0,0,20),
        BackgroundTransparency=1,
        LayoutOrder=order, ZIndex=6,
    },page)
    N("Frame",{
        Size=UDim2.new(1,0,0,1),
        Position=UDim2.new(0,0,.5,0),
        BackgroundColor3=COL.DIVIDER,
        BorderSizePixel=0, ZIndex=6,
    },D)
    -- pill label
    local pill=N("Frame",{
        Size=UDim2.new(0,0,1,-6),
        Position=UDim2.new(0,0,.5,-7),
        AutomaticSize=Enum.AutomaticSize.X,
        BackgroundColor3=COL.WIN_BG,
        BorderSizePixel=0, ZIndex=7,
    },D)
    Pad(0,0,7,7,pill)
    N("TextLabel",{
        Size=UDim2.new(0,0,1,0),
        AutomaticSize=Enum.AutomaticSize.X,
        BackgroundTransparency=1,
        Text=label, TextColor3=COL.SEP_TEXT,
        TextSize=9, Font=Enum.Font.GothamBold, ZIndex=8,
    },pill)
end

-- ── SLIDER ROW ────────────────────────────────────
--[[
  Layout (row height 58px):
  ┌─────────────────────────────────────────────┐
  │ Label name              [—————I—————]  val  │
  │ min ←————————————————————————→ max          │
  └─────────────────────────────────────────────┘
]]
local function MkSlider(page, order, label, mn, mx, default, unit, onChange)
    default = default or mn
    unit    = unit    or ""
    S.Val[label] = default

    local Row=N("Frame",{
        Size=UDim2.new(1,0,0,58),
        BackgroundColor3=COL.ROW_BG,
        BorderSizePixel=0, LayoutOrder=order, ZIndex=6,
    },page)
    Rnd(9,Row)
    Bdr(COL.BORDER,1,Row)

    -- label (top-left)
    N("TextLabel",{
        Size=UDim2.new(0,180,0,17),
        Position=UDim2.new(0,13,0,8),
        BackgroundTransparency=1,
        Text=label, TextColor3=COL.TEXT,
        TextSize=11.5, Font=Enum.Font.GothamMedium,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7,
    },Row)

    -- current value badge (top-right)
    local ValLbl=N("TextLabel",{
        Size=UDim2.new(0,72,0,17),
        Position=UDim2.new(1,-85,0,8),
        BackgroundTransparency=1,
        Text=tostring(default)..unit,
        TextColor3=COL.TEXT_VAL,
        TextSize=11, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Right, ZIndex=7,
    },Row)

    -- min label
    N("TextLabel",{
        Size=UDim2.new(0,28,0,11),
        Position=UDim2.new(0,13,1,-15),
        BackgroundTransparency=1,
        Text=tostring(mn)..unit,
        TextColor3=COL.TEXT_DIM, TextSize=8.5,
        Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7,
    },Row)
    -- max label
    N("TextLabel",{
        Size=UDim2.new(0,36,0,11),
        Position=UDim2.new(1,-49,1,-15),
        BackgroundTransparency=1,
        Text=tostring(mx)..unit,
        TextColor3=COL.TEXT_DIM, TextSize=8.5,
        Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Right, ZIndex=7,
    },Row)

    -- track background
    local TBG=N("Frame",{
        Size=UDim2.new(1,-26,0,5),
        Position=UDim2.new(0,13,0,32),
        BackgroundColor3=COL.TRACK_BG,
        BorderSizePixel=0, ZIndex=7,
    },Row)
    Rnd(3,TBG)

    -- filled portion
    local pct0 = (default-mn)/math.max(mx-mn,1)
    local Fill=N("Frame",{
        Size=UDim2.new(pct0,0,1,0),
        BackgroundColor3=COL.TRACK_FILL,
        BorderSizePixel=0, ZIndex=8,
    },TBG)
    Rnd(3,Fill)

    -- thumb
    local Thumb=N("Frame",{
        Size=UDim2.new(0,13,0,13),
        Position=UDim2.new(pct0,-7,.5,-7),
        BackgroundColor3=COL.THUMB_COL,
        BorderSizePixel=0, ZIndex=9,
    },TBG)
    Rnd(7,Thumb)
    Bdr(COL.ACCENT,1.5,Thumb)
    -- inner glow dot
    N("Frame",{
        Size=UDim2.new(0,5,0,5),
        Position=UDim2.new(.5,-3,.5,-3),
        BackgroundColor3=COL.ACCENT,
        BorderSizePixel=0, ZIndex=10,
    },Thumb):FindFirstChildWhichIsA("UICorner") -- silent
    local dot=N("Frame",{
        Size=UDim2.new(0,5,0,5),
        Position=UDim2.new(.5,-3,.5,-3),
        BackgroundColor3=COL.ACCENT,
        BorderSizePixel=0, ZIndex=10,
    },Thumb)
    Rnd(3,dot)

    -- drag logic
    local dragging=false
    local function applyX(mx_)
        local rel=math.clamp(
            (mx_ - TBG.AbsolutePosition.X) / TBG.AbsoluteSize.X,
            0, 1
        )
        local v=math.floor(mn+(mx-mn)*rel+.5)
        S.Val[label]=v
        ValLbl.Text=tostring(v)..unit
        Tw(Fill,  {Size=UDim2.new(rel,0,1,0)},    0.05)
        Tw(Thumb, {Position=UDim2.new(rel,-7,.5,-7)},0.05)
        if onChange then onChange(v) end
    end

    local HIT=N("TextButton",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, Text="", ZIndex=11,
    },TBG)
    HIT.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; applyX(i.Position.X)
        end
    end)
    HIT.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    HIT.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            applyX(i.Position.X)
        end
    end)
    HIT.MouseLeave:Connect(function() dragging=false end)

    -- row hover
    Row.MouseEnter:Connect(function() Tw(Row,{BackgroundColor3=COL.ROW_HOV},0.12) end)
    Row.MouseLeave:Connect(function() Tw(Row,{BackgroundColor3=COL.ROW_BG}, 0.12); dragging=false end)

    return Row
end

-- ═══════════════════════════════════════════════════
--  POPULATE PAGES
-- ═══════════════════════════════════════════════════

-- ── COMBAT ───────────────────────────────────────
do
    local p=TabPages["COMBAT"]
    MkHeader (p,"COMBAT","Aim assistance & recoil control", 0)
    MkSection(p,"AIMBOT",1)
    MkSlider (p,2, "Aim Assist Strength",  0, 100, 50, "%")
    MkSlider (p,3, "Field of View (FOV)",  1, 180, 30, "°")
    MkSlider (p,4, "Smooth Speed",         1, 100, 70, "" )
    MkSection(p,"HITBOX",5)
    MkSlider (p,6, "Hitbox Head Priority", 0, 100, 45, "%")
    MkSlider (p,7, "Hitbox Body Priority", 0, 100, 70, "%")
    MkSection(p,"RECOIL",8)
    MkSlider (p,9, "Recoil Compensation",  0, 100, 50, "%")
end

-- ── VISUALS ───────────────────────────────────────
do
    local p=TabPages["VISUALS"]
    MkHeader (p,"VISUALS","ESP · wallhack · render settings", 0)
    MkSection(p,"WALLHACK",1)
    MkSlider (p,2, "Wallhack Opacity",       0,   100, 50, "%" )
    MkSlider (p,3, "Skeleton Thickness",     1,    10,  2, "px")
    MkSection(p,"BOX ESP",4)
    MkSlider (p,5, "Box Corner Size",        1,    50, 35, "px")
    MkSlider (p,6, "Max Render Distance",   10,  1000,300, "m" )
    MkSection(p,"HEALTH",7)
    MkSlider (p,8, "Health Bar Height",      2,    30, 20, "px")
end

-- ── MISC ──────────────────────────────────────────
do
    local p=TabPages["MISC"]
    MkHeader (p,"MISC","Movement · cloud sync · interface", 0)
    MkSection(p,"MOVEMENT",1)
    MkSlider (p,2, "Movement Speed Mult",  100, 200, 100, "%" )
    MkSlider (p,3, "Bunnyhop Velocity",      0, 100,  20, ""  )
    MkSection(p,"CLOUD / SYNC",4)
    MkSlider (p,5, "Cloud Sync Interval",    1,  60,  10, "s" )
    MkSection(p,"INTERFACE",6)
    MkSlider (p,7, "UI Transparency",        0, 100,   0, "%",
        function(v) Tw(Win,{BackgroundTransparency=v/100},0.12) end)
end

-- ═══════════════════════════════════════════════════
--  DRAG WINDOW
-- ═══════════════════════════════════════════════════
do
    local drag,ds,wp=false
    local DragHit=N("TextButton",{
        Size=UDim2.new(1,-80,1,0),
        BackgroundTransparency=1, Text="", ZIndex=14,
    },TBar)
    DragHit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; ds=i.Position; wp=Win.Position
        end
    end)
    DragHit.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            Win.Position=UDim2.new(wp.X.Scale,wp.X.Offset+d.X,wp.Y.Scale,wp.Y.Offset+d.Y)
        end
    end)
end

-- ═══════════════════════════════════════════════════
--  OPEN / CLOSE
-- ═══════════════════════════════════════════════════
local function SetOpen(v)
    S.Open=v
    if v then
        Win.Visible=true
        Win.Size=UDim2.new(0,680,0,448)
        Win.BackgroundTransparency=1
        Tw(Win,{Size=UDim2.new(0,720,0,468), BackgroundTransparency=0},
            0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    else
        Tw(Win,{Size=UDim2.new(0,680,0,448), BackgroundTransparency=1},
            0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        task.delay(0.21,function()
            if not S.Open then Win.Visible=false end
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function() SetOpen(false) end)
CloseBtn.MouseEnter:Connect(function() Tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(70,20,20)},0.1) end)
CloseBtn.MouseLeave:Connect(function() Tw(CloseBtn,{BackgroundColor3=COL.CLOSE_BG},0.1) end)

UserInputService.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.Insert then SetOpen(not S.Open) end
end)

-- ═══════════════════════════════════════════════════
--  WATERMARK
-- ═══════════════════════════════════════════════════
local WM=N("Frame",{
    Size=UDim2.new(0,200,0,26),
    Position=UDim2.new(0,14,0,14),
    BackgroundColor3=COL.WIN_BG,
    BackgroundTransparency=0.15,
    BorderSizePixel=0, ZIndex=2,
},GUI)
Rnd(7,WM)
Bdr(COL.BORDER,1,WM)
N("Frame",{
    Size=UDim2.new(0,2,0,14),
    Position=UDim2.new(0,10,.5,-7),
    BackgroundColor3=COL.ACCENT,
    BorderSizePixel=0, ZIndex=3,
},WM)
N("TextLabel",{
    Size=UDim2.new(1,-22,1,0),
    Position=UDim2.new(0,18,0,0),
    BackgroundTransparency=1,
    Text="PHANTOM  ·  INSERT = toggle",
    TextColor3=COL.TEXT_DIM, TextSize=9.5,
    Font=Enum.Font.GothamMedium,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
},WM)

-- ═══════════════════════════════════════════════════
--  INIT
-- ═══════════════════════════════════════════════════
ActivateTab("COMBAT")
Win.BackgroundTransparency=1
Win.Size=UDim2.new(0,680,0,448)
task.delay(0.08, function() SetOpen(true) end)

print("✦ PhantomUI v4.0  |  INSERT = show/hide")
