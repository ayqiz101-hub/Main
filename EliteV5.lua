-- [[ ZORKIY ELITE V5: ULTIMATE EDITION ]]
-- Optimization: Tecno Pova 5 Pro 5G (Dimensity 6080)
-- Features: Hybrid Bypass, iPad View, 120 FPS Unlocker
-- TG: t.me/ayqiz_news

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🛡 ZORKIY ELITE | ULTIMATE V5",
   LoadingTitle = "Zorkiy Guard & Performance",
   LoadingSubtitle = "by Zorkiy GPT",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ZorkiyConfigs",
      FileName = "EliteUltimate"
   },
   KeySystem = false
})

-- ВКЛАДКИ
local BypassTab = Window:CreateTab("🛡 Bypass", 4483362458)
local VisualsTab = Window:CreateTab("👁 Visuals", 4483362458)
local BoostTab = Window:CreateTab("⚡ Performance", 4483362458)
local LogsTab = Window:CreateTab("📜 Guard Logs", 4483362458)

-- ПЕРЕМЕННЫЕ
local Camera = workspace.CurrentCamera
local ResValue = 1.0
local ResConnection
local Bypasses = {Adonis = true, Rost = true, KickBlock = true, BanBlock = true}

-- ФУНКЦИЯ ЛОГИРОВАНИЯ
local function AddLog(msg, type)
    local timestamp = os.date("%X")
    LogsTab:CreateLabel("[" .. timestamp .. "] " .. (type == "Alert" and "!!! " or ">>> ") .. msg)
    if type == "Alert" then
        Rayfield:Notify({Title = "GUARD PROTECTION", Content = msg, Duration = 4})
    end
end

-- ==========================================
-- 🚀 МОДУЛЬ 1: BYPASS CORE (АБСОЛЮТНАЯ ЗАЩИТА)
-- ==========================================
local function ActivateBypass()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    -- Удаление локальных античитов (Adonis/Rost)
    task.spawn(function()
        while task.wait(5) do
            if Bypasses.Adonis then
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("LocalScript") or v:IsA("ModuleScript") then
                        local n = v.Name:lower()
                        if n:find("adonis") or n:find("anti") or n:find("cheat") or n:find("ac") then
                            v.Disabled = true
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end)

    -- Блокировка методов Kick/FireServer
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if Bypasses.KickBlock and (method == "Kick" or method == "kick") then
            AddLog("ОТРАЖЕН КИК! (" .. tostring(args[1] or "No reason") .. ")", "Alert")
            return nil
        end
        if method == "FireServer" then
            local n = tostring(self):lower()
            if Bypasses.BanBlock and (n:find("ban") or n:find("flag") or n:find("check") or n:find("alpha")) then
                AddLog("ПОДАВЛЕН СИГНАЛ АНТИЧИТА: " .. n, "Alert")
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)

    -- Скрытие статов
    mt.__index = newcclosure(function(self, index)
        if not checkcaller() then
            if index == "WalkSpeed" then return 16 end
            if index == "JumpPower" then return 50 end
        end
        return oldIndex(self, index)
  end)
  AddLog("ГИБРИДНОЕ ЯДРО БАЙПАССА АКТИВИРОВАНО ✅", "Normal")
end

-- ==========================================
-- 👁 МОДУЛЬ 2: VISUALS (IPAD VIEW)
-- ==========================================
local function UpdateResolution()
    if ResConnection then ResConnection:Disconnect() end
    if ResValue == 1.0 then return end
    ResConnection = game:GetService("RunService").RenderStepped:Connect(function()
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, ResValue, 0, 0, 0, 1)
    end)
end

VisualsTab:CreateSlider({
    Name = "iPad View / Stretch Resolution",
    Range = {0.5, 1.5},
    Increment = 0.05,
    Suffix = "Res",
    CurrentValue = 1.0,
    Flag = "ResSlider",
    Callback = function(Value)
        ResValue = Value
        UpdateResolution()
    end,
})

VisualsTab:CreateButton({
    Name = "Reset Camera View",
    Callback = function()
        ResValue = 1.0
        UpdateResolution()
    end,
})

-- ==========================================
-- ⚡ МОДУЛЬ 3: PERFORMANCE (120 FPS BOOST)
-- ==========================================
local function BoostFPS()
    if setfpscap then setfpscap(120) end
    
    local l = game:GetService("Lighting")
    l.GlobalShadows = false
    l.FogEnd = 9e9
    settings().Rendering.QualityLevel = 1

    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
            if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        end
    end
    AddLog("ОПТИМИЗАЦИЯ ГРАФИКИ ВЫПОЛНЕНА ⚡", "Normal")
end

BoostTab:CreateButton({
    Name = "ACTIVATE 120 FPS BOOST",
    Callback = function()
        BoostFPS()
        Rayfield:Notify({Title = "Performance", Content = "FPS Unlocked & Graphics Cleaned!", Duration = 3})
    end,
})

BoostTab:CreateToggle({
    Name = "Potato Mode (Remove All Mesh)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("DataModelMesh") or v:IsA("CharacterMesh") then v:Destroy() end
            end
        end
    end,
})

-- НАСТРОЙКИ БАЙПАССА В МЕНЮ
BypassTab:CreateToggle({
    Name = "Enable Anti-Kick Protection",
    CurrentValue = true,
    Callback = function(Value) Bypasses.KickBlock = Value end,
})

BypassTab:CreateToggle({
    Name = "Destroy Local Anti-Cheats",
    CurrentValue = true,
    Callback = function(Value) Bypasses.Adonis = Value end,
})

-- ЗАПУСК
ActivateBypass()
AddLog("Zorkiy Elite Ultimate Loaded. Welcome, Creator.", "Normal")
