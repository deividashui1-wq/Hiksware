-- [[ PHANTOM CORE V6 — FINAL VERSION ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════
--  1. CLOUD LINK (ССЫЛКА НА ГИТХАБ)
-- ═══════════════════════════════════════════════════
-- ТУТ ТЫ ВСТАВЛЯЕШЬ СВОЮ RAW ССЫЛКУ:
local github_url = "https://raw.githubusercontent.com/deividashui1-wq/Hiksware/refs/heads/main/functions.lua""

-- Загружаем логику (аимбот и т.д.) прямо с сайта
local success, CloudLogic = pcall(function()
    return loadstring(game:HttpGet(github_url))()
end)

if not success then warn("PHANTOM: Cloud logic not found!") end

-- ═══════════════════════════════════════════════════
--  2. STYLE & SETTINGS
-- ═══════════════════════════════════════════════════
local Theme = {
    Main = Color3.fromRGB(12, 12, 12),      
    Header = Color3.fromRGB(16, 16, 16),    
    Accent = Color3.fromRGB(150, 80, 255),  
    Outline = Color3.fromRGB(30, 30, 35),   
    Text = Color3.fromRGB(230, 230, 230),   
    TextDim = Color3.fromRGB(120, 120, 130) 
}

-- Глобальные переменные для связи с облаком
_G.AimbotEnabled = false
_G.ShowFOV = false
_G.FOVRadius = 100
_G.AimSmooth = 5

-- ═══════════════════════════════════════════════════
--  3. UI BUILDER (ТВОЁ МЕНЮ)
-- ═══════════════════════════════════════════════════
local GUI = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 550, 0, 420)
Main.Position = UDim2.new(0.5, -275, 0.5, -210)
Main.BackgroundColor3 = Theme.Main
Instance.new("UIStroke", Main).Color = Theme.Outline

-- [Заголовок PHANTOM]
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Theme.Header
local Title = Instance.new("TextLabel", TopBar)
Title.Text = "  PHANTOM"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
local AccentLine = Instance.new("Frame", TopBar)
AccentLine.Size = UDim2.new(1, 0, 0, 1)
AccentLine.Position = UDim2.new(0, 0, 1, 0)
AccentLine.BackgroundColor3 = Theme.Accent

-- [Навигация и Контейнер]
local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 36)
TabContainer.BackgroundTransparency = 1
Instance.new("UIListLayout", TabContainer).FillDirection = Enum.FillDirection.Horizontal

local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -20, 1, -85)
PageContainer.Position = UDim2.new(0, 10, 0, 75)
PageContainer.BackgroundTransparency = 1

-- ═══════════════════════════════════════════════════
--  4. FUNCTIONS (КНОПКИ И ВКЛАДКИ)
-- ═══════════════════════════════════════════════════
local Pages = {}
local TabBtns = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0, 110, 1, 0)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name:upper()
    TabBtn.TextColor3 = Theme.TextDim
    TabBtn.Font = Enum.Font.Code
    TabBtn.TextSize = 11
    
    local Page = Instance.new("Frame", PageContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    local Left = Instance.new("Frame", Page)
    Left.Size = UDim2.new(0.485, 0, 1, 0)
    Left.BackgroundTransparency = 1
    Instance.new("UIListLayout", Left).Padding = UDim.new(0, 10)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabBtns) do b.TextColor3 = Theme.TextDim end
        Page.Visible = true
        TabBtn.TextColor3 = Theme.Accent
    end)
    
    Pages[name] = Page
    TabBtns[name] = TabBtn
    return Left
end

local function CreateSector(parent, title)
    local Sector = Instance.new("Frame", parent)
    Sector.Size = UDim2.new(1, 0, 0, 150)
    Sector.BackgroundColor3 = Theme.Header
    Instance.new("UIStroke", Sector).Color = Theme.Outline
    
    local STitle = Instance.new("TextLabel", Sector)
    STitle.Text = " " .. title:upper()
    STitle.Size = UDim2.new(1, 0, 0, 20)
    STitle.BackgroundColor3 = Theme.Outline
    STitle.TextColor3 = Theme.Text
    STitle.Font = Enum.Font.Code
    STitle.TextSize = 10
    STitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local Container = Instance.new("Frame", Sector)
    Container.Size = UDim2.new(1, -10, 1, -25)
    Container.Position = UDim2.new(0, 5, 0, 22)
    Container.BackgroundTransparency = 1
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)
    return Container
end

local function AddToggle(parent, text, callback)
    local Toggle = Instance.new("TextButton", parent)
    Toggle.Size = UDim2.new(1, 0, 0, 20)
    Toggle.BackgroundTransparency = 1
    Toggle.Text = "  " .. text
    Toggle.TextColor3 = Theme.TextDim
    Toggle.Font = Enum.Font.Code
    Toggle.TextSize = 12
    Toggle.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new("Frame", Toggle)
    Box.Size = UDim2.new(0, 12, 0, 12)
    Box.Position = UDim2.new(1, -15, 0.5, -6)
    Box.BackgroundColor3 = Theme.Main
    Instance.new("UIStroke", Box).Color = Theme.Outline

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Box.BackgroundColor3 = enabled and Theme.Accent or Theme.Main
        Toggle.TextColor3 = enabled and Theme.Text or Theme.TextDim
        callback(enabled)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local Slider = Instance.new("Frame", parent)
    Slider.Size = UDim2.new(1, 0, 0, 30)
    Slider.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Slider)
    Lbl.Text = "  " .. text
    Lbl.Size = UDim2.new(1, 0, 0, 15)
    Lbl.TextColor3 = Theme.TextDim
    Lbl.Font = Enum.Font.Code
    Lbl.BackgroundTransparency = 1
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local BG = Instance.new("Frame", Slider)
    BG.Size = UDim2.new(1, 0, 0, 3)
    BG.Position = UDim2.new(0, 0, 1, -5)
    BG.BackgroundColor3 = Theme.Outline
    local Fill = Instance.new("Frame", BG)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent

    local dragging = false
    BG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local rel = math.clamp((Mouse.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(rel, 0, 1, 0)
            callback(math.floor(min + (max-min)*rel))
        end
    end)
end

-- ═══════════════════════════════════════════════════
--  5. НАПОЛНЕНИЕ МЕНЮ (COMBAT)
-- ═══════════════════════════════════════════════════
local Combat = CreateTab("Combat")
local AimMain = CreateSector(Combat, "Aimbot Main")

AddToggle(AimMain, "Enable Aimbot", function(s) _G.AimbotEnabled = s end)
AddToggle(AimMain, "Show FOV Circle", function(s) _G.ShowFOV = s end)
AddSlider(AimMain, "FOV Radius", 30, 500, 100, function(v) _G.FOVRadius = v end)
AddSlider(AimMain, "Aim Smoothness", 1, 20, 5, function(v) _G.AimSmooth = v end)

Pages["Combat"].Visible = true
TabBtns["Combat"].TextColor3 = Theme.Accent

-- [Круг FOV на экране]
local Circle = Drawing.new("Circle")
Circle.Thickness = 1
Circle.Color = Theme.Accent
RunService.RenderStepped:Connect(function()
    Circle.Visible = _G.ShowFOV
    Circle.Radius = _G.FOVRadius
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

-- [Drag Logic]
local d, ds, sp
TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

print("✦ PHANTOM READY")
