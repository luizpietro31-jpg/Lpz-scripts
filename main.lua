-- [[ LPZ DEVOURER V3 (ULTRA NEON EDITION) - EXCLUSIVE ]]
-- [[ CREATED BY: LPZINN X ]]
-- [[ ALL RIGHTS RESERVED ]]

local cat1 = game:GetService("Players")
local cat2 = cat1.LocalPlayer
local cat3 = cat2:WaitForChild("Backpack")
local cat6 = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local cat5 = game.CoreGui:FindFirstChild("TigyFPSDevourUI")
if cat5 then cat5:Destroy() end

local cat7 = Instance.new("ScreenGui", game.CoreGui)
cat7.Name = "TigyFPSDevourUI"
cat7.ResetOnSpawn = false

local cat8 = Instance.new("Frame", cat7)
cat8.Size = UDim2.new(0, 260, 0, 160)
cat8.Position = UDim2.new(0.5, -130, 0.5, -80)
cat8.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
cat8.BorderSizePixel = 0
cat8.Active, cat8.Draggable = true, true
Instance.new("UICorner", cat8).CornerRadius = UDim.new(0, 12)

-- [[ MEU EFEITO DE GRADIENTE GIRATÓRIO ]]
local stroke = Instance.new("UIStroke", cat8)
stroke.Thickness = 3.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.new(1, 1, 1)

local gradient = Instance.new("UIGradient", stroke)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(160, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 50, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(160, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})

task.spawn(function()
    local rot = 0
    while true do
        rot = rot + 4
        gradient.Rotation = rot
        local pulse = (math.sin(tick() * 5) + 1) / 2
        stroke.Thickness = 3 + (2 * pulse)
        task.wait(0.02)
    end
end)

-- [[ INTERFACE ]]
local cat10 = Instance.new("TextLabel", cat8)
cat10.Size = UDim2.new(1, 0, 0, 25)
cat10.Position = UDim2.new(0, 0, 0, 5)
cat10.BackgroundTransparency = 1
cat10.Text = "🔥 LPZ DEVOURER V3 🔥"
cat10.Font = Enum.Font.GothamBlack
cat10.TextSize = 14
cat10.TextColor3 = Color3.fromRGB(200, 100, 255)

local creditLabel = Instance.new("TextLabel", cat8)
creditLabel.Size = UDim2.new(1, 0, 0, 15)
creditLabel.Position = UDim2.new(0, 0, 0, 25)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "by:LPZINN X"
creditLabel.Font = Enum.Font.GothamBold
creditLabel.TextSize = 10
creditLabel.TextColor3 = Color3.fromRGB(150, 50, 255)
creditLabel.TextTransparency = 0.2

local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", cat8)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text, btn.Font, btn.TextSize = text, Enum.Font.GothamBold, 13
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Thickness = 1.5
    bStroke.Color = Color3.fromRGB(100, 0, 200)
    
    return btn
end

local cat11 = createBtn("FPS Devour", UDim2.new(0, 10, 0, 55), Color3.fromRGB(15, 0, 30))
local cat13 = createBtn("Mass Equip: OFF", UDim2.new(0, 10, 0, 105), Color3.fromRGB(30, 0, 60))

-- [[ MINHAS FUNÇÕES ]]
local function startOptimizer()
    local function nukeVisualEffects(obj)
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or
               obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") or
               obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                    obj.Transparency = 1
                end
            end
        end)
    end

    pcall(function()
        local render = settings().Rendering
        render.QualityLevel = Enum.QualityLevel.Level01
        render.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.Brightness = 2
        Lighting.FogEnd = 9e9
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("BloomEffect") or 
               effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or 
               effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
                pcall(function() effect:Destroy() end)
            end
        end
    end)

    for _, obj in ipairs(workspace:GetDescendants()) do nukeVisualEffects(obj) end
    workspace.DescendantAdded:Connect(nukeVisualEffects)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize, terrain.WaterWaveSpeed, terrain.WaterReflectance = 0, 0, 0
            terrain.WaterTransparency, terrain.Decoration = 1, false
        end
    end)
end

local function startAntiRagdoll()
    local CharacterData = {}
    local function cacheData()
        local char = cat2.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return false end
        CharacterData.character, CharacterData.humanoid, CharacterData.root = char, hum, root
        return true
    end
    local function isRagdolled()
        local hum = CharacterData.humanoid
        if not hum then return false end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then return true end
        local endTime = cat2:GetAttribute("RagdollEndTime")
        return endTime and (endTime - workspace:GetServerTimeNow()) > 0
    end
    local function removeRagdollConstraints()
        local char = CharacterData.character
        if not char then return end
        for _, descendant in ipairs(char:GetDescendants()) do
            if descendant:IsA("BallSocketConstraint") or (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
                pcall(function() descendant:Destroy() end)
            end
        end
    end
    local function forceExitRagdoll()
        local hum, root = CharacterData.humanoid, CharacterData.root
        if not hum or not root then return end
        pcall(function() cat2:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
        if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
        root.Anchored, root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = false, Vector3.zero, Vector3.zero
    end
    task.spawn(function()
        while true do
            task.wait()
            if cacheData() and isRagdolled() then removeRagdollConstraints() forceExitRagdoll() end
        end
    end)
    cat6.RenderStepped:Connect(function()
        local cam, hum = workspace.CurrentCamera, CharacterData.humanoid
        if cam and hum and cam.CameraSubject ~= hum then cam.CameraSubject = hum end
    end)
end

local function startESP()
    local function applyESP(player)
        if player == cat2 then return end
        local function createHighlight(character)
            if not character then return end
            local old = character:FindFirstChild("LPZ_ESP")
            if old then old:Destroy() end
            local highlight = Instance.new("Highlight")
            highlight.Name = "LPZ_ESP"
            highlight.Parent = character
            highlight.FillColor = Color3.fromRGB(130, 0, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency, highlight.OutlineTransparency = 0.4, 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
        player.CharacterAdded:Connect(createHighlight)
        if player.Character then createHighlight(player.Character) end
    end
    for _, p in ipairs(cat1:GetPlayers()) do applyESP(p) end
    cat1.PlayerAdded:Connect(applyESP)
end

local function startESPTimer()
    local plotsFolder = workspace:FindFirstChild("Plots")
    local baseEspInstances = {}
    local function createBaseESP(plot, mainPart)
        if baseEspInstances[plot.Name] then baseEspInstances[plot.Name]:Destroy() end
        local billboard = Instance.new("BillboardGui", plot)
        billboard.Name, billboard.Size, billboard.AlwaysOnTop, billboard.Adornee = "rznnq" .. plot.Name, UDim2.new(0, 50, 0, 25), true, mainPart
        billboard.StudsOffset, billboard.MaxDistance = Vector3.new(0, 5, 0), 1000
        local label = Instance.new("TextLabel", billboard)
        label.Size, label.BackgroundTransparency, label.TextScaled, label.Font = UDim2.new(1, 0, 1, 0), 1, true, Enum.Font.Arcade
        label.TextColor3, label.TextStrokeTransparency, label.TextStrokeColor3 = Color3.fromRGB(190, 0, 255), 0, Color3.new(0, 0, 0)
        baseEspInstances[plot.Name] = billboard
        return billboard
    end
    cat6.RenderStepped:Connect(function()
        if not plotsFolder then return end
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local purchases = plot:FindFirstChild("Purchases")
            local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
            local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
            local billboard = baseEspInstances[plot.Name]
            local timeLabel = mainPart and mainPart:FindFirstChild("BillboardGui") and mainPart.BillboardGui:FindFirstChild("RemainingTime")
            if timeLabel and mainPart then
                billboard = billboard or createBaseESP(plot, mainPart)
                local label = billboard:FindFirstChildWhichIsA("TextLabel")
                if label then label.Text = timeLabel.Text end
            elseif billboard then
                billboard:Destroy()
                baseEspInstances[plot.Name] = nil
            end
        end
    end)
end

local function startBaseTransparency()
    local loaded = false
    local function isBaseWall(obj)
        local n = obj.Name:lower()
        local p = obj.Parent and obj.Parent.Name:lower() or ""
        return n:find("base") or p:find("base")
    end
    local function apply()
        if loaded then return end
        local plots = workspace:FindFirstChild("Plots")
        if not plots or #plots:GetChildren() == 0 then return end
        loaded = true
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Anchored and obj.CanCollide and isBaseWall(obj) then obj.LocalTransparencyModifier = 0.85 end
        end
        workspace.DescendantAdded:Connect(function(obj) if isBaseWall(obj) and obj:IsA("BasePart") then obj.LocalTransparencyModifier = 0.85 end end)
    end
    task.spawn(function() for _ = 1, 20 do apply() if loaded then break end task.wait(0.5) end end)
end

local function startAntiBeeDisco()
    local BAD = {Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true}
    local function nuke(obj) if obj and BAD[obj.Name] then pcall(function() obj:Destroy() end) end end
    local function protect()
        pcall(function()
            local PlayerScripts = cat2:WaitForChild("PlayerScripts")
            local Controls = require(PlayerScripts:WaitForChild("PlayerModule")):GetControls()
            local orig = Controls.moveFunction
            local function safe(self, mv, rel) if orig then orig(self, mv, rel) end end
            cat6.Heartbeat:Connect(function() if Controls.moveFunction ~= safe then Controls.moveFunction = safe end end)
            Controls.moveFunction = safe
        end)
    end
    local function blockBuzz()
        pcall(function()
            local bee = cat2.PlayerScripts:FindFirstChild("Bee", true)
            local buzz = bee and bee:FindFirstChild("Buzzing")
            if buzz and buzz:IsA("Sound") then buzz:Stop() buzz.Volume = 0 end
        end)
    end
    for _, inst in ipairs(Lighting:GetDescendants()) do nuke(inst) end
    Lighting.DescendantAdded:Connect(nuke)
    protect()
    cat6.Heartbeat:Connect(function() blockBuzz() local cam = workspace.CurrentCamera if cam then cam.FieldOfView = 70 end end)
end

task.spawn(function()
    while true do
        for _, p in ipairs(cat1:GetPlayers()) do 
            if p.Character then for _, i in ipairs(p.Character:GetChildren()) do if i:IsA("Shirt") or i:IsA("Pants") or i:IsA("Accessory") then i:Destroy() end end end 
        end
        for _, o in ipairs(workspace:GetChildren()) do 
            if o:IsA("Model") and o:FindFirstChild("Humanoid") then for _, i in ipairs(o:GetChildren()) do if i:IsA("Shirt") or i:IsA("Pants") or i:IsA("Accessory") then i:Destroy() end end end 
        end
        task.wait(0.3)
    end
end)

cat11.MouseButton1Click:Connect(function()
    cat11.Text = "WORKING..."
    local char = cat2.Character
    local clonador = cat3:FindFirstChild("Quantum Cloner") or (char and char:FindFirstChild("Quantum Cloner"))
    if char and char:FindFirstChildOfClass("Humanoid") and clonador then
        clonador.Parent = char
        local others = {}
        for _, tool in ipairs(cat3:GetChildren()) do if tool:IsA("Tool") and tool ~= clonador then tool.Parent = char table.insert(others, tool) end end
        local t0 = tick()
        while tick() - t0 < 1.2 do clonador:Activate() cat6.Heartbeat:Wait() end
        for _, tool in ipairs(others) do if tool and tool.Parent == char then tool.Parent = cat3 end end
    end
    cat11.Text = "FPS Devour"
end)

local massSpamActive = false
cat13.MouseButton1Click:Connect(function()
    massSpamActive = not massSpamActive
    cat13.Text = massSpamActive and "Mass Equip: ON" or "Mass Equip: OFF"
    cat13.BackgroundColor3 = massSpamActive and Color3.fromRGB(80, 0, 160) or Color3.fromRGB(30, 0, 60)
end)

task.spawn(function()
    while true do
        if massSpamActive then
            local char = cat2.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                local currentTools = {}
                for _, t in ipairs(cat3:GetChildren()) do if t:IsA("Tool") then t.Parent = char table.insert(currentTools, t) end end
                task.wait(0.4) 
                for _, t in ipairs(currentTools) do if t and t.Parent == char then t.Parent = cat3 end end
                task.wait(0.4)
            end
        else task.wait(0.5) end
        cat6.Heartbeat:Wait()
    end
end)

-- [[ MEUS SISTEMAS ATIVADOS ]]
startOptimizer()
startAntiRagdoll()
startESP()
startESPTimer()
startBaseTransparency()
startAntiBeeDisco()

