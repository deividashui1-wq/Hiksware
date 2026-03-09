local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("Hiksware_UI") then CoreGui.Hiksware_UI:Destroy() end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Hiksware_UI"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Боковая панель
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Text = "HIK S W A R E"
Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
Logo.Font = Enum.Font.SourceSansBold
Logo.TextSize = 20
Logo.BackgroundTransparency = 1

local TabButtons = Instance.new("Frame", Sidebar)
TabButtons.Position = UDim2.new(0, 0, 0, 60)
TabButtons.Size = UDim2.new(1, 0, 1, -60)
TabButtons.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", TabButtons)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0, 5)

-- Контейнер для страниц
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0, 140, 0, 10)
Pages.Size = UDim2.new(1, -150, 1, -20)
Pages.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("Frame", Pages)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    local TabBtn = Instance.new("TextButton", TabButtons)
    TabBtn.Size = UDim2.new(0, 110, 0, 30)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.SourceSans
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
        Page.Visible = true
    end)
    
    return Page
end

-- Создаем страницы
local CombatPage = CreatePage("Combat")
local VisualsPage = CreatePage("Visuals")
CombatPage.Visible = true -- Первая страница открыта сразу

-- Тестовая кнопка на странице Combat
local TestBtn = Instance.new("TextButton", CombatPage)
TestBtn.Size = UDim2.new(0, 150, 0, 40)
TestBtn.Text = "Silent Aim: OFF"
TestBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TestBtn)

-- Скрытие на Insert
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
end)

print("Hiksware Menu Updated!")
