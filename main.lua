-- Script para ser usado em Executores (Delta, Fluxus, etc.)
-- Este script expulsa o próprio usuário que o executa

local player = game:GetService("Players").LocalPlayer
local message = "The script has been deactivated by the owner"

if player then
    player:Kick(message)
else
    warn("Não foi possível encontrar o LocalPlayer.")
end
