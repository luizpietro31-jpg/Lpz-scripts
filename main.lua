--====================================================--
-- LPZX DEVOURER V8 - VERSÃO COM CLIQUE CORRIGIDO
--====================================================--

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--====================================================--
-- DEVOURER CORE (Lógica original do spam)
--====================================================--

local function removeCloneAccessories(clone)
    for _, item in ipairs(clone:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Hat") then
            item:Destroy()
        end
    end
end

workspace.ChildAdded:Connect(function(child)
    task.wait(0.1)
    if child:IsA("Model") then
        local hum = child:FindFirstChildOfClass("Humanoid")
        if hum and child ~= player.Character then
            removeCloneAccessories(child)
        end
    end
end)

local function Devourer()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local backpack = player:WaitForChild("Backpack")
    local keywords = {"clonador","clone","quantum","cloner","quantico"}
    
    local function isCloneTool(name)
        name = name:lower()
        for _,k in ipairs(keywords) do
            if string.find(name,k) then
                return true
            end
        end
        return false
    end
    
    local clonador
    for _,tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and isCloneTool(tool.Name) then
            clonador = tool
            break
        end
    end
    
    if not clonador then print("LPZX Devourer: Ferramenta de clone não encontrada.") return end
    
    humanoid:UnequipTools() -- Esta linha desequipa tudo, por isso a Cloak precisa ser ativada antes.
    humanoid:EquipTool(clonador)
    
    local others = {}
    for _,tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool ~= clonador then
            tool.Parent = character
            table.insert(others, tool)
        end
    end
    
    local t0 = tick()
    while tick() - t0 < 1 do
        local tool = character:FindFirstChild(clonador.Name)
        if tool then tool:Activate() end
        RunService.Heartbeat:Wait()
    end
    
    for _,obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= character and obj:FindFirstChildOfClass("Humanoid") then
            removeCloneAccessories(obj)
        end
    end
    
    for _,tool in ipairs(others) do
        if tool.Parent == character then
            tool.Parent = backpack
        end
    end
end

--====================================================--
-- GUI DO DEVOURER
--====================================================--

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "LPZXDevourerV1"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 140)
main.Position = UDim2.new(0.5, -150, 0.5, -70)
main.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
main.Active = true
main.Draggable = true

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(138, 43, 226)
stroke.Thickness = 2

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 34)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "LPZX Devourer V1"
title.TextColor3 = Color3.fromRGB(220, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 40)
status.BackgroundTransparency = 1
status.Text = "https://discord.gg/eYRYzCSZJU"
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 12

local button = Instance.new("TextButton", main)
button.Size = UDim2.new(1, -20, 0, 46)
button.Position = UDim2.new(0, 10, 0, 80)
button.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
button.Text = "LPZX Devourer"
button.TextColor3 = Color3.fromRGB(240, 200, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18

local btnCorner = Instance.new("UICorner", button)
btnCorner.CornerRadius = UDim.new(0, 12)

--====================================================--
-- AÇÃO DO BOTÃO (CORRIGIDA)
--====================================================--
local busy = false
button.MouseButton1Click:Connect(function()
    if busy then return end
    busy = true
    button.Text = "EXECUTANDO COMBO..."
    button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    
    task.spawn(function()
        -- ==================================================
        -- CORREÇÃO DA LÓGICA DO CLIQUE
        -- ==================================================
        
        -- 1. Pausa inicial
        task.wait(0.3)
        
        -- 2. Equipa e ATIVA a Invisibility Cloak
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local backpack = player:WaitForChild("Backpack")
        local invisibilityCloak = backpack:FindFirstChild("Invisibility Cloak")
        
        if humanoid and invisibilityCloak then
            humanoid:EquipTool(invisibilityCloak)
            task.wait(0.1) -- Pausa para garantir que equipou
            
            -- << A CORREÇÃO ESTÁ AQUI >>
            -- Usamos :Activate() que é mais confiável para scripts
            invisibilityCloak:Activate()
            
            task.wait(0.1) -- Pausa para a habilidade da cloak ter efeito
        else
            warn("LPZX Devourer: Invisibility Cloak não encontrada.")
        end
        
        -- 3. Executa a função original do Devourer para o spam
        Devourer()
        -- ==================================================
    end)
    
    task.wait(1.5)
    button.Text = "LPZX Devourer"
    button.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
    busy = false
end)

--====================================================--
-- INFORMAÇÕES NO CONSOLE
--====================================================--
print("====================================")
print("LPZX DEVOURER V8 (CLIQUE CORRIGIDO) - CARREGADO")
print("Versão: Sem Sistema de Key, com Combo Completo")
print("====================================")
