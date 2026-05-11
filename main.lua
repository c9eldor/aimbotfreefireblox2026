--// ========================================
--// C9ELDOR HUB - V1 HYPER-INSTANT (FINAL)
--// FIX: KILL DELAY | INSTANT RELOAD | NO-WALL
--// 2026 - PERFORMANCE SUPREMA
--// ========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// CONFIGURAÇÃO
local State = {
    aimbot = true,
    killAura = false,
    killAuraRange = 250, 
    espBox = true,
    espName = true,
    espLine = true,
    espRainbow = false,
    spinBot = false,
    spinSpeed = 150,
    infJump = false,
    speedActive = false, 
    speedValue = 100,    
    noclip = false,
    fovRadius = 150,
    fovVisible = true,
    Whitelist = {}
}

--// GUI
local Window = Rayfield:CreateWindow({
    Name = "c9eldor Hub v1",
    LoadingTitle = "Limpando Cache & Logs...",
    LoadingSubtitle = "by c9eldor",
    ConfigurationSaving = { Enabled = false }
})

local TabC = Window:CreateTab("Combate", "crosshair")
local TabV = Window:CreateTab("Visuals", "eye")
local TabP = Window:CreateTab("Player", "user")
local TabW = Window:CreateTab("Whitelist", "shield")

--// ABA COMBATE
TabC:CreateToggle({Name = "Aimbot", CurrentValue = true, Callback = function(v) State.aimbot = v end})
TabC:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) State.killAura = v end})
TabC:CreateSlider({Name = "Raio Kill", Range = {10, 1000}, Increment = 10, CurrentValue = 250, Callback = function(v) State.killAuraRange = v end})

TabC:CreateSection("Movimentação")
TabC:CreateToggle({Name = "Spinbot", CurrentValue = false, Callback = function(v) State.spinBot = v end})
TabC:CreateSlider({Name = "Velocidade Spin", Range = {10, 3000}, Increment = 50, CurrentValue = 150, Callback = function(v) State.spinSpeed = v end})

--// ABA VISUALS
TabV:CreateToggle({Name = "Rainbow Mode", CurrentValue = false, Callback = function(v) State.espRainbow = v end})
TabV:CreateToggle({Name = "Box ESP", CurrentValue = true, Callback = function(v) State.espBox = v end})
TabV:CreateToggle({Name = "Tracers", CurrentValue = true, Callback = function(v) State.espLine = v end})
TabV:CreateSection("FOV")
TabV:CreateToggle({Name = "Ver FOV", CurrentValue = true, Callback = function(v) State.fovVisible = v end})
TabV:CreateSlider({Name = "Raio FOV", Range = {50, 1000}, Increment = 10, CurrentValue = 150, Callback = function(v) State.fovRadius = v end})

--// ABA PLAYER
TabP:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(v) State.speedActive = v end})
TabP:CreateSlider({Name = "Velocidade", Range = {16, 500}, Increment = 1, CurrentValue = 100, Callback = function(v) State.speedValue = v end})
TabP:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.infJump = v end})
TabP:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) State.noclip = v end})

--// WHITELIST
local Dropdown = TabW:CreateDropdown({
    Name = "Whitelist",
    Options = {"Carregando..."},
    MultipleOptions = true,
    Callback = function(v) State.Whitelist = v end,
})

task.spawn(function()
    while task.wait(2) do
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end
        Dropdown:Refresh(names)
    end
end)

--// ENGINE
local FovCircle = Drawing.new("Circle")
FovCircle.Filled = false
FovCircle.Thickness = 1
FovCircle.Visible = true

local espCache = {}
local function RemoveESP(p)
    if espCache[p] then
        for _, obj in pairs(espCache[p]) do obj:Remove() end
        espCache[p] = nil
    end
end

--// FUNÇÃO DE DANO INSTANTÂNEO
local function Fire(target)
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local origin = char.HumanoidRootPart.Position
        
        -- Envia os pacotes sem yield (espera) para matar na hora
        ReplicatedStorage.Eventos.WeaponFired:FireServer(tool, {["id"] = math.random(1, 99999), ["charge"] = 0, ["origin"] = origin, ["dir"] = (head.Position - origin).Unit})
        
        -- Multi-hit agressivo para ignorar delay de HP do servidor
        for i = 1, 5 do 
            ReplicatedStorage.Eventos.WeaponHit:FireServer(tool, {["p"] = head.Position, ["pid"] = 1, ["part"] = head, ["d"] = (head.Position - origin).Magnitude, ["maxDist"] = 9999, ["h"] = head, ["sid"] = 100})
        end
    end
end

local function GetTarget(range, checkFOV)
    local target, dist = nil, range
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not table.find(State.Whitelist, p.Name) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            if checkFOV then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize/2).Magnitude
                if mag < dist then dist = mag target = p end
            else
                local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then dist = mag target = p end
            end
        end
    end
    return target
end

--// LOOP PRINCIPAL
local spinAngle = 0
RunService.RenderStepped:Connect(function()
    local rainbow = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    local curColor = State.espRainbow and rainbow or Color3.new(1,1,1)

    FovCircle.Visible = State.fovVisible
    FovCircle.Radius = State.fovRadius
    FovCircle.Position = Camera.ViewportSize/2
    FovCircle.Color = curColor

    if State.spinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        spinAngle = (spinAngle + State.spinSpeed/10) % 360
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.fromEulerAnglesXYZ(0, math.rad(spinAngle), 0)
    end

    if State.speedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = State.speedValue
    end

    if State.aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = GetTarget(State.fovRadius, true)
        if t then Fire(t) end
    end

    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or table.find(State.Whitelist, p.Name) then RemoveESP(p) continue end
        if not espCache[p] then
            espCache[p] = {box = Drawing.new("Square"), txt = Drawing.new("Text"), line = Drawing.new("Line")}
            espCache[p].box.Filled = false; espCache[p].box.Thickness = 1
            espCache[p].txt.Size = 14; espCache[p].txt.Outline = true; espCache[p].txt.Center = true
        end
        local d = espCache[p]
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local size = 2000/pos.Z
                d.box.Visible = State.espBox; d.box.Size = Vector2.new(size, size * 1.2); d.box.Position = Vector2.new(pos.X - d.box.Size.X/2, pos.Y - d.box.Size.Y/2); d.box.Color = curColor
                d.txt.Visible = State.espName; d.txt.Text = p.DisplayName; d.txt.Position = Vector2.new(pos.X, pos.Y - d.box.Size.Y/2 - 20); d.txt.Color = curColor
                d.line.Visible = State.espLine; d.line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); d.line.To = Vector2.new(pos.X, pos.Y + d.box.Size.Y/2); d.line.Color = curColor
            else d.box.Visible = false; d.txt.Visible = false; d.line.Visible = false end
        else d.box.Visible = false; d.txt.Visible = false; d.line.Visible = false end
    end
end)

--// LOOP DE KILL AURA ULTRA RÁPIDO
task.spawn(function()
    while true do
        if State.killAura then
            local t = GetTarget(State.killAuraRange, false)
            if t then Fire(t) end
        end
        if State.noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        task.wait(0.01) -- DELAY MÍNIMO (QUASE INSTANTÂNEO)
    end
end)

UserInputService.JumpRequest:Connect(function() if State.infJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
Players.PlayerRemoving:Connect(RemoveESP)

Rayfield:Notify({Title = "V1", Content = "Delay removido.", Duration = 5})
