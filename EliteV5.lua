-- [Zorkiy prompt]: ELITE HYBRID BYPASS V5 (FINAL)
-- TG: t.me/ayqiz_news
-- Designed for Mobile & PC Executors.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🛡 ZORKIY ELITE V5 | HYBRID BYPASS",
   LoadingTitle = "Zorkiy Guard System",
   LoadingSubtitle = "by Zorkiy GPT",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ZorkiyConfigs",
      FileName = "EliteBypass"
   },
   KeySystem = false
})

local BypassTab = Window:CreateTab("🛡 Bypass Core", 4483362458)
local LogsTab = Window:CreateTab("📜 Guard Logs", 4483362458)
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

local Bypasses = {
    Adonis = true,
    Rost = true,
    KickBlock = true,
    BanBlock = true,
    LogSuppression = true
}

-- ФУНКЦИЯ ЛОГИРОВАНИЯ
local function AddLog(msg, type)
    local color = type == "Alert" and "!!!" or ">>>"
    local timestamp = os.date("%X")
    LogsTab:CreateLabel("[" .. timestamp .. "] " .. color .. " " .. msg)
    
    if type == "Alert" then
        Rayfield:Notify({
            Title = "GUARD PROTECTION",
            Content = msg,
            Duration = 5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Ок",
                    Callback = function() print("Zorkiy Guard: Ack") end
                },
            },
        })
    end
end

-- ==========================================
-- 🚀 ЯДРО ГИБРИДНОГО БАЙПАССА (АБСОЛЮТНАЯ ЗАЩИТА)
-- ==========================================

local function ActivateBypass()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    -- 1. УНИЧТОЖЕНИЕ ADONIS И ДРУГИХ (CLIENT-SIDE NUKER)
    task.spawn(function()
        while task.wait(5) do
            if Bypasses.Adonis then
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("LocalScript") or v:IsA("ModuleScript") then
                        local n = v.Name:lower()
                        if n:find("adonis") or n:find("anticheat") or n:find("cheat") or n:find("ac") then
                            v.Disabled = true
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end)

    -- 2. HOOKING NAMECALL (БЛОКИРОВКА ВЫЗОВОВ)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Bypasses.KickBlock and (method == "Kick" or method == "kick") then
            AddLog("ОТРАЖЕНА ПОПЫТКА КИКА! Причина: " .. tostring(args[1] or "No reason"), "Alert")
            return nil
        end

        if method == "FireServer" then
            local remoteName = tostring(self):lower()
            
            -- Блокировка репортов о бане/чит-детект
            if Bypasses.BanBlock and (remoteName:find("ban") or remoteName:find("flag") or remoteName:find("cheat") or remoteName:find("detect")) then
                AddLog("ПАКЕТ БАНА ЗАБЛОКИРОВАН: " .. remoteName, "Alert")
                return nil
            end

            -- Блокировка Adonis/Rost Alpha коммуникации
            if Bypasses.Rost and (remoteName:find("check") or remoteName:find("verify") or remoteName:find("alpha")) then
                AddLog("ПРОВЕРКА АНТИЧИТА (Rost/Adonis) ПОДАВЛЕНА", "Normal")
                return nil
            end
        end

        return oldNamecall(self, ...)
    end)

    -- 3. HOOKING INDEX (ПОДМЕНА СТАТОВ)
    mt.__index = newcclosure(function(self, index)
        if not checkcaller() then
            if index == "WalkSpeed" then return 16 end
            if index == "JumpPower" then return 50 end
            if index == "HipHeight" then return 0 end
        end
        return oldIndex(self, index)
    end)

    AddLog("ГИБРИДНОЕ ЯДРО БАЙПАССА ЗАПУЩЕНО ✅", "Normal")
end

-- ИНТЕРФЕЙС УПРАВЛЕНИЯ
BypassTab:CreateToggle({
   Name = "Absolute Kick/Ban Protection",
   CurrentValue = true,
   Flag = "KickBlock",
   Callback = function(Value) Bypasses.KickBlock = Value end,
})

BypassTab:CreateToggle({
   Name = "Adonis Anticheat Nuker",
   CurrentValue = true,
   Flag = "Adonis",
   Callback = function(Value) Bypasses.Adonis = Value end,
})

BypassTab:CreateToggle({
   Name = "Rost Alpha / Engine Bypass",
   CurrentValue = true,
   Flag = "Rost",
   Callback = function(Value) Bypasses.Rost = Value end,
})

BypassTab:CreateButton({
   Name = "FORCE RE-ACTIVATE BYPASS",
   Callback = function()
       ActivateBypass()
       Rayfield:Notify({Title = "SYSTEM", Content = "Bypass Core Re-synced", Duration = 2})
   end,
})

InfoTab:CreateLabel("Zorkiy Elite v5 - Ultimate Defense")
InfoTab:CreateLabel("TG: t.me/ayqiz_news")
InfoTab:CreateParagraph("How it works:", "This script hooks game engine metamethods to intercept and nullify Kick/Ban commands before they reach the server.")

ActivateBypass()
AddLog("Zorkiy Guard V5 Ready. Have a safe game.", "Normal")
