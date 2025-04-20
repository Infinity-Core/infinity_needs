function roundValue(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

--- 
-- PAYDAY AUTOMATIC
---
RegisterNetEvent('infinity_needs:paycheck')
AddEventHandler('infinity_needs:paycheck', function(source)
    if source ~= nil or source ~= 0 then
        local SourceSteamID     = exports.infinity_core:GetPlayerSource(source)
        xpSend                  = tonumber(roundValue(Config.PaydayXP, 1)) 
        goldSend                = tonumber(roundValue(Config.PaydayGolds, 2))
        cashSend                = tonumber(roundValue(Config.PaydaySalary,2))
        if SourceSteamID then
            local PlayerDatas        = exports.infinity_core:GetPlayerSession(source)
            local playernowAccount   = tonumber(PlayerDatas._Cash)  + tonumber(cashSend)
            local playernowAccount02 = tonumber(PlayerDatas._Xp)    + tonumber(xpSend)
            local playernowAccount03 = tonumber(PlayerDatas._Gold)  + tonumber(goldSend)
            exports.infinity_core:AddGold(source, goldSend)
            exports.infinity_core:AddXP(source, xpSend)
            exports.infinity_core:AddCash(source, cashSend)
            exports.infinity_core:notification(source, '<div class="text-succes">PAYCHECK</div>', '<small style="font-size:18px;">You have received a paycheck</small>', 'center_left', 'infinitycore', 2500)
        end
    end
end)