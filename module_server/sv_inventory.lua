local DroppedItems      = {}
local player_inventory  = {}

--- 
-- CHECK INVENTORY PLAYER
---
RegisterNetEvent('infinity_needs:CheckInventory')
AddEventHandler('infinity_needs:CheckInventory', function(source, PlayerTarget)
    local TargetSteamID = exports.infinity_core:GetPlayerTarget(PlayerTarget)   
    local SPlayerDatas  = exports.infinity_core:GetPlayerSession(source)   
    if TargetSteamID then
        if SPlayerDatas._Rank == "superadmin" then
            local TPlayerDatas      = exports.infinity_core:GetPlayerTargetSession(tonumber(PlayerTarget))
            player_inventory       = json.decode(TPlayerDatas._InventoryT)     
            exports.infinity_core:notification(
                source,
                "Inspect Inventory from Player <b>"..TPlayerDatas._FirstnameT.." "..TPlayerDatas._LastnameT.."</b>",  		
                "<small style='font-size:18px!important'>"..player_inventory.."</small>",  	
                "bottom_center",         
                "redm_min",             
                12000
            )
        end
    else
        exports.infinity_core:notification(source, Config.NotFind, "",'center_left', 'infinitycore', 2500)
    end
end)

--- 
-- RESET INVENTORY PLAYER
---
RegisterNetEvent('infinity_needs:ResetInventory')
AddEventHandler('infinity_needs:ResetInventory', function(source, PlayerTarget)

    local TargetSteamID = exports.infinity_core:GetPlayerTarget(PlayerTarget)   
    local SPlayerDatas  = exports.infinity_core:GetPlayerSession(source)       

    if TargetSteamID then
        if SPlayerDatas._Rank == "superadmin" then

            local TPlayerDatas  = exports.infinity_core:GetPlayerTargetSession(PlayerTarget)

            local ToSaveInventory = {}
            table.insert(ToSaveInventory ,{ name = 'water', amount = 1, meta = {}})
            table.insert(ToSaveInventory ,{ name = 'bread', amount = 1, meta = {}})
            table.insert(ToSaveInventory ,{ name = 'WEAPON_MELEE_TORCH', amount = 1, meta = {}})
            local JsonItemsInventory = json.encode(ToSaveInventory)

            TriggerClientEvent('infinitycore:RefreshPlayerDatas', PlayerTarget, 
                TPlayerDatas._CharidT,
                false, -- bank
                false, -- cash
                false, -- xp
                false, -- golds
                false, -- job
                false, -- jobgrade
                false, -- gang
                false, -- gangrank
                JsonItemsInventory, -- inventoryList
                "inv" -- action
            )

            exports.infinity_core:notification(source,"", "Player "..TPlayerDatas._FirstnameT.." "..TPlayerDatas._LastnameT.." are now <b class='text-danger'>RESET</b>", "bottom_center","redm_min", 2500)
            exports.infinity_core:notification(PlayerTarget,"<b class='text-danger'>Inventory Reset</b> by Admin "..SPlayerDatas._Firstname.." "..SPlayerDatas._Lastname, "<small style='font-size:18px!important'>Inventory : "..JsonItemsInventory.."</small>","bottom_center","redm_min", 2500)
        else
            exports.infinity_core:notification(PlayerTarget, Config.Lang_Nopermission,"",'center_left', 'infinitycore', 2500)
        end
    else
        exports.infinity_core:notification(source, Config.NotFind, "",'center_left', 'infinitycore', 2500)
    end
end)

--- 
-- ADD ITEM FROM CMD ADMIN
---
RegisterNetEvent('infinity_needs:AddItem')
AddEventHandler('infinity_needs:AddItem', function(source, PlayerTarget, ItemSended, Qt)

    local TargetSteamID = exports.infinity_core:GetPlayerTarget(PlayerTarget)
    
    if TargetSteamID then

        local TPlayerDatas      = exports.infinity_core:GetPlayerTargetSession(tonumber(PlayerTarget)) -- (( GET DATAS TARGET PLAYER ))
        local quantitySended    = tonumber(Qt)

        JSON_CHECKER(ItemSended)

        if ItemHaveName ~= nil and quantitySended >= 1 then

                player_inventory        = json.decode(TPlayerDatas._InventoryT)
                local item , id         = getInventoryItemFromName(ItemSended, quantitySended, player_inventory, getMetaOutput(meta))

                -- INVENTORY FULL FUNC  
                ItemWeightCarry(player_inventory, quantitySended)
                if tonumber(WeightTotalPlayer) <= Config.MaxWeight then

                    -- Inventory User from database
                    for i,k in pairs(player_inventory) do
                        if k['name'] == ItemSended then
                            k['amount']  = tonumber(k['amount'] + quantitySended)
                        end
                    end

                    -- Check item sended is new in player inventory ?
                    if item == false and id == false then
                        table.insert(player_inventory ,{ name = ItemSended, amount = quantitySended, meta = {}})
                    end

                    local JsonItemsInventory        = json.encode(player_inventory)
                    
                    TriggerClientEvent('infinitycore:RefreshPlayerDatas',PlayerTarget, 
                        TPlayerDatas._CharidT,
                        false, -- bank
                        false, -- cash
                        false, -- xp
                        false, -- golds
                        false, -- job
                        false, -- jobgrade
                        false, -- gang
                        false, -- gangrank
                        JsonItemsInventory, -- inventoryList
                        "inv" -- action
                    )

                    local _Admin       = tonumber(source)
                    local SourceDatas   = exports.infinity_core:GetPlayerSession(_Admin)
                    local TargetDatas   = exports.infinity_core:GetPlayerTargetSession(tonumber(PlayerTarget)) -- (( GET DATAS TARGET PLAYER ))

                    exports.infinity_core:notification(
                        _Admin,
                        '<b class="text-success">Item are sended</b> to '..TargetDatas._FirstnameT..' '..TargetDatas._LastnameT..'',  		
                        ItemHaveLabel.." +"..quantitySended,  	
                        'center_left', 'infinitycore', 3500
                    )
                    exports.infinity_core:notification(
                        PlayerTarget,
                        '<b class="text-success">New item receive</b> by Admin '..SourceDatas._Firstname..' '..SourceDatas._Lastname,  		
                        ItemHaveLabel.." +"..quantitySended,  	
                        'center_left', 'infinitycore', 3500
                    )

                else
                    DroppedItems[id] = {
                        name    = ItemHaveName,
                        amount  = quantitySended,
                        label   = ItemHaveLabel,
                        weight  = WeightItemReceive,
                        coords  = {x = x, y = y, z = z}
                    }

                    TriggerClientEvent('infinity_needs:AnimationPickup', PlayerTarget)
                    TriggerClientEvent("infinity_needs:DropItemFunc", PlayerTarget, DroppedItems[id], TPlayerDatas._InventoryT)

                    exports.infinity_core:notification(PlayerTarget, '<b class="text-danger">Inventory is full</b>', '', 'center_left', 'infinitycore', 2500)
                end
        else
            exports.infinity_core:notification(
                source,
                '<b class="text-danger">ERROR</b>',  		
                'The item is not find in database !',  	
                'center_left', 'infinitycore', 2500
            )
        end
    else
        exports.infinity_core:notification(
            source,
            '<b class="text-danger">ERROR</b>',    		
            "Player is offline !",  	
            'center_left', 'infinitycore', 2500
        )
    end
end)

---
-- REMOVE INVENTORY FROM ADMIN
---
RegisterNetEvent('infinity_needs:RemoveItem')
AddEventHandler('infinity_needs:RemoveItem', function(source, PlayerTarget, ItemSended, Qt)
    local TargetSteamID = exports.infinity_core:GetPlayerTarget(PlayerTarget)

    if TargetSteamID then

        local TPlayerDatas    = exports.infinity_core:GetPlayerTargetSession(tonumber(PlayerTarget)) -- (( GET DATAS TARGET PLAYER ))
        local quantitySended  = tonumber(Qt)
        
        JSON_CHECKER(ItemSended)
        if ItemHaveName ~= nil and quantitySended >= 1 then
            player_inventory        = json.decode(TPlayerDatas._InventoryT)
            -- Inventory User from database
            for i,k in pairs(player_inventory) do
                if k['name'] == ItemSended then
                    if k['amount'] <= quantitySended then
                        k['amount'] = tonumber(0)
                    else
                        k['amount'] = tonumber(k['amount'] - quantitySended)
                    end

                end
            end
            local JsonItemsInventory        = json.encode(player_inventory)

            TriggerClientEvent('infinitycore:RefreshPlayerDatas', PlayerTarget, 
                TPlayerDatas._CharidT,
                false, -- bank
                false, -- cash
                false, -- xp
                false, -- golds
                false, -- job
                false, -- jobgrade
                false, -- gang
                false, -- gangrank
                JsonItemsInventory, -- inventoryList
                "inv" -- action
            )
 
            local _Admin         = tonumber(source)
            local SPlayerDatas   = exports.infinity_core:GetPlayerSession(_Admin)
            
            exports.infinity_core:notification(_Admin,'<b class="text-success">Item removed</b> <br> for '..TPlayerDatas._FirstnameT..' '..TPlayerDatas._LastnameT, ItemHaveLabel.." -"..quantitySended, 'center_left', 'infinitycore', 2500)
            exports.infinity_core:notification(PlayerTarget,'<b class="text-danger">Item removed</b> <br> by Admin '..SPlayerDatas._Firstname..' '..SPlayerDatas._Lastname, ItemHaveLabel.." -"..quantitySended, 'center_left', 'infinitycore', 2500)
        
        else
            exports.infinity_core:notification(
                source,
                '<b class="text-danger">ERROR</b>',  		
                'The item is not find in database !',  	
                'center_left', 'infinitycore', 2500
            )
        end
    else
        exports.infinity_core:notification(
            source,
            '<b class="text-danger">ERROR</b>',    		
            "Player is offline !",  	
            'center_left', 'infinitycore', 2500
        )
    end
end)

---
-- ADD INVENTORY PLAYER FUNC
---
RegisterNetEvent('infinity_needs:AddItemFunc')
AddEventHandler('infinity_needs:AddItemFunc', function(source, ItemSended, Qt, Inventory, notif, meta)
    local SourceSteamID         = exports.infinity_core:GetPlayerSource(source)
    if SourceSteamID then
        local SourceDatas       = exports.infinity_core:GetPlayerSession(source)
        local quantitySended    = tonumber(Qt)
        -- meta peut être nil ou une table

        JSON_CHECKER(ItemSended) 
        if ItemHaveName ~= nil and quantitySended >= 1 and quantitySended <= Config.MaxSendItems then
            local player_inventory        = json.decode(SourceDatas._Inventory)
                local item , id  = getInventoryItemFromName(ItemSended, quantitySended, player_inventory ,getMetaOutput(meta))
                ItemWeightCarry(player_inventory, quantitySended)
                if tonumber(WeightTotalPlayer) <= Config.MaxWeight then
                    -- Exist
                    for i,k in pairs(player_inventory) do
                        if k['name'] == ItemSended then
                            k['amount'] = tonumber(k['amount'] + quantitySended)
                        end
                    end
                    -- Wont Exist
                    if item == false and id == false then
                        table.insert(player_inventory ,{ 
                            name = ItemSended, 
                            amount = quantitySended, 
                            meta = getMetaOutput(meta)
                        })
                    end
                    local JsonItemsInventory        = json.encode(player_inventory)
                    if JsonItemsInventory ~= nil then

                        TriggerClientEvent('infinitycore:RefreshPlayerDatas', source, 
                            SourceDatas._Charid,
                            false, -- bank
                            false, -- cash
                            false, -- xp
                            false, -- golds
                            false, -- job
                            false, -- jobgrade
                            false, -- gang
                            false, -- gangrank
                            JsonItemsInventory, -- inventoryList
                            "inv" -- action
                        )

                        if notif == true then 
                            exports.infinity_core:notification(source,'<b class="text-success">New item receive</b>', ItemHaveLabel.." +"..quantitySended,'center_right', 'infinitycore', 2500)
                        end
                    end
                else
                    DroppedItems[id] = {
                        name    = ItemHaveName,
                        amount  = quantitySended,
                        label   = ItemHaveLabel,
                        weight  = WeightItemReceive,
                        coords  = {x = x, y = y, z = z}
                    }
                    TriggerClientEvent('infinity_needs:AnimationPickup', source)
                    TriggerClientEvent("infinity_needs:DropItemFunc", source, DroppedItems[id], SourceDatas._Inventory)
                    exports.infinity_core:notification(source, '<b class="text-danger">Inventory is full</b>', '', 'center_right', 'infinitycore', 2500)
                end
        else
            exports.infinity_core:notification(source,'<b class="text-danger">ERROR</b>','The item is not find in database !','center_right', 'infinitycore', 2500)
        end
    end
end)

---
-- REMOVE INVENTORY PLAYER FUNC
---
RegisterNetEvent('infinity_needs:RemoveItemFunc')
AddEventHandler('infinity_needs:RemoveItemFunc', function(source, ItemSended, Qt, Inventory, notif)
    local SourceSteamID     = exports.infinity_core:GetPlayerSource(source)
    local quantitySended    = tonumber(Qt)
    JSON_CHECKER(ItemSended)
    if ItemHaveName ~= nil and quantitySended >= 1 then
        player_inventory = json.decode(Inventory)
        for i,k in pairs(player_inventory) do
            if k['name'] == ItemSended then
                if k['amount'] >= 1 then 
                    if k['amount'] <= quantitySended then
                        k['amount'] = tonumber(0)
                        removal = true
                    else
                        removal = true
                        k['amount'] = tonumber(k['amount'] - quantitySended)
                    end
                else
                    removal = false
                end
            end
        end
        local JsonItemsInventory        = json.encode(player_inventory)
        if JsonItemsInventory ~= nil and removal then
            local SourceDatas       = exports.infinity_core:GetPlayerSession(source)

            TriggerClientEvent('infinitycore:RefreshPlayerDatas', source, 
                SourceDatas._Charid,
                false, -- bank
                false, -- cash
                false, -- xp
                false, -- golds
                false, -- job
                false, -- jobgrade
                false, -- gang
                false, -- gangrank
                JsonItemsInventory, -- inventoryList
                "inv" -- action
            )

            if notif == true then 
                exports.infinity_core:notification(source,'<b class="text-warning">Item removed</b>', ItemHaveLabel.." -"..quantitySended,'center_right', 'infinitycore',2500)
            end
        end
    else
        exports.infinity_core:notification(source,'<b class="text-danger">ERROR</b>','The item is not find in database !','center_right', 'infinitycore', 2500)
    end
    return removal
end)

--- 
-- USE ITEM FUNC
---
RegisterNetEvent('infinity_needs:UseItem')
AddEventHandler('infinity_needs:UseItem', function(source, itemUse, Inventory)

    local SourceSteamID     = exports.infinity_core:GetPlayerSource(source)
    Datas                   = LoadResourceFile(GetCurrentResourceName(), "./inventory/items.json")
    extract                 = json.decode(Datas)
    local ItemHaveName      = nil
    local ItemHaveLabel     = nil
    local ItemCat           = nil
    local ItemBonus         = nil
    local ItemBonus2        = nil
    local ItemBonus3        = nil
    local ItemDESC          = nil
    local ItemFor           = nil

    for i, json in pairs(extract.itemslist) do
        if json.name == itemUse then
            ItemHaveName  = json.name
            ItemHaveLabel = json.label
            ItemCat       = json.type_item
            ItemBonus     = json.bonus
            ItemBonus2    = json.bonus2
            ItemBonus3    = json.bonus3
            ItemDESC      = json.description
            ItemFor       = json.for_item
            break
        end
    end

    if ItemHaveLabel ~= nil and ItemHaveName ~= nil then

            player_inventory = json.decode(Inventory)
            CategoryItem     = ItemCat                      
            BonusItem        = ItemBonus 
            BonusItem2       = ItemBonus2
            BonusItem3       = ItemBonus3                          
            LabelName        = ItemHaveLabel                
            DescName         = ItemDESC                    
            ForItem          = ItemFor

            for i,k in pairs(player_inventory) do
                if k['name'] == itemUse then
                    if k['amount'] >= 1 then
                        
                    -- Use Water and Foods and remove item
                    if CategoryItem == "eat" or CategoryItem == "drink" then
                        TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3,  LabelName, DescName, ForItem)
                    end

                    -- Use Standard item and remove
                    if CategoryItem == "standard" then
                        TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
                    end

                    -- Use Standard item and remove
                    if CategoryItem == "potion" then
                        TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
                    end

                    -- Use health and remove
                    if CategoryItem == "health" then
                        TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
                    end

                    -- Use Standard item ammo and remove
                    if  CategoryItem == "ammo" then
                        TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
                    end

                    -- Use Standard item ammo and remove
                    if CategoryItem == "ammo_clip" and k['amount'] >= Config.AmmoClipMade then
                        if itemUse then 
                            TriggerEvent("infinity_needs:RemoveItemFunc", source, itemUse, 50, Inventory)
                        end
                    elseif CategoryItem == "ammo_clip" and k['amount'] < Config.AmmoClipMade then
                        exports.infinity_core:notification(source,'<b class="text-danger">ERROR</b>','You need X50 single ammo for made clip','center_left', 'infinitycore', 2500)
                    end

                    -- Use Weapon and dont remove weapon
                    if CategoryItem == "weapon" then
                        if itemUse == "WEAPON_BOW" then
                            local InventoryQT   = CheckPlayerInventory(source, "ammo_arrow")
                            BonusItem           = tonumber(InventoryQT)
                            TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
                        else 
                            TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
                        end
                    end

                    -- Use Weapon and dont remove weapon
                    if CategoryItem == "weaponthrow" then
                        TriggerClientEvent('infinity_core:useItem', source, itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
                    end

                else
                    exports.infinity_core:notification(source,'<b class="text-danger">ERROR</b>','You dont have this','center_left', 'infinitycore', 2500)
                end
                break
            end
        end
    end
end)

--- 
-- OPEN INVENTORY PLAYER
---
RegisterNetEvent('infinity_needs:OpenInventory')
AddEventHandler('infinity_needs:OpenInventory', function(source, Inventory)

    local SourceSteamID     = exports.infinity_core:GetPlayerSource(source)
    JsonItemsList()
    JsonItemsInventory   = json.decode(Inventory)

    for i,k in pairs(JsonItemsInventory) do
        for i, json in pairs(itemListJson.itemslist) do
            if k['name'] == json.name and k['amount'] >= 1 then
                k['label']          = json.label
                k['description']    = json.description
                k['type_item']      = json.type_item
                k['weight']         = json.weight
                k['bonus']          = json.bonus
                k['bonus2']         = json.bonus2
                k['bonus3']         = json.bonus3
                k['droped']         = json.droped
                k['rare']           = json.rare
                k['img']            = json.img
                k['name']           = json.name
                k['total']          = json.weight * k['amount']
                k['for_item']       = json.for_item
            end

        end
    end

    OutputInventory     = json.encode(JsonItemsInventory)
    FinalCheck          = json.decode(OutputInventory)
    TriggerClientEvent('infinity_needs:returnJson', source, FinalCheck)
end)

---
-- SINGLE AMMO
---
RegisterNetEvent('infinity_needs:AddSingleAmmo')
AddEventHandler('infinity_needs:AddSingleAmmo', function(source, Qt, WeaponID, PlayerDatas)
    local SourceSteamID     = exports.infinity_core:GetPlayerSource(source)
    local quantitySended    = tonumber(Qt)
    if WeaponID == -2055158210 then
        itemAdd = "single_ammo_pistol"
        TriggerEvent('infinity_needs:AddItemFunc', source, itemAdd, Qt, PlayerDatas._Inventory, false)
    end
end)

----- [[ FUNCTIONS CORE  ]] -----

function is_table_equal(t1, t2)
    if t1 == t2 then return true end
    if type(t1) ~= "table" or type(t2) ~= "table" then return false end
    for k, v in pairs(t1) do
        if type(v) == "table" and type(t2[k]) == "table" then
            if not is_table_equal(v, t2[k]) then return false end
        elseif v ~= t2[k] then
            return false
        end
    end
    for k, v in pairs(t2) do
        if t1[k] == nil then return false end
    end
    return true
end

function ItemWeightCarry(player_inventory, quantitySended) 
    JsonItemsList()
    PlayerWeight = 0
    ItemReceived = ItemWeight * quantitySended
    for i,k in pairs(player_inventory) do
        for i, json in pairs(itemListJson.itemslist) do
            if k['name'] == json.name and k['amount'] >= 1 then
                k['total']   = json.weight * k['amount']
                PlayerWeight = PlayerWeight + k['total']
            end
        end
    end
    WeightTotalPlayer = PlayerWeight + ItemReceived
    WeightItemReceive = ItemReceived
    return WeightTotalPlayer, WeightItemReceive
end

function getMetaOutput(m)
    if m == "empty" then
      return m
    else 
       local meta = m or {}
        if next(meta) == nil then
            meta = "empty"
        end
        return meta
    end
end

function getInventoryItemFromName(ItemSended, quantitySended, items_table , meta)
    for i,k in pairs(items_table) do
        if meta ~= "empty" then
            if next(meta) == nil then
                if ItemSended == k['name'] then
                    return items_table[i] , i
                end
            else
              if ItemSended == k['name'] then
                  if is_table_equal(meta, k['meta']) then
                     return items_table[i] , i
                   end
                end
            end
        else
            if ItemSended == k['name'] and next(k['meta']) == nil then
                return items_table[i] , i
            end
        end
    end
    return false, false
end

function JSON_CHECKER(ItemSended)
    Datas   = LoadResourceFile(GetCurrentResourceName(), "./inventory/items.json")
    extract = json.decode(Datas)
    ItemHaveName  = nil
    ItemHaveLabel = nil
    for i, json in pairs(extract.itemslist) do
        if json.name == ItemSended then
            ItemHaveName  = json.name
            ItemHaveLabel = json.label
            ItemWeight    = json.weight
            break
            return ItemHaveName, ItemHaveLabel, ItemWeight
        end
    end
end

----- [[ EXPORTS  ]] -----
-- local itemListJson = exports.infinity_needs:JsonItemsList() (+func)
function JsonItemsList()
    Datas           = LoadResourceFile(GetCurrentResourceName(), "./inventory/items.json")
    itemListJson    = json.decode(Datas)
    return itemListJson
end

-- exports.infinity_needs:AddInventoryItem(source, itemname, quantity)
function AddInventoryItem(source, itemAdd, quantity, Inventory, notif, meta)
    local _source       = tonumber(source)
    Wait(155)
    local SourceDatas   = exports.infinity_core:GetPlayerSession(_source)
    TriggerEvent('infinity_needs:AddItemFunc', source, itemAdd, quantity, SourceDatas._Inventory, notif, meta)
end

-- exports.infinity_needs:RemoveInventoryItem(source, itemname, quantity)
function RemoveInventoryItem(source, itemRemove, quantity, Inventory, notif)
    local _source       = tonumber(source)
    Wait(155)
    local SourceDatas   = exports.infinity_core:GetPlayerSession(_source)
    TriggerEvent('infinity_needs:RemoveItemFunc', source, itemRemove, quantity, SourceDatas._Inventory, notif)
end

-- exports.infinity_needs:UseInventoryItem(source, itemname)
function UseInventoryItem(source, itemUse, Inventory)
    local _source       = tonumber(source)
    local SourceDatas   = exports.infinity_core:GetPlayerSession(_source)
    TriggerEvent('infinity_needs:UseItem', source, itemUse, SourceDatas._Inventory)
end

-- exports.infinity_needs:CheckPlayerInventory(source, itemsended, Inventory)
function CheckPlayerInventory(source, itemsended)
    local _source       = tonumber(source)
    local SourceDatas   = exports.infinity_core:GetPlayerSession(_source)
    player_inventory = json.decode(SourceDatas._Inventory)
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

----- [[ DROP/PICKUP ]] -----
RegisterServerEvent("infinity_needs:AddPickupServer")
AddEventHandler("infinity_needs:AddPickupServer", function(name, amount, label, weight, x, y, z , id, Inventory)
    DroppedItems[id] = {
        name    = name,
        amount  = amount,
        label   = label,
        weight  = weight,
        coords  = {x = x, y = y, z = z}
    }
    TriggerEvent('infinity_needs:RemoveItemFunc', source, name, tonumber(amount), Inventory)
    TriggerClientEvent("infinity_needs:UpdatePickups", -1, DroppedItems)
end)

RegisterServerEvent("infinity_needs:AddPickupServerFull")
AddEventHandler("infinity_needs:AddPickupServerFull", function(name, amount, label, weight, x, y, z , id, InventoryTarget)
    DroppedItems[id] = {
        name    = name,
        amount  = amount,
        label   = label,
        weight  = weight,
        coords  = {x = x, y = y, z = z}
    }
    TriggerClientEvent("infinity_needs:UpdatePickups", -1, DroppedItems)
end)

RegisterServerEvent("infinity_needs:onPickup")
AddEventHandler("infinity_needs:onPickup", function(source, id)
    TriggerClientEvent('infinity_needs:removePickup', -1, id)
    TriggerClientEvent('infinity_needs:AnimationPickup', source)
    Wait(500)
    local _source       = tonumber(source)
    TriggerEvent('infinity_needs:AddItemFunc', source, DroppedItems[id].name,  DroppedItems[id].amount, true, id)
    DroppedItems[id] = nil
    TriggerClientEvent("infinity_needs:UpdatePickups", -1, DroppedItems)
    TriggerClientEvent('infinity_needs:ReEnablePrompt', source)
end)