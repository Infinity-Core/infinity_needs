-----
-- [ HASH FINDER GUNS ]
-----
function WeaponsHashFind(currentWeapon)
    if currentWeapon == -2055158210 then 
        WName = "WEAPON_PISTOL_MAUSER"
        Action = "SHORTARM_HOLD"
        Clean  = "SHORTARM_CLEAN"
    elseif currentWeapon == 379542007 then
        WName  = "WEAPON_REVOLVER_CATTLEMAN"
        Action = "SHORTARM_HOLD"
        Clean  = "SHORTARM_CLEAN"
    elseif currentWeapon == 1999408598 then
        WName  = "WEAPON_RIFLE_BOLTACTION"
        Action = "LONGARM_HOLD"
        Clean  = "LONGARM_CLEAN_ENTER"
    elseif currentWeapon == 834124286 then
        WName  = "WEAPON_SHOTGUN_PUMP"
        Action = "LONGARM_HOLD"
        Clean  = "LONGARM_CLEAN_ENTER"
    end
    return WName
end

-----
-- [ INSPECT GUNS ]
-----
RegisterNUICallback("inspectweapon", function(data)
    DisplayActions(false)
    local user, currentWeapon   = GetCurrentPedWeapon(PlayerPedId(), 1, 0, 1) 
    local WName                 = WeaponsHashFind(currentWeapon)
    if currentWeapon ~= nil then
        if currentWeapon ~= -1569615261 then
            TaskItemInteraction(PlayerPedId(), GetHashKey(WName), GetHashKey(Action), 1, 0, -1)
        else
            exports.infinity_core:notification(_InfinitySource, '', '<small style="font-size:18px;">No weapon in your hands</small>', 'center_left', 'infinitycore', 2500)
        end
    end
end)

-----
-- [ CLEAN GUN STATE/DIRT ]
-----
RegisterNUICallback("cleangun", function(data)
    DisplayActions(false)
    local user, currentWeapon   = GetCurrentPedWeapon(PlayerPedId(), 1, 0, 1) 
    local WName                 = WeaponsHashFind(currentWeapon)
    if currentWeapon ~= nil then
        if currentWeapon ~= -1569615261 then
            TaskItemInteraction(PlayerPedId(), GetHashKey(WName), GetHashKey(Action), 1, 0, -1)
            TaskItemInteraction(PlayerPedId(), GetHashKey(WName), GetHashKey(Clean), 1, 0, -1)
            local object = GetObjectIndexFromEntityIndex(GetCurrentPedWeaponEntityIndex(PlayerPedId(),0))
            Citizen.InvokeNative(0xA7A57E89E965D839,object,0.0,0)
            Citizen.InvokeNative(0x812CE61DEBCAB948,object,0.0,0)
        else
            exports.infinity_core:notification(_InfinitySource, '', '<small style="font-size:18px;">No weapon in your hands</small>', 'center_left', 'infinitycore', 2500)
        end
    end
end)

-----
-- [ CLIP MADE GUN ]
-----
RegisterNUICallback("clipgun", function(data)
    DisplayActions(false)
    source      = GetPlayerServerId(PlayerId())
    local user, currentWeapon = GetCurrentPedWeapon(PlayerPedId(), 1, 0, 1)  -- WEAPON USED BY PLAYER
    local totalammo = GetAmmoInPedWeapon(PlayerPedId(), currentWeapon)       -- GET TOTAL AMMO IN WEAPON USED
    if tonumber(totalammo) >= 1 then
        local PlayerDatas = exports.infinity_core:GetPlayerSession(source)
        TriggerServerEvent('infinity_needs:AddSingleAmmo', source, totalammo, currentWeapon, PlayerDatas)
        Citizen.InvokeNative(0x1B83C0DEEBCBB214, PlayerPedId())                  -- CLEAR ALL AMMO IN WEAPON USED
        SetCurrentPedWeapon(PlayerPedId() ,GetHashKey("WEAPON_UNARMED"),true)    -- HAND SELECTED FOR PREVENT GLITH AMMO
    elseif tonumber(totalammo) <= 0 then
        exports.infinity_core:notification(_InfinitySource, '<div class="text-danger">WARNING</div>', '<small style="font-size:18px;">No Ammo in your Weapon</small>', 'center_left', 'infinitycore', 2500)
    elseif currentWeapon == nil then
        exports.infinity_core:notification(_InfinitySource, '<div class="text-danger">WARNING</div>', '<small style="font-size:18px;">No Weapon in your hands</small>', 'center_left', 'infinitycore', 2500)
    end
end)