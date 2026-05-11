--// ========================================================
--// C9ELDOR HUB - V1 HYPER-INSTANT (MONITORED)
--// STATUS: PROTECTED | 2026
--// ========================================================

--// CONFIGURAÇÕES DE ACESSO E LOG
local MEU_WEBHOOK = "https://discord.com/api/webhooks/1503247905924845640/Qx0oIKHrFn1YHJbQaF1OHY_-faSf8hATnG9_mXMI-aEpVd5IgsHvDAfxgHYJH3mTebgJ"
local CHAVES_ATIVAS = {"C9-OMEGA-2026", "TESTE-FREE-01"} 

--// SERVIÇOS DO ROBLOX
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// FUNÇÃO DE LOG PROFISSIONAL (DISCORD)
local function EnviarLog(chave_digitada)
    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 NOVO ACESSO DETECTADO - C9ELDOR",
            ["description"] = "O script foi ativado com sucesso após a verificação.",
            ["color"] = 0x00FF7F, 
            ["fields"] = {
                {["name"] = "👤 Jogador", ["value"] = "```" .. LocalPlayer.Name .. "```", ["inline"] = true},
                {["name"] = "🆔 UserID", ["value"] = "```" .. LocalPlayer.UserId .. "
```", ["inline"] = true},
                {["name"] = "🔑 Chave Usada", ["value"] = "`" .. chave_digitada .. "`", ["inline"] = true},
                {["name"] = "💻 HWID", ["value"] = "```" .. game:GetService("RbxAnalyticsService"):GetClientId() .. "```", ["inline"] = false},
                {["name"] = "🎮 Jogo", ["value"] = "`" .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "`", ["inline"] = false}
            },
            ["footer"] = {["text"] = "C9ELDOR Security System • " .. os.date("%X")},
            ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"}
        }}
    }
    pcall(function()
        HttpService:PostAsync(MEU_WEBHOOK, HttpService:JSONEncode(data))
    end)
end

--// CARREGAR INTERFACE RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// CONFIGURAÇÃO DE ESTADO (MEMÓRIA DAS FUNÇÕES)
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

--// CRIAÇÃO DA JANELA COM SISTEMA DE KEY
local Window = Rayfield:CreateWindow({
    Name = "c9eldor Hub v1 | PROTECTED",
    LoadingTitle = "FLUSHING CACHE & LOGS...",
    LoadingSubtitle = "Verificando Credenciais...",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "C9ELDOR ACCESS PANEL",
        Subtitle = "Sistema de Licenciamento 2026",
        Note = "Adquira sua chave no Discord oficial.",
        FileName = "C9ELDOR_KEY_VERIFIER", 
        SaveKey = true, 
        GrabKeyFromSite = false, 
        Key = CHAVES_ATIVAS 
    }
})

-- Dispara o log após passar pela key
EnviarLog("VALIDADA")

--// CRIAÇÃO DAS ABAS
local TabC = Window:CreateTab("Combate", "crosshair")
local TabV = Window:CreateTab("Visuals", "eye")
local TabP = Window:CreateTab("Player", "user")
local TabW = Window:CreateTab("Whitelist", "shield")

--// --- ABA COMBATE ---
TabC:CreateToggle({Name = "Aimbot", CurrentValue = true, Callback = function(v) State.aimbot = v end})
TabC:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) State.killAura = v end})
TabC:CreateSlider({Name = "Raio Kill", Range = {10, 1000}, Increment = 10, CurrentValue = 250, Callback = function(v) State.killAuraRange = v end})
TabC:CreateSection("Movimentação")
TabC:CreateToggle({Name = "Spinbot", CurrentValue = false, Callback = function(v) State.spinBot = v end})
TabC:CreateSlider({Name = "Velocidade Spin", Range = {10, 3000}, Increment = 50, CurrentValue = 150, Callback = function(v) State.spinSpeed = v end})

--// --- ABA VISUALS ---
TabV:CreateToggle({Name = "Rainbow Mode", CurrentValue = false, Callback = function(v) State.espRainbow = v end})
TabV:CreateToggle({Name = "Box ESP", CurrentValue = true, Callback = function(v) State.espBox = v end})
TabV:CreateToggle({Name = "Tracers (Lines)", CurrentValue = true, Callback = function(v) State.espLine = v end})
TabV:CreateSection("Config FOV")
TabV:CreateToggle({Name = "Ver Raio FOV", CurrentValue = true, Callback = function(v) State.fovVisible = v end})
TabV:CreateSlider({Name = "Tamanho FOV", Range = {50, 1000}, Increment = 10, CurrentValue = 150, Callback = function(v) State.fovRadius = v end})

--// --- ABA PLAYER ---
TabP:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(v) State.speedActive = v end})
TabP:CreateSlider({Name = "Velocidade", Range = {16, 500}, Increment = 1, CurrentValue = 100, Callback = function(v) State.speedValue = v end})
TabP:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.infJump = v end})
TabP:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) State.noclip = v end})

--// --- ABA WHITELIST ---
local Dropdown = TabW:CreateDropdown({
    Name = "Ignorar Jogadores",
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

--// --- ENGINE DE RENDERIZAÇÃO (ESP & FOV) ---
local FovCircle = Drawing.new("Circle")
FovCircle.Filled = false; FovCircle.Thickness = 1; FovCircle.Visible = true

local espCache = {}
local function RemoveESP(p)
    if espCache[p] then
        for _, obj in pairs(espCache[p]) do obj:Remove() end
        espCache[p] = nil
    end
end

--// LÓGICA DE TIRO (REMOTES)
local function Fire(target)
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local origin = char.HumanoidRootPart.Position
        pcall(function()
            ReplicatedStorage.Eventos.WeaponFired:FireServer(tool, {["id"] = math.random(1, 99999), ["charge"] = 0, ["origin"] = origin, ["dir"] = (head.Position - origin).Unit})
            for i = 1, 5 do 
                ReplicatedStorage.Eventos.WeaponHit:FireServer(tool, {["p"] = head.Position, ["pid"] = 1, ["part"] = head, ["d"] = (head.Position - origin).Magnitude, ["maxDist"] = 9999, ["h"] = head, ["sid"] = 100})
            end
        end)
    end
end

--// BUSCA DE ALVO MAIS PRÓXIMO
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

--// LOOP DE ATUALIZAÇÃO CONSTANTE (RENDER STEPPED)
local spinAngle = 0
RunService.RenderStepped:Connect(function()
    local rainbow = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    local curColor = State.espRainbow and rainbow or Color3.new(1,1,1)

    -- Atualizar FOV
    FovCircle.Visible = State.fovVisible
    FovCircle.Radius = State.fovRadius
    FovCircle.Position = Camera.ViewportSize/2
    FovCircle.Color = curColor

    -- Spinbot
    if State.spinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        spinAngle = (spinAngle + State.spinSpeed/10) % 360
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.fromEulerAnglesXYZ(0, math.rad(spinAngle), 0)
    end

    -- Speed Hack
    if State.speedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = State.speedValue
    end

    -- Aimbot (Executa ao segurar clique esquerdo)
    if State.aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = GetTarget(State.fovRadius, true)
        if t then Fire(t) end
    end

    -- ESP (Desenho das Caixas e Nomes)
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

--// LOOP DE SEGUNDO PLANO (KILL AURA & NOCLIP)
task.spawn(function()
    while true do
        if State.killAura then
            local t = GetTarget(State.killAuraRange, false)
            if t then Fire(t) end
        end
        if State.noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        task.wait(0.01) 
    end
end)

--// CONTROLES DE PULO INFINITO
UserInputService.JumpRequest:Connect(function() 
    if State.infJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end 
end)

--// LIMPEZA AO SAIR
Players.PlayerRemoving:Connect(RemoveESP)

--// NOTIFICAÇÃO DE INICIALIZAÇÃO
Rayfield:Notify({
    Title = "C9ELDOR HUB INICIADO",
    Content = "Tudo pronto, " .. LocalPlayer.Name .. "!",
    Duration = 5,
    Image = 139699508645438,
})
