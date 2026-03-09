local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("Hiksware_Ultra") then CoreGui.Hiksware_Ultra:Destroy() end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Hiksware_Ultra"

_G.HikswareSettings = _G.HikswareSettings or { SilentAim = false, ESP = false }

-- ГЛАВНОЕ ОКНО (Широкое - 800px)
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 800, 0, 500)
Main.Position = UDim2.new(0.5, -400, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- ВЕРХНЯЯ ПАНЕЛЬ
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Text = "HIKSWARE"
Title.Position = UDim2.new(0, 25, 0, 0)
Title.Size = UDim2.new(0, 130, 1, 0)
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- КОНТЕЙНЕР ДЛЯ ВСЕХ 7 ВКЛАДОК
local TabContainer = Instance.new("Frame", Header)
TabContainer.Position = UDim2.new(0, 170, 0, 10)
TabContainer.Size = UDim2.new(1, -190, 0, 45)
TabContainer.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- КОНТЕЙНЕР ДЛЯ СТРАНИЦ
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0, 20, 0, 85)
Pages.Size = UDim2.new(1, -40, 1, -105)
Pages.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    
    local PageLayout = Instance.new("UIGridLayout", Page)
    PageLayout.CellSize = UDim2.new(0, 180, 0, 45)
    PageLayout.CellPadding = UDim2.new(0, 12, 0, 12)

    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0, 85, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
        for _, b in pairs(TabContainer:GetChildren()) do 
            if b:IsA("TextButton") then 
                b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                b.TextColor3 = Color3.fromRGB(180, 180, 180)
            end 
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    return Page
end

-- СОЗДАЕМ ВСЕ СЕКЦИИ
local Combat = CreatePage("Combat")
local ESPPage = CreatePage("ESP")
local Visuals = CreatePage("Visuals")
local Misc = CreatePage("Misc")
local Configs = CreatePage("Config")
local Settings = CreatePage("Settings")
local Binds = CreatePage("Binds")

local function AddModule(parent, name, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)

    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(22, 22, 22)
        Btn.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    end)
end

-- НАПОЛНЕНИЕ (ПРИМЕРЫ)
AddModule(Combat, "Silent Aim", function(v) _G.HikswareSettings.SilentAim = v end)
AddModule(ESPPage, "Box ESP", function(v) _G.HikswareSettings.ESP = v end)
AddModule(Misc, "Speed Hack", function(v) 
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v and 50 or 16 
end)

-- ОТКРЫВАЕМ ПЕРВУЮ ВКЛАДКУ
Combat.Visible = true

-- ДРАГ
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

-- СКРЫТИЕ НА INSERT
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
end)
