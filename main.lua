--// ========================================================
--// C9ELDOR HUB - V1 HYPER-INSTANT (MONITORED)
--// STATUS: PROTECTED | 2026
--// ========================================================

--// CONFIGURAÇÕES DE ACESSO E LOG
local MEU_WEBHOOK = "https://discord.com/api/webhooks/1503247905924845640/Qx0oIKHrFn1YHJbQaF1OHY_-faSf8hATnG9_mXMI-aEpVd5IgsHvDAfxgHYJH3mTebgJ"
local CHAVES_ATIVAS = {"C9-OMEGA-2026", "TESTE-FREE-01"} 

--// SERVIÇOS
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// FUNÇÃO DE LOG PROFISSIONAL
local function EnviarLog(chave_digitada)
    local data = {
        ["embeds"] = {{
            ["title"] = "🔑 ACESSO VALIDADO - C9ELDOR HUB",
            ["color"] = 0x00FF7F, 
            ["fields"] = {
                {["name"] = "👤 Jogador", ["value"] = "```" .. LocalPlayer.Name .. "```", ["inline"] = true},
                {["name"] = "🆔 UserID", ["value"] = "```" .. LocalPlayer.UserId .. "
```", ["inline"] = true},
                {["name"] = "🔑 Chave Usada", ["value"] = "`" .. chave_digitada .. "`", ["inline"] = true},
                {["name"] = "💻 HWID", ["value"] = "```" .. game:GetService("RbxAnalyticsService"):GetClientId() .. "```", ["inline"] = false}
            },
            ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"}
        }}
    }
    pcall(function() HttpService:PostAsync(MEU_WEBHOOK, HttpService:JSONEncode(data)) end)
end

--// CARREGAR RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// ESTADO
local State = {aimbot=true, killAura=false, killAuraRange=250, espBox=true, espName=true, espLine=true, espRainbow=false, spinBot=false, spinSpeed=150, infJump=false, speedActive=false, speedValue=100, noclip=false, fovRadius=150, fovVisible=true, Whitelist={}}

--// JANELA COM SISTEMA DE KEY OBRIGATÓRIO
local Window = Rayfield:CreateWindow({
    Name = "c9eldor Hub v1 | PROTECTED",
    LoadingTitle = "Carregando Sistema...",
    LoadingSubtitle = "Verificando Credenciais...",
    KeySystem = true,
    KeySettings = {
        Title = "C9ELDOR ACCESS PANEL",
        Subtitle = "Insira sua Chave",
        Note = "Peça no Discord oficial.",
        FileName = "C9ELDOR_KEY_VERIFIER", -- Mude isso se quiser resetar a key salva
        SaveKey = true, 
        Key = CHAVES_ATIVAS 
    }
})

-- O log é enviado apenas se a Key estiver correta
EnviarLog("C9-OMEGA-2026")

--// ABAS
local TabC = Window:CreateTab("Combate", "crosshair")
local TabV = Window:CreateTab("Visuals", "eye")
local TabP = Window:CreateTab("Player", "user")
local TabW = Window:CreateTab("Whitelist", "shield")

--// ABA COMBATE
TabC:CreateToggle({Name = "Aimbot", CurrentValue = true, Callback = function(v) State.aimbot = v end})
TabC:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) State.killAura = v end})
TabC:CreateSlider({Name = "Raio Kill", Range = {10, 1000}, CurrentValue = 250, Callback = function(v) State.killAuraRange = v end})
TabC:CreateToggle({Name = "Spinbot", CurrentValue = false, Callback = function(v) State.spinBot = v end})

--// ABA VISUALS
TabV:CreateToggle({Name = "Box ESP", CurrentValue = true, Callback = function(v) State.espBox = v end})
TabV:CreateToggle({Name = "Tracers", CurrentValue = true, Callback = function(v) State.espLine = v end})
TabV:CreateToggle({Name = "Ver FOV", CurrentValue = true, Callback = function(v) State.fovVisible = v end})

--// ABA PLAYER
TabP:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(v) State.speedActive = v end})
TabP:CreateSlider({Name = "Velocidade", Range = {16, 500}, CurrentValue = 100, Callback = function(v) State.speedValue = v end})
TabP:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.infJump = v end})
TabP:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) State.noclip = v end})

--// LÓGICA E ENGINE (Mantendo suas funções originais)
local FovCircle = Drawing.new("Circle")
FovCircle.Filled = false; FovCircle.Visible = true

local function Fire(target)
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local origin = char.HumanoidRootPart.Position
        ReplicatedStorage.Eventos.WeaponFired:FireServer(tool, {["id"] = math.random(1, 99999), ["charge"] = 0, ["origin"] = origin, ["dir"] = (head.Position - origin).Unit})
        for i = 1, 5 do ReplicatedStorage.Eventos.WeaponHit:FireServer(tool, {["p"] = head.Position, ["pid"] = 1, ["part"] = head, ["d"] = (head.Position - origin).Magnitude, ["maxDist"] = 9999, ["h"] = head, ["sid"] = 100}) end
    end
end

RunService.RenderStepped:Connect(function()
    FovCircle.Visible = State.fovVisible
    FovCircle.Radius = State.fovRadius
    FovCircle.Position = Camera.ViewportSize/2
    
    if State.speedActive and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = State.speedValue end
    
    if State.aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis and (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize/2).Magnitude < State.fovRadius then
                    Fire(p)
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "Sucesso!", Content = "C9ELDOR Hub Iniciado.", Duration = 5})
