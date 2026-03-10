-- [[ PHANTOM CLOUD LOGIC — ЭТОТ ФАЙЛ НА GITHUB ]]
local Cloud = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Находим ближайшую цель
function GetClosestPlayer()
    local target = nil
    local dist = _G.FOVRadius or 100
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if magnitude < dist then
                    dist = magnitude
                    target = v
                end
            end
        end
    end
    return target
end

-- Основной цикл Аимбота
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = GetClosestPlayer()
        if target then
            -- Плавная наводка
            local targetPos = workspace.CurrentCamera:WorldToViewportPoint(target.Character.Head.Position)
            mousemoverel(
                (targetPos.X - Mouse.X) / (_G.AimSmooth or 5), 
                (targetPos.Y - Mouse.Y) / (_G.AimSmooth or 5)
            )
        end
    end
end)

return Cloud
