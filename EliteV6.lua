local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZORKIY ELITE V6 | GOOD SCRIPT",
   LoadingTitle = "NEON RED EDITION",
   LoadingSubtitle = "by Ayqiz",
   ConfigurationSaving = {Enabled = true, FolderName = "ZorkiyConfigs", FileName = "EliteV6"},
   KeySystem = true
})

local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    AimActive = false, AimSmooth = 1, AimFOV = 150, SilentAim = false,
    ESPActive = false, ESPNames = false, ESPTracers = false, Chams = false,
    HitboxSize = 2, KillAura = false,
    ResValue = 1.0, WalkSpeed = 16, JumpPower = 50, Gravity = 196.2,
    FlyActive = false, FlySpeed = 50, NoclipActive = false,
    Fullbright = false, AutoClicker = false
}

local CombatTab = Window:CreateTab("🎯 Combat")
local GameTab = Window:CreateTab("🎮 Game")
local VisualsTab = Window:CreateTab("👁 Visuals")
local MovementTab = Window:CreateTab("🏃 Movement")
local BoostTab = Window:CreateTab("⚡ Performance")

-- COMBAT & HITBOX
CombatTab:CreateToggle({Name = "Kill Aura (20m)", CurrentValue = false, Callback = function(v) Config.KillAura = v end})

task.spawn(function()
    while task.wait(0.1) do
        if Config.KillAura then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (Player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 20 then
                        -- Имитация удара (зависит от инструментов в плейсе)
                        local tool = Player.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
    end
end)

CombatTab:CreateSlider({Name = "Hitbox Expander (Reach)", Range = {2, 20}, Increment = 1, CurrentValue = 2, Callback = function(v)
    Config.HitboxSize = v
    task.spawn(function()
        while task.wait(1) do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(v, v, v)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end})

-- GAMEPASS SPOOF
GameTab:CreateButton({Name = "Unlock All Gamepasses (Local)", Callback = function()
    -- Попытка локального обхода проверки MarketplaceService
    local mps = game:GetService("MarketplaceService")
    local old; old = hookfunction(mps.UserOwnsGamePassAsync, function(self, id, gid)
        return true
    end)
    Rayfield:Notify({Title = "Success", Content = "Gamepasses Spoofed! Check Tools.", Duration = 5})
end})

GameTab:CreateToggle({Name = "Auto-Clicker", CurrentValue = false, Callback = function(v) Config.AutoClicker = v end})

-- VISUALS (NEON RED)
local function CreateESP(target)
    local Box = Drawing.new("Square")
    Box.Visible = false; Box.Color = Color3.fromRGB(255, 0, 0); Box.Thickness = 2
    
    RunService.RenderStepped:Connect(function()
        if Config.ESPActive and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            if onScreen then
                local size = 2000 / pos.Z
                Box.Size = Vector2.new(size, size * 1.5)
                Box.Position = Vector2.new(pos.X - Box.Size.X/2, pos.Y - Box.Size.Y/2)
                Box.Visible = true
            else Box.Visible = false end
        else Box.Visible = false end
    end)
end

for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then CreateESP(v) end end

VisualsTab:CreateToggle({Name = "Enable Neon Red ESP", CurrentValue = false, Callback = function(v) Config.ESPActive = v end})
VisualsTab:CreateToggle({Name = "Chams (Red Glow)", CurrentValue = false, Callback = function(v)
    Config.Chams = v
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character then
            if v then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "ZorkiyChams"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
                if p.Character:FindFirstChild("ZorkiyChams") then p.Character.ZorkiyChams:Destroy() end
            end
        end
    end
end})

VisualsTab:CreateSlider({Name = "iPad View", Range = {0.5, 1.5}, Increment = 0.05, CurrentValue = 1.0, Callback = function(v) 
    Config.ResValue = v
    if _G.ResCon then _G.ResCon:Disconnect() end
    _G.ResCon = RunService.RenderStepped:Connect(function()
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, Config.ResValue, 0, 0, 0, 1)
    end)
end})

-- MOVEMENT
MovementTab:CreateSlider({Name = "Speed", Range = {16, 500}, Increment = 5, CurrentValue = 16, Callback = function(v) Config.WalkSpeed = v end})
MovementTab:CreateSlider({Name = "Gravity Control", Range = {0, 500}, Increment = 10, CurrentValue = 196, Callback = function(v) workspace.Gravity = v end})
MovementTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) Config.NoclipActive = v end})

RunService.Stepped:Connect(function()
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
BoostTab:CreateButton({Name = "Mega FPS Boost", Callback = function()
    if setfpscap then setfpscap(120) end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = "SmoothPlastic" v.CastShadow = false end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end})

Rayfield:Notify({Title = "V9 GOD Loaded", Content = "Neon Red Edition Ready", Duration = 5})
