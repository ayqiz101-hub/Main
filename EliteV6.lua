-- [[ ZORKIY ELITE V6: Final Edition]]
-- Created by Ayqiz
-- TG: t.me/ayqiz_news

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZORKIY ELITE V6 | GOD MODE",
   LoadingTitle = "Script loaded",
   LoadingSubtitle = "by Ayqiz",
   ConfigurationSaving = {Enabled = true, FolderName = "ZorkiyConfigs", FileName = "EliteV6"},
   KeySystem = false
})

local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    AimActive = false, AimSmooth = 3, AimFOV = 150,
    ESPActive = false, Chams = false,
    FlingActive = false,
    ResValue = 1.0, WalkSpeed = 16, JumpPower = 50,
    Noclip = false, Fly = false
}

-- ВКЛАДКИ
local CombatTab = Window:CreateTab("🎯 Убийство")
local VisualsTab = Window:CreateTab("👁 Визуалы")
local MovementTab = Window:CreateTab("🏃 Движение")
local BoostTab = Window:CreateTab("⚡ Оптимизация")
local SettingsTab = Window:CreateTab("⚙️ Настройки")

-- ==========================================
-- 🎯 AIMBOT (РАБОЧИЙ)
-- ==========================================
local FOVring = Drawing.new("Circle")
FOVring.Visible = false; FOVring.Thickness = 2; FOVring.Color = Color3.fromRGB(255, 0, 0); FOVring.Filled = false

local function getClosestPlayer()
    local closest = nil; local shortestDistance = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if distance < shortestDistance and distance < Config.AimFOV then
                    closest = v; shortestDistance = distance
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    FOVring.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVring.Radius = Config.AimFOV
    if Config.AimActive and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target then
            local lookVector = (target.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit
            local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lookVector)
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1/Config.AimSmooth)
        end
    end
end)

CombatTab:CreateToggle({Name = "Аимбот (Прав. кнопка мыши)", CurrentValue = false, Callback = function(v) Config.AimActive = v; FOVring.Visible = v end})
CombatTab:CreateSlider({Name = "Плавность аима", Range = {1, 10}, Increment = 1, CurrentValue = 3, Callback = function(v) Config.AimSmooth = v end})

-- ==========================================
-- 🌪 FLING (УБИЙСТВО ТИПОВ)
-- ==========================================
CombatTab:CreateToggle({
    Name = "ФЛИНГ АУРА (Убивать при касании)",
    CurrentValue = false,
    Callback = function(v)
        Config.FlingActive = v
        if v then
            local char = Player.Character
            local hrp = char.HumanoidRootPart
            local vel = hrp.Velocity
            task.spawn(function()
                while Config.FlingActive do
                    RunService.Heartbeat:Wait()
                    hrp.Velocity = Vector3.new(5000, 5000, 5000)
                    hrp.RotVelocity = Vector3.new(5000, 5000, 5000)
                    -- Чтобы тебя не кикнуло, мы чередуем силу
                    task.wait(0.1)
                    hrp.Velocity = vel
                end
            end)
            Rayfield:Notify({Title = "FLING", Content = "Подходи вплотную к игрокам, чтобы их выкинуло!", Duration = 5})
        end
    end,
})

-- ==========================================
-- 👁 ВИЗУАЛЫ (CHAMS & ESP)
-- ==========================================
local function ApplyChams(target)
    if not target.Character then return end
    local h = target.Character:FindFirstChild("ZorkiyHighlight") or Instance.new("Highlight", target.Character)
    h.Name = "ZorkiyHighlight"
    h.FillColor = Color3.fromRGB(255, 0, 0)
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.Enabled = Config.Chams
end

VisualsTab:CreateToggle({Name = "Чамсы (Подсветка тел)", CurrentValue = false, Callback = function(v) 
    Config.Chams = v 
    for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player then ApplyChams(p) end end
end})

VisualsTab:CreateToggle({Name = "Неоновый ESP (Боксы)", CurrentValue = false, Callback = function(v) Config.ESPActive = v end})

VisualsTab:CreateSlider({Name = "iPad View (Растяг)", Range = {0.5, 1.5}, Increment = 0.05, CurrentValue = 1.0, Callback = function(v) 
    Config.ResValue = v
    if _G.ResCon then _G.ResCon:Disconnect() end
    _G.ResCon = RunService.RenderStepped:Connect(function()
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, Config.ResValue, 0, 0, 0, 1)
    end)
end})

-- ==========================================
-- 🏃 ДВИЖЕНИЕ
-- ==========================================
MovementTab:CreateSlider({Name = "Скорость бега", Range = {16, 500}, Increment = 5, CurrentValue = 16, Callback = function(v) Config.WalkSpeed = v end})
MovementTab:CreateToggle({Name = "Ноуклип (Сквозь стены)", CurrentValue = false, Callback = function(v) Config.Noclip = v end})

RunService.Stepped:Connect(function()
    pcall(function()
        Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        if Config.Noclip then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- ==========================================
-- ⚡ ОПТИМИЗАЦИЯ
-- ==========================================
BoostTab:CreateButton({Name = "УЛЬТРА БУСТ 120 ФПС", Callback = function()
    if setfpscap then setfpscap(120) end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = "SmoothPlastic"; v.CastShadow = false end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end})

-- ==========================================
-- ⚙️ НАСТРОЙКИ
-- ==========================================
SettingsTab:CreateButton({Name = "Копировать ТГ: t.me/ayqiz_news", Callback = function() setclipboard("t.me/ayqiz_news") end})
SettingsTab:CreateButton({Name = "⛔ ВЫКЛЮЧИТЬ СКРИПТ", Callback = function() Rayfield:Destroy() end})

Rayfield:Notify({Title = "ZORKIY V11", Content = "МОД АКТИВИРОВАН. УДАЧНОЙ ОХОТЫ.", Duration = 5})
