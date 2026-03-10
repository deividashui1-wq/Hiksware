-- [[ PHANTOM CORE V6 — CUSTOM ENGINE ]]
-- "Этот скрипт является чекпоинтом, и в будущем я буду его дополнять."

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════
--  STYLE CONFIG (Тот самый цвет и стиль)
-- ═══════════════════════════════════════════════════
local Theme = {
    Main = Color3.fromRGB(12, 12, 12),      
    Header = Color3.fromRGB(16, 16, 16),    
    Accent = Color3.fromRGB(150, 80, 255),  
    Outline = Color3.fromRGB(30, 30, 35),   
    Text = Color3.fromRGB(230, 230, 230),   
    TextDim = Color3.fromRGB(120, 120, 130) 
}

-- ═══════════════════════════════════════════════════
--  UI CONSTRUCTOR
-- ═══════════════════════════════════════════════════
local GUI = Instance.new("ScreenGui", CoreGui)
GUI.Name = "PhantomV6"

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 550, 0, 420)
Main.Position = UDim2.new(0.5, -275, 0.5, -210)
Main.BackgroundColor3 = Theme.Main
Main.BorderSizePixel = 0

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Theme.Outline
Stroke.Thickness = 1
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Заголовок (Оставил только PHANTOM)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Theme.Header
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "  PHANTOM"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Theme.Text
Title.TextSize = 13
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left

local AccentLine = Instance.new("Frame", TopBar)
AccentLine.Size = UDim2.new(1, 0, 0, 1)
AccentLine.Position = UDim2.new(0, 0, 1, 0)
AccentLine.BackgroundColor3 = Theme.Accent
AccentLine.BorderSizePixel = 0

-- Навигация ВЕРХНЯЯ
local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 36)
TabContainer.BackgroundColor3 = Theme.Main
TabContainer.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Контейнер для страниц
local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -20, 1, -85)
PageContainer.Position = UDim2.new(0, 10, 0, 75)
PageContainer.BackgroundTransparency = 1

-- ═══════════════════════════════════════════════════
--  FUNCTIONS: ADD TAB & ADD SECTOR
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
    TabBtn.TextSize = 12
    
    local Page = Instance.new("Frame", PageContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    local LeftCol = Instance.new("Frame", Page)
    LeftCol.Name = "Left"
    LeftCol.Size = UDim2.new(0.485, 0, 1, 0)
    LeftCol.BackgroundTransparency = 1
    Instance.new("UIListLayout", LeftCol).Padding = UDim.new(0, 10)

    local RightCol = Instance.new("Frame", Page)
    RightCol.Name = "Right"
    RightCol.Size = UDim2.new(0.485, 0, 1, 0)
    RightCol.Position = UDim2.new(0.515, 0, 0, 0)
    RightCol.BackgroundTransparency = 1
    Instance.new("UIListLayout", RightCol).Padding = UDim.new(0, 10)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabBtns) do b.TextColor3 = Theme.TextDim end
        Page.Visible = true
        TabBtn.TextColor3 = Theme.Accent
    end)
    
    Pages[name] = Page
    TabBtns[name] = TabBtn
    return Page
end

local function CreateSector(parentCol, title)
    local Sector = Instance.new("Frame", parentCol)
    Sector.Size = UDim2.new(1, 0, 0, 155) 
    Sector.BackgroundColor3 = Theme.Header
    Sector.BorderSizePixel = 0
    local SStroke = Instance.new("UIStroke", Sector)
    SStroke.Color = Theme.Outline
    
    local STitle = Instance.new("TextLabel", Sector)
    STitle.Text = " " .. title:upper()
    STitle.Size = UDim2.new(1, 0, 0, 20)
    STitle.BackgroundColor3 = Theme.Outline
    STitle.TextColor3 = Theme.Text
    STitle.Font = Enum.Font.Code
    STitle.TextSize = 11
    STitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local Container = Instance.new("Frame", Sector)
    Container.Size = UDim2.new(1, -10, 1, -25)
    Container.Position = UDim2.new(0, 5, 0, 25)
    Container.BackgroundTransparency = 1
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)
    
    return Container
end

-- ═══════════════════════════════════════════════════
--  BUILDING TABS (Combat, Visuals, Movement, Misc, Settings)
-- ═══════════════════════════════════════════════════

-- 1. COMBAT
local Combat = CreateTab("Combat")
CreateSector(Combat.Left, "Aimbot Main")
CreateSector(Combat.Right, "Aimbot Settings")

-- 2. VISUALS
local Visuals = CreateTab("Visuals")
CreateSector(Visuals.Left, "ESP Players")
CreateSector(Visuals.Right, "World Visuals")

-- 3. MOVEMENT
local Movement = CreateTab("Movement")
CreateSector(Movement.Left, "Character")
CreateSector(Movement.Right, "Extra")

-- 4. MISC
local Misc = CreateTab("Misc")
CreateSector(Misc.Left, "Main Misc")
CreateSector(Misc.Right, "Automation")

-- 5. SETTINGS
local Settings = CreateTab("Settings")
CreateSector(Settings.Left, "Menu Config")
CreateSector(Settings.Right, "Networking")

-- Включаем Combat по умолчанию
Pages["Combat"].Visible = true
TabBtns["Combat"].TextColor3 = Theme.Accent

-- ═══════════════════════════════════════════════════
--  INTERACTIVITY (Drag)
-- ═══════════════════════════════════════════════════
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

print("✦ PHANTOM V6 RESTORED.")
