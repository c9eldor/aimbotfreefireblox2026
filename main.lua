--// ========================================================
--// C9ELDOR HUB - V3.1 ULTRA (WEBHOOK & KEY FIXED)
--// STATUS: 100% OPERACIONAL | 2026
--// ========================================================

--// [ CONFIGURAÇÕES TÉCNICAS ]
local CONFIG = {
    -- Trocado para Lewisakura Proxy (Mais estável que Hyra no momento)
    Webhook = "https://webhook.lewisakura.moe/api/webhooks/1503247905924845640/Qx0oIKHrFn1YHJbQaF1OHY_-faSf8hATnG9_mXMI-aEpVd5IgsHvDAfxgHYJH3mTebgJ",
    Keys = {"C9-OMEGA-2026", "TESTE-FREE-01"},
    Icon = "rbxassetid://139699508645438"
}

--// [ SERVIÇOS DO SISTEMA ]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// [ FUNÇÃO DE LOGS (DISCORD) ]
local function EnviarLog(chave_usada)
    local executor = (identifyexecutor and identifyexecutor()) or "Desconhecido"
    local gameName = "Desconhecido"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    
    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 C9ELDOR HUB - ACESSO CONFIRMADO",
            ["description"] = "Um utilizador validou o acesso com sucesso.",
            ["color"] = 65450, -- Verde Neon
            ["fields"] = {
                {["name"] = "👤 Utilizador", ["value"] = "```" .. LocalPlayer.Name .. "```", ["inline"] = true},
                {["name"] = "🆔 UserID", ["value"] = "```" .. tostring(LocalPlayer.UserId) .. "```", ["inline"] = true},
                {["name"] = "🔑 Chave Utilizada", ["value"] = "`" .. chave_usada .. "`", ["inline"] = true},
                {["name"] = "⚙️ Executor", ["value"] = "```" .. executor .. "```", ["inline"] = false},
                {["name"] = "🎮 Jogo Atual", ["value"] = "```" .. gameName .. "```", ["inline"] = false}
            },
            ["footer"] = {["text"] = "C9ELDOR Security System 2026 • " .. os.date("%X")},
            ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"}
        }}
    }
    
    -- Envio com Headers para evitar bloqueios de formato
    task.spawn(function()
        pcall(function()
            HttpService:PostAsync(
                CONFIG.Webhook, 
                HttpService:JSONEncode(data), 
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end)
end

--// [ CARREGAR INTERFACE RAYFIELD ]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// [ ESTADO GLOBAL DO SCRIPT ]
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

--// [ CRIAÇÃO DA JANELA ]
local Window = Rayfield:CreateWindow({
    Name = "c9eldor Hub v2 | PROTECTED",
    LoadingTitle = "CARREGANDO C9ELDOR HUB...",
    LoadingSubtitle = "Verificando Credenciais 2026...",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "C9ELDOR ACCESS PANEL",
        Subtitle = "Sistema de Licenciamento",
        Note = "Insira a sua chave para continuar.",
        FileName = "C9ELDOR_HUB_TEMP", -- Nome do ficheiro temporário
        SaveKey = false, -- NÃO SALVAR PARA PEDIR SEMPRE
        GrabKeyFromSite = false, 
        Key = CONFIG.Keys 
    }
})

-- Dispara o log após a autenticação
EnviarLog("LOGIN_EFETUADO")

--// [ ABAS ]
local TabC = Window:CreateTab("Combate", "crosshair")
local TabV = Window:CreateTab("Visuals", "eye")
local TabP = Window:CreateTab("Player", "user")
local TabW = Window:CreateTab("Whitelist", "shield")

-- [ COMBATE ]
TabC:CreateToggle({Name = "Aimbot (Auto-Target)", CurrentValue = true, Callback = function(v) State.aimbot = v end})
TabC:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) State.killAura = v end})
TabC:CreateSlider({Name = "Alcance Kill Aura", Range = {10, 1000}, Increment = 10, CurrentValue = 250, Callback = function(v) State.killAuraRange = v end})
TabC:CreateSection("Movimentos")
TabC:CreateToggle({Name = "Spinbot", CurrentValue = false, Callback = function(v) State.spinBot = v end})
TabC:CreateSlider({Name = "Velocidade Spin", Range = {10, 3000}, Increment = 50, CurrentValue = 150, Callback = function(v) State.spinSpeed = v end})

-- [ VISUAIS ]
TabV:CreateToggle({Name = "Arco-Íris (Rainbow)", CurrentValue = false, Callback = function(v) State.espRainbow = v end})
TabV:CreateToggle({Name = "Box ESP", CurrentValue = true, Callback = function(v) State.espBox = v end})
TabV:CreateToggle({Name = "Tracers", CurrentValue = true, Callback = function(v) State.espLine = v end})
TabV:CreateSection("FOV")
TabV:CreateToggle({Name = "Exibir FOV", CurrentValue = true, Callback = function(v) State.fovVisible = v end})
TabV:CreateSlider({Name = "Tamanho FOV", Range = {50, 1000}, Increment = 5, CurrentValue = 150, Callback = function(v) State.fovRadius = v end})

-- [ PLAYER ]
TabP:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(v) State.speedActive = v end})
TabP:CreateSlider({Name = "Velocidade", Range = {16, 500}, Increment = 1, CurrentValue = 100, Callback = function(v) State.speedValue = v end})
TabP:CreateToggle({Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) State.infJump = v end})
TabP:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) State.noclip = v end})

-- [ WHITELIST ]
local Dropdown = TabW:CreateDropdown({
    Name = "Ignorar Jogador",
    Options = {"A carregar..."},
    MultipleOptions = true,
    Callback = function(v) State.Whitelist = v end,
})
task.spawn(function()
    while task.wait(3) do
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end
        Dropdown:Refresh(names)
    end
end)

--// [ SISTEMA DE COMBATE ]
local function Fire(target)
    pcall(function()
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local origin = char.HumanoidRootPart.Position
            ReplicatedStorage.Eventos.WeaponFired:FireServer(tool, {["id"] = math.random(1, 9999), ["charge"] = 0, ["origin"] = origin, ["dir"] = (head.Position - origin).Unit})
            for i = 1, 5 do 
                ReplicatedStorage.Eventos.WeaponHit:FireServer(tool, {["p"] = head.Position, ["part"] = head, ["d"] = (head.Position - origin).Magnitude, ["h"] = head})
            end
        end
    end)
end

local function GetTarget(range, checkFOV)
    local target, dist = nil, range
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not table.find(State.Whitelist, p.Name) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            if checkFOV then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize/2).Magnitude
                if vis and mag < dist then dist = mag target = p end
            else
                local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then dist = mag target = p end
            end
        end
    end
    return target
end

--// [ RENDERIZAÇÃO ]
local FovCircle = Drawing.new("Circle")
FovCircle.Filled = false; FovCircle.Thickness = 1

local espCache = {}
local function RemoveESP(p)
    if espCache[p] then
        for _, obj in pairs(espCache[p]) do obj:Remove() end
        espCache[p] = nil
    end
end

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
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
    end

    if State.speedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = State.speedValue
    end

    if State.aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = GetTarget(State.fovRadius, true)
        if t then Fire(t) end
    end

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

task.spawn(function()
    while true do
        if State.killAura then
            local t = GetTarget(State.killAuraRange, false)
            if t then Fire(t) end
        end
        if State.noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        task.wait(0.1) 
    end
end)

UserInputService.JumpRequest:Connect(function() 
    if State.infJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end 
end)

Players.PlayerRemoving:Connect(RemoveESP)

Rayfield:Notify({
    Title = "C9ELDOR HUB V3",
    Content = "Script carregado. Key Reset Ativo.",
    Duration = 5,
    Image = CONFIG.Icon,
})
