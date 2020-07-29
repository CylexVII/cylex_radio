
--===============================================================================
--=== Stworzone przez Alcapone aka suprisex. Zakaz rozpowszechniania skryptu! ===
--===================== na potrzeby LS-Story.pl =================================
--===============================================================================


-- ESX

ESX = nil
local PlayerData                = {}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
	end
end)

local myPedId = GetPlayerPed(-1)

local phoneProp = 0
local radioModel = "prop_cs_walkie_talkie"
-- OR "prop_npc_phone"
-- OR "prop_npc_phone_02"
-- OR "prop_cs_phone_01"

local currentStatus = 'out'
local lastDict = nil
local lastAnim = nil
local lastIsFreeze = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


function newRadioProp()
	deleteRadio()
	RequestModel(radioModel)
	while not HasModelLoaded(radioModel) do
		Citizen.Wait(1)
	end
	phoneProp = CreateObject(radioModel, 1.0, 1.0, 1.0, 1, 1, 0)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
  AttachEntityToEntity(phoneProp, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
  print("newRadio")
  local dict = "cellphone@"
	if IsPedInAnyVehicle(myPedId, false) then
		dict = "anim@cellphone@in_car@ps"
	end
	loadAnimDict(dict)
  TaskPlayAnim(GetPlayerPed(-1), dict, "cellphone_text_in", 3.0, -1, -1, 50, 0, false, false, false)
end

function deleteRadio ()
	if phoneProp ~= 0 then
		DeleteEntity(phoneProp)
    phoneProp = 0
	end
end

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end

local radioMenu = false

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end



function enableRadio(enable)

  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({

    type = "enableui",
    enable = enable

  })
  newRadioProp()
end

--- sprawdza czy komenda /radio jest włączony

-- RegisterCommand('telsiz', function(source, args)
--       enableRadio(true)
    
-- end, false)


-- radio test

-- RegisterCommand('telsizkanal', function(source, args)
--   local playerName = GetPlayerName(PlayerId())
--   local data = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

--   print(tonumber(data))

--   if data == "nil" then
--     exports['mythic_notify']:SendAlert('inform', Config.messages['not_on_radio'])
--   else
--    exports['mythic_notify']:SendAlert('inform', Config.messages['on_radio'] .. data .. '.00 MHz </b>')
--  end

-- end, false)

-- dołączanie do radia

RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local PlayerData = ESX.GetPlayerData(_source)
    local playerName = GetPlayerName(PlayerId())
    local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
        if tonumber(data.channel) <= Config.RestrictedChannels then
          if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'sheriff') then
            exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
            exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
            exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
            exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>')
          elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'sheriff') then
            exports['mythic_notify']:SendAlert('error', Config.messages['restricted_channel_error'])
          end
        end
        if tonumber(data.channel) > Config.RestrictedChannels then
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
          exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
          exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>')
        end
      else
        exports['mythic_notify']:SendAlert('error', Config.messages['you_on_radio'] .. data.channel .. ' MHz </b>')
      end
      --[[
    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
    exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
    PrintChatMessage("radio: " .. data.channel)
    print('radiook')
      ]]--
    cb('ok')
end)

-- opuszczanie radia

RegisterNUICallback('leaveRadio', function(data, cb)
   local playerName = GetPlayerName(PlayerId())
   local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if getPlayerRadioChannel == "nil" then
      exports['mythic_notify']:SendAlert('inform', Config.messages['not_on_radio'])
    else
      exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
      exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
      exports['mythic_notify']:SendAlert('inform', Config.messages['you_leave'] .. getPlayerRadioChannel .. ' MHz </b>')
    end

   cb('ok')

end)

RegisterNUICallback('escape', function(data, cb)

    enableRadio(false)
    SetNuiFocus(false, false)
    deleteRadio ()
    TaskPlayAnim(GetPlayerPed(-1), "cellphone@", "cellphone_text_out", 3.0, -1, -1, 50, 0, false, false, false)
    Citizen.Wait(1700)
    ClearPedTasks(GetPlayerPed(-1))
    cb('ok')
end)

-- net eventy

RegisterNetEvent('cylex_radio:use')
AddEventHandler('cylex_radio:use', function()
  enableRadio(true)
end)

RegisterNetEvent('cylex_radio:onRadioDrop')
AddEventHandler('cylex_radio:onRadioDrop', function()
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")


  if getPlayerRadioChannel ~= "nil" then

    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
    exports['mythic_notify']:SendAlert('error', 'Telsizden çıkartıldın', 4000)

  end
end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
