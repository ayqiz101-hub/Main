-- [[ ZORKIY ELITE V12: MOBILE GOD MODE ]]
-- Optimized for Mobile Executors (Delta, Fluxus, etc.)
-- TG: t.me/ayqiz_news

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZORKIY ELITE V6 | MOBILE",
   LoadingTitle = "SCRIPT LOADED",
   LoadingSubtitle = "by Ayqiz",
   ConfigurationSaving = {Enabled = true, FolderName = "ZorkiyConfigs", FileName = "EliteV6"},
   KeySystem = false
})

local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local Config = {
    AimActive = false, AimSmooth = 1, AimFOV = 150,
    ESPActive = false, ChamsActive = false,
    FlingActive = false,
    ResValue = 1.0, WalkSpeed = 16,
    Noclip = false
}

-- ВКЛАДКИ
local CombatTab = Window:CreateTab("🎯 Бой")
local VisualsTab = Window:CreateTab("👁 Визуалы")
local MovementTab = Window:CreateTab("🏃 Движение")
local SettingsTab = Window:CreateTab("⚙️ Настройки")

-- ==========================================
-- 🎯 MOBILE AIMBOT (AUTO-LOCK)
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
    if Config.AimActive then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

CombatTab:CreateToggle({Name = "Авто-Аим (Захват цели)", CurrentValue = false, Callback = function(v) Config.AimActive = v; FOVring.Visible = v end})
CombatTab:CreateSlider({Name = "Радиус Аима (FOV)", Range = {50, 500}, Increment = 10, CurrentValue = 150, Callback = function(v) Config.AimFOV = v end})

-- ==========================================
-- 🌪 FLING (УБИЙСТВО ТИПОВ)
-- ==========================================
CombatTab:CreateToggle({
    Name = "ФЛИНГ (Убивать при касании)",
    CurrentValue = false,
    Callback = function(v)
        Config.FlingActive = v
        if v then
            task.spawn(function()
                while Config.FlingActive do
                    RunService.Heartbeat:Wait()
                    local hrp = Player.Character.HumanoidRootPart
                    hrp.Velocity = Vector3.new(0, 10000, 0)
                    hrp.RotVelocity = Vector3.new(10000, 10000, 10000)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

-- ==========================================
-- 👁 ВИЗУАЛЫ (REAL CHAMS)
-- ==========================================
local function UpdateChams()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local highlight = p.Character:FindFirstChild("AyqizChams")
            if Config.ChamsActive then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "AyqizChams"
                end
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillOpacity = 0.5
                highlight.Enabled = true
            elseif highlight then
                highlight.Enabled = false
            end
        end
    end
end

VisualsTab:CreateToggle({Name = "НЕОНОВЫЕ ЧАМСЫ (Силуэты)", CurrentValue = false, Callback = function(v) 
    Config.ChamsActive = v 
    UpdateChams()
end})

VisualsTab:CreateSlider({Name = "iPad View (Растяг)", Range = {0.5, 1.5}, Increment = 0.05, CurrentValue = 1.0, Callback = function(v) 
    Config.ResValue = v
    if _G.ResCon then _G.ResCon:Disconnect() end
    _G.ResCon = RunService.RenderStepped:Connect(function()
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, Config.ResValue, 0, 0, 0, 1)
    end)
end})

-- ==========================================
-- 🏃 ДВИЖЕНИЕ & PERFORMANCE
-- ==========================================
MovementTab:CreateSlider({Name = "Скорость", Range = {16, 300}, Increment = 5, CurrentValue = 16, Callback = function(v) Config.WalkSpeed = v end})
MovementTab:CreateButton({Name = "БУСТ 120 ФПС", Callback = function()
    if setfpscap then setfpscap(120) end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = "SmoothPlastic"; v.CastShadow = false end
    end
end})

-- ==========================================
-- ⚙️ НАСТРОЙКИ
-- ==========================================
SettingsTab:CreateButton({Name = "Телеграм: t.me/ayqiz_news", Callback = function() setclipboard("https://t.me/ayqiz_news") end})
SettingsTab:CreateButton({Name = "⛔ ОСТАНОВИТЬ СКРИПТ", Callback = function() Rayfield:Destroy() end})

game.Players.PlayerAdded:Connect(function() if Config.ChamsActive then task.wait(1) UpdateChams() end end)
RunService.Stepped:Connect(function() pcall(function() Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed end) end)

Rayfield:Notify({Title = "ZORKIY V6 MOBILE", Content = "Mobile Script", Duration = 5})
