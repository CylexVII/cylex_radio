ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('radio', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerClientEvent('cylex_radio:use', source)

end)

-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(1000)
--     local xPlayers = ESX.GetPlayers()
--     for i=1, #xPlayers, 1 do
--         local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
--           if xPlayer ~= nil then
--               if xPlayer.getInventoryItem('radio').count == 0 then

--                 local source = xPlayers[i]
--                 TriggerClientEvent('cylex_radio:onRadioDrop', source)

--                 break
--               end
--             end
--           end
--         end
-- end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer ~= nil then
    if item.name == 'radio' and item.count < 1 then
        TriggerClientEvent('cylex_radio:onRadioDrop', source)
        -- TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = "Telsizden çıkartıldın."})
    end
  end
end)

ESX.RegisterServerCallback('cylex_radio:getItemAmount', function(source, cb, item)
  local xPlayer = ESX.GetPlayerFromId(source)
  local qtty = xPlayer.getInventoryItem(item).count
  cb(qtty)
end)
