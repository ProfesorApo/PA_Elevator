local Config = Config or {}
Locales = Locales or {}

function Translate(key)
    local lang = Config.Language or "fr"
    return Locales[lang][key] or "Translation missing"
end

function SetupTargets()
    for elevatorName, floors in pairs(Config.Elevators) do
        for _, floor in ipairs(floors) do
            local coords = floor.position
            exports['ox_target']:addBoxZone({
                coords = coords,
                size = vec3(3, 3, 2),
                rotation = 0,
                options = {
                    {
                        name = 'elevator_' .. elevatorName,
                        event = 'elevator:showMenu',
                        label = Translate('use_elevator'),
                        icon = 'fa-solid fa-elevator',
                        data = {
                            elevator = elevatorName,
                            currentFloor = floor.position 
                        }
                    }
                }
            })
        end
    end
end

RegisterNetEvent('elevator:showMenu', function(data)
    local elevatorName = data.data and data.data.elevator
    local currentFloor = data.data and data.data.currentFloor

    if not elevatorName then
        TriggerEvent('ox_lib:notify', {type = 'error', description = Translate('missing_elevator')})
        return
    end

    local floors = Config.Elevators[elevatorName]

    if not floors or #floors == 0 then
        TriggerEvent('ox_lib:notify', {type = 'error', description = Translate('no_floors_found') .. elevatorName})
        return
    end

    local options = {}
    for _, floor in ipairs(floors) do
        table.insert(options, {
            title = floor.name,
            event = 'elevator:gotoFloor',
            args = {
                position = floor.position,
                name = floor.name
            },
            disabled = (currentFloor.x == floor.position.x and currentFloor.y == floor.position.y and currentFloor.z == floor.position.z)
        })
    end

    lib.registerContext({
        id = 'elevator_menu',
        title = Translate('select_floor'),
        options = options
    })

    lib.showContext('elevator_menu')
end)

RegisterNetEvent('elevator:gotoFloor', function(data)
    local position = data.position
    if position and position.x and position.y and position.z then
        local playerPed = PlayerPedId()
        SetEntityCoords(playerPed, position.x, position.y, position.z, false, false, false, true)
        TriggerEvent('ox_lib:notify', {type = 'success', description = Translate('arrived_at') .. (data.name or 'un étage inconnu')})
    else
        TriggerEvent('ox_lib:notify', {type = 'error', description = Translate('floor_invalid')})
    end
end)

CreateThread(function()
    SetupTargets()
end)

