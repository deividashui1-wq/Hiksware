local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("Hiksware_V2") then CoreGui.Hiksware_V2:Destroy() end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Hiksware_V2"

-- Главное окно
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Красивая полоска сверху (Градиент)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 3)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopBar.BorderSizePixel = 0
local Gradient = Instance.new("UIGradient", TopBar)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255))
})

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.Text = "H I K S W A R E"
Title.Position = UDim2.new(0, 20, 0, 15)
Title.Size = UDim2.new(0, 100, 0, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Сетка для модулей
local ModuleList = Instance.new("ScrollingFrame", Main)
ModuleList.Position = UDim2.new(0, 15, 0, 60)
ModuleList.Size = UDim2.new(1, -30, 1, -80)
ModuleList.BackgroundTransparency = 1
ModuleList.CanvasSize = UDim2.new(0, 0, 2, 0)
ModuleList.ScrollBarThickness = 2

local Layout = Instance.new("UIGridLayout", ModuleList)
Layout.CellSize = UDim2.new(0, 130, 0, 40)
Layout.CellPadding = UDim2.new(0, 10, 0, 10)

-- Функция создания модуля
local function AddModule(name, callback)
    local Btn = Instance.new("TextButton", ModuleList)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    local btnCorner = Instance.new("UICorner", Btn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 120, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
        end
        callback(enabled)
    end)
end

-- Добавляем функции
AddModule("Silent Aim", function(state)
    _G.HikswareSettings.SilentAim = state
    print("Silent Aim:", state)
end)

AddModule("ESP Boxes", function(state)
    _G.HikswareSettings.ESP = state
    print("ESP:", state)
end)

AddModule("Fly Hack", function(state)
    print("Fly:", state)
end)

-- Плавное появление
Main.GroupTransparency = 1
TweenService:Create(Main, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -225, 0.5, -150)}):Play()

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
