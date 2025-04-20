-----
-- [ infinitycore SESSION]
-----
RegisterNetEvent('infinitycore:SetSession')
AddEventHandler('infinitycore:SetSession', function(source)
	_InfinitySource = source
end)

-----
-- [ TEMP METABOLISM ]
-----
local ClothesForPlayer = {
	0x9925C067, 
	0x2026C46D, 
	0x1D4C528A, 
	0x777EC6EF, 
	0xE06D30CE, 
	0x662AC34,  
	0xEABE0032,
	0x485EE834, 
	0xAF14310B,
}
Citizen.CreateThread(function()
    while true do 
        x,y,z             = table.unpack(GetEntityCoords(PlayerPedId()))
        Citizen.Wait(Config.TickTemperature)
        temperature       = GetTemperatureAtCoords(x,y,z)
		for k,v in pairs(ClothesForPlayer) do
			local IsWearingClothes = Citizen.InvokeNative(0xFB4891BD7578CDC1 ,PlayerPedId(), v)
			if IsWearingClothes then 
				temperature = temperature + 1.00
			end
		end
        Temp_Metabolism(temperature)
        if Config.TemperatureExtreme then
            if tonumber(temperature) <= Config.LowTemperatureLimit then
                TickTemperatureDamage()
            end
        end
    end
end)

-----
-- [ PAYDAY TIMER ]
-----
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(Config.PaydayTimer)
        PayCheck()
    end
end)

-----
-- [ HP METABOLISM ]     SetEntityHealth(PlayerPedId(), initialhp)
-----
function Health_Metabolism(health)
     if health ~= nil then
         if health > 100 then
             local new    = health - 100
             local remove = health - new
             SetEntityHealth(PlayerPedId(), remove)
         elseif health <= 100 then
             SetEntityHealth(PlayerPedId(), health)
         end
         if health >= 0 then 
             StoreHp(health)
         end
     end
     return health
end

-----
-- [ STORE HP ]
-----
function StoreHp(health) 
    Currenthealth = health
end

-----
-- [ TEMP METABOLISM ]
-----
function Temp_Metabolism()
    return temperature
end

-----
-- [ FOOD METABOLISM ]
-----
function Eat_Metabolism(Come)
    if not ComeEat then
        ComeEat = Come
    end
    return ComeEat
end
Citizen.CreateThread(function()
    while true do 
        if not ComeEat then
            Citizen.Wait(3500)
        else
            if ComeEat then
                launchedEat = true
                if ComeEat > 0 then
                    ComeEat = ComeEat -1
                end
                if ComeEat <= 0 then
                    TickFoodDamage()
                end
            end
            Citizen.Wait(Config.TickEat) -- ( -1% of Eating )
            Eat_Metabolism(ComeEat)
        end
    end
end)

-----
-- [ DRINK METABOLISM ]
-----
function Water_Metabolism(ComeW)
    if not ComeWater then
        ComeWater = ComeW
    end
    return ComeWater
end
Citizen.CreateThread(function()
    while true do 
        if not ComeWater then
            Citizen.Wait(3500)
        else
            if ComeWater then
                launchedEat = true
                if ComeWater > 0 then
                    ComeWater = ComeWater -1
                end
                if ComeWater <= 0 then
                    TickDrinkDamage()
                end
            end
            Citizen.Wait(Config.TickDrink) -- ( -1% of Water )
            Water_Metabolism(ComeWater)
        end
    end
end)

-----
-- [ SLEEP METABOLISM ]
-----
function Sleep_Metabolism(ComeSleep)
    return ComeSleep
end

Citizen.CreateThread(function()
    while true do 
        
        if not ComeSleep then
            ComeSleep = 100
            Citizen.Wait(3500)
        else
            if ComeSleep then

                _InfinitySource        = GetPlayerServerId(PlayerId())
               
                if ComeSleep > 0 then
                    ComeSleep = ComeSleep -1
                end
               
                if ComeSleep == 20 then
                    exports.infinity_core:notification(_InfinitySource, "<span class='text-danger'>You are tired</span>", "", "center_bottom", "redm_min", 3500)
                end

                if ComeSleep <= 0 then
                    ComeSleep = 100
                    local PlayerPed      = PlayerPedId()
                    if IsPedMale(PlayerPed) then
                        DoScreenFadeOut(6500)
                        exports.infinity_core:notification(_InfinitySource, "<span class='text-danger'>You are verry tired</span>", "", "center_bottom", "redm_min", 3500)
                        local scenario_type_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM")
                        local scenario_duration = -1  -- (1000 = 1 second, -1 = forever)
                        local must_play_enter_anim = true
                        local optional_conditional_anim_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM_MALE_B")  -- 0 = play random conditional anim. Every conditional anim has requirements to play it. If requirements are not met, ped plays random allowed conditional anim or can be stuck. For example, this scenario type have possible conditional anim "WORLD_HUMAN_LEAN_BACK_WALL_SMOKING_MALE_D", but it can not be played by player, because condition is set to NOT be CAIConditionIsPlayer (check file amb_rest.meta and amb_rest_CA.meta with OPENIV to clarify requirements). 
                        local unknown_5 = -1.0
                        local unknown_6 = 0
                        Citizen.InvokeNative(0x524B54361229154F, PlayerPed, scenario_type_hash, scenario_duration, must_play_enter_anim, optional_conditional_anim_hash, unknown_5, unknown_6)
                        Wait(9500)
                        DoScreenFadeIn(7500)  -- Black Screen for sleeping out
                        exports.infinity_core:notification(_InfinitySource, "You wake up after a nap", "", "center_bottom", "redm_min", 3500)
                        ClearPedTasks(PlayerPedId())
                    else
                        DoScreenFadeOut(6500)
                        exports.infinity_core:notification(_InfinitySource, "<span class='text-danger'>You are verry tired</span>", "", "center_bottom", "redm_min", 3500)
                        local scenario_type_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM")
                        local scenario_duration = -1  -- (1000 = 1 second, -1 = forever)
                        local must_play_enter_anim = true
                        local optional_conditional_anim_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM_FEMALE_A")  -- 0 = play random conditional anim. Every conditional anim has requirements to play it. If requirements are not met, ped plays random allowed conditional anim or can be stuck. For example, this scenario type have possible conditional anim "WORLD_HUMAN_LEAN_BACK_WALL_SMOKING_MALE_D", but it can not be played by player, because condition is set to NOT be CAIConditionIsPlayer (check file amb_rest.meta and amb_rest_CA.meta with OPENIV to clarify requirements). 
                        local unknown_5 = -1.0
                        local unknown_6 = 0
                        Citizen.InvokeNative(0x524B54361229154F, PlayerPed, scenario_type_hash, scenario_duration, must_play_enter_anim, optional_conditional_anim_hash, unknown_5, unknown_6)
                        Wait(9500)
                        DoScreenFadeIn(7500)  -- Black Screen for sleeping out
                        exports.infinity_core:notification(_InfinitySource, "You wake up after a nap", "", "center_bottom", "redm_min", 3500)
                        ClearPedTasks(PlayerPedId())
                    end
                end
            end
            Citizen.Wait(Config.TickSleep) -- ( -1% of Rest of 200000ms ~= 3,5min)
        end
        Sleep_Metabolism(ComeSleep)

    end
end)

-----
-- [ /sleep ]
-----
TriggerEvent('chat:addSuggestion', '/sleep', 'Sleeping', {})
RegisterCommand('sleep', function(source, args)
    _InfinitySource        = GetPlayerServerId(PlayerId())
    local PlayerPed      = PlayerPedId()
    if IsPedMale(PlayerPed) then
        DoScreenFadeOut(6500)
        exports.infinity_core:notification(_InfinitySource, "You have started to sleep", "", "center_bottom", "redm_min", 3500)
        local scenario_type_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM")
        local scenario_duration = -1  -- (1000 = 1 second, -1 = forever)
        local must_play_enter_anim = true
        local optional_conditional_anim_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM_MALE_B")  -- 0 = play random conditional anim. Every conditional anim has requirements to play it. If requirements are not met, ped plays random allowed conditional anim or can be stuck. For example, this scenario type have possible conditional anim "WORLD_HUMAN_LEAN_BACK_WALL_SMOKING_MALE_D", but it can not be played by player, because condition is set to NOT be CAIConditionIsPlayer (check file amb_rest.meta and amb_rest_CA.meta with OPENIV to clarify requirements). 
        local unknown_5 = -1.0
        local unknown_6 = 0
        ComeSleep = 100
        Citizen.InvokeNative(0x524B54361229154F, PlayerPed, scenario_type_hash, scenario_duration, must_play_enter_anim, optional_conditional_anim_hash, unknown_5, unknown_6)
        Wait(9500)
        DoScreenFadeIn(7500)  -- Black Screen for sleeping out
        exports.infinity_core:notification(_InfinitySource, "You wake up after a nap", "", "center_bottom", "redm_min", 3500)
        ClearPedTasks(PlayerPedId())
    else
        DoScreenFadeOut(6500)
        exports.infinity_core:notification(_InfinitySource, "You have started to sleep", "", "center_bottom", "redm_min", 3500)
        local scenario_type_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM")
        local scenario_duration = -1  -- (1000 = 1 second, -1 = forever)
        local must_play_enter_anim = true
        local optional_conditional_anim_hash = GetHashKey("WORLD_HUMAN_SLEEP_GROUND_ARM_FEMALE_A")  -- 0 = play random conditional anim. Every conditional anim has requirements to play it. If requirements are not met, ped plays random allowed conditional anim or can be stuck. For example, this scenario type have possible conditional anim "WORLD_HUMAN_LEAN_BACK_WALL_SMOKING_MALE_D", but it can not be played by player, because condition is set to NOT be CAIConditionIsPlayer (check file amb_rest.meta and amb_rest_CA.meta with OPENIV to clarify requirements). 
        local unknown_5 = -1.0
        local unknown_6 = 0
        ComeSleep = 100
        Citizen.InvokeNative(0x524B54361229154F, PlayerPed, scenario_type_hash, scenario_duration, must_play_enter_anim, optional_conditional_anim_hash, unknown_5, unknown_6)
        Wait(9500)
        DoScreenFadeIn(7500)  -- Black Screen for sleeping out
        exports.infinity_core:notification(_InfinitySource, "You wake up after a nap", "", "center_bottom", "redm_min", 3500)
        ClearPedTasks(PlayerPedId())
    end
end)

-----
-- [ INVENTORY USE ITEM ]
-----
RegisterNetEvent('infinity_core:useItem')
AddEventHandler('infinity_core:useItem', function(itemUse, CategoryItem, BonusItem, BonusItem2, BonusItem3, LabelName, DescName, ForItem)
   
    local SPlayerDatas           = exports.infinity_core:GetPlayerSession(_InfinitySource)
    local ped                    = PlayerPedId()

    if CategoryItem == "standard" then 
    end

    if CategoryItem == "weaponthrow" then
        hash = GetHashKey(itemUse)
        if itemUse == "WEAPON_THROWN_DYNAMITE" 
        or itemUse == "WEAPON_THROWN_TOMAHAWK" 
        or itemUse == "WEAPON_THROWN_POISONBOTTLE"
        or itemUse == "WEAPON_THROWN_TOMAHAWK_ANCIEN" 
        or itemUse == "WEAPON_MELEE_HATCHET"
        or itemUse == "WEAPON_MELEE_CLEAVER"
        or itemUse == "WEAPON_THROWN_BOLAS"
        or itemUse == "WEAPON_MOONSHINEJUG_MP"
        or itemUse == "WEAPON_THROWN_BOLAS_HAWKMOTH"
        or itemUse == "WEAPON_THROWN_BOLAS_IRONSPIKED"
        or itemUse == "WEAPON_THROWN_BOLAS_INTERTWINED"
        or itemUse == "WEAPON_THROWN_THROWING_KNIVES"
        then
            Citizen.InvokeNative(0x5E3BDDBCB83F3D84, PlayerPedId(), hash, 0, false, true)
            if itemUse == "WEAPON_MOONSHINEJUG_MP" then 
            SetPedAmmo(PlayerPedId(), hash , 100)
            else 
                SetPedAmmo(PlayerPedId(), hash , 1)
            end
            SetCurrentPedWeapon(PlayerPedId(),hash,true)
        end
        if itemUse == "WEAPON_THROWN_MOLOTOV" then
            SetPedAmmo(PlayerPedId(), hash , 3)
            SetAmmoInClip(PlayerPedId(), hash , 0)
            SetCurrentPedWeapon(PlayerPedId(), hash, true)
        end
    end
    if CategoryItem == "weapon" then
        if not active_weapon or active_weapon ~= itemUse then

            _InfinitySource = GetPlayerServerId(PlayerId())
            exports.infinity_core:notification(_InfinitySource, '', '<small style="font-size:18px;">Use '..LabelName..'</small>', 'center_left', 'infinitycore', 2500)
            
            if itemUse == "WEAPON_BOW" then 

                hash                        = GetHashKey(itemUse)
                local player                = PlayerPedId()
                local user, currentWeapon   = GetCurrentPedWeapon(PlayerPedId(), 1, 0, 1)
                local totalammo             = GetAmmoInPedWeapon(PlayerPedId(), currentWeapon) 

                if totalammo == 0 and BonusItem >= 1 then
                    SetPedAmmo(ped, hash, 1) 
                    TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, "ammo_arrow", 1, SPlayerDatas._Inventory, true)
                end

                Citizen.InvokeNative(0xB282DC6EBD803C75, ped, GetHashKey(itemUse), 0, true, 0)
                active_weapon = itemUse 
                
            else
                Citizen.InvokeNative(0xB282DC6EBD803C75, ped, GetHashKey(itemUse), 0, true, 0)
                active_weapon = itemUse 
            end
            
        elseif active_weapon == itemUse then
            local user, currentWeapon = GetCurrentPedWeapon(PlayerPedId(), 1, 0, 1)
            Citizen.InvokeNative(0x4899CB088EDF59B8, PlayerPedId(), currentWeapon)
            active_weapon = false 
        end
    end
    if CategoryItem == "eat" then
        if ComeEat ~= nil then
            if itemUse == "peach" then
                PlayAnimationEatPeachcan()
            elseif itemUse == "chocolat" then
                PlayAnimationEatChocolat()
            elseif itemUse == "ragout" then
                PlayAnimationEatRagout()
            else
                PlayAnimationEatBread()
            end
            TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
           
            if ComeEat <= 100 then
                new_estomac = tonumber(ComeEat) + tonumber(BonusItem)
                if new_estomac >= 100 then
                    ComeEat = 100
                else
                    ComeEat = new_estomac
                end
            end

            if BonusItem2 ~= 0 or BonusItem2 ~= nil then
                if ComeWater <= 100 then
                    new_jar = tonumber(ComeWater) + tonumber(BonusItem2)
                    if new_jar >= 100 then
                        ComeWater = 100
                    else
                        ComeWater = new_jar
                    end
                end
            end

        else
            exports.infinity_core:notification(_InfinitySource , '<b class="text-danger">infinitycore need restart</b>', '', 'center_left', 'infinitycore', 2500)
        end
    end
    if CategoryItem == "health" then
        local seringue      = tonumber(Currenthealth) + tonumber(BonusItem)
        if Currenthealth < 100 then 
            TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            TaskItemInteraction(PlayerPedId(), GetHashKey("PrimaryItem"), GetHashKey("USE_STIMULANT_INJECTION_QUICK_LEFT_HAND_RIFLE"), 1, 0, 0)
            Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, tonumber(seringue))
            Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, tonumber(seringue))
            Wait(755)
            AnimpostfxPlay("MP_HealthDrop")
        else
            exports.infinity_core:notification(_InfinitySource , '<b class="text-danger">Not need for the moment</b>', '', 'center_left', 'infinitycore', 2500)
        end
    end

    if CategoryItem == "potion" then
        if itemUse ~= "potionhorse" then 
            PlayAnimationDrinkPotion()
        end
        TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
    end

    if CategoryItem == "drink" then
        if ComeWater ~= nil then
            if itemUse == "rhum" then
                PlayAnimationDrinkRhum()
            elseif itemUse == "coffee" then 
                PlayAnimationDrinkCoffee()
            else
                PlayAnimationDrink()
            end
            TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            if ComeWater <= 100 then
                new_jar = tonumber(ComeWater) + tonumber(BonusItem)
                if new_jar >= 100 then
                    ComeWater = 100
                else
                    ComeWater = new_jar
                end
            end
        else
            exports.infinity_core:notification(_InfinitySource , '<b class="text-danger">infinitycore need restart</b>', '', 'center_left', 'infinitycore', 2500)
        end
    end

    -- Reload Guns
    if CategoryItem == "ammo" then
        local player        = PlayerPedId()
        local user, currentWeapon = GetCurrentPedWeapon(PlayerPedId(), 1, 0, 1)
        local WeaponAmmo    = currentWeapon
        if ForItem == "pistol" then
            if currentWeapon == -2055158210 or currentWeapon == 1701864918 then 
                Citizen.InvokeNative(0xB190BCA3F4042F95, player, WeaponAmmo, Config.AmmoLoad, true)
                TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            else
                ErrorAmmo()
            end
        end
        if ForItem == "revolver" then
            if currentWeapon == 379542007 then 
                Citizen.InvokeNative(0xB190BCA3F4042F95, player, WeaponAmmo, Config.AmmoLoad, true)
                TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            else
                ErrorAmmo()
            end
        end
        if ForItem == "shotgun" then
            if currentWeapon == 834124286 then 
                Citizen.InvokeNative(0xB190BCA3F4042F95, player, WeaponAmmo, Config.AmmoLoad, true)
                TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            else
                ErrorAmmo()
            end
        end
        if ForItem == "repeater" then
            if currentWeapon == -183018591 then 
                Citizen.InvokeNative(0xB190BCA3F4042F95, player, WeaponAmmo, Config.AmmoLoad, true)
                TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            else
                ErrorAmmo()
            end
        end
        if ForItem == "bow" then
            if currentWeapon == 115405099 or currentWeapon == 115405099 or currentWeapon == -2002235300 then 
                Citizen.InvokeNative(0xB190BCA3F4042F95, player, WeaponAmmo, Config.AmmoLoad, true)
                TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            else
                ErrorAmmo()
            end
        end
        if ForItem == "rifle" then
            if currentWeapon == 1999408598 or currentWeapon == 1676963302 or currentWeapon == 1402226560 then 
                Citizen.InvokeNative(0xB190BCA3F4042F95, player, WeaponAmmo, Config.AmmoLoad, true)
                TriggerServerEvent('infinity_needs:RemoveItemFunc', _InfinitySource, itemUse, 1, SPlayerDatas._Inventory, true)
            else
                ErrorAmmo()
            end
        end
    end
end)

function LoadGun()
    exports.infinity_core:notification(_InfinitySource , 'Ammo Load', 'You load a weapon', 'center_left', 'infinitycore', 2500)
end
function ErrorAmmo()
    exports.infinity_core:notification(_InfinitySource , '<b class="text-danger">Ammo Incorrect</b>', 'The Weapon in your hand is incorrect !', 'center_left', 'infinitycore', 2500)
end
function PlayAnimationDrinkRhum()
    TaskItemInteraction(PlayerPedId(), GetHashKey("CONSUMABLE_RUM"), GetHashKey("USE_TONIC_POTENT_SATCHEL_LEFT_HAND_QUICK"), 1, 0, 0)
end
function PlayAnimationEatBread()
    TaskItemInteraction(PlayerPedId(), GetHashKey("CONSUMABLE_BREAD_ROLL"), GetHashKey("EAT_MULTI_BITE_FOOD_SPHERE_D8-2_SANDWICH_QUICK_LEFT_HAND"), 1, 0, 0)
end
function PlayAnimationEatPeachcan()
    TaskItemInteraction(PlayerPedId(), GetHashKey("CONSUMABLE_PEACHES_CAN"), GetHashKey("EAT_CANNED_FOOD_CYLINDER@D8-2_H10-5_QUICK_LEFT"), 1, 0, 0)
end
function PlayAnimationEatChocolat()
    TaskItemInteraction(PlayerPedId(), GetHashKey("CONSUMABLE_CHOCOLATE_BAR"), GetHashKey("RECTANGLE@L4-5_W15_H2-5_InspectZ"), 1, 0, 0)
end
function PlayAnimationOilHealth()
    TaskItemInteraction(PlayerPedId(), GetHashKey("CONSUMABLE_SNAKE_OIL"), GetHashKey("APPLY_LOTION_BOTH_HANDS"), 1, 0, 0)
end
function PlayAnimationDrink()
    TaskItemInteraction(PlayerPedId(), GetHashKey("CONSUMABLE_MOONSHINE"), GetHashKey("USE_TONIC_POTENT_SATCHEL_LEFT_HAND_QUICK"), 1, 0, 0)
end
function EnableEagleeye(player, enable)
	Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, player, enable)
end
function PlayAnimationDrinkPotion()
    TaskItemInteraction(PlayerPedId(), GetHashKey("CONSUMABLE_BRANDY"), GetHashKey("USE_TONIC_SATCHEL_LEFT_HAND_QUICK"), 1, 0, 0)
    EnableEagleeye(PlayerId(), true)
    Citizen.SetTimeout(55000, function()
        EnableEagleeye(PlayerId(), false)
    end)
end
function PlayAnimationDrinkCoffee()
    local object_id     = CreateObject("p_mugcoffee01x", vector3(0.0, 0.0, 0.0), true)
    TaskItemInteraction_2(PlayerPedId(), GetHashKey("CONSUMABLE_COFFEE"), object_id, GetHashKey("P_MUGCOFFEE01X_PH_R_HAND"), GetHashKey("DRINK_COFFEE_HOLD"), 1, 0, -1)
end
function PlayAnimationEatRagout()
    local object_id     = CreateObject("p_cs_meatbowl01x", vector3(0.0, 0.0, 0.0), true)
    TaskItemInteraction_2(PlayerPedId(), GetHashKey("PrimaryItem"), object_id,  GetHashKey("p_bowl04x_stew_PH_L_HAND"), GetHashKey("EAT_STEW_BOWL_INTRO"), 1, 0, -1)
end
function TickFoodDamage()
    local health = GetEntityHealth(PlayerPedId())
    local remove = health - Config.DMGEat
    exports.infinity_core:notification(_InfinitySource, '<div class="text-danger">WARNING</div>', '<small style="font-size:18px;">You are starving</small>', 'center_left', 'infinitycore', 2500)
    SetEntityHealth(PlayerPedId(), remove)
end
function TickDrinkDamage()
    local health = GetEntityHealth(PlayerPedId())
    local remove = health - Config.DMGDrink
    exports.infinity_core:notification(_InfinitySource, '<div class="text-danger">WARNING</div>', '<small style="font-size:18px;">You are desydrathed</small>', 'center_left', 'infinitycore', 2500)
    SetEntityHealth(PlayerPedId(), remove)
end
function TickTemperatureDamage()
    local health = GetEntityHealth(PlayerPedId())
    local remove = health - Config.DMGTEMP
    exports.infinity_core:notification(_InfinitySource, '<div class="text-danger">WARNING</div>', '<small style="font-size:18px;">Its verry cold</small>', 'center_left', 'infinitycore', 2500)
    SetEntityHealth(PlayerPedId(), remove)
end
function PayCheck()
    source      = GetPlayerServerId(PlayerId())
    TriggerServerEvent('infinity_needs:paycheck', source)
end
TriggerEvent('chat:addSuggestion', '/itemremove', 'itemadd water 1', {
    { name="ID",        help="ID of player" },
    { name="ITEM_NAME", help="Item Name in database" },
    { name="QUANTITY",  help="How much quantity removed ?" }
})
TriggerEvent('chat:addSuggestion', '/useitem', 'useitem itemname', {
    { name="itemname",        help="water, bread..." }
})