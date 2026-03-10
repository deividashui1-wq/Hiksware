local Cloud = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function GetClosestPlayer()
    local target = nil
    local dist = _G.FOVRadius or 100
    -- Читаем, что выбрано в меню (Голова или Торс)
    local targetPart = _G.AimPart or "Head" 
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(targetPart) then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character[targetPart].Position)
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

RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = GetClosestPlayer()
        local targetPart = _G.AimPart or "Head" -- Опять проверяем кость
        
        if target and target.Character and target.Character:FindFirstChild(targetPart) then
            local targetPos = workspace.CurrentCamera:WorldToViewportPoint(target.Character[targetPart].Position)
            -- Наводка
            mousemoverel(
                (targetPos.X - Mouse.X) / (_G.AimSmooth or 2), 
                (targetPos.Y - Mouse.Y) / (_G.AimSmooth or 2)
            )
        end
    end
end)

return Cloud
