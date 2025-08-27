local originalModel = nil
local originalComponents = {}
local originalProps = {}


function SavePedAppearance(ped)
    originalComponents = {}
    originalProps = {}

    
    for i = 0, 11 do
        originalComponents[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i),
            palette = GetPedPaletteVariation(ped, i)
        }
    end

    
    for i = 0, 7 do
        originalProps[i] = {
            prop = GetPedPropIndex(ped, i),
            texture = GetPedPropTextureIndex(ped, i)
        }
    end
end


function RestorePedAppearance(ped)
    
    for i, comp in pairs(originalComponents) do
        SetPedComponentVariation(ped, i, comp.drawable, comp.texture, comp.palette)
    end

    
    for i, prop in pairs(originalProps) do
        if prop.prop ~= -1 then
            SetPedPropIndex(ped, i, prop.prop, prop.texture, true)
        else
            ClearPedProp(ped, i)
        end
    end
end


RegisterNetEvent("setPed:change")
AddEventHandler("setPed:change", function(pedModel)
    local ped = PlayerPedId()

 
    if originalModel == nil then
        originalModel = GetEntityModel(ped)
        SavePedAppearance(ped)
    end

    local model = GetHashKey(pedModel)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)


    SetPedDefaultComponentVariation(PlayerPedId())

    TriggerEvent('chat:addMessage', { args = { '^2INFO', 'Tu ped ha sido cambiado a: ' .. pedModel } })
end)


RegisterNetEvent("setPed:reset")
AddEventHandler("setPed:reset", function()
    local model = originalModel or `mp_m_freemode_01`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)

    local ped = PlayerPedId()


    if originalModel ~= nil then
        RestorePedAppearance(ped)
    else
        SetPedDefaultComponentVariation(ped)
    end

    TriggerEvent('chat:addMessage', { args = { '^2INFO', 'Has vuelto a tu skin original con ropa.' } })


    originalModel = nil
    originalComponents = {}
    originalProps = {}
end)
