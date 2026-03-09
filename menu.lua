local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("Hiksware_V2") then CoreGui.Hiksware_V2:Destroy() end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Hiksware_V2"

-- Главное окно (Увеличенное)
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 600, 0, 450)
Main.Position = UDim2.new(0.5, -300, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
Main.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 10)

-- Верхняя панель (Header)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Header.BorderSizePixel = 0
local HeaderCorner = Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Text = "HIKSWARE"
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0, 100, 1, 0)
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Контейнер для вкладок сверху
local TabBar = Instance.new("Frame", Header)
TabBar.Position = UDim2.new(0, 150, 0, 0)
TabBar.Size = UDim2.new(1, -160, 1, 0)
TabBar.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 10)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Контейнер для страниц
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0, 20, 0, 70)
Pages.Size = UDim2.new(1, -40, 1, -90)
Pages.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.CanvasSize = UDim2.new(0,0,2,0)
    
    local PageLayout = Instance.new("UIGridLayout", Page)
    PageLayout.CellSize = UDim2.new(0, 170, 0, 45)
    PageLayout.CellPadding = UDim2.new(0, 15, 0, 15)

    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0, 90, 0, 30)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do 
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end 
        end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)

    return Page
end

-- Создаем страницы
local CombatPage = CreatePage("Combat")
local VisualsPage = CreatePage("Visuals")
local MiscPage = CreatePage("Misc")
CombatPage.Visible = true

-- Функция добавления модуля
local function AddModule(parent, name, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)

    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        if enabled then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end

-- Наполняем модулями
AddModule(CombatPage, "Silent Aim", function(v) _G.HikswareSettings.SilentAim = v end)
AddModule(CombatPage, "Trigger Bot", function(v) print("Trigger:", v) end)

AddModule(VisualsPage, "Box ESP", function(v) _G.HikswareSettings.ESP = v end)
AddModule(VisualsPage, "Tracers", function(v) print("Tracers:", v) end)

AddModule(MiscPage, "Speed Hack", function(v) 
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v and 50 or 16 
end)

-- Драг (перетаскивание)
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
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
