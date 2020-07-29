Config = {}

Config.RestrictedChannels = 10 -- channels that are encrypted (EMS, Fire and police can be included there) if we give eg 10, channels from 1 - 10 will be encrypted
Config.enableCmd = false --  /radio command should be active or not (if not you have to carry the item "radio") true / false

Config.messages = {

  ['not_on_radio'] = 'Her hangi bir telsiz kanalında değilsin',
  ['on_radio'] = 'Şuanda telsiz kanalındasın: <b>',
  ['joined_to_radio'] = 'Telsiz kanalına katıldın: <b>',
  ['restricted_channel_error'] = 'Polislere özel kanallara giremezsin!',
  ['you_on_radio'] = 'Zaten telsiz kanalındasın: <b>',
  ['you_leave'] = 'Telsiz kanalından ayrıldın: <b>'

}
