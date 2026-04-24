--[[ 
    XIT MENU V5.5 - ANIMATED BACKGROUND EDITION
    Executor: Xeno & Others
    Atalhos: Q (Teleport) | F (Fly) | N (Noclip)
--]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local posicaoSalva = nil
local flying, speedActive, noclipActive = false, false, false
local flySpeed, walkSpeedValue = 60, 200

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "XIT_MENU_ANIMATED"

-- Janela Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Size = UDim2.new(0, 300, 0, 520)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true -- Garante que a animação não saia da borda
Instance.new("UICorner", MainFrame)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(200, 0, 0)
Stroke.Thickness = 4

-- FUNDO ANIMADO (Efeito de Partículas Flutuantes)
local AnimContainer = Instance.new("Frame", MainFrame)
AnimContainer.Size = UDim2.new(1, 0, 1, 0)
AnimContainer.BackgroundTransparency = 1

local function CreateParticle()
    local p = Instance.new("Frame", AnimContainer)
    local size = math.random(2, 5)
    p.Size = UDim2.new(0, size, 0, size)
    p.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    p.BackgroundTransparency = 0.6
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
    
    local speedX = math.random(-50, 50) / 1000
    local speedY = math.random(-50, 50) / 1000
    
    RunService.RenderStepped:Connect(function()
        if MainFrame.Visible then
            local newX = p.Position.X.Scale + speedX
            local newY = p.Position.Y.Scale + speedY
            
            if newX > 1 then newX = 0 elseif newX < 0 then newX = 1 end
            if newY > 1 then newY = 0 elseif newY < 0 then newY = 1 end
            
            p.Position = UDim2.new(newX, 0, newY, 0)
        end
    end)
end

for i = 1, 15 do CreateParticle() end -- Cria 15 partículas

-- [RESTAURANDO BOTÕES E LÓGICA DO V5.4]
-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "SeloreV1"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundTransparency = 1
Title.TextSize = 26
Title.ZIndex = 2 -- Fica por cima da animação

-- Funções de Botão XL
local function CreateBtn(name, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 260, 0, 55)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    return btn
end

local SalvarBtn = CreateBtn("SALVAR POSIÇÃO", UDim2.new(0.07, 0, 0.15, 0), Color3.fromRGB(30, 30, 35))
local TeleBtn = CreateBtn("TELEPORTAR (Q)", UDim2.new(0.07, 0, 0.28, 0), Color3.fromRGB(150, 0, 0))
local SpeedBtn = CreateBtn("SPEED: OFF", UDim2.new(0.07, 0, 0.45, 0), Color3.fromRGB(30, 30, 35))
local FlyBtn = CreateBtn("FLY: OFF (F)", UDim2.new(0.07, 0, 0.60, 0), Color3.fromRGB(30, 30, 35))
local NoclipBtn = CreateBtn("NOCLIP: OFF (N)", UDim2.new(0.07, 0, 0.75, 0), Color3.fromRGB(30, 30, 35))

-- Lógica Noclip
RunService.Stepped:Connect(function()
    if noclipActive and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Eventos de Clique
SalvarBtn.MouseButton1Click:Connect(function() if player.Character:FindFirstChild("HumanoidRootPart") then posicaoSalva = player.Character.HumanoidRootPart.CFrame end end)
TeleBtn.MouseButton1Click:Connect(function() if posicaoSalva then player.Character.HumanoidRootPart.CFrame = posicaoSalva end end)
SpeedBtn.MouseButton1Click:Connect(function() 
    speedActive = not speedActive 
    SpeedBtn.Text = speedActive and "SPEED: ON" or "SPEED: OFF"
    SpeedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 35)
end)

-- Atalhos de Teclado
UserInputService.InputBegan:Connect(function(i, p)
    if not p then
        if i.KeyCode == Enum.KeyCode.Q then if posicaoSalva then player.Character.HumanoidRootPart.CFrame = posicaoSalva end
        elseif i.KeyCode == Enum.KeyCode.F then -- Lógica Fly Simplificada
            flying = not flying
            FlyBtn.Text = flying and "FLY: ON" or "FLY: OFF (F)"
            FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 35)
        elseif i.KeyCode == Enum.KeyCode.N then
            noclipActive = not noclipActive
            NoclipBtn.Text = noclipActive and "NOCLIP: ON" or "NOCLIP: OFF (N)"
            NoclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 35)
        end
    end
end)

-- Fechar e Minimizar (Gatinho)
local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(0.84, 0, 0.02, 0)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
Close.TextColor3 = Color3.new(1, 0, 0)
Close.ZIndex = 3
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
