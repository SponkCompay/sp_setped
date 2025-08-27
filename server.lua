-- Lista de jugadores con permiso (puedes poner su steam hex o license)
local allowedPlayers = {
    --"steam:110000112345678", -- ejemplo
    "license:33afe6c01" -- ejemplo
}

RegisterCommand("setped", function(source, args)
    if source == 0 then
        print("Este comando solo lo pueden usar jugadores en el juego.")
        return
    end

    local playerId = source
    local pedModel = args[1]

    if not pedModel then
        TriggerClientEvent('chat:addMessage', playerId, { args = { '^1ERROR', 'Debes escribir un modelo de ped.' } })
        return
    end

    if not hasPermission(playerId) then
        TriggerClientEvent('chat:addMessage', playerId, { args = { '^1ERROR', 'No tienes permisos para usar este comando.' } })
        return
    end

    TriggerClientEvent("setPed:change", playerId, pedModel)
end, false)

RegisterCommand("resetped", function(source)
    if source == 0 then
        print("Este comando solo lo pueden usar jugadores en el juego.")
        return
    end

    local playerId = source

    if not hasPermission(playerId) then
        TriggerClientEvent('chat:addMessage', playerId, { args = { '^1ERROR', 'No tienes permisos para usar este comando.' } })
        return
    end

    TriggerClientEvent("setPed:reset", playerId)
end, false)

function hasPermission(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, id in ipairs(identifiers) do
        for _, allowedId in ipairs(allowedPlayers) do
            if id == allowedId then
                return true
            end
        end
    end
    return false
end
