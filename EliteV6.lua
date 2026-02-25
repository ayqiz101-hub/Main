-- [[ ZORKIY ELITE V6: FINAL EDITION ]]
-- Created by Ayqiz
-- TG: t.me/ayqiz_news

if _G.ZorkiyLoaded then return end
_G.ZorkiyLoaded = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZORKIY ELITE V6 | NEON RED",
   LoadingTitle = "FINAL VERSION",
   LoadingSubtitle = "by Ayqiz",
   ConfigurationSaving = {Enabled = true, FolderName = "ZorkiyConfigs", FileName = "EliteV6"},
   KeySystem = false
})

local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    Lang = "EN", -- RU / EN
    AimActive = false, AimFOV = 150, SilentAim = false,
    ESPActive = false, Chams = false,
    ResValue = 1.0, WalkSpeed = 16, JumpPower = 50, Gravity = 196.2,
    NoclipActive = false, AutoClicker = false, KillAura = false
}

-- ПЕРЕВОДЫ
local T = {
    EN = {Combat = "Combat", Visuals = "Visuals", Movement = "Movement", Game = "Game", Boost = "Performance", Settings = "Settings", Stop = "STOP SCRIPT", TG = "Telegram Channel"},
    RU = {Combat = "Бой", Visuals = "Визуалы", Movement = "Движение", Game = "Игра", Boost = "Буст ФПС", Settings = "Настройки", Stop = "ОСТАНОВИТЬ СКРИПТ", TG = "Телеграм Канал"}
}

local CombatTab = Window:CreateTab(T.EN.Combat)
local GameTab = Window:CreateTab(T.EN.Game)
local VisualsTab = Window:CreateTab(T.EN.Visuals)
local MovementTab = Window:CreateTab(T.EN.Movement)
local BoostTab = Window:CreateTab(T.EN.Boost)
local SettingsTab = Window:CreateTab(T.EN.Settings)

-- SETTINGS & UTILS
SettingsTab:CreateButton({
    Name = "Switch Language: RU / EN",
    Callback = function()
        Config.Lang = (Config.Lang == "EN") and "RU" or "EN"
        Rayfield:Notify({Title = "Language", Content = "Language changed to: " .. Config.Lang, Duration = 3})
    end,
})

SettingsTab:CreateButton({
    Name = "Copy Telegram: t.me/ayqiz_news",
    Callback = function()
        setclipboard("https://t.me/ayqiz_news")
        Rayfield:Notify({Title = "Telegram", Content = "Link copied to clipboard!", Duration = 3})
    end,
})

-- КНОПКА ПОЛНОЙ ОСТАНОВКИ
SettingsTab:CreateButton({
    Name = "⛔ STOP & UNLOAD SCRIPT",
    Callback = function()
        _G.ZorkiyLoaded = false
        Config.ESPActive = false
        Config.AimActive = false
        if _G.ResCon then _G.ResCon:Disconnect() end
        workspace.Gravity = 196.2
        Player.Character.Humanoid.WalkSpeed = 16
        Rayfield:Destroy()
    end,
})

-- COMBAT
CombatTab:CreateToggle({
    Name = "Kill Aura (Auto Attack)",
    CurrentValue = false,
    Callback = function(v) Config.KillAura = v end,
})

task.spawn(function()
    while task.wait(0.2) do
        if not _G.ZorkiyLoaded then break end
        if Config.KillAura then
            pcall(function()
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (Player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if d < 20 then
                            local tool = Player.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end)
        end
    end
end)

-- GAMEPASS CRACK
GameTab:CreateButton({
    Name = "Crack All Gamepasses (God Mode)",
    Callback = function()
        local mps = game:GetService("MarketplaceService")
        local old; old = hookfunction(mps.UserOwnsGamePassAsync, function(self, id, gid) return true end)
        local old2; old2 = hookfunction(mps.PlayerOwnsAsset, function(self, p, id) return true end)
        Rayfield:Notify({Title = "Crack", Content = "All Gamepasses unlocked locally!", Duration = 5})
    end,
})

GameTab:CreateToggle({Name = "Auto-Clicker", CurrentValue = false, Callback = function(v) Config.AutoClicker = v end})

-- VISUALS (NEON RED)
VisualsTab:CreateToggle({
    Name = "Neon Red ESP Boxes",
    CurrentValue = false,
    Callback = function(v) Config.ESPActive = v end,
})

local function CreateESP(target)
    local Box = Drawing.new("Square")
    Box.Visible = false; Box.Color = Color3.fromRGB(255, 0, 0); Box.Thickness = 2
    RunService.RenderStepped:Connect(function()
        if Config.ESPActive and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            if onScreen then
                local s = 2000 / pos.Z
                Box.Size = Vector2.new(s, s * 1.5)
                Box.Position = Vector2.new(pos.X - Box.Size.X/2, pos.Y - Box.Size.Y/2)
                Box.Visible = true
            else Box.Visible = false end
        else Box.Visible = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then CreateESP(v) end end

VisualsTab:CreateSlider({
    Name = "iPad View (Stretch)",
    Range = {0.5, 1.5},
    Increment = 0.05,
    CurrentValue = 1.0,
    Callback = function(v) 
        Config.ResValue = v
        if _G.ResCon then _G.ResCon:Disconnect() end
        _G.ResCon = RunService.RenderStepped:Connect(function()
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, Config.ResValue, 0, 0, 0, 1)
        end)
    end,
})

-- MOVEMENT
MovementTab:CreateSlider({Name = "WalkSpeed", Range = {16, 500}, Increment = 5, CurrentValue = 16, Callback = function(v) Config.WalkSpeed = v end})
MovementTab:CreateSlider({Name = "Gravity Control", Range = {0, 500}, Increment = 10, CurrentValue = 196, Callback = function(v) workspace.Gravity = v end})
MovementTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) Config.NoclipActive = v end})

RunService.Stepped:Connect(function()
    if not _G.ZorkiyLoaded then return end
    pcall(function()
        Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        if Config.NoclipActive then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- PERFORMANCE
BoostTab:CreateButton({
    Name = "Ultimate 120 FPS Boost",
    Callback = function()
        if setfpscap then setfpscap(120) end
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = "SmoothPlastic" v.CastShadow = false end
            if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        end
    end,
})

-- BYPASS
local mt = getrawmetatable(game); setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if not _G.ZorkiyLoaded then return old(self, ...) end
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then return nil end
    return old(self, ...)
end)

Rayfield:Notify({Title = "ZORKIY V6", Content = "Script Loaded Successfully", Duration = 5})
