require "Wherigo"
ZonePoint = Wherigo.ZonePoint
Distance = Wherigo.Distance
Player = Wherigo.Player

-- String decode --
function _cAnoM(str)
	local res = ""
    local dtable = "\028\087\052\051\081\001\000\121\009\020\096\112\017\007\066\034\105\024\057\089\054\101\014\040\109\003\032\012\011\090\049\030\031\086\123\125\065\036\008\119\044\033\037\073\006\110\107\085\095\115\047\102\120\070\116\077\058\021\111\124\098\042\084\075\035\103\106\022\041\080\068\027\091\059\088\061\083\072\039\002\074\013\126\078\100\005\067\122\063\038\004\097\060\029\025\092\018\062\094\076\053\050\118\016\079\046\019\082\093\108\026\055\114\104\056\010\117\113\048\043\015\045\099\023\069\071\064"
	for i=1, #str do
        local b = str:byte(i)
        if b > 0 and b <= 0x7F then
	        res = res .. string.char(dtable:byte(b))
        else
            res = res .. string.char(b)
        end
	end
	return res
end

-- Internal functions --
require "table"
require "math"

math.randomseed(os.time())
math.random()
math.random()
math.random()

_Urwigo = {}

_Urwigo.InlineRequireLoaded = {}
_Urwigo.InlineRequireRes = {}
_Urwigo.InlineRequire = function(moduleName)
  local res
  if _Urwigo.InlineRequireLoaded[moduleName] == nil then
    res = _Urwigo.InlineModuleFunc[moduleName]()
    _Urwigo.InlineRequireLoaded[moduleName] = 1
    _Urwigo.InlineRequireRes[moduleName] = res
  else
    res = _Urwigo.InlineRequireRes[moduleName]
  end
  return res
end

_Urwigo.Round = function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

_Urwigo.Ceil = function(num, idp)
  local mult = 10^(idp or 0)
  return math.ceil(num * mult) / mult
end

_Urwigo.Floor = function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult) / mult
end

_Urwigo.DialogQueue = {}
_Urwigo.RunDialogs = function(callback)
	local dialogs = _Urwigo.DialogQueue
	local lastCallback = nil
	_Urwigo.DialogQueue = {}
	local msgcb = {}
	msgcb = function(action)
		if action ~= nil then
			if lastCallback ~= nil then
				lastCallback(action)
			end
			local entry = table.remove(dialogs, 1)
			if entry ~= nil then
				lastCallback = entry.Callback;
				if entry.Text ~= nil then
					Wherigo.MessageBox({Text = entry.Text, Media=entry.Media, Buttons=entry.Buttons, Callback=msgcb})
				else
					msgcb(action)
				end
			else
				if callback ~= nil then
					callback()
				end
			end
		end
	end
	msgcb(true) -- any non-null argument
end

_Urwigo.MessageBox = function(tbl)
    _Urwigo.RunDialogs(function() Wherigo.MessageBox(tbl) end)
end

_Urwigo.OldDialog = function(tbl)
    _Urwigo.RunDialogs(function() Wherigo.Dialog(tbl) end)
end

_Urwigo.Dialog = function(buffered, tbl, callback)
	for k,v in ipairs(tbl) do
		table.insert(_Urwigo.DialogQueue, v)
	end
	if callback ~= nil then
		table.insert(_Urwigo.DialogQueue, {Callback=callback})
	end
	if not buffered then
		_Urwigo.RunDialogs(nil)
	end
end

_Urwigo.Hash = function(str)
   local b = 378551;
   local a = 63689;
   local hash = 0;
   for i = 1, #str, 1 do
      hash = hash*a+string.byte(str,i);
      hash = math.fmod(hash, 65535)
      a = a*b;
      a = math.fmod(a, 65535)
   end
   return hash;
end

_Urwigo.DaysInMonth = {
	31,
	28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
}

_Urwigo_Date_IsLeapYear = function(year)
	if year % 400 == 0 then
		return true
	elseif year% 100 == 0 then
		return false
	elseif year % 4 == 0 then
		return true
	else
		return false
	end
end

_Urwigo.Date_DaysInMonth = function(year, month)
	if month ~= 2 then
		return _Urwigo.DaysInMonth[month];
	else
		if _Urwigo_Date_IsLeapYear(year) then
			return 29
		else
			return 28
		end
	end
end

_Urwigo.Date_DayInYear = function(t)
	local res = t.day
	for month = 1, t.month - 1 do
		res = res + _Urwigo.Date_DaysInMonth(t.year, month)
	end
	return res
end

_Urwigo.Date_HourInWeek = function(t)
	return t.hour + (t.wday-1) * 24
end

_Urwigo.Date_HourInMonth = function(t)
	return t.hour + t.day * 24
end

_Urwigo.Date_HourInYear = function(t)
	return t.hour + (_Urwigo.Date_DayInYear(t) - 1) * 24
end

_Urwigo.Date_MinuteInDay = function(t)
	return t.min + t.hour * 60
end

_Urwigo.Date_MinuteInWeek = function(t)
	return t.min + t.hour * 60 + (t.wday-1) * 1440;
end

_Urwigo.Date_MinuteInMonth = function(t)
	return t.min + t.hour * 60 + (t.day-1) * 1440;
end

_Urwigo.Date_MinuteInYear = function(t)
	return t.min + t.hour * 60 + (_Urwigo.Date_DayInYear(t) - 1) * 1440;
end

_Urwigo.Date_SecondInHour = function(t)
	return t.sec + t.min * 60
end

_Urwigo.Date_SecondInDay = function(t)
	return t.sec + t.min * 60 + t.hour * 3600
end

_Urwigo.Date_SecondInWeek = function(t)
	return t.sec + t.min * 60 + t.hour * 3600 + (t.wday-1) * 86400
end

_Urwigo.Date_SecondInMonth = function(t)
	return t.sec + t.min * 60 + t.hour * 3600 + (t.day-1) * 86400
end

_Urwigo.Date_SecondInYear = function(t)
	return t.sec + t.min * 60 + t.hour * 3600 + (_Urwigo.Date_DayInYear(t)-1) * 86400
end


-- Inlined modules --
_Urwigo.InlineModuleFunc = {}

objWherigoTestsuiteEN = Wherigo.ZCartridge()

-- Media --
objAniPic1 = Wherigo.ZMedia(objWherigoTestsuiteEN)
objAniPic1.Id = "4948331b-a79d-4e98-80dd-ad2307123140"
objAniPic1.Name = "AniPic1"
objAniPic1.Description = ""
objAniPic1.AltText = ""
objAniPic1.Resources = {
	{
		Type = "jpg", 
		Filename = "Anipic1.jpg", 
		Directives = {}
	}
}
objAniPic2 = Wherigo.ZMedia(objWherigoTestsuiteEN)
objAniPic2.Id = "d86eac20-caa0-4312-b396-3687eaaf85a0"
objAniPic2.Name = "AniPic2"
objAniPic2.Description = ""
objAniPic2.AltText = ""
objAniPic2.Resources = {
	{
		Type = "jpg", 
		Filename = "Anipic2.jpg", 
		Directives = {}
	}
}
objAniPic3 = Wherigo.ZMedia(objWherigoTestsuiteEN)
objAniPic3.Id = "4cfa2296-381a-4f54-b166-2c3e4f35746a"
objAniPic3.Name = "AniPic3"
objAniPic3.Description = ""
objAniPic3.AltText = ""
objAniPic3.Resources = {
	{
		Type = "jpg", 
		Filename = "Anipic3.jpg", 
		Directives = {}
	}
}
objAniPic4 = Wherigo.ZMedia(objWherigoTestsuiteEN)
objAniPic4.Id = "e1cb306a-41ec-417c-9692-69d121ff09d2"
objAniPic4.Name = "AniPic4"
objAniPic4.Description = ""
objAniPic4.AltText = ""
objAniPic4.Resources = {
	{
		Type = "jpg", 
		Filename = "Anipic4.jpg", 
		Directives = {}
	}
}
objAniPic5 = Wherigo.ZMedia(objWherigoTestsuiteEN)
objAniPic5.Id = "3efa250a-fd3e-4219-94d8-1a6b4eba98f3"
objAniPic5.Name = "AniPic5"
objAniPic5.Description = ""
objAniPic5.AltText = ""
objAniPic5.Resources = {
	{
		Type = "jpg", 
		Filename = "Anipic5.jpg", 
		Directives = {}
	}
}
objPhoneRing = Wherigo.ZMedia(objWherigoTestsuiteEN)
objPhoneRing.Id = "d4463aa5-8fe2-438c-956d-e056bd5593e3"
objPhoneRing.Name = "PhoneRing"
objPhoneRing.Description = ""
objPhoneRing.AltText = ""
objPhoneRing.Resources = {
	{
		Type = "mp3", 
		Filename = "phone.mp3", 
		Directives = {}
	}, 
	{
		Type = "fdl", 
		Filename = "phone.fdl", 
		Directives = {}
	}
}
objAnipic6 = Wherigo.ZMedia(objWherigoTestsuiteEN)
objAnipic6.Id = "568d1eaf-fbba-4c2f-ba17-d5a04e8c5059"
objAnipic6.Name = "Anipic6"
objAnipic6.Description = ""
objAnipic6.AltText = ""
objAnipic6.Resources = {
	{
		Type = "jpg", 
		Filename = "Anipic6.jpg", 
		Directives = {}
	}
}
objTaskicon = Wherigo.ZMedia(objWherigoTestsuiteEN)
objTaskicon.Id = "bdbc88ff-32cc-4933-8584-3f00ad6de61f"
objTaskicon.Name = "Taskicon"
objTaskicon.Description = ""
objTaskicon.AltText = ""
objTaskicon.Resources = {
	{
		Type = "jpg", 
		Filename = "Task.jpg", 
		Directives = {}
	}
}
objZone = Wherigo.ZMedia(objWherigoTestsuiteEN)
objZone.Id = "da5807e8-d702-48eb-9d81-ea4eae5f7f91"
objZone.Name = "Zone"
objZone.Description = ""
objZone.AltText = ""
objZone.Resources = {
	{
		Type = "jpg", 
		Filename = "Zone.jpg", 
		Directives = {}
	}
}
obj115x170 = Wherigo.ZMedia(objWherigoTestsuiteEN)
obj115x170.Id = "5e74e893-badb-4e2b-be83-52b0f902dd2b"
obj115x170.Name = "115x170"
obj115x170.Description = ""
obj115x170.AltText = ""
obj115x170.Resources = {
	{
		Type = "jpg", 
		Filename = "115x170.jpg", 
		Directives = {}
	}
}
obj230x340 = Wherigo.ZMedia(objWherigoTestsuiteEN)
obj230x340.Id = "3e516949-3a5f-46e4-894f-a3cf15763971"
obj230x340.Name = "230x340"
obj230x340.Description = ""
obj230x340.AltText = ""
obj230x340.Resources = {
	{
		Type = "jpg", 
		Filename = "230x340.jpg", 
		Directives = {}
	}
}
obj540x800 = Wherigo.ZMedia(objWherigoTestsuiteEN)
obj540x800.Id = "b7627428-41ca-41a2-8e52-349be2605f87"
obj540x800.Name = "540x800"
obj540x800.Description = ""
obj540x800.AltText = ""
obj540x800.Resources = {
	{
		Type = "jpg", 
		Filename = "540x800.jpg", 
		Directives = {}
	}
}
objSound_high = Wherigo.ZMedia(objWherigoTestsuiteEN)
objSound_high.Id = "9704bbdd-3de2-4b62-bfca-09c81e4bba78"
objSound_high.Name = "Sound_high"
objSound_high.Description = ""
objSound_high.AltText = ""
objSound_high.Resources = {
	{
		Type = "mp3", 
		Filename = "sound_high.mp3", 
		Directives = {}
	}
}
objSound_low = Wherigo.ZMedia(objWherigoTestsuiteEN)
objSound_low.Id = "62df6279-a036-4b91-aaa5-51ece276b665"
objSound_low.Name = "Sound_low"
objSound_low.Description = ""
objSound_low.AltText = ""
objSound_low.Resources = {
	{
		Type = "mp3", 
		Filename = "sound_low.mp3", 
		Directives = {}
	}
}
objNullsound = Wherigo.ZMedia(objWherigoTestsuiteEN)
objNullsound.Id = "faf20d92-04b7-4b89-a68f-0e15c4440a87"
objNullsound.Name = "Nullsound"
objNullsound.Description = ""
objNullsound.AltText = ""
objNullsound.Resources = {
	{
		Type = "mp3", 
		Filename = "nullsound.mp3", 
		Directives = {}
	}
}
objSpecChars = Wherigo.ZMedia(objWherigoTestsuiteEN)
objSpecChars.Id = "f0d9d356-2193-4137-9358-3ae3981fc637"
objSpecChars.Name = "SpecChars"
objSpecChars.Description = ""
objSpecChars.AltText = ""
objSpecChars.Resources = {
	{
		Type = "jpg", 
		Filename = "specchars.jpg", 
		Directives = {}
	}
}
objAniGif = Wherigo.ZMedia(objWherigoTestsuiteEN)
objAniGif.Id = "b3d4a747-38fc-4e69-8377-3f40d9bf3e88"
objAniGif.Name = "AniGif"
objAniGif.Description = ""
objAniGif.AltText = ""
objAniGif.Resources = {
	{
		Type = "gif", 
		Filename = "GifAni1.gif", 
		Directives = {}
	}
}
objJPGFormat = Wherigo.ZMedia(objWherigoTestsuiteEN)
objJPGFormat.Id = "0ec566dc-5694-4b65-82f2-df691b065c33"
objJPGFormat.Name = "JPGFormat"
objJPGFormat.Description = ""
objJPGFormat.AltText = "Your player does not support the JPG Format"
objJPGFormat.Resources = {
	{
		Type = "jpg", 
		Filename = "jpgformat.jpg", 
		Directives = {}
	}
}
objGifFormat = Wherigo.ZMedia(objWherigoTestsuiteEN)
objGifFormat.Id = "c0533cbf-a98c-4dd4-bde3-e869967b1629"
objGifFormat.Name = "GifFormat"
objGifFormat.Description = ""
objGifFormat.AltText = "Your player does not support the GIF Format"
objGifFormat.Resources = {
	{
		Type = "gif", 
		Filename = "gifformat.gif", 
		Directives = {}
	}
}
objPNGFormat = Wherigo.ZMedia(objWherigoTestsuiteEN)
objPNGFormat.Id = "413d2654-59c9-46b5-a06f-7dee8156af49"
objPNGFormat.Name = "PNGFormat"
objPNGFormat.Description = ""
objPNGFormat.AltText = "Your player does not support the PNG Format"
objPNGFormat.Resources = {
	{
		Type = "png", 
		Filename = "pngformat.png", 
		Directives = {}
	}
}
objBMPFormat = Wherigo.ZMedia(objWherigoTestsuiteEN)
objBMPFormat.Id = "70042846-a1d4-451f-9fdd-2ba2abaa024f"
objBMPFormat.Name = "BMPFormat"
objBMPFormat.Description = ""
objBMPFormat.AltText = "Your player does not support the BMP Format"
objBMPFormat.Resources = {
	{
		Type = "bmp", 
		Filename = "bmpformat.bmp", 
		Directives = {}
	}
}
objSound_Wav = Wherigo.ZMedia(objWherigoTestsuiteEN)
objSound_Wav.Id = "4a415b95-2731-4fd6-991c-d7317eaeec79"
objSound_Wav.Name = "Sound_Wav"
objSound_Wav.Description = ""
objSound_Wav.AltText = ""
objSound_Wav.Resources = {
	{
		Type = "wav", 
		Filename = "sound_high.wav", 
		Directives = {}
	}
}
objSound_Ogg = Wherigo.ZMedia(objWherigoTestsuiteEN)
objSound_Ogg.Id = "cd52d2c4-388d-4081-9946-7290deeec6af"
objSound_Ogg.Name = "Sound_Ogg"
objSound_Ogg.Description = ""
objSound_Ogg.AltText = ""
objSound_Ogg.Resources = {
	{
		Type = "ogg", 
		Filename = "sound_high.ogg", 
		Directives = {}
	}
}
objTestpic = Wherigo.ZMedia(objWherigoTestsuiteEN)
objTestpic.Id = "68db671e-e90d-4910-97f1-52f89e6e78f8"
objTestpic.Name = "Testpic"
objTestpic.Description = ""
objTestpic.AltText = ""
objTestpic.Resources = {
	{
		Type = "jpg", 
		Filename = "testbild.jpg", 
		Directives = {}
	}
}
objNotify = Wherigo.ZMedia(objWherigoTestsuiteEN)
objNotify.Id = "491aa9c5-52b8-49e2-ba62-04f1605a8a2a"
objNotify.Name = "Notify"
objNotify.Description = ""
objNotify.AltText = ""
objNotify.Resources = {
	{
		Type = "mp3", 
		Filename = "notify.mp3", 
		Directives = {}
	}, 
	{
		Type = "fdl", 
		Filename = "notify.fdl", 
		Directives = {}
	}
}
objTelSilent = Wherigo.ZMedia(objWherigoTestsuiteEN)
objTelSilent.Id = "3c0b4bd8-1337-441f-9fec-2d5a8716b1bd"
objTelSilent.Name = "TelSilent"
objTelSilent.Description = ""
objTelSilent.AltText = ""
objTelSilent.Resources = {
	{
		Type = "jpg", 
		Filename = "TelSilent.jpg", 
		Directives = {}
	}
}
objTelRing = Wherigo.ZMedia(objWherigoTestsuiteEN)
objTelRing.Id = "9aeeff3b-33f3-4c69-ae09-ebe5b6ea8ddb"
objTelRing.Name = "TelRing"
objTelRing.Description = ""
objTelRing.AltText = ""
objTelRing.Resources = {
	{
		Type = "jpg", 
		Filename = "TelRing.jpg", 
		Directives = {}
	}
}
objTelRingIcon = Wherigo.ZMedia(objWherigoTestsuiteEN)
objTelRingIcon.Id = "4a44399d-d4ae-40c2-a674-36fddb6e88fe"
objTelRingIcon.Name = "TelRingIcon"
objTelRingIcon.Description = ""
objTelRingIcon.AltText = ""
objTelRingIcon.Resources = {
	{
		Type = "jpg", 
		Filename = "Icon_TelRing.jpg", 
		Directives = {}
	}
}
objTelSilentIcon = Wherigo.ZMedia(objWherigoTestsuiteEN)
objTelSilentIcon.Id = "dad1fffc-e1e8-4507-a207-69ec8accb8ab"
objTelSilentIcon.Name = "TelSilentIcon"
objTelSilentIcon.Description = ""
objTelSilentIcon.AltText = ""
objTelSilentIcon.Resources = {
	{
		Type = "jpg", 
		Filename = "Icon_TelSilent.jpg", 
		Directives = {}
	}
}
-- Cartridge Info --
objWherigoTestsuiteEN.Id="0b5a3e94-f200-4999-9d22-00fe7b32fb9b"
objWherigoTestsuiteEN.Name="Wherigo Testsuite (EN)"
objWherigoTestsuiteEN.Description=[[]]
objWherigoTestsuiteEN.Visible=true
objWherigoTestsuiteEN.Activity="TourGuide"
objWherigoTestsuiteEN.StartingLocationDescription=[[The Wherigo Testsuite by jonny65]]
objWherigoTestsuiteEN.StartingLocation = Wherigo.INVALID_ZONEPOINT
objWherigoTestsuiteEN.Version="1.8"
objWherigoTestsuiteEN.Company="JonnyCache"
objWherigoTestsuiteEN.Author="jonny65"
objWherigoTestsuiteEN.BuilderVersion="URWIGO 1.20.5218.24064"
objWherigoTestsuiteEN.CreateDate="12/15/2011 14:05:43"
objWherigoTestsuiteEN.PublishDate="1/1/0001 12:00:00 AM"
objWherigoTestsuiteEN.UpdateDate="11/18/2014 19:59:56"
objWherigoTestsuiteEN.LastPlayedDate="1/1/0001 12:00:00 AM"
objWherigoTestsuiteEN.TargetDevice="PocketPC"
objWherigoTestsuiteEN.TargetDeviceVersion="0"
objWherigoTestsuiteEN.StateId="1"
objWherigoTestsuiteEN.CountryId="2"
objWherigoTestsuiteEN.Complete=false
objWherigoTestsuiteEN.UseLogging=true

objWherigoTestsuiteEN.Media=objTestpic

objWherigoTestsuiteEN.Icon=objTestpic


-- Zones --
PlayersZone = Wherigo.Zone(objWherigoTestsuiteEN)
PlayersZone.Id = "93cbda1d-ea12-429d-ac19-56214d3ff47a"
PlayersZone.Name = "PlayersZone"
PlayersZone.Description = "The playerzone where you can check the enter and exit event. Also if the player crashes if you have an open input. While entering the zone also a sound will be fired. Can you hear it too, if your device is in standby mode ? The zone should have an icon, but some players do not show them, they have direction values or symbols instead (distance and direction)."
PlayersZone.Visible = true
PlayersZone.Media = objZone
PlayersZone.Icon = objZone
PlayersZone.Commands = {
	cmdZoneCommand = Wherigo.ZCommand{
		Text = "ZoneCommand", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
PlayersZone.Commands.cmdZoneCommand.Custom = true
PlayersZone.Commands.cmdZoneCommand.Id = "a38b074a-2902-4e12-b7be-4a2c074b13f3"
PlayersZone.Commands.cmdZoneCommand.WorksWithAll = true
PlayersZone.DistanceRange = Distance(-1, "feet")
PlayersZone.ShowObjects = "OnEnter"
PlayersZone.ProximityRange = Distance(60, "meters")
PlayersZone.AllowSetPositionTo = false
PlayersZone.Active = false
PlayersZone.Points = {
	ZonePoint(47.6147950642962, 9.59668175816523, 0), 
	ZonePoint(47.6147372047947, 9.5964242660998, 0), 
	ZonePoint(47.6144189763918, 9.59629552006709, 0)
}
PlayersZone.OriginalPoint = ZonePoint(47.6146504151609, 9.59646718144404, 0)
PlayersZone.DistanceRangeUOM = "Feet"
PlayersZone.ProximityRangeUOM = "Meters"
PlayersZone.OutOfRangeName = ""
PlayersZone.InRangeName = ""
objDemozone = Wherigo.Zone(objWherigoTestsuiteEN)
objDemozone.Id = "2fb8c64e-e6e1-4174-818b-43613f43cfcc"
objDemozone.Name = "Demozone"
objDemozone.Description = "These object is only demo and will be called from the motheritem Objectdetails. On some players (garmin) the zone commands do not work."
objDemozone.Visible = true
objDemozone.Commands = {
	cmdTomotheritem = Wherigo.ZCommand{
		Text = "To motheritem", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdMainmenue = Wherigo.ZCommand{
		Text = "Mainmenue", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objDemozone.Commands.cmdTomotheritem.Custom = true
objDemozone.Commands.cmdTomotheritem.Id = "c6eee442-69fe-47bc-ba96-45abfe147946"
objDemozone.Commands.cmdTomotheritem.WorksWithAll = true
objDemozone.Commands.cmdMainmenue.Custom = true
objDemozone.Commands.cmdMainmenue.Id = "e295f0da-7f6a-46ce-b299-ffe1b26db7df"
objDemozone.Commands.cmdMainmenue.WorksWithAll = true
objDemozone.DistanceRange = Distance(-1, "feet")
objDemozone.ShowObjects = "OnEnter"
objDemozone.ProximityRange = Distance(60, "meters")
objDemozone.AllowSetPositionTo = false
objDemozone.Active = true
objDemozone.Points = {
	ZonePoint(49.4713939947246, 11.0069918632507, 0), 
	ZonePoint(49.4713521633431, 11.0082793235779, 0), 
	ZonePoint(49.4707665202509, 11.0075390338898, 0)
}
objDemozone.OriginalPoint = ZonePoint(49.4711708927729, 11.0076034069061, 0)
objDemozone.DistanceRangeUOM = "Feet"
objDemozone.ProximityRangeUOM = "Meters"
objDemozone.OutOfRangeName = ""
objDemozone.InRangeName = ""

-- Characters --
objDemocharacter = Wherigo.ZCharacter{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objDemocharacter.Id = "b6a28242-6920-48a4-91ee-cb958d054517"
objDemocharacter.Name = "Democharacter"
objDemocharacter.Description = "These object is only demo and will be called from the motheritem Objectdetails. On some players this does not work."
objDemocharacter.Visible = true
objDemocharacter.Commands = {
	cmdTomotheritem = Wherigo.ZCommand{
		Text = "To motheritem", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdMainmenu = Wherigo.ZCommand{
		Text = "Mainmenu", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objDemocharacter.Commands.cmdTomotheritem.Custom = true
objDemocharacter.Commands.cmdTomotheritem.Id = "ac782788-1fbf-4cdd-8c88-59d794cf2e3d"
objDemocharacter.Commands.cmdTomotheritem.WorksWithAll = true
objDemocharacter.Commands.cmdMainmenu.Custom = true
objDemocharacter.Commands.cmdMainmenu.Id = "53d83fa4-672e-4a25-adda-1194446dda74"
objDemocharacter.Commands.cmdMainmenu.WorksWithAll = true
objDemocharacter.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objDemocharacter.Gender = "Male"
objDemocharacter.Type = "NPC"

-- Items --
objSetPlayerZone = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objSetPlayerZone.Id = "5bb06635-b5bb-4cb8-ae63-61b37f390bbf"
objSetPlayerZone.Name = "Set PlayerZone"
objSetPlayerZone.Description = "Go outside, turn your GPS on and look for a proper place where you can set the zone. It will be activated in a distance of approximatelly 20 meters or 70 feet course NORTH."
objSetPlayerZone.Visible = true
objSetPlayerZone.Commands = {
	cmdSetthezone = Wherigo.ZCommand{
		Text = "Set the zone", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objSetPlayerZone.Commands.cmdSetthezone.Custom = true
objSetPlayerZone.Commands.cmdSetthezone.Id = "5799a263-e2ab-4d48-a8af-41b4f0c02f6a"
objSetPlayerZone.Commands.cmdSetthezone.WorksWithAll = true
objSetPlayerZone.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objSetPlayerZone.Locked = false
objSetPlayerZone.Opened = false
objToggleatask = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objToggleatask.Id = "781488f7-95ee-4b2e-80b6-b37c847903d6"
objToggleatask.Name = "Toggle a task"
objToggleatask.Description = "Here you can set the status of the demotask. Set it to complete, incomplete, correct, not correct and set correction to none. The correction is nearly never used and  often does not work ! The status of the task you can see in its description. The null task we need to show a completed task. By the way, the null task should have an icon, is your player able to see it ? Note : Simulator may fail or crash on setting correctness."
objToggleatask.Visible = true
objToggleatask.Commands = {
	cmdIncomplete = Wherigo.ZCommand{
		Text = "Incomplete", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdComplete = Wherigo.ZCommand{
		Text = "Complete", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdCorrect = Wherigo.ZCommand{
		Text = "Correct", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdNotcorrect = Wherigo.ZCommand{
		Text = "Not correct", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdCorrectnessnone = Wherigo.ZCommand{
		Text = "Correctness none", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}
}
objToggleatask.Commands.cmdIncomplete.Custom = true
objToggleatask.Commands.cmdIncomplete.Id = "d6edbb22-30be-4603-bf80-bff44af9ebe7"
objToggleatask.Commands.cmdIncomplete.WorksWithAll = true
objToggleatask.Commands.cmdComplete.Custom = true
objToggleatask.Commands.cmdComplete.Id = "ae67a477-279a-449f-8506-34ac3006bc2b"
objToggleatask.Commands.cmdComplete.WorksWithAll = true
objToggleatask.Commands.cmdCorrect.Custom = true
objToggleatask.Commands.cmdCorrect.Id = "7e1cf8a2-d4e1-45ca-9792-d0d4502548c5"
objToggleatask.Commands.cmdCorrect.WorksWithAll = true
objToggleatask.Commands.cmdNotcorrect.Custom = true
objToggleatask.Commands.cmdNotcorrect.Id = "c4d63ac5-a854-4436-b1ea-65f790f69c18"
objToggleatask.Commands.cmdNotcorrect.WorksWithAll = true
objToggleatask.Commands.cmdCorrectnessnone.Custom = true
objToggleatask.Commands.cmdCorrectnessnone.Id = "fb73c3c0-5702-4f55-a6d4-086a88a2a3de"
objToggleatask.Commands.cmdCorrectnessnone.WorksWithAll = true
objToggleatask.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objToggleatask.Locked = false
objToggleatask.Opened = false
objInputs = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objInputs.Id = "bbf827d2-ecfd-49d9-af13-bba908860c2c"
objInputs.Name = "Inputs"
objInputs.Description = "Make an input. Also check the \"garmin crash symptome\". Leave the input editfield open and exit the zone. Garmin crashes because the exit message overlies the opened input. Other devices not ? By the way, same effect in emulator, it shows you a beautiful blue screen ;-)"
objInputs.Visible = true
objInputs.Commands = {
	cmdInputanumber = Wherigo.ZCommand{
		Text = "Input a number", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdInputchars = Wherigo.ZCommand{
		Text = "Input chars", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdChoiceinput = Wherigo.ZCommand{
		Text = "Choice input", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdInputloop = Wherigo.ZCommand{
		Text = "Input loop", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdInputwithpic = Wherigo.ZCommand{
		Text = "Input with pic", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objInputs.Commands.cmdInputanumber.Custom = true
objInputs.Commands.cmdInputanumber.Id = "b8f6ac35-a6b3-4fc7-b61b-531944ffde7e"
objInputs.Commands.cmdInputanumber.WorksWithAll = true
objInputs.Commands.cmdInputchars.Custom = true
objInputs.Commands.cmdInputchars.Id = "5c3ede3e-0516-474a-b4a8-52130a5f7a3e"
objInputs.Commands.cmdInputchars.WorksWithAll = true
objInputs.Commands.cmdChoiceinput.Custom = true
objInputs.Commands.cmdChoiceinput.Id = "26f51965-80ee-41fa-8a90-8a1c36d39864"
objInputs.Commands.cmdChoiceinput.WorksWithAll = true
objInputs.Commands.cmdInputloop.Custom = true
objInputs.Commands.cmdInputloop.Id = "7348d9ef-aa64-4e35-97fd-6162f0abef3f"
objInputs.Commands.cmdInputloop.WorksWithAll = true
objInputs.Commands.cmdInputwithpic.Custom = true
objInputs.Commands.cmdInputwithpic.Id = "f93e1c45-a4b1-4dd3-85ba-ff0d59a345d8"
objInputs.Commands.cmdInputwithpic.WorksWithAll = true
objInputs.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objInputs.Locked = false
objInputs.Opened = false
objShowanimation = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objShowanimation.Id = "324596bd-d17e-4a3b-aaab-64e070fc40c6"
objShowanimation.Name = "Show animation"
objShowanimation.Description = "You should see a kind of animation. Each second a new picture appears. There are 2 kinds of animations, via messageboxes and changing an items picture, both 6 times (6 pictures). On some players such animations don't work, I think iPhone has problems with them."
objShowanimation.Visible = true
objShowanimation.Commands = {
	cmdMessage = Wherigo.ZCommand{
		Text = "Message", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdItem = Wherigo.ZCommand{
		Text = "Item", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdGoback = Wherigo.ZCommand{
		Text = "Go back", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objShowanimation.Commands.cmdMessage.Custom = true
objShowanimation.Commands.cmdMessage.Id = "b73157ca-0b25-42ae-9b61-2adf49132a64"
objShowanimation.Commands.cmdMessage.WorksWithAll = true
objShowanimation.Commands.cmdItem.Custom = true
objShowanimation.Commands.cmdItem.Id = "2705ce2d-583a-4733-98e6-1b513c3ca757"
objShowanimation.Commands.cmdItem.WorksWithAll = true
objShowanimation.Commands.cmdGoback.Custom = true
objShowanimation.Commands.cmdGoback.Id = "8cafc9a5-cce0-44c7-ae3a-98ce679c41fb"
objShowanimation.Commands.cmdGoback.WorksWithAll = true
objShowanimation.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objShowanimation.Locked = false
objShowanimation.Opened = false
objPhone1 = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objPhone1.Id = "1d65c031-060f-4775-87cb-2e5d4b343cc6"
objPhone1.Name = "Phone 1"
objPhone1.Description = "The phone should ring every 4 seconds until you press stop. Are 4 seconds in timer also 4 seconds in reality ? These item uses the intervall timer with the \"on Start\" event. Maybe some players do not work with it. In that case you will hear nothing. Note : Emulator often likes to crash when a sound starts."
objPhone1.Visible = true
objPhone1.Commands = {
	cmdLetitring = Wherigo.ZCommand{
		Text = "Let it ring", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdStop = Wherigo.ZCommand{
		Text = "Stop", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}
}
objPhone1.Commands.cmdLetitring.Custom = true
objPhone1.Commands.cmdLetitring.Id = "81f3858b-efc3-491d-82c7-71f15df31a61"
objPhone1.Commands.cmdLetitring.WorksWithAll = true
objPhone1.Commands.cmdStop.Custom = true
objPhone1.Commands.cmdStop.Id = "97809aa8-4afa-4df4-87ed-886e6286b1f6"
objPhone1.Commands.cmdStop.WorksWithAll = true
objPhone1.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objPhone1.Locked = false
objPhone1.Opened = false
objAnimation = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objAnimation.Id = "df3d9e99-b36c-41eb-af77-5a9ce10edff4"
objAnimation.Name = "Animation"
objAnimation.Description = ""
objAnimation.Visible = false
objAnimation.Commands = {}
objAnimation.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objAnimation.Locked = false
objAnimation.Opened = false
objBearing = Wherigo.ZItem(objWherigoTestsuiteEN)
objBearing.Id = "d95d61d0-5775-4c41-a1d9-376f77643642"
objBearing.Name = "Bearing"
objBearing.Description = "If your playerzone is active, these item shows bearing and distance to the CENTER of the zone. Every 2 seconds a measure will be made and shows the values. Depending on device the altitude may be not reliably."
objBearing.Visible = true
objBearing.Commands = {
	cmdStart = Wherigo.ZCommand{
		Text = "Start", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdStop = Wherigo.ZCommand{
		Text = "Stop", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}
}
objBearing.Commands.cmdStart.Custom = true
objBearing.Commands.cmdStart.Id = "f726e1d5-031c-4779-9b20-c4912d995a62"
objBearing.Commands.cmdStart.WorksWithAll = true
objBearing.Commands.cmdStop.Custom = true
objBearing.Commands.cmdStop.Id = "dea9bf2c-71fa-4af0-8c0b-ea9df39232a8"
objBearing.Commands.cmdStop.WorksWithAll = true
objBearing.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objBearing.Locked = false
objBearing.Opened = false
objSystem = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objSystem.Id = "d4e40f33-e860-4c12-a112-a47e1cb35558"
objSystem.Name = "System"
objSystem.Description = "There are some things to check whether the device or player are working correct or compare differences between players."
objSystem.Visible = true
objSystem.Commands = {
	cmdSavegame = Wherigo.ZCommand{
		Text = "Save game", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdEnvironment = Wherigo.ZCommand{
		Text = "Environment", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdWhattimeisit = Wherigo.ZCommand{
		Text = "What time is it ?", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdCompletionstatus = Wherigo.ZCommand{
		Text = "Completion status", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdBackgroundflashes = Wherigo.ZCommand{
		Text = "Background flashes", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdBooleanSave = Wherigo.ZCommand{
		Text = "Boolean Save", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdSimulatorProtection = Wherigo.ZCommand{
		Text = "Simulator Protection", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objSystem.Commands.cmdSavegame.Custom = true
objSystem.Commands.cmdSavegame.Id = "41f3d643-0374-4051-a641-d430021e580b"
objSystem.Commands.cmdSavegame.WorksWithAll = true
objSystem.Commands.cmdEnvironment.Custom = true
objSystem.Commands.cmdEnvironment.Id = "4149aa36-9430-4c98-89ac-89cf876ac10c"
objSystem.Commands.cmdEnvironment.WorksWithAll = true
objSystem.Commands.cmdWhattimeisit.Custom = true
objSystem.Commands.cmdWhattimeisit.Id = "e7d36107-dd65-463e-ac71-30387459839d"
objSystem.Commands.cmdWhattimeisit.WorksWithAll = true
objSystem.Commands.cmdCompletionstatus.Custom = true
objSystem.Commands.cmdCompletionstatus.Id = "c28c2ecc-41ff-43a6-b618-143fee406827"
objSystem.Commands.cmdCompletionstatus.WorksWithAll = true
objSystem.Commands.cmdBackgroundflashes.Custom = true
objSystem.Commands.cmdBackgroundflashes.Id = "dbd8d2b8-dd5d-416c-afc1-f3692561cee2"
objSystem.Commands.cmdBackgroundflashes.WorksWithAll = true
objSystem.Commands.cmdBooleanSave.Custom = true
objSystem.Commands.cmdBooleanSave.Id = "ed45eb3a-951d-473f-9bb1-34afa4637148"
objSystem.Commands.cmdBooleanSave.WorksWithAll = true
objSystem.Commands.cmdSimulatorProtection.Custom = true
objSystem.Commands.cmdSimulatorProtection.Id = "ccf907e3-5e4b-4cb0-ba86-9a6befa03243"
objSystem.Commands.cmdSimulatorProtection.WorksWithAll = true
objSystem.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objSystem.Locked = false
objSystem.Opened = false
objTimertests = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objTimertests.Id = "7ad9a19c-33b8-42ca-8a49-a5197a63aecc"
objTimertests.Name = "Timertests"
objTimertests.Description = "Timers sometimes react in a way which the programmer does not want ;-) Here you can check, whether they countdown and interval timer work with your player correctly."
objTimertests.Visible = true
objTimertests.Commands = {
	cmdCountdown = Wherigo.ZCommand{
		Text = "Countdown", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdIntervall = Wherigo.ZCommand{
		Text = "Intervall", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdTimerduration = Wherigo.ZCommand{
		Text = "Timerduration", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objTimertests.Commands.cmdCountdown.Custom = true
objTimertests.Commands.cmdCountdown.Id = "4e49867c-bcc9-44d2-83ed-eed42a6ac80c"
objTimertests.Commands.cmdCountdown.WorksWithAll = true
objTimertests.Commands.cmdIntervall.Custom = true
objTimertests.Commands.cmdIntervall.Id = "5bae9767-e4f9-44b9-9699-0df70710f2d1"
objTimertests.Commands.cmdIntervall.WorksWithAll = true
objTimertests.Commands.cmdTimerduration.Custom = true
objTimertests.Commands.cmdTimerduration.Id = "2486d27a-0463-474e-ab8c-e7ed0b159076"
objTimertests.Commands.cmdTimerduration.WorksWithAll = true
objTimertests.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objTimertests.Locked = false
objTimertests.Opened = false
objCounterdisplay = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objCounterdisplay.Id = "04769edf-b66c-4559-81d4-8338ae8d5552"
objCounterdisplay.Name = "Counterdisplay"
objCounterdisplay.Description = ""
objCounterdisplay.Visible = false
objCounterdisplay.Commands = {
	cmdStopandback = Wherigo.ZCommand{
		Text = "Stop and back", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objCounterdisplay.Commands.cmdStopandback.Custom = true
objCounterdisplay.Commands.cmdStopandback.Id = "2f0159b2-c2e8-494f-8223-af2767793d30"
objCounterdisplay.Commands.cmdStopandback.WorksWithAll = true
objCounterdisplay.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objCounterdisplay.Locked = false
objCounterdisplay.Opened = false
objPhone2 = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objPhone2.Id = "69b4d8c2-3282-4bef-bf3a-23336aadb06c"
objPhone2.Name = "Phone 2"
objPhone2.Description = "The phone should ring every 4 seconds until you press stop. Are 4 seconds in timer also 4 seconds in reality ? These item uses the intervall timer with the \"on Elapse\" event. This should work on most of the players. The very first sound is called directly after starting. Note : Emulator often likes to crash when a sound starts."
objPhone2.Visible = true
objPhone2.Commands = {
	cmdLetitring = Wherigo.ZCommand{
		Text = "Let it ring", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdStop = Wherigo.ZCommand{
		Text = "Stop", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}
}
objPhone2.Commands.cmdLetitring.Custom = true
objPhone2.Commands.cmdLetitring.Id = "31d2a821-e129-4681-8796-0e9c2ba9c867"
objPhone2.Commands.cmdLetitring.WorksWithAll = true
objPhone2.Commands.cmdStop.Custom = true
objPhone2.Commands.cmdStop.Id = "2d9096d9-c132-4bad-9892-23ea4cca3ff5"
objPhone2.Commands.cmdStop.WorksWithAll = true
objPhone2.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objPhone2.Locked = false
objPhone2.Opened = false
objPicsandChars = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objPicsandChars.Id = "e569f7e9-abad-4630-ae70-64a700e18625"
objPicsandChars.Name = "Pics and Chars"
objPicsandChars.Description = "Are your player able to show specific chars and displays pictures in the right dimension ? Can it read all formats, perhaps an animated gif ? Here you can check it out ..."
objPicsandChars.Visible = true
objPicsandChars.Commands = {
	cmdSpecificchars = Wherigo.ZCommand{
		Text = "Specific chars", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdAnimatedGif = Wherigo.ZCommand{
		Text = "Animated Gif", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPicturesize = Wherigo.ZCommand{
		Text = "Picturesize", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPictureformat = Wherigo.ZCommand{
		Text = "Pictureformat", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdLinebreak = Wherigo.ZCommand{
		Text = "Line break", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdMarkdown = Wherigo.ZCommand{
		Text = "Markdown", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objPicsandChars.Commands.cmdSpecificchars.Custom = true
objPicsandChars.Commands.cmdSpecificchars.Id = "209a5eeb-e1e9-48a2-9348-b76442ef3c82"
objPicsandChars.Commands.cmdSpecificchars.WorksWithAll = true
objPicsandChars.Commands.cmdAnimatedGif.Custom = true
objPicsandChars.Commands.cmdAnimatedGif.Id = "c7797f33-2ffa-49ce-8f51-a572fa25a5ef"
objPicsandChars.Commands.cmdAnimatedGif.WorksWithAll = true
objPicsandChars.Commands.cmdPicturesize.Custom = true
objPicsandChars.Commands.cmdPicturesize.Id = "826929b5-4b3d-4d68-b408-74f05a22caea"
objPicsandChars.Commands.cmdPicturesize.WorksWithAll = true
objPicsandChars.Commands.cmdPictureformat.Custom = true
objPicsandChars.Commands.cmdPictureformat.Id = "9c38a875-49c0-4cdf-9632-6eb2b637cd32"
objPicsandChars.Commands.cmdPictureformat.WorksWithAll = true
objPicsandChars.Commands.cmdLinebreak.Custom = true
objPicsandChars.Commands.cmdLinebreak.Id = "688d4df7-06e3-42dd-92d3-213ddfdd2372"
objPicsandChars.Commands.cmdLinebreak.WorksWithAll = true
objPicsandChars.Commands.cmdMarkdown.Custom = true
objPicsandChars.Commands.cmdMarkdown.Id = "f646414a-ccb1-49fb-a8f8-e726160ab54a"
objPicsandChars.Commands.cmdMarkdown.WorksWithAll = true
objPicsandChars.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objPicsandChars.Locked = false
objPicsandChars.Opened = false
objPhone3 = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objPhone3.Id = "51c6c294-36da-41d7-9e3c-5363b94087be"
objPhone3.Name = "Phone 3"
objPhone3.Description = "The phone should ring every 4 seconds until you press stop. These item uses the countdown timer with the \"on Elapse\" event. The very first sound is called directly after starting. Addon : Item pic, icon and name of the item change after each ring. Does it work ? "
objPhone3.Visible = true
objPhone3.Media = objTelSilent
objPhone3.Icon = objTelSilentIcon
objPhone3.Commands = {
	cmdLetitring = Wherigo.ZCommand{
		Text = "Let it ring", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdStop = Wherigo.ZCommand{
		Text = "Stop", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}
}
objPhone3.Commands.cmdLetitring.Custom = true
objPhone3.Commands.cmdLetitring.Id = "fe58df87-0962-4691-a4b1-9fbbf301f519"
objPhone3.Commands.cmdLetitring.WorksWithAll = true
objPhone3.Commands.cmdStop.Custom = true
objPhone3.Commands.cmdStop.Id = "b8e123fc-e620-4477-a097-510809536524"
objPhone3.Commands.cmdStop.WorksWithAll = true
objPhone3.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objPhone3.Locked = false
objPhone3.Opened = false
objSounds = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objSounds.Id = "e7f35aa7-744d-4bf8-9d6b-d0e7306d465b"
objSounds.Name = "Sounds"
objSounds.Description = "If you hear nothing on the sound tests, your player settings are not ok. Note : These functions does not work on garmin devices."
objSounds.Visible = true
objSounds.Commands = {
	cmdSoundquality = Wherigo.ZCommand{
		Text = "Soundquality", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdAStopsound = Wherigo.ZCommand{
		Text = "A) Stopsound", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdBStopwithnullsound = Wherigo.ZCommand{
		Text = "B) Stop with nullsound", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdSoundformat = Wherigo.ZCommand{
		Text = "Soundformat", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdCStopandnullsound = Wherigo.ZCommand{
		Text = "C) Stop and nullsound", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objSounds.Commands.cmdSoundquality.Custom = true
objSounds.Commands.cmdSoundquality.Id = "2ebe32c2-2118-4656-a76b-f8049b5c4fce"
objSounds.Commands.cmdSoundquality.WorksWithAll = true
objSounds.Commands.cmdAStopsound.Custom = true
objSounds.Commands.cmdAStopsound.Id = "9f94a609-03aa-458e-b3c7-c9a7186ffd20"
objSounds.Commands.cmdAStopsound.WorksWithAll = true
objSounds.Commands.cmdBStopwithnullsound.Custom = true
objSounds.Commands.cmdBStopwithnullsound.Id = "c4fb94db-66dc-47e1-b7f3-238e39d9eb6f"
objSounds.Commands.cmdBStopwithnullsound.WorksWithAll = true
objSounds.Commands.cmdSoundformat.Custom = true
objSounds.Commands.cmdSoundformat.Id = "295d3447-c843-4aad-b3bc-5316f90403a6"
objSounds.Commands.cmdSoundformat.WorksWithAll = true
objSounds.Commands.cmdCStopandnullsound.Custom = true
objSounds.Commands.cmdCStopandnullsound.Id = "a453dea2-a130-4c5c-a939-3dcacf160672"
objSounds.Commands.cmdCStopandnullsound.WorksWithAll = true
objSounds.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objSounds.Locked = false
objSounds.Opened = false
objStandbycheck = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objStandbycheck.Id = "0d2cb7d0-7843-46c3-912c-66c38f86c70d"
objStandbycheck.Name = "Standbycheck"
objStandbycheck.Description = "Lets check, how your player reacts in standby mode. Start the timer and switch the device to standby. Every 5 seconds you should hear a sound. The counter increases its value everytime the sound is being played. If sound and counter will be stopped your player sleeps in standby mode. Perhaps you have to call the item again, to see the progress. Besides the name of the item will be changed each time the sound is being played. Standbycheck.NumberOfLoops"
objStandbycheck.Visible = true
objStandbycheck.Commands = {
	cmdStart = Wherigo.ZCommand{
		Text = "Start", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdStop = Wherigo.ZCommand{
		Text = "Stop", 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = "Nothing available"
	}
}
objStandbycheck.Commands.cmdStart.Custom = true
objStandbycheck.Commands.cmdStart.Id = "8f24b483-1738-4ff8-971b-cafa7ed71fd3"
objStandbycheck.Commands.cmdStart.WorksWithAll = true
objStandbycheck.Commands.cmdStop.Custom = true
objStandbycheck.Commands.cmdStop.Id = "bb915d72-1e31-4cb9-b7fa-507e5d179cb5"
objStandbycheck.Commands.cmdStop.WorksWithAll = true
objStandbycheck.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objStandbycheck.Locked = false
objStandbycheck.Opened = false
objShowScreens = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objShowScreens.Id = "196964e2-6903-47a2-9ab9-21197a840aef"
objShowScreens.Name = "Show Screens"
objShowScreens.Description = "Some players (especially Garmin) do not work with show screens commands. Here you can check their behaviour."
objShowScreens.Visible = true
objShowScreens.Commands = {
	cmdShowlocations = Wherigo.ZCommand{
		Text = "Show locations", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdShowinventory = Wherigo.ZCommand{
		Text = "Show inventory", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdShowitems = Wherigo.ZCommand{
		Text = "Show items", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdShowtasks = Wherigo.ZCommand{
		Text = "Show tasks", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objShowScreens.Commands.cmdShowlocations.Custom = true
objShowScreens.Commands.cmdShowlocations.Id = "776d75c5-852b-4e4e-84a3-e161d2852a1d"
objShowScreens.Commands.cmdShowlocations.WorksWithAll = true
objShowScreens.Commands.cmdShowinventory.Custom = true
objShowScreens.Commands.cmdShowinventory.Id = "49393383-e828-4fcc-ac81-245c4ee0c2ee"
objShowScreens.Commands.cmdShowinventory.WorksWithAll = true
objShowScreens.Commands.cmdShowitems.Custom = true
objShowScreens.Commands.cmdShowitems.Id = "ee508481-96e9-4987-a021-93b420c90056"
objShowScreens.Commands.cmdShowitems.WorksWithAll = true
objShowScreens.Commands.cmdShowtasks.Custom = true
objShowScreens.Commands.cmdShowtasks.Id = "3b0355c1-69b2-4a8b-a9fc-fb0c919c8b88"
objShowScreens.Commands.cmdShowtasks.WorksWithAll = true
objShowScreens.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objShowScreens.Locked = false
objShowScreens.Opened = false
objKnife = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = PlayersZone
}
objKnife.Id = "adbd90a0-8246-4966-9928-b019272cc351"
objKnife.Name = "Knife"
objKnife.Description = "This item we need to check the item show screen function. For more see the item Show Screens. Besides you see the command Eat reciprocal, but NOT EAT itself. Thats because reciprocal is set to false. Look at the LUA section of the sources. This is the better way to link 2 commands from 2 items."
objKnife.Visible = true
objKnife.Commands = {}
objKnife.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objKnife.Locked = false
objKnife.Opened = false
objSpoon = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = PlayersZone
}
objSpoon.Id = "0ff891a4-4754-47dc-9913-c3399594e5f7"
objSpoon.Name = "Spoon"
objSpoon.Description = "This is an item to check the item show screen function. For more see the item Show Screens. Besides the item soup has 2 commands, 1 of them contains the directive reciprocals and the other not. Look at the LUA section of the sources. Thats why you see a command also in these item."
objSpoon.Visible = true
objSpoon.Commands = {}
objSpoon.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objSpoon.Locked = false
objSpoon.Opened = false
objFork = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = PlayersZone
}
objFork.Id = "e0eb3cce-8121-498c-a713-cce94ae7ba95"
objFork.Name = "Fork"
objFork.Description = "This item we need to check the item show screen function. For more see the item Show Screens. Besides you see the command Eat reciprocal, but NOT EAT itself. Thats because reciprocal is set to false. Look at the LUA section of the sources. This is the better way to link 2 commands from 2 items."
objFork.Visible = true
objFork.Commands = {}
objFork.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objFork.Locked = false
objFork.Opened = false
objTextonbutton = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objTextonbutton.Id = "6dca3e5c-50d3-4b98-8ac4-4dc897f47b6c"
objTextonbutton.Name = "Text on button"
objTextonbutton.Description = ""
objTextonbutton.Visible = true
objTextonbutton.Commands = {
	cmd1Button = Wherigo.ZCommand{
		Text = "1 Button", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmd2Buttons = Wherigo.ZCommand{
		Text = "2 Buttons", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdGoback = Wherigo.ZCommand{
		Text = "Go back", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objTextonbutton.Commands.cmd1Button.Custom = true
objTextonbutton.Commands.cmd1Button.Id = "dae86ff8-e81f-407b-ae11-ec3dd34881d2"
objTextonbutton.Commands.cmd1Button.WorksWithAll = true
objTextonbutton.Commands.cmd2Buttons.Custom = true
objTextonbutton.Commands.cmd2Buttons.Id = "f3f4ed03-b087-4c56-9e33-96f7689986e3"
objTextonbutton.Commands.cmd2Buttons.WorksWithAll = true
objTextonbutton.Commands.cmdGoback.Custom = true
objTextonbutton.Commands.cmdGoback.Id = "b5871cf5-6442-43c4-ad44-d182f7e24234"
objTextonbutton.Commands.cmdGoback.WorksWithAll = true
objTextonbutton.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objTextonbutton.Locked = false
objTextonbutton.Opened = false
objObjectdetails = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objObjectdetails.Id = "66a27405-3581-45eb-b950-d747357aa709"
objObjectdetails.Name = "Objectdetails"
objObjectdetails.Description = "Here you can check if the details of a single object can be shown. The objects to test are zone,character,item and task."
objObjectdetails.Visible = true
objObjectdetails.Commands = {
	cmdObjectzone = Wherigo.ZCommand{
		Text = "Object zone", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdObjectItem = Wherigo.ZCommand{
		Text = "Object Item", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdObjectCharacter = Wherigo.ZCommand{
		Text = "Object Character", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdObjecttask = Wherigo.ZCommand{
		Text = "Object task", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objObjectdetails.Commands.cmdObjectzone.Custom = true
objObjectdetails.Commands.cmdObjectzone.Id = "e48910ac-da08-4625-af4a-acd2683bf6d1"
objObjectdetails.Commands.cmdObjectzone.WorksWithAll = true
objObjectdetails.Commands.cmdObjectItem.Custom = true
objObjectdetails.Commands.cmdObjectItem.Id = "10b81b54-160c-4044-9871-ea19ba6ac4b8"
objObjectdetails.Commands.cmdObjectItem.WorksWithAll = true
objObjectdetails.Commands.cmdObjectCharacter.Custom = true
objObjectdetails.Commands.cmdObjectCharacter.Id = "dbb43144-a01f-4d7e-87d1-acb693a3888e"
objObjectdetails.Commands.cmdObjectCharacter.WorksWithAll = true
objObjectdetails.Commands.cmdObjecttask.Custom = true
objObjectdetails.Commands.cmdObjecttask.Id = "4b861413-2830-40be-b706-5a4ae5a0bf92"
objObjectdetails.Commands.cmdObjecttask.WorksWithAll = true
objObjectdetails.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objObjectdetails.Locked = false
objObjectdetails.Opened = false
objDemoitem = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objDemoitem.Id = "2095c68f-df03-4a7c-b21d-29b7e3bfe5e6"
objDemoitem.Name = "Demoitem"
objDemoitem.Description = "These object is only demo and will be called from the motheritem Objectdetails. On some players this does not work."
objDemoitem.Visible = true
objDemoitem.Commands = {
	cmdTomotheritem = Wherigo.ZCommand{
		Text = "To motheritem", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdMainmenue = Wherigo.ZCommand{
		Text = "Mainmenue", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objDemoitem.Commands.cmdTomotheritem.Custom = true
objDemoitem.Commands.cmdTomotheritem.Id = "54b94663-d34e-4ce2-b0c1-a842a4d80d20"
objDemoitem.Commands.cmdTomotheritem.WorksWithAll = true
objDemoitem.Commands.cmdMainmenue.Custom = true
objDemoitem.Commands.cmdMainmenue.Id = "fc00522c-5a3b-481b-ad78-8f24c1b2bcea"
objDemoitem.Commands.cmdMainmenue.WorksWithAll = true
objDemoitem.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objDemoitem.Locked = false
objDemoitem.Opened = false
objSoup = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = PlayersZone
}
objSoup.Id = "b5c687f2-b0b7-44e6-9eba-cc1b217d4205"
objSoup.Name = "Soup"
objSoup.Description = [[These item is for checking the ShowScreen function, also see the item Show Screens. Besides we need it 
to handle the cutlery. You only can eat the soup with the spoon. Fork and knife you can try but not use. Because of the lua directive objSoup.Commands.cmdEat.MakeReciprocal = false there is only one way : soup, eat,spoon. The 2nd command EAT is without the directive, thats why the command appears also at item spoon.]]
objSoup.Visible = true
objSoup.Commands = {
	cmdEat = Wherigo.ZCommand{
		Text = "Eat", 
		CmdWith = true, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdEatreciprocal = Wherigo.ZCommand{
		Text = "Eat reciprocal", 
		CmdWith = true, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objSoup.Commands.cmdEat.Custom = true
objSoup.Commands.cmdEat.Id = "1595b09a-9318-4431-bad3-fd6e974e4748"
objSoup.Commands.cmdEat.WorksWithAll = false
objSoup.Commands.cmdEat.WorksWithListIds = {
	"adbd90a0-8246-4966-9928-b019272cc351", 
	"e0eb3cce-8121-498c-a713-cce94ae7ba95", 
	"0ff891a4-4754-47dc-9913-c3399594e5f7"
}
objSoup.Commands.cmdEatreciprocal.Custom = true
objSoup.Commands.cmdEatreciprocal.Id = "8067605a-fe77-498c-a5cd-b57d81b07243"
objSoup.Commands.cmdEatreciprocal.WorksWithAll = false
objSoup.Commands.cmdEatreciprocal.WorksWithListIds = {
	"e0eb3cce-8121-498c-a713-cce94ae7ba95", 
	"adbd90a0-8246-4966-9928-b019272cc351", 
	"0ff891a4-4754-47dc-9913-c3399594e5f7"
}
objSoup.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objSoup.Locked = false
objSoup.Opened = false
objVectorToPoint = Wherigo.ZItem{
	Cartridge = objWherigoTestsuiteEN, 
	Container = Player
}
objVectorToPoint.Id = "4858f424-2658-4a2b-ad47-25ffd9896a06"
objVectorToPoint.Name = "VectorToPoint"
objVectorToPoint.Description = [[Some players have problems with the function Wherigo.VectorToPoint() and Wherigo.TranslatePoint(). With this functions it is possible to calculate distance and bearing between two points and to move a point. A point, which distance and bearing to another point is calculated to the first function and translated by the second function should result in the second point.

All calculations are from point lat=48, lon=0.

The results could be checked at http://williams.best.vwh.net/gccalc.htm.]]
objVectorToPoint.Visible = true
objVectorToPoint.Commands = {
	cmdPoslat481lon01 = Wherigo.ZCommand{
		Text = "Pos. lat=48.1,lon=0.1", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPoslat49lon1 = Wherigo.ZCommand{
		Text = "Pos. lat 49,lon=1", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPoslat53lon9 = Wherigo.ZCommand{
		Text = "Pos. lat=53,lon=9", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPoslat55lon26 = Wherigo.ZCommand{
		Text = "Pos. lat=55,lon=26", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPoslat58lon58 = Wherigo.ZCommand{
		Text = "Pos. lat=58,lon=58", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPoslat58lon58_1 = Wherigo.ZCommand{
		Text = "Pos. lat=-58,lon=-58", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}, 
	cmdPoslat4800747lon000747 = Wherigo.ZCommand{
		Text = "Pos. lat=48.00747,lon=0.00747", 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = "Nothing available"
	}
}
objVectorToPoint.Commands.cmdPoslat481lon01.Custom = true
objVectorToPoint.Commands.cmdPoslat481lon01.Id = "16ed8d72-2063-4966-bee3-2bfe3fb21fb8"
objVectorToPoint.Commands.cmdPoslat481lon01.WorksWithAll = true
objVectorToPoint.Commands.cmdPoslat49lon1.Custom = true
objVectorToPoint.Commands.cmdPoslat49lon1.Id = "506a644c-be8e-4370-85f0-1fa90c7a5c0e"
objVectorToPoint.Commands.cmdPoslat49lon1.WorksWithAll = true
objVectorToPoint.Commands.cmdPoslat53lon9.Custom = true
objVectorToPoint.Commands.cmdPoslat53lon9.Id = "94e6d9e4-4d6b-4e26-8716-cbf948578fa8"
objVectorToPoint.Commands.cmdPoslat53lon9.WorksWithAll = true
objVectorToPoint.Commands.cmdPoslat55lon26.Custom = true
objVectorToPoint.Commands.cmdPoslat55lon26.Id = "3c13c81c-4589-45a4-b377-c17e897f52db"
objVectorToPoint.Commands.cmdPoslat55lon26.WorksWithAll = true
objVectorToPoint.Commands.cmdPoslat58lon58.Custom = true
objVectorToPoint.Commands.cmdPoslat58lon58.Id = "5a110678-bc53-45a5-9633-7718d8188852"
objVectorToPoint.Commands.cmdPoslat58lon58.WorksWithAll = true
objVectorToPoint.Commands.cmdPoslat58lon58_1.Custom = true
objVectorToPoint.Commands.cmdPoslat58lon58_1.Id = "64f1babd-ec1f-4b8c-9d8d-31e312f2c14b"
objVectorToPoint.Commands.cmdPoslat58lon58_1.WorksWithAll = true
objVectorToPoint.Commands.cmdPoslat4800747lon000747.Custom = true
objVectorToPoint.Commands.cmdPoslat4800747lon000747.Id = "cffb2001-40af-430a-865c-866df0b2f1cd"
objVectorToPoint.Commands.cmdPoslat4800747lon000747.WorksWithAll = true
objVectorToPoint.ObjectLocation = Wherigo.INVALID_ZONEPOINT
objVectorToPoint.Locked = false
objVectorToPoint.Opened = false

-- Tasks --
objTask = Wherigo.ZTask(objWherigoTestsuiteEN)
objTask.Id = "6c6ae998-5b21-48b2-a2ef-f7ee8d1601f9"
objTask.Name = "Task"
objTask.Description = "This is the task, with the toggle task item you can set its status complete, incomplete, correct, not correct and set correction to none. I think the correction flag does not work !?"
objTask.Visible = true
objTask.Active = true
objTask.Complete = false
objTask.CorrectState = "None"
objNulltask = Wherigo.ZTask(objWherigoTestsuiteEN)
objNulltask.Id = "7b48aa9a-7ff1-4b37-ba1a-a5e55034d6cd"
objNulltask.Name = "Nulltask"
objNulltask.Description = "These task is always here, set to active, visible and incomplete. It should has an own icon. Can you see it ?"
objNulltask.Visible = true
objNulltask.Icon = objTaskicon
objNulltask.Active = true
objNulltask.Complete = false
objNulltask.CorrectState = "None"
objTaskOnclick = Wherigo.ZTask(objWherigoTestsuiteEN)
objTaskOnclick.Id = "e66b43e3-352d-475d-b1b8-8da7cf7708f7"
objTaskOnclick.Name = "Task On click"
objTaskOnclick.Description = "This is the task description, not the text of a command. This means your player does not support the On click event of a task."
objTaskOnclick.Visible = true
objTaskOnclick.Active = true
objTaskOnclick.Complete = false
objTaskOnclick.CorrectState = "None"
objDemotask = Wherigo.ZTask(objWherigoTestsuiteEN)
objDemotask.Id = "7ed3f445-86b8-4fc8-844a-c393a1616540"
objDemotask.Name = "Demotask"
objDemotask.Description = "These object is only demo and will be called from the motheritem. To go back you must call the item again. Tasks do not have commands."
objDemotask.Visible = true
objDemotask.Active = true
objDemotask.Complete = false
objDemotask.CorrectState = "None"

-- Cartridge Variables --
objCounter = 0
CR = ""
objCorrectnessStatus = "undefined"
objvarBoolean = false
objBooleanValue = "nil"
objSimulatorStatus = "You play in simulator : No"
objDist = 0
objDistStr = ""
objNumOfMeasureTotal = 0
objNumOfMeasureCycle = 0
objNumberOfSounds = 0
objCompleteStatus = "not complete"
objTimerduration = 10
objTelRing1 = 0
objAccuracy = 0
objAltitude = 0
currentZone = "PlayersZone"
currentCharacter = "objDemocharacter"
currentItem = "objSetPlayerZone"
currentTask = "objTask"
currentInput = "objNumInput"
currentTimer = "objAnimationMsgbox"
objWherigoTestsuiteEN.ZVariables = {
	objCounter = 0, 
	CR = "", 
	objCorrectnessStatus = "undefined", 
	objvarBoolean = false, 
	objBooleanValue = "nil", 
	objSimulatorStatus = "You play in simulator : No", 
	objDist = 0, 
	objDistStr = "", 
	objNumOfMeasureTotal = 0, 
	objNumOfMeasureCycle = 0, 
	objNumberOfSounds = 0, 
	objCompleteStatus = "not complete", 
	objTimerduration = 10, 
	objTelRing1 = 0, 
	objAccuracy = 0, 
	objAltitude = 0, 
	currentZone = "PlayersZone", 
	currentCharacter = "objDemocharacter", 
	currentItem = "objSetPlayerZone", 
	currentTask = "objTask", 
	currentInput = "objNumInput", 
	currentTimer = "objAnimationMsgbox"
}

-- Timers --
objAnimationMsgbox = Wherigo.ZTimer(objWherigoTestsuiteEN)
objAnimationMsgbox.Id = "2a2e7335-ae8c-46b5-a536-50241db24956"
objAnimationMsgbox.Name = "AnimationMsgbox"
objAnimationMsgbox.Description = ""
objAnimationMsgbox.Visible = true
objAnimationMsgbox.Duration = 1
objAnimationMsgbox.Type = "Countdown"
objPhoneRingingOnStart = Wherigo.ZTimer(objWherigoTestsuiteEN)
objPhoneRingingOnStart.Id = "881a7119-4039-4031-b12a-edecae3322fa"
objPhoneRingingOnStart.Name = "PhoneRingingOnStart"
objPhoneRingingOnStart.Description = ""
objPhoneRingingOnStart.Visible = true
objPhoneRingingOnStart.Duration = 4
objPhoneRingingOnStart.Type = "Interval"
objAnimationItem = Wherigo.ZTimer(objWherigoTestsuiteEN)
objAnimationItem.Id = "6e8f0dd8-3748-4dbc-ba63-cd8599e0df6b"
objAnimationItem.Name = "AnimationItem"
objAnimationItem.Description = ""
objAnimationItem.Visible = true
objAnimationItem.Duration = 1
objAnimationItem.Type = "Countdown"
objOnlineCheck = Wherigo.ZTimer(objWherigoTestsuiteEN)
objOnlineCheck.Id = "0aee37d1-04bb-430c-a05d-843a3be59b69"
objOnlineCheck.Name = "OnlineCheck"
objOnlineCheck.Description = ""
objOnlineCheck.Visible = true
objOnlineCheck.Duration = 3
objOnlineCheck.Type = "Countdown"
objCheckPosition = Wherigo.ZTimer(objWherigoTestsuiteEN)
objCheckPosition.Id = "1c4220e9-3cc9-4d42-bc79-ff41312ef98f"
objCheckPosition.Name = "CheckPosition"
objCheckPosition.Description = ""
objCheckPosition.Visible = true
objCheckPosition.Duration = 2
objCheckPosition.Type = "Interval"
objCountdowntimer = Wherigo.ZTimer(objWherigoTestsuiteEN)
objCountdowntimer.Id = "9bd91b7a-4705-4fad-a7db-0ceb208df081"
objCountdowntimer.Name = "Countdowntimer"
objCountdowntimer.Description = ""
objCountdowntimer.Visible = true
objCountdowntimer.Duration = 1
objCountdowntimer.Type = "Countdown"
objIntervalltimer = Wherigo.ZTimer(objWherigoTestsuiteEN)
objIntervalltimer.Id = "3ad7a65e-8bbb-41d5-bcaf-0b737f96f5af"
objIntervalltimer.Name = "Intervalltimer"
objIntervalltimer.Description = ""
objIntervalltimer.Visible = true
objIntervalltimer.Duration = 1
objIntervalltimer.Type = "Interval"
objPhoneRingingOnElapse = Wherigo.ZTimer(objWherigoTestsuiteEN)
objPhoneRingingOnElapse.Id = "32bfcaf6-bfe9-4c39-8daf-bf61e1de5674"
objPhoneRingingOnElapse.Name = "PhoneRingingOnElapse"
objPhoneRingingOnElapse.Description = ""
objPhoneRingingOnElapse.Visible = true
objPhoneRingingOnElapse.Duration = 4
objPhoneRingingOnElapse.Type = "Interval"
objPhoneRingingCountdown = Wherigo.ZTimer(objWherigoTestsuiteEN)
objPhoneRingingCountdown.Id = "27233cbc-251b-479e-8869-07d6e64370f8"
objPhoneRingingCountdown.Name = "PhoneRingingCountdown"
objPhoneRingingCountdown.Description = ""
objPhoneRingingCountdown.Visible = true
objPhoneRingingCountdown.Duration = 4
objPhoneRingingCountdown.Type = "Countdown"
objTimerStandbyTest = Wherigo.ZTimer(objWherigoTestsuiteEN)
objTimerStandbyTest.Id = "b8b2a916-3910-4c8e-92ad-11cb6adcddd0"
objTimerStandbyTest.Name = "TimerStandbyTest"
objTimerStandbyTest.Description = ""
objTimerStandbyTest.Visible = true
objTimerStandbyTest.Duration = 5
objTimerStandbyTest.Type = "Countdown"

-- Inputs --
objNumInput = Wherigo.ZInput(objWherigoTestsuiteEN)
objNumInput.Id = "8eac6b82-5ae7-4f99-bd92-2ade209b12d0"
objNumInput.Name = "NumInput"
objNumInput.Description = "Enter a valid number, also check what happens if you enter chars."
objNumInput.Visible = true
objNumInput.InputType = "Text"
objNumInput.Text = "Enter a valid number, also check what happens if you enter chars. "
objCharInput = Wherigo.ZInput(objWherigoTestsuiteEN)
objCharInput.Id = "d45c45cf-258f-4ff1-9a07-5d5191301f6e"
objCharInput.Name = "CharInput"
objCharInput.Description = "Enter chars (also numbers are allowed)"
objCharInput.Visible = true
objCharInput.InputType = "Text"
objCharInput.Text = "Enter chars (also numbers are allowed)"
objSoundformat = Wherigo.ZInput(objWherigoTestsuiteEN)
objSoundformat.Id = "bf0f2175-5f33-4d21-b543-cda2488a8036"
objSoundformat.Name = "Soundformat"
objSoundformat.Description = ""
objSoundformat.Visible = true
objSoundformat.Choices = {
	"MP3", 
	"WAV", 
	"OGG", 
	"BACK"
}
objSoundformat.InputType = "MultipleChoice"
objSoundformat.Text = "Choose the kind of soundformat. Leave the loop by pressing BACK."
objPicturesize = Wherigo.ZInput(objWherigoTestsuiteEN)
objPicturesize.Id = "a27510f8-19e5-4a3c-8724-148f3c9a5b73"
objPicturesize.Name = "Picturesize"
objPicturesize.Description = ""
objPicturesize.Visible = true
objPicturesize.Choices = {
	"115x170", 
	"230x340", 
	"540x800", 
	"BACK"
}
objPicturesize.InputType = "MultipleChoice"
objPicturesize.Text = "Some players fit pictures to screen, other use the exact given format. Have a look at the following pics and check how your player reacts. Choose the picturesize you want to see. Leave the loop by pressing BACK."
objPictureformat = Wherigo.ZInput(objWherigoTestsuiteEN)
objPictureformat.Id = "7b8c2b26-1ef1-4281-a531-c90754bfb170"
objPictureformat.Name = "Pictureformat"
objPictureformat.Description = ""
objPictureformat.Visible = true
objPictureformat.Choices = {
	"JPG", 
	"GIF (not animated)", 
	"BMP", 
	"PNG", 
	"BACK"
}
objPictureformat.InputType = "MultipleChoice"
objPictureformat.Text = "Check if all kinds of picture formats are displayed on your player. Leave the loop by pressing BACK."
objBooleanstate = Wherigo.ZInput(objWherigoTestsuiteEN)
objBooleanstate.Id = "68625520-e8c8-4672-be29-89ec06dc4b6a"
objBooleanstate.Name = "Booleanstate"
objBooleanstate.Description = ""
objBooleanstate.Visible = true
objBooleanstate.Choices = {
	"Set to true", 
	"Set to false", 
	"Show value", 
	"Back"
}
objBooleanstate.InputType = "MultipleChoice"
objBooleanstate.Text = "One of the last versions of iPhone player has had the effect, that sometimes variables from type boolean were not restored correctly. Here you can set a boolean variable to true or false, save the cartridge and compare whether the current value is ok."
objChoiceInput = Wherigo.ZInput(objWherigoTestsuiteEN)
objChoiceInput.Id = "9fdadcdc-8918-48dd-824c-0fd6eaa39336"
objChoiceInput.Name = "ChoiceInput"
objChoiceInput.Description = ""
objChoiceInput.Visible = true
objChoiceInput.Choices = {
	"Cherry", 
	"Lemon", 
	"Apple", 
	"Orange", 
	"Strawberry", 
	"Melon"
}
objChoiceInput.InputType = "MultipleChoice"
objChoiceInput.Text = "Choose a fruit"
objInputLoop = Wherigo.ZInput(objWherigoTestsuiteEN)
objInputLoop.Id = "513d8e76-6f4e-4d53-8491-6d0f94b773a5"
objInputLoop.Name = "InputLoop"
objInputLoop.Description = ""
objInputLoop.Visible = true
objInputLoop.InputType = "Text"
objInputLoop.Text = "Here you must enter EXIT to finish the input. It should be not possible to terminate the input, e.g with BACK button of the player."
objInputPic = Wherigo.ZInput(objWherigoTestsuiteEN)
objInputPic.Id = "4899f3f4-f3d5-487d-8bef-2aec0b4d81ce"
objInputPic.Name = "InputPic"
objInputPic.Description = ""
objInputPic.Visible = true
objInputPic.Media = objTestpic
objInputPic.InputType = "Text"
objInputPic.Text = "The answer is irrelevant, here we want to check how and where the picture and text were located, when the keyboard appears."
objInputTimerDuration = Wherigo.ZInput(objWherigoTestsuiteEN)
objInputTimerDuration.Id = "17fad57d-da39-4050-be4a-a28c356f6338"
objInputTimerDuration.Name = "InputTimerDuration"
objInputTimerDuration.Description = ""
objInputTimerDuration.Visible = true
objInputTimerDuration.Choices = {
	"10 secs", 
	"30 secs", 
	"60 secs", 
	"2 minutes", 
	"5 minutes"
}
objInputTimerDuration.InputType = "MultipleChoice"
objInputTimerDuration.Text = "Choose how long the timer should run. Actually it is set to 10 seconds."

-- WorksWithList for object commands --
objSoup.Commands.cmdEat.WorksWithList = {
	objKnife, 
	objFork, 
	objSpoon
}
objSoup.Commands.cmdEatreciprocal.WorksWithList = {
	objFork, 
	objKnife, 
	objSpoon
}

-- functions --
function objWherigoTestsuiteEN:OnStart()
	objReadTaskStatus()
	objReadBooleanValue()
	_Urwigo.MessageBox{
		Text = (("The Wherigo Testsuite by jonny65"..CR)..CR).."It is made to check out some typical things used in a wherigo cartridge and also testing your current player. Some players are reacting different. To check the special chars, please download the GWC from the wherigo.com site. Do not use the built GWC from urwigo.", 
		Media = objTestpic, 
		Callback = function(action)
			if action ~= nil then
				_Urwigo.MessageBox{
					Text = "Now here comes our first check. If you only can read these message in the urwigo source (embedded in on Start event) but not in the player, there is something wrong. Probably the cartridge is corrupt or the player skips the start event."
				}
			end
		end
	}
end
function objWherigoTestsuiteEN:OnRestore()
end
function PlayersZone:OncmdZoneCommand(target)
	currentZone = "PlayersZone"
	_Urwigo.MessageBox{
		Text = "Congrats, if you see these message, your player supports zone commands."
	}
end
function PlayersZone:OnEnter()
	currentZone = "PlayersZone"
	Wherigo.PlayAudio(objNotify)
	_Urwigo.MessageBox{
		Text = "You have entered the playerzone ! You can taste the soup, but choose the right kind of catlery ;-)"
	}
end
function PlayersZone:OnExit()
	currentZone = "PlayersZone"
	_Urwigo.MessageBox{
		Text = "You have left the zone"
	}
end
function objDemozone:OncmdTomotheritem(target)
	currentZone = "objDemozone"
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objObjectdetails)
end
function objDemozone:OncmdMainmenue(target)
	currentZone = "objDemozone"
	Wherigo.ShowScreen(Wherigo.MAINSCREEN)
end
function objTaskOnclick:OnClick()
	_Urwigo.MessageBox{
		Text = "Congrats, your player supports the On click event of a task."
	}
end
function objDemozone:OnClick()
	_Urwigo.MessageBox{
		Text = "Congrats, your player supports the On click event of a zone."
	}
end
function objNumInput:OnGetInput(input)
	input = tonumber(input)
	if input == nil then
		_Urwigo.MessageBox{
			Text = "This is not a valid number, try again or cancel ?", 
			Buttons = {
				"Try again", 
				"Cancel"
			}, 
			Callback = function(action)
				if action ~= nil then
					if (action == "Button1") == true then
						_Urwigo.RunDialogs(function()
							Wherigo.GetInput(objNumInput)
						end)
					end
				end
			end
		}
		return
	end
	if input ~= tonumber "" then
		_Urwigo.MessageBox{
			Text = "You have entered "..input
		}
	else
		_Urwigo.MessageBox{
			Text = "You have entered NOTHING"
		}
	end
end
function objCharInput:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if input ~= "" then
		_Urwigo.MessageBox{
			Text = "You have entered "..input
		}
	else
		_Urwigo.MessageBox{
			Text = "You have entered NOTHING"
		}
	end
end
function objSoundformat:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if Wherigo.NoCaseEquals(input, "MP3") then
		Wherigo.PlayAudio(objSound_high)
		_Urwigo.MessageBox{
			Text = "You hear the MP3 Format ...", 
			Callback = function(action)
				if action ~= nil then
					Wherigo.PlayAudio(objNullsound)
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objSoundformat)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "WAV") then
		Wherigo.PlayAudio(objSound_Wav)
		_Urwigo.MessageBox{
			Text = "You hear the WAV Format ...", 
			Callback = function(action)
				if action ~= nil then
					Wherigo.PlayAudio(objNullsound)
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objSoundformat)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "OGG") then
		Wherigo.PlayAudio(objSound_Ogg)
		_Urwigo.MessageBox{
			Text = "You hear the OGG Format ...", 
			Callback = function(action)
				if action ~= nil then
					Wherigo.PlayAudio(objNullsound)
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objSoundformat)
					end)
				end
			end
		}
	else
		Wherigo.PlayAudio(objNullsound)
	end
end
function objPicturesize:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if Wherigo.NoCaseEquals(input, "115x170") then
		_Urwigo.MessageBox{
			Text = "", 
			Media = obj115x170, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objPicturesize)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "230x340") then
		_Urwigo.MessageBox{
			Text = "", 
			Media = obj230x340, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objPicturesize)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "540x800") then
		_Urwigo.MessageBox{
			Text = "", 
			Media = obj540x800, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objPicturesize)
					end)
				end
			end
		}
	end
end
function objPictureformat:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if Wherigo.NoCaseEquals(input, "JPG") then
		_Urwigo.MessageBox{
			Text = "", 
			Media = objJPGFormat, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objPictureformat)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "GIF (not animated)") then
		_Urwigo.MessageBox{
			Text = "", 
			Media = objGifFormat, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objPictureformat)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "BMP") then
		_Urwigo.MessageBox{
			Text = "", 
			Media = objBMPFormat, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objPictureformat)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "PNG") then
		_Urwigo.MessageBox{
			Text = "", 
			Media = objPNGFormat, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objPictureformat)
					end)
				end
			end
		}
	end
end
function objBooleanstate:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if Wherigo.NoCaseEquals(input, "Set to true") then
		objvarBoolean = true
		objReadBooleanValue()
		_Urwigo.MessageBox{
			Text = "Current value is : "..objBooleanValue, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objBooleanstate)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "Set to false") then
		objvarBoolean = false
		objReadBooleanValue()
		_Urwigo.MessageBox{
			Text = "Current value is : "..objBooleanValue, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objBooleanstate)
					end)
				end
			end
		}
	elseif Wherigo.NoCaseEquals(input, "Show value") then
		objReadBooleanValue()
		_Urwigo.MessageBox{
			Text = "Current value is : "..objBooleanValue, 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objBooleanstate)
					end)
				end
			end
		}
	end
end
function objChoiceInput:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if input ~= "" then
		_Urwigo.MessageBox{
			Text = "You have chosen "..input
		}
	else
		_Urwigo.MessageBox{
			Text = "You have entered NOTHING"
		}
	end
end
function objInputLoop:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if input == "EXIT" then
		_Urwigo.MessageBox{
			Text = "Your answer was correct, going back to input item menu ..."
		}
	else
		_Urwigo.MessageBox{
			Text = "Your answer is not correct, enter EXIT (uppercase), please try again.", 
			Callback = function(action)
				if action ~= nil then
					_Urwigo.RunDialogs(function()
						Wherigo.GetInput(objInputLoop)
					end)
				end
			end
		}
	end
end
function objInputPic:OnGetInput(input)
	if input == nil then
		input = ""
	end
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objInputs)
end
function objInputTimerDuration:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if Wherigo.NoCaseEquals(input, "10 secs") then
		objTimerduration = 10
	elseif Wherigo.NoCaseEquals(input, "30 secs") then
		objTimerduration = 30
	elseif Wherigo.NoCaseEquals(input, "60 secs") then
		objTimerduration = 60
	elseif Wherigo.NoCaseEquals(input, "2 minutes") then
		objTimerduration = 120
	elseif Wherigo.NoCaseEquals(input, "5 minutes") then
		objTimerduration = 300
	end
	objInputTimerDuration.Text = ("Choose how long the timer should run. Actually it is set to "..objTimerduration).." seconds."
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objTimertests)
end
function objAnimationMsgbox:OnTick()
	objCounter = objCounter + 1
	if objCounter <= 6 then
		if objCounter == 1 then
			_Urwigo.MessageBox{
				Text = "", 
				Media = objAniPic1
			}
		elseif objCounter == 2 then
			_Urwigo.MessageBox{
				Text = "", 
				Media = objAniPic2
			}
		elseif objCounter == 3 then
			_Urwigo.MessageBox{
				Text = "", 
				Media = objAniPic3
			}
		elseif objCounter == 4 then
			_Urwigo.MessageBox{
				Text = "", 
				Media = objAniPic4
			}
		elseif objCounter == 5 then
			_Urwigo.MessageBox{
				Text = "", 
				Media = objAniPic5
			}
		elseif objCounter == 6 then
			_Urwigo.MessageBox{
				Text = "", 
				Media = objAnipic6
			}
		end
		objAnimationMsgbox:Start()
	else
		objCounter = 0
		objShowanimation.Commands.cmdMessage.Enabled = true
		objShowanimation.Commands.cmdItem.Enabled = true
		objShowanimation.Commands.cmdGoback.Enabled = true
		_Urwigo.MessageBox{
			Text = "Animation stopped", 
			Media = objAnipic6, 
			Callback = function(action)
				if action ~= nil then
					Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objShowanimation)
				end
			end
		}
	end
end
function objPhoneRingingOnStart:OnStart()
	Wherigo.PlayAudio(objPhoneRing)
end
function objAnimationItem:OnTick()
	objCounter = objCounter + 1
	if objCounter <= 6 then
		if objCounter == 1 then
			objAnimation.Media = objAniPic1
		elseif objCounter == 2 then
			objAnimation.Media = objAniPic2
		elseif objCounter == 3 then
			objAnimation.Media = objAniPic3
		elseif objCounter == 4 then
			objAnimation.Media = objAniPic4
		elseif objCounter == 5 then
			objAnimation.Media = objAniPic5
		elseif objCounter == 6 then
			objAnimation.Media = objAnipic6
		end
		Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objAnimation)
		objAnimationItem:Start()
	else
		objCounter = 0
		objAnimation.Visible = false
		objShowanimation.Commands.cmdGoback.Enabled = true
		objShowanimation.Commands.cmdMessage.Enabled = true
		objShowanimation.Commands.cmdItem.Enabled = true
		_Urwigo.MessageBox{
			Text = "Animation stopped", 
			Media = objAnipic6, 
			Callback = function(action)
				if action ~= nil then
					Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objShowanimation)
				end
			end
		}
	end
end
function objOnlineCheck:OnTick()
	if (((_G[_cAnoM("\125\046\103")][_cAnoM("\070\110\092\055\052\059\113\025")] == _cAnoM("\002\017\046\004\102")) or (_G[_cAnoM("\125\046\103")][_cAnoM("\071\022\103\017\123\022\044\071")] == _cAnoM("\071\022\050\047\055\059\012"))) == true) or (((1 * tonumber(Player.PositionAccuracy:GetValue('m'))) <= 30) and ((1 * tonumber(Player.PositionAccuracy:GetValue('m'))) > 1)) then
		_Urwigo.MessageBox{
			Text = (("GPS signal or simulator detected ..."..CR)..CR).."Set the zone now ?", 
			Buttons = {
				"Yes, set it", 
				"Not yet"
			}, 
			Callback = function(action)
				if action ~= nil then
					if (action == "Button1") == true then
						fsetzone()
						objSetPlayerZone:MoveTo(nil)
						objBearing:MoveTo(Player)
						_Urwigo.MessageBox{
							Text = "The zone was now set. You can enter and make your tests. Besides you have got an item \"Bearing\". It shows the distance and bearing in degrees to the center of the zone. Check out whether the refresh is working.", 
							Callback = function(action)
								if action ~= nil then
									Wherigo.ShowScreen(Wherigo.MAINSCREEN)
								end
							end
						}
					else
						_Urwigo.MessageBox{
							Text = "You can search for another location and make a new try somewhere else.", 
							Callback = function(action)
								if action ~= nil then
									Wherigo.ShowScreen(Wherigo.MAINSCREEN)
								end
							end
						}
					end
				end
			end
		}
	else
		objOnlineCheck:Start()
	end
end
function objCheckPosition:OnStart()
	--[[Would be better here instead of elapse event, but some players do not work correctly.]]
end
function objCheckPosition:OnTick()
	objNumOfMeasureTotal = objNumOfMeasureTotal + 1
	objNumOfMeasureCycle = objNumOfMeasureCycle + 1
	objDist = _Urwigo.Round(1 * Wherigo.VectorToPoint(Player.ObjectLocation, PlayersZone.OriginalPoint):GetValue "m", 2)
	objDistStr = objDist..[[ m
Bearing : ]]
	if objDist >= 1000 then
		objDistStr = _Urwigo.Round(objDist / 1000, 1)..[[ km
Bearing : ]]
	end
	objBearing.Description = ((((((((((((("Bearing is running ..."..[[

Distance to target : ]])..objDistStr)..(Peilung(PlayersZone)))..[[ degrees
Altitude : ]])..(Player.ObjectLocation.altitude:GetValue("m")))..[[ m

Accuracy : ]])..(Player.PositionAccuracy:GetValue('m'))).." m")..CR)..CR).."Values overall : ")..objNumOfMeasureTotal)..[[
Values per cycle : ]])..objNumOfMeasureCycle
end
function objCountdowntimer:OnTick()
	objCounter = objCounter + -1
	if objCounter >= 0 then
		_Urwigo.MessageBox{
			Text = objCounter.." seconds left"
		}
		objCountdowntimer:Start()
	else
		_Urwigo.MessageBox{
			Text = "The time is up"
		}
	end
end
function objIntervalltimer:OnTick()
	objCounter = objCounter + 1
	if objCounter == objTimerduration then
		objCounterdisplay.Description = objCounter.." seconds ..."
		objIntervalltimer:Stop()
		_Urwigo.MessageBox{
			Text = "Timer should be stopped !?! Go back to the item and have a look. If it still runs, your player has problems stopping an intervall timer.", 
			Callback = function(action)
				if action ~= nil then
					Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objCounterdisplay)
				end
			end
		}
	else
		if objCounter < objTimerduration then
			objCounterdisplay.Description = (((objCounter.." seconds ...")..CR)..CR).."Watch counting and do not leave this screen until the message appears. Go back if the counter stands still and nothing happens."
		elseif objCounter > objTimerduration then
			objCounterdisplay.Description = ((objCounter.." seconds ...")..CR).."Your player can not handle intervall timers correctly."
		end
	end
end
function objPhoneRingingOnElapse:OnTick()
	Wherigo.PlayAudio(objPhoneRing)
end
function objPhoneRingingCountdown:OnTick()
	Wherigo.PlayAudio(objPhoneRing)
	if objTelRing1 == 0 then
		objTelRing1 = 1
		objPhone3.Name = "RING RING"
		objPhone3.Media = objTelRing
		objPhone3.Icon = objTelRingIcon
	else
		objTelRing1 = 0
		objPhone3.Media = objTelSilent
		objPhone3.Icon = objTelSilentIcon
		objPhone3.Name = "Tzzzzzzzzz"
	end
	objPhoneRingingCountdown:Start()
end
function objTimerStandbyTest:OnTick()
	Wherigo.PlayAudio(objNotify)
	objNumberOfSounds = objNumberOfSounds + 1
	objStandbycheck.Name = "Standbycheck."..objNumberOfSounds
	objStandbycheck.Description = ("I have played "..objNumberOfSounds).." times"
	objTimerStandbyTest:Start()
end
function objDemocharacter:OncmdTomotheritem(target)
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objObjectdetails)
end
function objDemocharacter:OncmdMainmenu(target)
	Wherigo.ShowScreen(Wherigo.MAINSCREEN)
end
function objSetPlayerZone:OncmdSetthezone(target)
	objOnlineCheck:Start()
	_Urwigo.MessageBox{
		Text = (("Waiting for GPS signal or confirming simulator use ..."..CR)..CR)..[[
If you click CANCEL you can search for another location and make a new try somewhere else.]], 
		Buttons = {
			"CANCEL"
		}, 
		Callback = function(action)
			if action ~= nil then
				objOnlineCheck:Stop()
				_Urwigo.MessageBox{
					Text = "Process stopped, you can search for another location and make a new try somewhere else.", 
					Callback = function(action)
						if action ~= nil then
							Wherigo.ShowScreen(Wherigo.MAINSCREEN)
						end
					end
				}
			end
		end
	}
end
function objToggleatask:OncmdIncomplete(target)
	objTask.Complete = false
	objToggleatask.Commands.cmdComplete.Enabled = true
	objToggleatask.Commands.cmdIncomplete.Enabled = false
	_Urwigo.MessageBox{
		Text = "Look at the task in task menu or description how its state is.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.MAINSCREEN)
			end
		end
	}
end
function objToggleatask:OncmdComplete(target)
	objTask.Complete = true
	objToggleatask.Commands.cmdComplete.Enabled = false
	objToggleatask.Commands.cmdIncomplete.Enabled = true
	_Urwigo.MessageBox{
		Text = "Look at the task in task menu or description how its state is.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.MAINSCREEN)
			end
		end
	}
end
function objToggleatask:OncmdCorrect(target)
	objTask.CorrectState = "Correct"
	objToggleatask.Commands.cmdCorrect.Enabled = false
	objToggleatask.Commands.cmdNotcorrect.Enabled = true
	objToggleatask.Commands.cmdCorrectnessnone.Enabled = true
	objReadTaskStatus()
	_Urwigo.MessageBox{
		Text = "Look at the task in task menu or description how its state is.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.MAINSCREEN)
			end
		end
	}
end
function objToggleatask:OncmdNotcorrect(target)
	objTask.CorrectState = "NotCorrect"
	objToggleatask.Commands.cmdCorrectnessnone.Enabled = true
	objToggleatask.Commands.cmdCorrect.Enabled = true
	objToggleatask.Commands.cmdNotcorrect.Enabled = false
	objReadTaskStatus()
	_Urwigo.MessageBox{
		Text = "Look at the task in task menu or description how its state is.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.MAINSCREEN)
			end
		end
	}
end
function objToggleatask:OncmdCorrectnessnone(target)
	objTask.CorrectState = "None"
	objToggleatask.Commands.cmdNotcorrect.Enabled = true
	objToggleatask.Commands.cmdCorrectnessnone.Enabled = false
	objToggleatask.Commands.cmdCorrect.Enabled = true
	objReadTaskStatus()
	_Urwigo.MessageBox{
		Text = "Look at the task in task menu or description how its state is.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.MAINSCREEN)
			end
		end
	}
end
function objInputs:OncmdInputanumber(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objNumInput)
	end)
end
function objInputs:OncmdInputchars(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objCharInput)
	end)
end
function objInputs:OncmdChoiceinput(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objChoiceInput)
	end)
end
function objInputs:OncmdInputloop(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objInputLoop)
	end)
end
function objInputs:OncmdInputwithpic(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objInputPic)
	end)
end
function objShowanimation:OncmdMessage(target)
	objCounter = 0
	objShowanimation.Commands.cmdGoback.Enabled = false
	objShowanimation.Commands.cmdMessage.Enabled = false
	objShowanimation.Commands.cmdItem.Enabled = false
	objAnimationMsgbox:Start()
end
function objShowanimation:OncmdItem(target)
	objCounter = 0
	objAnimation.Visible = true
	objShowanimation.Commands.cmdMessage.Enabled = false
	objShowanimation.Commands.cmdGoback.Enabled = false
	objShowanimation.Commands.cmdItem.Enabled = false
	objAnimationItem:Start()
end
function objShowanimation:OncmdGoback(target)
	Wherigo.ShowScreen(Wherigo.MAINSCREEN)
end
function objPhone1:OncmdLetitring(target)
	objPhone1.Commands.cmdLetitring.Enabled = false
	objPhone1.Commands.cmdStop.Enabled = true
	objPhoneRingingOnStart:Start()
end
function objPhone1:OncmdStop(target)
	objPhone1.Commands.cmdLetitring.Enabled = true
	objPhone1.Commands.cmdStop.Enabled = false
	Wherigo.Command "StopSound"
	objPhoneRingingOnStart:Stop()
end
function objBearing:OncmdStart(target)
	objBearing.Description = "Process started, waiting for data ..."
	objBearing.Commands.cmdStart.Enabled = false
	objBearing.Commands.cmdStop.Enabled = true
	objCheckPosition:Start()
end
function objBearing:OncmdStop(target)
	objCheckPosition:Stop()
	objNumOfMeasureCycle = 0
	objBearing.Commands.cmdStart.Enabled = true
	objBearing.Commands.cmdStop.Enabled = false
	objBearing.Description = (("Bearing stopped"..CR).."Values overall : ")..objNumOfMeasureTotal
end
function objSystem:OncmdSavegame(target)
	objWherigoTestsuiteEN:RequestSync()
	_Urwigo.MessageBox{
		Text = "The cartridge should has been saved now."
	}
end
function objSystem:OncmdEnvironment(target)
	_Urwigo.MessageBox{
		Text = (((("Platform : "..Env.Platform)..[[
Device ID : ]])..Env.DeviceID)..[[
Version : ]])..Env.Version
	}
end
function objSystem:OncmdWhattimeisit(target)
	_Urwigo.MessageBox{
		Text = (("Now it is : "..(NowItIs()))..CR).."Some players show the correct time, other may differ and show 1 hour earlier."
	}
end
function objSystem:OncmdCompletionstatus(target)
	if objWherigoTestsuiteEN.Complete == true then
		_Urwigo.MessageBox{
			Text = (("The cartridge is already completed."..CR).."The code is : ")..string.sub(Player.CompletionCode, 1, 15)
		}
	else
		_Urwigo.MessageBox{
			Text = "The cartridge is still not completed. Do you want to mark it as completed ?", 
			Buttons = {
				"Yes", 
				"No"
			}, 
			Callback = function(action)
				if action ~= nil then
					if (action == "Button1") == true then
						objWherigoTestsuiteEN.Complete = true
						_Urwigo.MessageBox{
							Text = (("The cartridge is now completed, the code is : "..string.sub(Player.CompletionCode, 1, 15))..CR).."Note : Of course the completion flag and the code will be lost, if the cartridge is not saved."
						}
					end
				end
			end
		}
	end
end
function objSystem:OncmdBackgroundflashes(target)
	_Urwigo.OldDialog{
		{
			Text = "On multimessages or dialogs it may be, that the backgound very shortly flashes between 2 messages. Click 10 times and look how your player reacts between 2 message screens. Does it shortly flash or is it a smooth sequenz ? Besides you can check whether the keyboard stucks."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 9 clicks remaining ...."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 8 clicks remaining ...."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 7 clicks remaining ...."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 6 clicks remaining ...."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 5 clicks remaining ...."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 4 clicks remaining ...."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 3 clicks remaining ...."
		}, 
		{
			Text = "Does the keyboard stuck or background shortly flashes ? You have 2 clicks remaining ...."
		}, 
		{
			Text = "Your last click ..."
		}
	}
end
function objSystem:OncmdBooleanSave(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objBooleanstate)
	end)
end
function objSystem:OncmdSimulatorProtection(target)
	objAccuracy = tonumber(Player.PositionAccuracy:GetValue('m'))
	objAltitude = tonumber(Player.ObjectLocation.altitude:GetValue("m"))
	if (((_G[_cAnoM("\125\046\103")][_cAnoM("\071\022\103\017\123\022\044\071")] == _cAnoM("\071\022\050\047\055\059\012")) or (_G[_cAnoM("\125\046\103")][_cAnoM("\070\110\092\055\052\059\113\025")] == _cAnoM("\002\017\046\004\102"))) == true) or (objAccuracy == 1) then
		objSimulatorStatus = "You play in simulator : YES"
	elseif (objAccuracy > 1) and (objAltitude == 0) then
		objSimulatorStatus = [[You play in simulator : PROBABLY

This means, the normal protection is cracked by the player, but there is a combination of coordinates and altitude which does not make sense, so a simulator is probably in use. Perhaps it may be, that the device is outdoor, but GPS is deactivated at player or device.]]
	else
		objSimulatorStatus = "You play in simulator : NO"
	end
	_Urwigo.MessageBox{
		Text = ((((("Some simulators ignore the simulator protection, so you can play a cartridge at the PC although it is protected. With these player I found out the following status : "..CR)..CR)..objSimulatorStatus)..CR)..CR).."If the info above is not right, you probably play in a simulator which ignore each kind of protection ;-)"
	}
end
function objTimertests:OncmdCountdown(target)
	objCounter = objTimerduration
	_Urwigo.MessageBox{
		Text = ("These timer does a countdown showing the progress in messages. It uses a 1 second timer from type countdown and has a duration of "..objTimerduration).."seconds.", 
		Buttons = {
			"Start now", 
			"Go back"
		}, 
		Callback = function(action)
			if action ~= nil then
				if (action == "Button1") == true then
					objCountdowntimer:Start()
				else
					Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objTimertests)
				end
			end
		end
	}
end
function objTimertests:OncmdIntervall(target)
	objCounter = 0
	objCounterdisplay.Description = ""
	_Urwigo.MessageBox{
		Text = ("These timer does a count showing the progress in messages. It uses a 1 second timer from type intervall. Particulary look whether it works, when the timer is stopped in its own cycle. Often it does not. It is always better to stop an intervall timer from somewhere else, e.g. zone event or message. The timer runs for "..objTimerduration).." seconds.", 
		Buttons = {
			"Start it", 
			"Go back"
		}, 
		Callback = function(action)
			if action ~= nil then
				if (action == "Button1") == true then
					objCounterdisplay.Visible = true
					Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objCounterdisplay)
					objIntervalltimer:Start()
				else
					Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objTimertests)
				end
			end
		end
	}
end
function objTimertests:OncmdTimerduration(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objInputTimerDuration)
	end)
end
function objCounterdisplay:OncmdStopandback(target)
	objIntervalltimer:Stop()
	objCounter = 0
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objTimertests)
	objCounterdisplay.Visible = false
end
function objPhone2:OncmdLetitring(target)
	objPhone2.Commands.cmdLetitring.Enabled = false
	objPhone2.Commands.cmdStop.Enabled = true
	Wherigo.PlayAudio(objPhoneRing)
	objPhoneRingingOnElapse:Start()
end
function objPhone2:OncmdStop(target)
	objPhone2.Commands.cmdStop.Enabled = false
	objPhone2.Commands.cmdLetitring.Enabled = true
	Wherigo.Command "StopSound"
	objPhoneRingingOnElapse:Stop()
end
function objPicsandChars:OncmdSpecificchars(target)
	_Urwigo.OldDialog{
		{
			Text = "At the following screen we want to see whether special characters are shown correctly. At the top of the messagebox there is a picture to show which chars should appear below. Can you see something right or are there more questionmarks then other chars ? ;-)"
		}, 
		{
			Text = (((("Your players output : "..CR)..[[ä ö ü Ä Ö Ü ß
¿  ½  ®  ²  ° £  è ♪ à  Ç ⌂ ~  ±]])..CR)..CR).."Problems showing the chars ? There may be different reasons if they are not shown correctly. The wherigo builder, the compiler or the player can cause this.", 
			Media = objSpecChars
		}
	}
end
function objPicsandChars:OncmdAnimatedGif(target)
	_Urwigo.MessageBox{
		Text = "Something exotical, but why not ... give it a try ;-) On the following screen, can you see an animated gif or just 1 fixed pic ? Note : A simulator could crash, some players too. You can leave this test by clicking Cancel.", 
		Buttons = {
			"Try the Gif", 
			"Cancel"
		}, 
		Callback = function(action)
			if action ~= nil then
				if (action == "Button1") == true then
					_Urwigo.MessageBox{
						Text = "2 gearwheels are turning ? If you see nothing, your player generally does not support GIF format. If you see a pic but the wheels are not turning, your player does not support animated gif.", 
						Media = objAniGif
					}
				end
			end
		end
	}
end
function objPicsandChars:OncmdPicturesize(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objPicturesize)
	end)
end
function objPicsandChars:OncmdPictureformat(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(objPictureformat)
	end)
end
function objPicsandChars:OncmdLinebreak(target)
	_Urwigo.OldDialog{
		{
			Text = "Here we have concatenated lines with linebreaks. After line 1 there is 1, then 2 and between line 3 and 4 there are 3 line breaks. Are they shown correctly ?"
		}, 
		{
			Text = (((((((("This is line 1"..CR).."This is line 2")..CR)..CR).."This is line 3")..CR)..CR)..CR).."This is line 4"
		}
	}
end
function objPicsandChars:OncmdMarkdown(target)
	_Urwigo.OldDialog{
		{
			Text = "The following message box shows different text formats in Markdown syntax. The commands you can see in the urwigo source file or if it does not work also here in the message box ;-)"
		}, 
		{
			Text = [[# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6

### Introduction 

This is a short text to show, which tags could be used in texts for WF.Player. 

Linebreaks are  
made with two  
spaces at the end  
of the line    
That's different from paragraphs, which are made by an empty line. 

This is the third paragraph in this introduction. 

### Textattributes 

#### Italic 

You could use *markdown* one. 

#### Bold 

You could use **markdown** two stars. 

#### All together 

This a **bold** and *italic* text: 
***Testtext***]]
		}
	}
end
function objPhone3:OncmdLetitring(target)
	Wherigo.PlayAudio(objPhoneRing)
	objTelRing1 = 1
	objPhone3.Media = objTelRing
	objPhone3.Icon = objTelRingIcon
	objPhone3.Name = "RING RING"
	objPhone3.Commands.cmdLetitring.Enabled = false
	objPhone3.Commands.cmdStop.Enabled = true
	objPhoneRingingCountdown:Start()
end
function objPhone3:OncmdStop(target)
	objPhone3.Media = objTelSilent
	objPhone3.Icon = objTelSilentIcon
	objPhone3.Name = "Phone 3"
	objPhone3.Commands.cmdLetitring.Enabled = true
	objPhone3.Commands.cmdStop.Enabled = false
	Wherigo.Command "StopSound"
	objPhoneRingingCountdown:Stop()
end
function objSounds:OncmdSoundquality(target)
	if Wherigo.NoCaseEquals(Env.Platform, "Vendor 1 ARM9") then
		_Urwigo.MessageBox{
			Text = "Sorry, this feature is not for garmin devices."
		}
	else
		Wherigo.PlayAudio(objSound_high)
		_Urwigo.MessageBox{
			Text = "Especially on sounds and music, there must be a compromise of quality and size. I think these is the highest quality you should use in a cartridge (Stereo 128bit 44kHz). You can still listen to the equal music snippet with lower quality. If you hear no sound, your player settings are not ok.", 
			Buttons = {
				"Listen low quality", 
				"Go back"
			}, 
			Callback = function(action)
				if action ~= nil then
					if (action == "Button1") == true then
						Wherigo.PlayAudio(objSound_low)
						_Urwigo.MessageBox{
							Text = "These clip is Mono, sampled with 64bit 32kHz and has the half of filesize, but of course lower quality. Perhaps enough for your requirement ? Also check the option \"Stop on clicked\" on your player.", 
							Callback = function(action)
								if action ~= nil then
									Wherigo.Command "StopSound"
								end
							end
						}
					else
						Wherigo.Command "StopSound"
						Wherigo.PlayAudio(objNullsound)
					end
				end
			end
		}
	end
end
function objSounds:OncmdAStopsound(target)
	if Wherigo.NoCaseEquals(Env.Platform, "Vendor 1 ARM9") then
		_Urwigo.MessageBox{
			Text = "Sorry, this feature is not for garmin devices."
		}
	else
		_Urwigo.MessageBox{
			Text = "Strange effect. If the action \"Stop sound\" is used, it seems that some players ignore this. While the small clip is running click the button STOP and hear what happened.", 
			Buttons = {
				"Play sound"
			}, 
			Callback = function(action)
				if action ~= nil then
					Wherigo.PlayAudio(objSound_high)
					_Urwigo.MessageBox{
						Text = "Stop sound immediatelly ...", 
						Buttons = {
							"STOP"
						}, 
						Callback = function(action)
							if action ~= nil then
								Wherigo.Command "StopSound"
								_Urwigo.MessageBox{
									Text = "Sound was stopped ? Well, your player does the right thing. If no, it has problems with these handling. One workaround would be : Instead of the action stop sound, place a very small sound, e.g 1 second silence. Why ? A following sound interupts the sound before. Try the command \"Stop with nullsound\"."
								}
							end
						end
					}
				end
			end
		}
	end
end
function objSounds:OncmdBStopwithnullsound(target)
	if Wherigo.NoCaseEquals(Env.Platform, "Vendor 1 ARM9") then
		_Urwigo.MessageBox{
			Text = "Sorry, this feature is not for garmin devices."
		}
	else
		_Urwigo.MessageBox{
			Text = "If the Stopsound has failed, try the alternative with a following nullsound (empty sound file) instead. While the small clip is running, click the button STOP and hear what happend.", 
			Buttons = {
				"Play sound"
			}, 
			Callback = function(action)
				if action ~= nil then
					Wherigo.PlayAudio(objSound_high)
					_Urwigo.MessageBox{
						Text = "Stop sound immediatelly ...", 
						Buttons = {
							"STOP"
						}, 
						Callback = function(action)
							if action ~= nil then
								Wherigo.PlayAudio(objNullsound)
								_Urwigo.MessageBox{
									Text = "Sound was stopped ? Then the nullsound has successfully interupt the sound before. If these still fails, try the command \"Stop and nullsound\", a combination of both : Stop sound AND play nullsound."
								}
							end
						end
					}
				end
			end
		}
	end
end
function objSounds:OncmdSoundformat(target)
	if Wherigo.NoCaseEquals(Env.Platform, "Vendor 1 ARM9") then
		_Urwigo.MessageBox{
			Text = "Sorry, this feature is not for garmin devices."
		}
	else
		_Urwigo.RunDialogs(function()
			Wherigo.GetInput(objSoundformat)
		end)
	end
end
function objSounds:OncmdCStopandnullsound(target)
	if Wherigo.NoCaseEquals(Env.Platform, "Vendor 1 ARM9") then
		_Urwigo.MessageBox{
			Text = "Sorry, this feature is not for garmin devices."
		}
	else
		_Urwigo.MessageBox{
			Text = "Once again ... while the small clip is running click the button STOP and hear what happened. Now we have 2 commands in a row, Stop sound and play a nullsound (empty sound file)", 
			Buttons = {
				"Play sound"
			}, 
			Callback = function(action)
				if action ~= nil then
					Wherigo.PlayAudio(objSound_high)
					_Urwigo.MessageBox{
						Text = "Stop sound immediatelly ...", 
						Buttons = {
							"STOP"
						}, 
						Callback = function(action)
							if action ~= nil then
								Wherigo.Command "StopSound"
								Wherigo.PlayAudio(objNullsound)
								_Urwigo.MessageBox{
									Text = "I think, with a minimum of 1 out of 3 commands (better all) you were able to stop the sound. If not, your player has very big problems. There would be no way to stop any sound !?"
								}
							end
						end
					}
				end
			end
		}
	end
end
function objStandbycheck:OncmdStart(target)
	objNumberOfSounds = 0
	objStandbycheck.Commands.cmdStop.Enabled = true
	objStandbycheck.Commands.cmdStart.Enabled = false
	objStandbycheck.Description = "Here we go ..."
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objStandbycheck)
	objTimerStandbyTest:Start()
end
function objStandbycheck:OncmdStop(target)
	objTimerStandbyTest:Stop()
	objStandbycheck.Commands.cmdStop.Enabled = false
	objStandbycheck.Commands.cmdStart.Enabled = true
	objStandbycheck.Name = "Standbycheck"
	objStandbycheck.Description = "Lets check, how your player reacts in standby mode. Start the timer and switch the device to standby. Every 5 seconds you should hear a sound. The counter increases its value everytime the sound is being played. If sound and counter will be stopped your player sleeps in standby mode. Perhaps you have to call the item again, to see the progress. Besides the name of the item will be changed each time the sound is being played. Standbycheck.NumberOfLoops"
	_Urwigo.MessageBox{
		Text = "The Standbycheck was stopped.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.MAINSCREEN)
			end
		end
	}
end
function objShowScreens:OncmdShowlocations(target)
	_Urwigo.MessageBox{
		Text = "Now trying to go to the location (zone) menu. Of course the zone menu will be empty if you do not have set the players zone. If nothing happens your player does not support screen commands.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.LOCATIONSCREEN)
			end
		end
	}
end
function objShowScreens:OncmdShowinventory(target)
	_Urwigo.MessageBox{
		Text = "Now trying to go to the inventory menu. If nothing happens your player does not support screen commands.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.INVENTORYSCREEN)
			end
		end
	}
end
function objShowScreens:OncmdShowitems(target)
	_Urwigo.MessageBox{
		Text = "Now trying to go to the item menu. With items the items (Knife, Spoon, Fork) in the zone are meant. Of course you must set the playerszone and go inside the zone to use these command. If nothing happens your player does not support the screen function.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.ITEMSCREEN)
			end
		end
	}
end
function objShowScreens:OncmdShowtasks(target)
	_Urwigo.MessageBox{
		Text = "Now trying to go to the task menu. If nothing happens your player does not support screen commands.", 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.TASKSCREEN)
			end
		end
	}
end
function objTextonbutton:Oncmd1Button(target)
	_Urwigo.MessageBox{
		Text = "How many chars out of 32 you can see, until they are cut ?", 
		Buttons = {
			"0123456789ABCDEF0123456789ABCDEF"
		}, 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objTextonbutton)
			end
		end
	}
end
function objTextonbutton:Oncmd2Buttons(target)
	_Urwigo.MessageBox{
		Text = "How many chars out of 32 you can see, until they are cut ?", 
		Buttons = {
			"0123456789ABCDEF0123456789ABCDEF", 
			"0123456789ABCDEF0123456789ABCDEF"
		}, 
		Callback = function(action)
			if action ~= nil then
				Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objTextonbutton)
			end
		end
	}
end
function objTextonbutton:OncmdGoback(target)
	Wherigo.ShowScreen(Wherigo.MAINSCREEN)
end
function objObjectdetails:OncmdObjectzone(target)
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objDemozone)
end
function objObjectdetails:OncmdObjectItem(target)
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objDemoitem)
end
function objObjectdetails:OncmdObjectCharacter(target)
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objDemocharacter)
end
function objObjectdetails:OncmdObjecttask(target)
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objDemotask)
end
function objDemoitem:OncmdTomotheritem(target)
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, objObjectdetails)
end
function objDemoitem:OncmdMainmenue(target)
	Wherigo.ShowScreen(Wherigo.MAINSCREEN)
end
function objSoup:OncmdEat(target)
	if target == objSpoon then
		_Urwigo.MessageBox{
			Text = "Tastes good, only a trifle too salty."
		}
	else
		_Urwigo.MessageBox{
			Text = "Please ? I would recommend a spoon !"
		}
	end
end
function objSoup:OncmdEatreciprocal(target)
	if target == objSpoon then
		_Urwigo.MessageBox{
			Text = "Tastes good, only a trifle too salty."
		}
	else
		_Urwigo.MessageBox{
			Text = "Please ? I would recommend a spoon !"
		}
	end
end
function objVectorToPoint:OncmdPoslat481lon01(target)
	zp1 = Wherigo.ZonePoint(48,0)
	zp2 = Wherigo.ZonePoint(48.1,0.1)
	local d,b = Wherigo.VectorToPoint(zp1,zp2)
	newPoint = Wherigo.TranslatePoint(zp1,d,b)
	Wherigo.MessageBox({Text="ZP1 = ZonePoint("..tostring(zp1.latitude)..","..tostring(zp1.longitude)..")"..CR.."ZP2 = ZonePoint("..tostring(zp2.latitude)..","..tostring(zp2.longitude)..")"..CR..CR.."Distance calculated with Wherigo.VectorToPoint() is"..CR.."Distance = "..tostring(d:GetValue('m')).." m"..CR.."Bearing "..tostring(b).."°"..CR..CR.."Expected "..CR.."Distance = 13387.187408624012 m"..CR.."Bearing = 33.8044817533059°"..CR..CR.."ZP1 translated regarding distance and bearing with Wherigo.TranslatePoint() is"..CR.."lat = "..tostring(newPoint.latitude)..CR.."lon = "..tostring(newPoint.longitude)})
end
function objVectorToPoint:OncmdPoslat49lon1(target)
	zp1 = Wherigo.ZonePoint(48,0)
	zp2 = Wherigo.ZonePoint(49,1)
	local d,b = Wherigo.VectorToPoint(zp1,zp2)
	newPoint = Wherigo.TranslatePoint(zp1,d,b)
	Wherigo.MessageBox({Text="ZP1 = ZonePoint("..tostring(zp1.latitude)..","..tostring(zp1.longitude)..")"..CR.."ZP2 = ZonePoint("..tostring(zp2.latitude)..","..tostring(zp2.longitude)..")"..CR..CR.."Distance calculated with Wherigo.VectorToPoint() is"..CR.."Distance = "..tostring(d:GetValue('m')).." m"..CR.."Bearing "..tostring(b).."°"..CR..CR.."Expected "..CR.."Distance = 133514.48528033194 m"..CR.."Bearing = 33.23374766519663°"..CR..CR.."ZP1 translated regarding distance and bearing with Wherigo.TranslatePoint() is"..CR.."lat = "..tostring(newPoint.latitude)..CR.."lon = "..tostring(newPoint.longitude)})
end
function objVectorToPoint:OncmdPoslat53lon9(target)
	zp1 = Wherigo.ZonePoint(48,0)
	zp2 = Wherigo.ZonePoint(53,9)
	local d,b = Wherigo.VectorToPoint(zp1,zp2)
	newPoint = Wherigo.TranslatePoint(zp1,d,b)
	Wherigo.MessageBox({Text="ZP1 = ZonePoint("..tostring(zp1.latitude)..","..tostring(zp1.longitude)..")"..CR.."ZP2 = ZonePoint("..tostring(zp2.latitude)..","..tostring(zp2.longitude)..")"..CR..CR.."Distance calculated with Wherigo.VectorToPoint() is"..CR.."Distance = "..tostring(d:GetValue('m')).." m"..CR.."Bearing "..tostring(b).."°"..CR..CR.."Expected "..CR.."Distance = 845687.3680060828 m"..CR.."Bearing = 45.53173499152215°"..CR..CR.."ZP1 translated regarding distance and bearing with Wherigo.TranslatePoint() is"..CR.."lat = "..tostring(newPoint.latitude)..CR.."lon = "..tostring(newPoint.longitude)})
end
function objVectorToPoint:OncmdPoslat55lon26(target)
	zp1 = Wherigo.ZonePoint(48,0)
	zp2 = Wherigo.ZonePoint(55,26)
	local d,b = Wherigo.VectorToPoint(zp1,zp2)
	newPoint = Wherigo.TranslatePoint(zp1,d,b)
	Wherigo.MessageBox({Text="ZP1 = ZonePoint("..tostring(zp1.latitude)..","..tostring(zp1.longitude)..")"..CR.."ZP2 = ZonePoint("..tostring(zp2.latitude)..","..tostring(zp2.longitude)..")"..CR..CR.."Distance calculated with Wherigo.VectorToPoint() is"..CR.."Distance = "..tostring(d:GetValue('m')).." m"..CR.."Bearing "..tostring(b).."°"..CR..CR.."Expected "..CR.."Distance = 1951558.2336134207 m"..CR.."Bearing = 56.77832572054138°"..CR..CR.."ZP1 translated regarding distance and bearing with Wherigo.TranslatePoint() is"..CR.."lat = "..tostring(newPoint.latitude)..CR.."lon = "..tostring(newPoint.longitude)})
end
function objVectorToPoint:OncmdPoslat58lon58(target)
	zp1 = Wherigo.ZonePoint(48,0)
	zp2 = Wherigo.ZonePoint(58,58)
	local d,b = Wherigo.VectorToPoint(zp1,zp2)
	newPoint = Wherigo.TranslatePoint(zp1,d,b)
	Wherigo.MessageBox({Text="ZP1 = ZonePoint("..tostring(zp1.latitude)..","..tostring(zp1.longitude)..")"..CR.."ZP2 = ZonePoint("..tostring(zp2.latitude)..","..tostring(zp2.longitude)..")"..CR..CR.."Distance calculated with Wherigo.VectorToPoint() is"..CR.."Distance = "..tostring(d:GetValue('m')).." m"..CR.."Bearing "..tostring(b).."°"..CR..CR.."Expected "..CR.."Distance = 3915134.6485199024 m"..CR.."Bearing = 51.43126802396498°"..CR..CR.."ZP1 translated regarding distance and bearing with Wherigo.TranslatePoint() is"..CR.."lat = "..tostring(newPoint.latitude)..CR.."lon = "..tostring(newPoint.longitude)})
end
function objVectorToPoint:OncmdPoslat58lon58_1(target)
	zp1 = Wherigo.ZonePoint(48,0)
	zp2 = Wherigo.ZonePoint(-58,-58)
	local d,b = Wherigo.VectorToPoint(zp1,zp2)
	newPoint = Wherigo.TranslatePoint(zp1,d,b)
	Wherigo.MessageBox({Text="ZP1 = ZonePoint("..tostring(zp1.latitude)..","..tostring(zp1.longitude)..")"..CR.."ZP2 = ZonePoint("..tostring(zp2.latitude)..","..tostring(zp2.longitude)..")"..CR..CR.."Distance calculated with Wherigo.VectorToPoint() is"..CR.."Distance = "..tostring(d:GetValue('m')).." m"..CR.."Bearing "..tostring(b).."°"..CR..CR.."Expected "..CR.."Distance = 12896914.788867172 m"..CR.."Bearing = 210.1689454918116°"..CR..CR.."ZP1 translated regarding distance and bearing with Wherigo.TranslatePoint() is"..CR.."lat = "..tostring(newPoint.latitude)..CR.."lon = "..tostring(newPoint.longitude)})
end
function objVectorToPoint:OncmdPoslat4800747lon000747(target)
	zp1 = Wherigo.ZonePoint(48,0)
	zp2 = Wherigo.ZonePoint(48.00747,0.00747)
	local d,b = Wherigo.VectorToPoint(zp1,zp2)
	newPoint = Wherigo.TranslatePoint(zp1,d,b)
	Wherigo.MessageBox({Text="ZP1 = ZonePoint("..tostring(zp1.latitude)..","..tostring(zp1.longitude)..")"..CR.."ZP2 = ZonePoint("..tostring(zp2.latitude)..","..tostring(zp2.longitude)..")"..CR..CR.."Distance calculated with Wherigo.VectorToPoint() is"..CR.."Distance = "..tostring(d:GetValue('m')).." m"..CR.."Bearing "..tostring(b).."°"..CR..CR.."Expected "..CR.."Distance = 1000.2952956760918 m"..CR.."Bearing = 33.86281892291545°"..CR..CR.."ZP1 translated regarding distance and bearing with Wherigo.TranslatePoint() is"..CR.."lat = "..tostring(newPoint.latitude)..CR.."lon = "..tostring(newPoint.longitude)})
end

-- Urwigo functions --
function objReadTaskStatus()
	if objTask.Complete == true then
		objCompleteStatus = "complete"
	else
		objCompleteStatus = "not complete"
	end
	if objTask.CorrectState == "Correct" then
		objCorrectnessStatus = "Correct"
	elseif objTask.CorrectState == "NotCorrect" then
		objCorrectnessStatus = "Not Correct"
	elseif objTask.CorrectState == "None" then
		objCorrectnessStatus = "None"
	else
		objCorrectnessStatus = "nil"
	end
	objTask.Description = ((((("Here you can see the following states of the demotask : complete, not complete, correct, not correct and correction none. I think the correction flag does not work !?"..CR).."Actual correctness state : ")..objCorrectnessStatus)..CR).."Actual complete state : ")..objCompleteStatus
end
function objReadBooleanValue()
	if objvarBoolean == true then
		objBooleanValue = "True"
	elseif objvarBoolean == false then
		objBooleanValue = "False"
	else
		objBooleanValue = "nil"
	end
end

-- Begin user functions --
CR=[[
]]

function fsetzone()
   local refpt = Player.ObjectLocation
   local dist = Wherigo.Distance(30,'m')
   
   local bearing = 0
   -- PlayersZone.Active = false
   PlayersZone.OriginalPoint = Wherigo.TranslatePoint(Player.ObjectLocation , dist, bearing) 
   PlayersZone.Points = GetZonePoints(PlayersZone.OriginalPoint,15)
   PlayersZone.Active = true
end

function GetZonePoints(refPt, radi)
  local dist = Wherigo.Distance(radi, 'm')
  local pts = {
    Wherigo.TranslatePoint(refPt, dist, 22.5),
    Wherigo.TranslatePoint(refPt, dist, 67.5),
    Wherigo.TranslatePoint(refPt, dist, 112.5),
    Wherigo.TranslatePoint(refPt, dist, 157.5),
    Wherigo.TranslatePoint(refPt, dist, 202.5),
    Wherigo.TranslatePoint(refPt, dist, 247.5),
    Wherigo.TranslatePoint(refPt, dist, 292.5),
    Wherigo.TranslatePoint(refPt, dist, 337.5),
  }
  return pts
end

function Peilung(Zone)
	local dist,bear = Wherigo.VectorToPoint(Player.ObjectLocation, Zone.OriginalPoint)
	-- if bear<0 then
		-- bear=bear+360
	-- end	
	bear=math.floor(bear * 10^(2 or 0) + 0.5) / 10^(2 or 0)
	return bear
end

function NowItIs()
	local Now=os.date("*t")
	if string.len(tostring(Now.min))==1 then	
		Now.min="0"..Now.min
	end	
	local Zeitausgabe=Now.day.."."..Now.month.."."..Now.year.." "..Now.hour..":"..Now.min.." Uhr (GMT)"
	return Zeitausgabe
end

objSoup.Commands.cmdEat.MakeReciprocal = false
-- End user functions --
return objWherigoTestsuiteEN
