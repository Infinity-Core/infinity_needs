local displayInventory  = false
source                  = GetPlayerServerId(PlayerId())

function roundValue(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

-----
-- [/restored]
-----
RegisterCommand('restored', function(source, args, rawCommand)
    local PlayerDatas = exports.infinity_core:GetPlayerSession(source)
    if PlayerDatas._Rank == "superadmin" then
        source      = GetPlayerServerId(PlayerId())
        ComeEat     = 100
        ComeWater   = 100
    end
end)

-----
-- [/itemremove ID water 1]
-----
TriggerEvent('chat:addSuggestion', '/itemremove', 'itemremove idPlayer itemname quantity (admin only)',{
{ name="ID", help="ID of player" },
{ name="ITEM_NAME", help="Item Name in database" },
{ name="QUANTITY", help="How much quantity ?" }
})
RegisterCommand('itemremove', function(source, args, rawCommand)
    local PlayerDatas = exports.infinity_core:GetPlayerSession(source)
    if PlayerDatas._Rank == "superadmin" then
        if args[1] == nil or args[2] == nil or args[3] == nil then
            print("^1 Wrong Command, argument #1 is missing")
        else
            source              = GetPlayerServerId(PlayerId())
            local PlayerTarget  = tonumber(args[1])
           TriggerServerEvent('infinity_needs:RemoveItem', source, PlayerTarget, args[2], args[3])
        end
    end
end)

-----
-- [/itemadd ID water 1]
-----
TriggerEvent('chat:addSuggestion', '/itemadd', 'itemadd idPlayer itemname quantity (admin only)',{
{ name="ID", help="ID of player" },
{ name="ITEM_NAME", help="Item Name in database" },
{ name="QUANTITY", help="How much quantity ?" }
})
RegisterCommand('itemadd', function(source, args, rawCommand)
    local PlayerDatas = exports.infinity_core:GetPlayerSession(source)
    if PlayerDatas._Rank == "superadmin" then
        if args[1] == nil or args[2] == nil or args[3] == nil then
            print("^1 Wrong Command, argument #1 is missing")
        else
            source              = GetPlayerServerId(PlayerId())
            local PlayerTarget  = tonumber(args[1])
            TriggerServerEvent('infinity_needs:AddItem', source, PlayerTarget, args[2], args[3])
        end
    end
end)

-----
-- [/resetinventory idPlayer]
-----
TriggerEvent('chat:addSuggestion', '/resetinventory', 'Reset Inventory of Player (admin only)', {
{ name="ID", help="ID of player" }
})
RegisterCommand('resetinventory', function(source, args, rawCommand)
    local PlayerDatas = exports.infinity_core:GetPlayerSession(source)
    if PlayerDatas._Rank == "superadmin" then
        if args[1] == nil then
            print("^1 Wrong Command, argument #1 is missing")
        else
            source        = GetPlayerServerId(PlayerId())
            PlayerTarget  = tonumber(args[1])
            TriggerServerEvent('infinity_needs:ResetInventory', source, PlayerTarget)
        end
    end
end)

-----
-- [/checkinventory idPlayer]
-----
TriggerEvent('chat:addSuggestion', '/checkinventory', 'Check Items (^2 admin only)', {
    { name="ID", help="ID of player" }
})
RegisterCommand('checkinventory', function(source, args, rawCommand)
    local PlayerDatas = exports.infinity_core:GetPlayerSession(source)
    if PlayerDatas._Rank == "superadmin" then
        if args[1] == nil then
            print("^1 Wrong Command, argument #1 is missing")
        else
            source        = GetPlayerServerId(PlayerId())
            PlayerTarget  = tonumber(args[1])
            TriggerServerEvent('infinity_needs:CheckInventory', source, PlayerTarget)
        end
    end
end)

-----
-- [/inv Open your inventory]
-----
-- Citizen.CreateThread(function()
--     while true do
--         Wait(5)
--         if IsControlJustReleased(0, 0xC1989F95) then
--             source        = GetPlayerServerId(PlayerId())
--             _InfinitySource = source
--             local SPlayerDatas           = exports.infinity_core:GetPlayerSession(source)
--             TriggerServerEvent('infinity_needs:OpenInventory', _InfinitySource, SPlayerDatas._Inventory)
--         end
--     end
-- end)

TriggerEvent('chat:addSuggestion', '/inv', 'Open your inventory', {})
RegisterCommand('inv', function()
    source        = GetPlayerServerId(PlayerId())
    _InfinitySource = source
    local SPlayerDatas           = exports.infinity_core:GetPlayerSession(source)
    TriggerServerEvent('infinity_needs:OpenInventory', _InfinitySource, SPlayerDatas._Inventory)
end, false)

RegisterNetEvent('infinity_needs:returnJson')
AddEventHandler('infinity_needs:returnJson', function(ItemsPlayer)
    local PlayerDatas = exports.infinity_core:GetPlayerSession(source)
    DisplayActions(not displayInventory, ItemsPlayer, PlayerDatas._Cash, PlayerDatas._Gold, PlayerDatas._Xp)
end)

function DisplayActions(bool, ItemsPlayer, cash, golds, xp)
    displayInventory    = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type   		= "inventory_ui",
        status 	 	= displayInventory,
        ItemsPlayer = ItemsPlayer,
        cash        = cash,
        golds       = golds,
        xp          = xp,
        sizemax     = Config.MaxWeight
    })
end

RegisterNUICallback("exit", function(data)
    DisplayActions(false)
end)

RegisterNUICallback("useitem", function(data)
    DisplayActions(false)
    source      = GetPlayerServerId(PlayerId())
    local SPlayerDatas           = exports.infinity_core:GetPlayerSession(source)
    TriggerServerEvent('infinity_needs:UseItem', source, data.itemname, SPlayerDatas._Inventory)
end)

RegisterNUICallback("map", function(data)
    DisplayActions(false)
    _InfinitySource      = GetPlayerServerId(PlayerId())
    TriggerEvent("infinity_core:coords", _InfinitySource, 25)
end)

---- DROP ITEM CLASS ----
local DroppedItems = {}
local PickupPromptGroup = GetRandomIntInRange(0, 0xffffff)
local PickupPrompt
local PromptActive = false

function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

function SetupPickPrompt()
    Citizen.CreateThread(function()
        local str = Config.Str
        PickupPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(PickupPrompt, 0xF84FA74F)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PickupPrompt, str)
        PromptSetEnabled(PickupPrompt, true)
        PromptSetVisible(PickupPrompt, true)
        PromptSetHoldMode(PickupPrompt, true)
        PromptSetGroup(PickupPrompt, PickupPromptGroup)
        PromptRegisterEnd(PickupPrompt)
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
    local factor = (string.len(text)) / 150
    DrawSprite("itemtype_textures", "crew_tag", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
end

RegisterNUICallback("errordrop", function(data)
    exports.infinity_core:notification(_InfinitySource, '<div class="text-danger">WARNING</div>', '<small style="font-size:18px;">Invalid Quantity</small>', 'center_left', 'infinitycore', 2500)
end)
RegisterNUICallback("errordrop2", function(data)
    exports.infinity_core:notification(_InfinitySource, '<div class="text-danger">WARNING</div>', '<small style="font-size:18px;">You dont have this quantity</small>', 'center_left', 'infinitycore', 2500)
end)

--- DROP FROM NUI ---
RegisterNUICallback("drop", function(data)
    DisplayActions(false)
    local SPlayerDatas           = exports.infinity_core:GetPlayerSession(source)
    local ped                    = PlayerPedId()
    local coords                 = GetEntityCoords(ped)
    local forward                = GetEntityForwardVector(ped)
    local x, y, z                = table.unpack(coords + forward * 0.5)
    while not HasModelLoaded( GetHashKey(Config.ItemModelDroped) ) do
        Wait(500)
        modelrequest( GetHashKey(Config.ItemModelDroped) )
    end
    local obj = CreateObject(Config.ItemModelDroped, x, y, z, true, true, true)
    PlaceObjectOnGroundProperly(obj)
    SetEntityAsMissionEntity(obj, true, true)
    FreezeEntityPosition(obj , true)
	local _coords = GetEntityCoords(obj)
    PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
    SetModelAsNoLongerNeeded(GetHashKey(Config.ItemModelDroped))
    TriggerServerEvent("infinity_needs:AddPickupServer", data.itemname, data.dropQT, data.itemlabel, data.weight, _coords.x, _coords.y, _coords.z, obj, SPlayerDatas._Inventory)
end)

-- Remove Item Fully or drop
RegisterNetEvent('infinity_needs:DropItemFunc')
AddEventHandler('infinity_needs:DropItemFunc', function(data, InventoryTarget)
    local ped     = PlayerPedId()
    local coords  = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local x, y, z = table.unpack(coords + forward * 0.5)
    while not HasModelLoaded( GetHashKey(Config.ItemModelDroped) ) do
        Wait(500)
        modelrequest( GetHashKey(Config.ItemModelDroped) )
    end
    local obj = CreateObject(Config.ItemModelDroped, x, y, z, true, true, true)
    PlaceObjectOnGroundProperly(obj)
    SetEntityAsMissionEntity(obj, true, true)
    FreezeEntityPosition(obj , true)
	local _coords = GetEntityCoords(obj)
    PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
    SetModelAsNoLongerNeeded(GetHashKey(Config.ItemModelDroped))
    TriggerServerEvent("infinity_needs:AddPickupServerFull", data.name, data.amount, data.label, data.weight, _coords.x, _coords.y, _coords.z, obj, InventoryTarget)
end)

RegisterNetEvent('infinity_needs:UpdatePickups')
AddEventHandler('infinity_needs:UpdatePickups', function(pick)
    DroppedItems = pick
end)

Citizen.CreateThread(function()
    local wait = 1
    SetupPickPrompt()
    while true do
        Citizen.Wait(wait)

        local can_wait  = true
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        if next(DroppedItems) == nil then
            Citizen.Wait(500)
        end

        if DroppedItems ~= nil then

            for k,v in pairs(DroppedItems) do

                local distance = Vdist(coords, v.coords.x, v.coords.y, v.coords.z)
                
                if distance <= 15.0 then
                    can_wait = false
                end

                if distance <= 3.0 then
                    if v.weight ~= nil then
                        DrawText3D(v.coords.x, v.coords.y, v.coords.z+0.5, v.label.."".." x"..v.amount.." - "..v.weight.."kg")
                    else 
                        DrawText3D(v.coords.x, v.coords.y, v.coords.z+0.5, v.label.."".." x"..v.amount.."")
                    end
                end

                if distance <= 1.2 then
                    if  not PromptActive then
                        TaskLookAtEntity(playerPed, v.obj , 3000 ,2048 , 3)
                        local PromptGroupName  = CreateVarString(10, 'LITERAL_STRING', v.label.." x ("..v.amount..")")
                        PromptSetActiveGroupThisFrame(PickupPromptGroup, PromptGroupName)
                        if PromptHasHoldModeCompleted(PickupPrompt) then
                            PromptActive = true
                            source      = GetPlayerServerId(PlayerId())
                            TriggerServerEvent("infinity_needs:onPickup", source, k)
                        end
                    end
                end

            end
        end
        if can_wait == true then
            wait = 2500
        else
            wait = 1
        end
    end
end)

RegisterNetEvent('infinity_needs:removePickup')
AddEventHandler('infinity_needs:removePickup', function(obj)
    SetEntityAsMissionEntity(obj, false, true)
    NetworkRequestControlOfEntity(obj)
    local timeout = 0
    while not NetworkHasControlOfEntity(obj) and timeout < 5000 do
        timeout = timeout+100
        if timeout == 5000 then
        end
        Wait(100)
    end
    if NetworkHasControlOfEntity(obj) then
    end
    FreezeEntityPosition(obj , false)
    DeleteEntity(obj)
end)

RegisterNetEvent('infinity_needs:AnimationPickup')
AddEventHandler('infinity_needs:AnimationPickup', function()
    local dict = "amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), dict, "exit_front", 1.0, 8.0, -1, 1, 0, false, false, false)
    Wait(1200)
    Wait(1000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('infinity_needs:ReEnablePrompt')
AddEventHandler('infinity_needs:ReEnablePrompt', function()
    PromptActive = false
end)

-- exports.infinity_needs:CheckPlayerInventory(source, itemsended, Inventory)
function CheckPlayerInventory(source, itemsended, Inventory)
    player_inventory = json.decode(Inventory)
    for i,k in pairs(player_inventory) do
        if k['name'] == itemsended then
            if k['amount'] >= 1 then 
                quantity = k['amount']
            else
                quantity = k['amount']
            end
        end
    end
    return quantity
end

-- exports.infinity_needs:RemoveInventoryItem(source, itemUse, quantity, Inventory)
function RemoveInventoryItem(source, itemUse, quantity, Inventory, notif)
    TriggerServerEvent('infinity_needs:RemoveItemFunc', source, itemUse, quantity, Inventory, notif)
end