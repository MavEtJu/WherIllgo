require "Wherigo"
ZonePoint = Wherigo.ZonePoint
Distance = Wherigo.Distance
Player = Wherigo.Player

-- String decode --
function _214L(str)
	local res = ""
    local dtable = "\077\018\011\121\051\000\088\078\041\052\084\038\115\067\049\030\096\025\073\024\037\012\020\021\008\080\092\079\076\033\004\066\099\082\026\085\060\059\017\057\022\095\016\050\062\044\047\074\094\042\070\103\031\106\083\014\100\116\028\111\013\007\123\035\108\027\112\090\097\005\055\114\075\046\006\089\003\009\036\029\010\125\110\023\098\034\040\109\081\048\019\126\119\093\032\001\120\113\104\068\039\053\117\105\091\107\118\072\043\071\124\064\065\086\101\063\054\061\087\069\002\102\058\056\122\015\045"
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

_uVERC = Wherigo.ZCartridge()

-- Media --
_O30im = Wherigo.ZMedia(_uVERC)
_O30im.Id = "28cd8f65-9434-4205-8469-2e82bea22959"
_O30im.Name = _214L("\028\099\088\095\029\060\052\060")
_O30im.Description = ""
_O30im.AltText = ""
_O30im.Resources = {
	{
		Type = "jpg", 
		Filename = "ohm2013_1.jpg", 
		Directives = {}
	}
}
_PWe2d = Wherigo.ZMedia(_uVERC)
_PWe2d.Id = "935f261a-33af-4f8f-b2d7-fc92a829d07b"
_PWe2d.Name = _214L("\076\060\057\069")
_PWe2d.Description = ""
_PWe2d.AltText = ""
_PWe2d.Resources = {
	{
		Type = "jpg", 
		Filename = "Yoda.jpg", 
		Directives = {}
	}
}
_dBdDe = Wherigo.ZMedia(_uVERC)
_dBdDe.Id = "8e5239c2-b7ae-4954-a050-2ea9d3a4c7d3"
_dBdDe.Name = _214L("\072\069\104\083\085\060\093\095\013\060\083\052")
_dBdDe.Description = ""
_dBdDe.AltText = ""
_dBdDe.Resources = {
	{
		Type = "mp3", 
		Filename = "somewhereovertherainbow8bitversion.mp3", 
		Directives = {}
	}
}
_xV8 = Wherigo.ZMedia(_uVERC)
_xV8.Id = "ac8397f2-e634-4565-9935-6ee57e3dec99"
_xV8.Name = _214L("\122\060\060\057\099\069\033\106")
_xV8.Description = ""
_xV8.AltText = ""
_xV8.Resources = {
	{
		Type = "jpg", 
		Filename = "foodhack.jpg", 
		Directives = {}
	}
}
_7xZmb = Wherigo.ZMedia(_uVERC)
_7xZmb.Id = "cbb41837-4897-4930-9531-722c6bfa4e65"
_7xZmb.Name = _214L("\034\069\104\083\085\060\093")
_7xZmb.Description = ""
_7xZmb.AltText = ""
_7xZmb.Resources = {
	{
		Type = "jpg", 
		Filename = "rainbow.jpg", 
		Directives = {}
	}
}
_gHbhY = Wherigo.ZMedia(_uVERC)
_gHbhY.Id = "4a3c44ea-3659-48d5-87c8-74ef251ddd0f"
_gHbhY.Name = _214L("\119\115\065\065")
_gHbhY.Description = ""
_gHbhY.AltText = ""
_gHbhY.Resources = {
	{
		Type = "jpg", 
		Filename = "well2.jpg", 
		Directives = {}
	}
}
_A_Fi = Wherigo.ZMedia(_uVERC)
_A_Fi.Id = "aa5633c5-1a31-4be7-87d6-11ad62af7b14"
_A_Fi.Name = _214L("\100\115\065\060\072\104\069\083")
_A_Fi.Description = ""
_A_Fi.AltText = ""
_A_Fi.Resources = {
	{
		Type = "jpg", 
		Filename = "delorian2.jpg", 
		Directives = {}
	}
}
_OwS = Wherigo.ZMedia(_uVERC)
_OwS.Id = "e3d35ac6-a070-4e62-a137-8a86c6a0323e"
_OwS.Name = _214L("\051\065\103\097\095\033\069\067\069\033\104\058\060\072")
_OwS.Description = ""
_OwS.AltText = ""
_OwS.Resources = {
	{
		Type = "jpg", 
		Filename = "Fluxcapacitor.jpg", 
		Directives = {}
	}
}
_QX7Z = Wherigo.ZMedia(_uVERC)
_QX7Z.Id = "93cbb7f8-1ee7-4791-ab8c-c14d855a103a"
_QX7Z.Name = _214L("\100\072\103\104\057")
_QX7Z.Description = ""
_QX7Z.AltText = ""
_QX7Z.Resources = {
	{
		Type = "jpg", 
		Filename = "druid.jpg", 
		Directives = {}
	}
}
_43R = Wherigo.ZMedia(_uVERC)
_43R.Id = "b56304bc-8909-4933-b39d-53e3cf664005"
_43R.Name = _214L("\034\060\088\069\083\095\026\069\058\072\060\065")
_43R.Description = ""
_43R.AltText = ""
_43R.Resources = {
	{
		Type = "jpg", 
		Filename = "roman.jpg", 
		Directives = {}
	}
}
_uR23 = Wherigo.ZMedia(_uVERC)
_uR23.Id = "dca523df-b04b-4ac9-9c35-f828d44ae092"
_uR23.Name = _214L("\014\065\115\069\072\104\083\052")
_uR23.Description = ""
_uR23.AltText = ""
_uR23.Resources = {
	{
		Type = "jpg", 
		Filename = "Clearing_by_a_marsh_in_the_woods.jpg", 
		Directives = {}
	}
}
_LuaPT = Wherigo.ZMedia(_uVERC)
_LuaPT.Id = "9ff88eee-8eb2-4590-ad1e-2b67070ac6e6"
_LuaPT.Name = _214L("\001\104\013\058\065\115\058\060\115")
_LuaPT.Description = ""
_LuaPT.AltText = ""
_LuaPT.Resources = {
	{
		Type = "jpg", 
		Filename = "mistletoe.jpg", 
		Directives = {}
	}
}
_H18h = Wherigo.ZMedia(_uVERC)
_H18h.Id = "97535ddc-8ce6-4aad-accf-4bef03488482"
_H18h.Name = _214L("\113\013\058\115\072\104\013\106")
_H18h.Description = ""
_H18h.AltText = ""
_H18h.Resources = {
	{
		Type = "jpg", 
		Filename = "asterisk.jpg", 
		Directives = {}
	}
}
_ad97 = Wherigo.ZMedia(_uVERC)
_ad97.Id = "fc1068c6-8c8d-40c6-ba7c-f01ccfeb3ac9"
_ad97.Name = _214L("\099\044\060")
_ad97.Description = ""
_ad97.AltText = ""
_ad97.Resources = {
	{
		Type = "jpg", 
		Filename = "h2o.jpg", 
		Directives = {}
	}
}
_Tzpzp = Wherigo.ZMedia(_uVERC)
_Tzpzp.Id = "339176b9-48f2-485c-9542-2913ebc53ae9"
_Tzpzp.Name = _214L("\089\103\115\013\058\104\060\083\095\088\069\072\106")
_Tzpzp.Description = ""
_Tzpzp.AltText = ""
_Tzpzp.Resources = {
	{
		Type = "jpg", 
		Filename = "questoinmark.jpg", 
		Directives = {}
	}
}
_5x3e = Wherigo.ZMedia(_uVERC)
_5x3e.Id = "a870663e-c07f-4eea-b73e-7e14d9426108"
_5x3e.Name = _214L("\051\104\052\099\058")
_5x3e.Description = ""
_5x3e.AltText = ""
_5x3e.Resources = {
	{
		Type = "jpg", 
		Filename = "fight.jpg", 
		Directives = {}
	}
}
_1QX = Wherigo.ZMedia(_uVERC)
_1QX.Id = "73f71746-6642-4e18-8de0-a2efd9521c33"
_1QX.Name = _214L("\011\069\072\057\104\013")
_1QX.Description = ""
_1QX.AltText = ""
_1QX.Resources = {
	{
		Type = "jpg", 
		Filename = "tardis.jpg", 
		Directives = {}
	}
}
_LJe = Wherigo.ZMedia(_uVERC)
_LJe.Id = "b60ccb7a-1cf6-4e88-b88a-71711342fa0d"
_LJe.Name = _214L("\100\072\074\095\119\099\060")
_LJe.Description = ""
_LJe.AltText = ""
_LJe.Resources = {
	{
		Type = "jpg", 
		Filename = "DrWho.jpg", 
		Directives = {}
	}
}
_Zi_Nc = Wherigo.ZMedia(_uVERC)
_Zi_Nc.Id = "5bf77a97-2bd3-4e6d-bba8-d04f1ba1b3e5"
_Zi_Nc.Name = _214L("\033\117\010")
_Zi_Nc.Description = ""
_Zi_Nc.AltText = ""
_Zi_Nc.Resources = {
	{
		Type = "jpg", 
		Filename = "c64.jpg", 
		Directives = {}
	}
}
_22Zmj = Wherigo.ZMedia(_uVERC)
_22Zmj.Id = "c1e2390b-6337-4ffa-8fd3-cccdb542d69a"
_22Zmj.Name = _214L("\011\072\069\057\104\013\095\013\060\103\083\057")
_22Zmj.Description = ""
_22Zmj.AltText = ""
_22Zmj.Resources = {
	{
		Type = "mp3", 
		Filename = "tardis.mp3", 
		Directives = {}
	}
}
_6VwMs = Wherigo.ZMedia(_uVERC)
_6VwMs.Id = "f5260aee-8dfa-4a2c-95e8-67e31423af55"
_6VwMs.Name = _214L("\019\026\036")
_6VwMs.Description = ""
_6VwMs.AltText = ""
_6VwMs.Resources = {
	{
		Type = "jpg", 
		Filename = "ipu.jpg", 
		Directives = {}
	}
}
_CRaA = Wherigo.ZMedia(_uVERC)
_CRaA.Id = "e58ede08-16e0-4029-a2ff-072cd896486d"
_CRaA.Name = _214L("\036\083\104\033\060\072\083")
_CRaA.Description = ""
_CRaA.AltText = ""
_CRaA.Resources = {
	{
		Type = "jpg", 
		Filename = "unicarn.jpg", 
		Directives = {}
	}
}
_XPAR = Wherigo.ZMedia(_uVERC)
_XPAR.Id = "ef97f9f3-44f5-46cc-bb49-fcc94988116c"
_XPAR.Name = _214L("\107\085\088")
_XPAR.Description = ""
_XPAR.AltText = ""
_XPAR.Resources = {
	{
		Type = "jpg", 
		Filename = "vbm.jpg", 
		Directives = {}
	}
}
_jab = Wherigo.ZMedia(_uVERC)
_jab.Id = "62b2ff8a-274b-4d3e-a02b-2e89dde3b21e"
_jab.Name = _214L("\051\069\072\088\114\104\065\065\115")
_jab.Description = ""
_jab.AltText = ""
_jab.Resources = {
	{
		Type = "jpg", 
		Filename = "FarmVille.jpg", 
		Directives = {}
	}
}
__dh2 = Wherigo.ZMedia(_uVERC)
__dh2.Id = "fa88fe34-2b77-47f1-a9ac-e04d0d7d2723"
__dh2.Name = _214L("\113\072\115\069\010\044")
__dh2.Description = ""
__dh2.AltText = ""
__dh2.Resources = {
	{
		Type = "PNG", 
		Filename = "area42.PNG", 
		Directives = {}
	}
}
_WmJzU = Wherigo.ZMedia(_uVERC)
_WmJzU.Id = "9f3c7036-7dd3-409b-beb6-4c7dde7378db"
_WmJzU.Name = _214L("\108\103\088\088\115\072")
_WmJzU.Description = ""
_WmJzU.AltText = ""
_WmJzU.Resources = {
	{
		Type = "jpg", 
		Filename = "hummer.jpg", 
		Directives = {}
	}
}
_lSp = Wherigo.ZMedia(_uVERC)
_lSp.Id = "c3665513-32b3-4166-8958-623069139ba4"
_lSp.Name = _214L("\001\104\065\065\104\093\069\004\013")
_lSp.Description = ""
_lSp.AltText = ""
_lSp.Resources = {
	{
		Type = "jpg", 
		Filename = "milliways.jpg", 
		Directives = {}
	}
}
_ful = Wherigo.ZMedia(_uVERC)
_ful.Id = "3421b59b-eb37-4334-99de-c31e9ddbad2b"
_ful.Name = _214L("\051\060\072\115\013\058")
_ful.Description = ""
_ful.AltText = ""
_ful.Resources = {
	{
		Type = "jpg", 
		Filename = "forest.jpg", 
		Directives = {}
	}
}
_0gx5y = Wherigo.ZMedia(_uVERC)
_0gx5y.Id = "c853cb34-a664-468a-916e-37c8e154b003"
_0gx5y.Name = _214L("\076\001\014\113")
_0gx5y.Description = ""
_0gx5y.AltText = ""
_0gx5y.Resources = {
	{
		Type = "jpg", 
		Filename = "ymca.jpg", 
		Directives = {}
	}
}
_m0Nj = Wherigo.ZMedia(_uVERC)
_m0Nj.Id = "181a604a-b4c7-4756-96cf-8e76678fccf7"
_m0Nj.Name = _214L("\019\013\069\033")
_m0Nj.Description = ""
_m0Nj.AltText = ""
_m0Nj.Resources = {
	{
		Type = "jpg", 
		Filename = "isac.jpg", 
		Directives = {}
	}
}
_RYlTZ = Wherigo.ZMedia(_uVERC)
_RYlTZ.Id = "877b62f9-d862-431c-83c9-e1255112e06f"
_RYlTZ.Name = _214L("\011\099\115\100\060\033")
_RYlTZ.Description = ""
_RYlTZ.AltText = ""
_RYlTZ.Resources = {
	{
		Type = "jpg", 
		Filename = "TheDoc.jpg", 
		Directives = {}
	}
}
_OF3GA = Wherigo.ZMedia(_uVERC)
_OF3GA.Id = "c86880b2-6103-4a64-ad43-a8fae935d7ef"
_OF3GA.Name = _214L("\058\054")
_OF3GA.Description = ""
_OF3GA.AltText = ""
_OF3GA.Resources = {
	{
		Type = "jpg", 
		Filename = "tj.jpg", 
		Directives = {}
	}
}
-- Cartridge Info --
_uVERC.Id="e4de424e-2406-4528-952c-ec8d1a39c02a"
_uVERC.Name="Ohm 2013"
_uVERC.Description=[[]]
_uVERC.Visible=true
_uVERC.Activity="Fiction"
_uVERC.StartingLocationDescription=[[]]
_uVERC.StartingLocation = ZonePoint(52.6953207311222,4.75300312042236,0)
_uVERC.Version="1.0"
_uVERC.Company="Schuberg Philis"
_uVERC.Author="Frank & Gert"
_uVERC.BuilderVersion="URWIGO 1.14.4813.25199"
_uVERC.CreateDate="07/09/2013 15:49:36"
_uVERC.PublishDate="1/1/0001 12:00:00 AM"
_uVERC.UpdateDate="08/01/2013 13:47:20"
_uVERC.LastPlayedDate="1/1/0001 12:00:00 AM"
_uVERC.TargetDevice="PocketPC"
_uVERC.TargetDeviceVersion="0"
_uVERC.StateId="1"
_uVERC.CountryId="2"
_uVERC.Complete=false
_uVERC.UseLogging=true

_uVERC.Media=_O30im

_uVERC.Icon=_O30im


-- Zones --
FoodHacking = Wherigo.Zone(_uVERC)
FoodHacking.Id = "76fd6c85-d417-4a73-98c2-5496a22a5a91"
FoodHacking.Name = _214L("\051\060\060\057\095\099\069\033\106\104\083\052")
FoodHacking.Description = _214L("\119\099\069\058\101\013\095\033\060\060\106\104\083\052\116\095\014\060\060\106\104\083\052\046\095\083\060\046\095\058\099\115\072\115\101\013\095\013\060\060\095\088\103\033\099\095\088\060\072\115\095\004\060\103\095\033\069\083\095\057\060\095\093\104\058\099\095\122\060\060\057\074\074\074")
FoodHacking.Visible = true
FoodHacking.Media = _xV8
FoodHacking.Icon = _xV8
FoodHacking.Commands = {}
FoodHacking.DistanceRange = Distance(-1, "feet")
FoodHacking.ShowObjects = "OnEnter"
FoodHacking.ProximityRange = Distance(20, "meters")
FoodHacking.AllowSetPositionTo = false
FoodHacking.Active = true
FoodHacking.Points = {
	ZonePoint(52.6961661596523, 4.75267546100622, 0), 
	ZonePoint(52.6961661596523, 4.75274546100616, 0), 
	ZonePoint(52.6961261596523, 4.75274546100616, 0), 
	ZonePoint(52.6961261596523, 4.75267546100622, 0)
}
FoodHacking.OriginalPoint = ZonePoint(52.6961461596523, 4.75271046100619, 0)
FoodHacking.DistanceRangeUOM = "Feet"
FoodHacking.ProximityRangeUOM = "Meters"
FoodHacking.OutOfRangeName = ""
FoodHacking.InRangeName = ""
Well = Wherigo.Zone(_uVERC)
Well.Id = "ec05c434-cc8e-45cc-ae32-a30d87cd7d89"
Well.Name = _214L("\119\115\065\065")
Well.Description = _214L("\113\065\065\101\013\095\093\115\065\065\046\095\058\099\069\058\095\115\083\057\013\095\093\115\065\065")
Well.Visible = true
Well.Media = _gHbhY
Well.Icon = _gHbhY
Well.Commands = {}
Well.DistanceRange = Distance(-1, "feet")
Well.ShowObjects = "OnEnter"
Well.ProximityRange = Distance(60, "meters")
Well.AllowSetPositionTo = false
Well.Active = true
Well.Points = {
	ZonePoint(52.691933, 4.75107500000001, 0), 
	ZonePoint(52.691927, 4.75091900000007, 0), 
	ZonePoint(52.691888, 4.75075800000002, 0), 
	ZonePoint(52.691797, 4.75068299999998, 0), 
	ZonePoint(52.691701, 4.75070000000005, 0), 
	ZonePoint(52.691623, 4.750811, 0), 
	ZonePoint(52.691592, 4.75097400000004, 0), 
	ZonePoint(52.691623, 4.75112000000001, 0), 
	ZonePoint(52.691696, 4.75121799999999, 0), 
	ZonePoint(52.691785, 4.75123600000006, 0), 
	ZonePoint(52.691874, 4.75116600000001, 0)
}
Well.OriginalPoint = ZonePoint(52.6917671818182, 4.75096909090911, 0)
Well.DistanceRangeUOM = "Feet"
Well.ProximityRangeUOM = "Meters"
Well.OutOfRangeName = ""
Well.InRangeName = ""
Area42 = Wherigo.Zone(_uVERC)
Area42.Id = "5c799bc8-341f-437e-aabe-9d25acab7662"
Area42.Name = _214L("\113\072\115\069\010\044")
Area42.Description = _214L("\113\072\115\095\004\060\103\095\015\090\090\021\095\013\103\072\115\095\058\099\115\095\069\083\013\093\115\072\095\104\013\095\099\115\072\115\116\037\032\034\045\037\032\034\045\019\058\095\065\060\060\106\013\095\065\104\106\115\095\104\058\095\104\013\095\054\103\013\058\095\069\095\085\103\083\033\099\095\060\122\095\052\115\115\106\013\095\093\104\058\099\095\069\095\085\103\057\052\115\058\074\074\074\095\119\060\072\106\104\083\052\095\122\060\072\095\058\099\115\095\085\115\013\058\095\033\060\088\067\069\083\004\095\058\099\115\072\115\095\104\013\046\095\104\122\095\004\060\103\095\069\013\106\095\058\099\115\088\074")
Area42.Visible = true
Area42.Media = __dh2
Area42.Icon = __dh2
Area42.Commands = {}
Area42.DistanceRange = Distance(-1, "feet")
Area42.ShowObjects = "OnEnter"
Area42.ProximityRange = Distance(60, "meters")
Area42.AllowSetPositionTo = false
Area42.Active = true
Area42.Points = {
	ZonePoint(52.695404, 4.75132199999996, 0), 
	ZonePoint(52.695271, 4.75131599999997, 0), 
	ZonePoint(52.695239, 4.751169, 0), 
	ZonePoint(52.695322, 4.75102300000003, 0), 
	ZonePoint(52.695422, 4.75105299999996, 0), 
	ZonePoint(52.695458, 4.75120200000003, 0), 
	ZonePoint(52.695404, 4.75132199999996, 0), 
	ZonePoint(52.695404, 4.75132199999996, 0)
}
Area42.OriginalPoint = ZonePoint(52.6953655, 4.75121612499998, 0)
Area42.DistanceRangeUOM = "Feet"
Area42.ProximityRangeUOM = "Meters"
Area42.OutOfRangeName = ""
Area42.InRangeName = ""
RainbowIsland = Wherigo.Zone(_uVERC)
RainbowIsland.Id = "73300b25-e2de-464c-a490-f222bca06fe9"
RainbowIsland.Name = _214L("\034\069\104\083\085\060\093\095\104\013\065\069\083\057")
RainbowIsland.Description = _214L("\055\060\088\115\057\069\004\095\004\060\103\101\065\065\095\122\104\083\057\095\104\058\046\095\058\099\115\095\072\069\104\083\085\060\093\095\033\060\083\083\115\033\058\104\060\083")
RainbowIsland.Visible = true
RainbowIsland.Media = _7xZmb
RainbowIsland.Icon = _7xZmb
RainbowIsland.Commands = {}
RainbowIsland.DistanceRange = Distance(-1, "feet")
RainbowIsland.ShowObjects = "OnEnter"
RainbowIsland.ProximityRange = Distance(10, "meters")
RainbowIsland.AllowSetPositionTo = false
RainbowIsland.Active = true
RainbowIsland.Points = {
	ZonePoint(52.694958, 4.75021500000003, 0), 
	ZonePoint(52.694994, 4.75020100000006, 0), 
	ZonePoint(52.695052, 4.75018999999998, 0), 
	ZonePoint(52.695154, 4.75016800000003, 0), 
	ZonePoint(52.695211, 4.75028999999995, 0), 
	ZonePoint(52.695251, 4.75044300000002, 0), 
	ZonePoint(52.695293, 4.75059299999998, 0), 
	ZonePoint(52.695206, 4.75063299999999, 0), 
	ZonePoint(52.695112, 4.75069199999996, 0), 
	ZonePoint(52.695015, 4.75075100000004, 0), 
	ZonePoint(52.69493, 4.75080600000001, 0), 
	ZonePoint(52.694846, 4.75073199999997, 0), 
	ZonePoint(52.6947708129883, 4.7507700920105, 0), 
	ZonePoint(52.69475, 4.75070800000003, 0), 
	ZonePoint(52.694852, 4.75066500000003, 0), 
	ZonePoint(52.694803, 4.75053100000002, 0), 
	ZonePoint(52.69476, 4.75039600000002, 0), 
	ZonePoint(52.694761, 4.75023599999997, 0), 
	ZonePoint(52.694866, 4.75022000000001, 0), 
	ZonePoint(52.694958, 4.75021500000003, 0)
}
RainbowIsland.OriginalPoint = ZonePoint(52.6949771406494, 4.75047275460053, 0)
RainbowIsland.DistanceRangeUOM = "Feet"
RainbowIsland.ProximityRangeUOM = "Meters"
RainbowIsland.OutOfRangeName = ""
RainbowIsland.InRangeName = ""
Bar = Wherigo.Zone(_uVERC)
Bar.Id = "5c06d17f-e03b-47e0-ae88-cd46abbf3fcc"
Bar.Name = _214L("\032\069\072")
Bar.Description = _214L("\008\060\058\095\058\060\095\085\115\095\033\060\083\122\103\013\115\057\095\093\104\058\099\095\047\067\103\085\037\032\034\045\037\032\034\045\029\103\033\106\095\122\060\072\095\004\060\103\046\095\104\058\095\104\013\083\038\058\095\069\058\095\058\099\115\095\060\058\099\115\072\095\115\083\057\095\060\122\095\058\099\115\095\103\083\107\115\072\013\115")
Bar.Visible = true
Bar.Media = _lSp
Bar.Icon = _lSp
Bar.Commands = {}
Bar.DistanceRange = Distance(-1, "feet")
Bar.ShowObjects = "OnEnter"
Bar.ProximityRange = Distance(60, "meters")
Bar.AllowSetPositionTo = false
Bar.Active = true
Bar.Points = {
	ZonePoint(52.6944161596523, 4.75038546100609, 0), 
	ZonePoint(52.6943132029596, 4.75038546100609, 0), 
	ZonePoint(52.6943148285589, 4.75067811378472, 0), 
	ZonePoint(52.6944129084612, 4.75067006715767, 0)
}
Bar.OriginalPoint = ZonePoint(52.694364274908, 4.75052977573864, 0)
Bar.DistanceRangeUOM = "Feet"
Bar.ProximityRangeUOM = "Meters"
Bar.OutOfRangeName = ""
Bar.InRangeName = ""
AncientFarm = Wherigo.Zone(_uVERC)
AncientFarm.Id = "9e11b323-273f-46ad-80a3-f6f181dae923"
AncientFarm.Name = _214L("\113\083\104\115\083\058\095\122\069\072\088")
AncientFarm.Description = _214L("\019\058\095\093\069\013\095\033\069\065\065\115\057\095\058\099\115\095\122\069\072\088\046\095\085\115\122\060\072\115\095\058\099\115\095\051\032\019\095\058\072\069\104\083\104\083\052\095\122\069\033\104\065\104\058\004\095\093\069\013\074\074\074")
AncientFarm.Visible = true
AncientFarm.Media = _jab
AncientFarm.Icon = _jab
AncientFarm.Commands = {}
AncientFarm.DistanceRange = Distance(-1, "feet")
AncientFarm.ShowObjects = "OnEnter"
AncientFarm.ProximityRange = Distance(60, "meters")
AncientFarm.AllowSetPositionTo = false
AncientFarm.Active = true
AncientFarm.Points = {
	ZonePoint(52.6941861596523, 4.75089546100617, 0), 
	ZonePoint(52.6939561596523, 4.75089546100617, 0), 
	ZonePoint(52.6939561596523, 4.75036546100614, 0), 
	ZonePoint(52.6941861596523, 4.75036546100614, 0)
}
AncientFarm.OriginalPoint = ZonePoint(52.6940711596523, 4.75063046100616, 0)
AncientFarm.DistanceRangeUOM = "Feet"
AncientFarm.ProximityRangeUOM = "Meters"
AncientFarm.OutOfRangeName = ""
AncientFarm.InRangeName = ""
RandomVillage = Wherigo.Zone(_uVERC)
RandomVillage.Id = "e384f28b-e67f-4ed3-b4f6-13c5dcd17848"
RandomVillage.Name = _214L("\034\069\083\057\060\088\095\114\104\065\065\069\052\115")
RandomVillage.Description = _214L("\034\069\083\057\060\088\095\107\104\065\065\069\052\115\095\122\060\072\095\072\069\083\057\060\088\095\067\115\060\067\065\115\074\037\032\034\045\110\060\057\095\106\083\060\093\013\095\093\099\060\095\004\060\103\101\065\065\095\088\115\115\058\095\058\099\115\072\115\074\074\074")
RandomVillage.Visible = true
RandomVillage.Media = _0gx5y
RandomVillage.Icon = _0gx5y
RandomVillage.Commands = {}
RandomVillage.DistanceRange = Distance(-1, "feet")
RandomVillage.ShowObjects = "OnEnter"
RandomVillage.ProximityRange = Distance(60, "meters")
RandomVillage.AllowSetPositionTo = false
RandomVillage.Active = true
RandomVillage.Points = {
	ZonePoint(52.6925255180243, 4.75155312849995, 0), 
	ZonePoint(52.6925398282145, 4.75162788064949, 0), 
	ZonePoint(52.6924965768383, 4.75166922175413, 0), 
	ZonePoint(52.692474138314, 4.75159251623154, 0)
}
RandomVillage.OriginalPoint = ZonePoint(52.6925090153478, 4.75161068678378, 0)
RandomVillage.DistanceRangeUOM = "Feet"
RandomVillage.ProximityRangeUOM = "Meters"
RandomVillage.OutOfRangeName = ""
RandomVillage.InRangeName = ""
Farm = Wherigo.Zone(_uVERC)
Farm.Id = "a070a23c-a4a3-454e-8716-91f0dcb4efea"
Farm.Name = _214L("\051\069\072\088")
Farm.Description = _214L("\119\099\069\058\095\058\099\115\095\069\083\033\104\115\083\058\095\122\069\072\088\095\093\069\013\095\104\083\095\069\083\033\104\115\083\058\095\058\104\088\115\013\046\095\065\060\083\052\095\085\115\122\060\072\115\095\058\099\115\095\051\032\019\095\058\072\069\104\083\104\083\052\095\122\069\033\104\065\104\058\004\095\115\097\104\013\058\115\057\074\074\074")
Farm.Visible = true
Farm.Media = _jab
Farm.Icon = _jab
Farm.Commands = {}
Farm.DistanceRange = Distance(-1, "feet")
Farm.ShowObjects = "OnEnter"
Farm.ProximityRange = Distance(60, "meters")
Farm.AllowSetPositionTo = false
Farm.Active = false
Farm.Points = {
	ZonePoint(52.6941861596523, 4.75089546100617, 0), 
	ZonePoint(52.6939561596523, 4.75089546100617, 0), 
	ZonePoint(52.6939561596523, 4.75036546100614, 0), 
	ZonePoint(52.6941861596523, 4.75036546100614, 0)
}
Farm.OriginalPoint = ZonePoint(52.6940711596523, 4.75063046100616, 0)
Farm.DistanceRangeUOM = "Feet"
Farm.ProximityRangeUOM = "Meters"
Farm.OutOfRangeName = ""
Farm.InRangeName = ""
BEPB = Wherigo.Zone(_uVERC)
BEPB.Id = "73271bda-3080-4c31-b1ca-0713f9b0bf76"
BEPB.Name = _214L("\032\065\103\115\095\120\083\052\065\104\013\099\095\026\099\060\083\115\095\085\060\060\058\099")
BEPB.Description = _214L("\119\099\069\058\095\104\013\095\069\095\067\099\060\083\115\095\085\060\060\058\099\095\057\060\104\083\052\095\099\115\072\115\116\095\104\058\095\065\060\060\106\013\095\060\103\058\095\060\122\095\067\065\069\033\115\074\095\100\060\115\013\095\058\099\115\095\067\099\060\083\115\095\104\083\013\104\057\115\095\093\060\072\106\116")
BEPB.Visible = true
BEPB.Media = _1QX
BEPB.Icon = _1QX
BEPB.Commands = {}
BEPB.DistanceRange = Distance(-1, "feet")
BEPB.ShowObjects = "OnEnter"
BEPB.ProximityRange = Distance(60, "meters")
BEPB.AllowSetPositionTo = false
BEPB.Active = false
BEPB.Points = {
	ZonePoint(52.695814899111, 4.7518926858902, 0), 
	ZonePoint(52.6958116480241, 4.7519651055336, 0), 
	ZonePoint(52.695745000689, 4.75197851657867, 0), 
	ZonePoint(52.6957482517809, 4.75189805030823, 0)
}
BEPB.OriginalPoint = ZonePoint(52.6957799499012, 4.75193358957767, 0)
BEPB.DistanceRangeUOM = "Feet"
BEPB.ProximityRangeUOM = "Meters"
BEPB.OutOfRangeName = ""
BEPB.InRangeName = ""
TardisLivingRoom = Wherigo.Zone(_uVERC)
TardisLivingRoom.Id = "6b87e57c-0f29-4a33-9bc1-623177a44e99"
TardisLivingRoom.Name = _214L("\011\069\072\057\104\013\095\065\104\107\104\083\052\095\072\060\060\088")
TardisLivingRoom.Description = _214L("\119\099\069\058\095\069\095\013\067\069\033\104\060\103\013\095\067\099\060\083\115\095\085\060\060\058\099\095\058\099\069\058\095\104\013\074\074\074\074\037\032\034\045\037\032\034\045\036\083\065\104\106\115\095\069\095\108\103\088\088\115\072\095\104\058\095\104\013\095\104\083\057\115\115\057\095\085\104\052\052\115\072\095\060\083\095\058\099\115\095\104\083\013\104\057\115\074\074\074")
TardisLivingRoom.Visible = true
TardisLivingRoom.Media = _WmJzU
TardisLivingRoom.Icon = _WmJzU
TardisLivingRoom.Commands = {}
TardisLivingRoom.DistanceRange = Distance(-1, "feet")
TardisLivingRoom.ShowObjects = "OnEnter"
TardisLivingRoom.ProximityRange = Distance(60, "meters")
TardisLivingRoom.AllowSetPositionTo = false
TardisLivingRoom.Active = false
TardisLivingRoom.Points = {
	ZonePoint(52.6958181501977, 4.7518926858902, 0), 
	ZonePoint(52.6958148991109, 4.7519651055336, 0), 
	ZonePoint(52.6951224121327, 4.7520911693573, 0), 
	ZonePoint(52.6949517270352, 4.75089758634567, 0), 
	ZonePoint(52.6951516723682, 4.75080102682114, 0), 
	ZonePoint(52.69526708755, 4.75135624408722, 0)
}
TardisLivingRoom.OriginalPoint = ZonePoint(52.6953543247324, 4.75150063633919, 0)
TardisLivingRoom.DistanceRangeUOM = "Feet"
TardisLivingRoom.ProximityRangeUOM = "Meters"
TardisLivingRoom.OutOfRangeName = ""
TardisLivingRoom.InRangeName = ""
TardisExit = Wherigo.Zone(_uVERC)
TardisExit.Id = "15178a0c-ef90-4f13-9491-298df344f9cf"
TardisExit.Name = _214L("\011\069\072\057\104\013\095\115\097\104\058")
TardisExit.Description = _214L("\029\069\013\058\095\058\099\104\083\052\095\019\095\072\115\088\115\088\085\115\072\046\095\019\095\093\069\013\037\032\034\045\034\103\083\083\104\083\052\095\122\060\072\095\058\099\115\095\057\060\060\072\037\032\034\045\019\095\099\069\057\095\058\060\095\122\104\083\057\095\058\099\115\095\067\069\013\013\069\052\115\095\085\069\033\106\095\058\060\095\058\099\115\095\067\065\069\033\115\095\019\095\093\069\013\095\085\115\122\060\072\115\037\032\034\045\101\034\115\065\069\097\101\095\013\069\104\057\095\058\099\115\095\083\104\052\099\058\095\088\069\083\046\037\032\034\045\101\119\115\095\069\072\115\095\067\072\060\052\072\069\088\088\115\057\095\058\060\095\072\115\033\115\104\107\115\074\037\032\034\045\076\060\103\095\033\069\083\095\033\099\115\033\106\095\060\103\058\095\069\083\004\095\058\104\088\115\095\004\060\103\095\065\104\106\115\046\037\032\034\045\032\103\058\095\004\060\103\095\033\069\083\095\083\115\107\115\072\095\065\115\069\107\115\030\101")
TardisExit.Visible = true
TardisExit.Media = _1QX
TardisExit.Icon = _1QX
TardisExit.Commands = {}
TardisExit.DistanceRange = Distance(-1, "feet")
TardisExit.ShowObjects = "OnEnter"
TardisExit.ProximityRange = Distance(60, "meters")
TardisExit.AllowSetPositionTo = false
TardisExit.Active = false
TardisExit.Points = {
	ZonePoint(52.695001307061, 4.75127510726452, 0), 
	ZonePoint(52.6950106541086, 4.75137367844582, 0), 
	ZonePoint(52.6949521334291, 4.75137166678905, 0), 
	ZonePoint(52.6949513206413, 4.75126035511494, 0)
}
TardisExit.OriginalPoint = ZonePoint(52.69497885381, 4.75132020190358, 0)
TardisExit.DistanceRangeUOM = "Feet"
TardisExit.ProximityRangeUOM = "Meters"
TardisExit.OutOfRangeName = ""
TardisExit.InRangeName = ""
Clearing = Wherigo.Zone(_uVERC)
Clearing.Id = "1b8ce340-6ce7-4a9d-b4b2-c0a0ea886ad6"
Clearing.Name = _214L("\014\065\115\069\072\104\083\052")
Clearing.Description = _214L("\119\099\069\058\095\069\095\065\060\107\115\065\004\095\098\103\104\115\058\095\013\067\069\033\115\095\104\083\095\058\099\115\095\088\104\057\013\095\060\122\095\058\099\115\095\093\060\060\057\013\074")
Clearing.Visible = true
Clearing.Media = _uR23
Clearing.Icon = _uR23
Clearing.Commands = {}
Clearing.DistanceRange = Distance(-1, "feet")
Clearing.ShowObjects = "OnEnter"
Clearing.ProximityRange = Distance(60, "meters")
Clearing.AllowSetPositionTo = false
Clearing.Active = false
Clearing.Points = {
	ZonePoint(52.695358, 4.74979899999994, 0), 
	ZonePoint(52.69535, 4.749686, 0), 
	ZonePoint(52.695439, 4.74966199999994, 0), 
	ZonePoint(52.695531, 4.74965099999997, 0), 
	ZonePoint(52.695627, 4.74966799999993, 0), 
	ZonePoint(52.695728, 4.74966399999994, 0), 
	ZonePoint(52.695764, 4.74952600000006, 0), 
	ZonePoint(52.695718, 4.74938799999995, 0), 
	ZonePoint(52.695675, 4.74925499999995, 0), 
	ZonePoint(52.695586, 4.74920199999997, 0), 
	ZonePoint(52.695493, 4.749215959259, 0), 
	ZonePoint(52.695398, 4.74922895925897, 0), 
	ZonePoint(52.695299, 4.74922300000003, 0), 
	ZonePoint(52.695206, 4.74923899999999, 0), 
	ZonePoint(52.69515, 4.74937799999998, 0), 
	ZonePoint(52.695135, 4.74952600000006, 0), 
	ZonePoint(52.695162, 4.74967900000001, 0), 
	ZonePoint(52.695196, 4.74982199999999, 0), 
	ZonePoint(52.695294, 4.74985700000002, 0), 
	ZonePoint(52.695358, 4.74979899999994, 0)
}
Clearing.OriginalPoint = ZonePoint(52.69542335, 4.74952344592588, 0)
Clearing.DistanceRangeUOM = "Feet"
Clearing.ProximityRangeUOM = "Meters"
Clearing.OutOfRangeName = ""
Clearing.InRangeName = ""
Forest = Wherigo.Zone(_uVERC)
Forest.Id = "fa5d6cd1-2ebe-432d-bef0-b3b99f68c018"
Forest.Name = _214L("\051\060\072\115\013\058")
Forest.Description = _214L("\119\099\069\058\095\069\095\083\104\033\115\095\033\060\065\065\115\033\058\104\060\083\095\060\122\095\058\072\115\115\013\095\004\060\103\101\107\115\095\052\060\058\095\099\115\072\115\074\095\011\060\060\095\085\069\057\095\058\099\115\004\095\069\072\115\095\013\058\069\083\057\104\083\052\095\104\083\095\122\072\060\083\095\060\122\095\058\099\115\095\122\060\072\115\013\058\074")
Forest.Visible = true
Forest.Media = _ful
Forest.Icon = _ful
Forest.Commands = {}
Forest.DistanceRange = Distance(-1, "feet")
Forest.ShowObjects = "OnEnter"
Forest.ProximityRange = Distance(60, "meters")
Forest.AllowSetPositionTo = false
Forest.Active = false
Forest.Points = {
	ZonePoint(52.6955546293945, 4.74919872763064, 0), 
	ZonePoint(52.695673, 4.74917099999993, 0), 
	ZonePoint(52.695659, 4.74913100000003, 0), 
	ZonePoint(52.695619, 4.74899800000003, 0), 
	ZonePoint(52.695575, 4.74884099999997, 0), 
	ZonePoint(52.695564, 4.74868200000003, 0), 
	ZonePoint(52.695501, 4.74855200000002, 0), 
	ZonePoint(52.695477, 4.74840700000004, 0), 
	ZonePoint(52.69542, 4.74826699999994, 0), 
	ZonePoint(52.695355, 4.74814000000003, 0), 
	ZonePoint(52.695316, 4.74797699999999, 0), 
	ZonePoint(52.695294, 4.74782800000003, 0), 
	ZonePoint(52.69529, 4.74767700000007, 0), 
	ZonePoint(52.695239, 4.74752999999998, 0), 
	ZonePoint(52.695218, 4.74738000000002, 0), 
	ZonePoint(52.695202, 4.74722999999995, 0), 
	ZonePoint(52.695176, 4.74708299999998, 0), 
	ZonePoint(52.695132, 4.74694499999998, 0), 
	ZonePoint(52.6951, 4.74679200000003, 0), 
	ZonePoint(52.695075, 4.74664600000006, 0), 
	ZonePoint(52.695029, 4.74650199999996, 0), 
	ZonePoint(52.69498, 4.74637600000005, 0), 
	ZonePoint(52.69494, 4.74623299999996, 0), 
	ZonePoint(52.694912, 4.74608000000001, 0), 
	ZonePoint(52.69487, 4.74592899999993, 0), 
	ZonePoint(52.69486, 4.745766, 0), 
	ZonePoint(52.694823, 4.74562400000002, 0), 
	ZonePoint(52.694722, 4.74564799999996, 0), 
	ZonePoint(52.694625, 4.74569999999994, 0), 
	ZonePoint(52.69455, 4.74580200000003, 0), 
	ZonePoint(52.694478, 4.74590799999999, 0), 
	ZonePoint(52.69445, 4.74605799999995, 0), 
	ZonePoint(52.694401, 4.74620500000003, 0), 
	ZonePoint(52.694366, 4.74635499999999, 0), 
	ZonePoint(52.694327, 4.74649999999997, 0), 
	ZonePoint(52.694262, 4.74663899999996, 0), 
	ZonePoint(52.694195, 4.74675300000001, 0), 
	ZonePoint(52.694111, 4.74685099999999, 0), 
	ZonePoint(52.694016, 4.74689799999999, 0), 
	ZonePoint(52.693982, 4.74704700000007, 0), 
	ZonePoint(52.69401, 4.74719600000003, 0), 
	ZonePoint(52.694047, 4.74733500000002, 0), 
	ZonePoint(52.694076, 4.747479, 0), 
	ZonePoint(52.694125, 4.74763600000006, 0), 
	ZonePoint(52.694162, 4.74778100000003, 0), 
	ZonePoint(52.694193, 4.74793899999997, 0), 
	ZonePoint(52.694232, 4.74809500000003, 0), 
	ZonePoint(52.694287, 4.74822300000005, 0), 
	ZonePoint(52.694322, 4.74836099999993, 0), 
	ZonePoint(52.694355, 4.74851799999999, 0), 
	ZonePoint(52.694417, 4.74863600000003, 0), 
	ZonePoint(52.694521, 4.74861899999996, 0), 
	ZonePoint(52.694624, 4.74864100000002, 0), 
	ZonePoint(52.694708, 4.74869200000001, 0), 
	ZonePoint(52.694793, 4.74876199999994, 0), 
	ZonePoint(52.694889, 4.74877200000003, 0), 
	ZonePoint(52.69495, 4.74888599999997, 0), 
	ZonePoint(52.694989, 4.74903300000005, 0), 
	ZonePoint(52.695011, 4.74919, 0), 
	ZonePoint(52.695071, 4.74931900000001, 0), 
	ZonePoint(52.695164, 4.7492440822449, 0), 
	ZonePoint(52.695257, 4.74921908224485, 0), 
	ZonePoint(52.6953728881836, 4.74920806866453, 0), 
	ZonePoint(52.6954768881836, 4.74919606866456, 0), 
	ZonePoint(52.6955546293945, 4.74919872763064, 0)
}
Forest.OriginalPoint = ZonePoint(52.6948453236178, 4.74766967318585, 0)
Forest.DistanceRangeUOM = "Feet"
Forest.ProximityRangeUOM = "Meters"
Forest.OutOfRangeName = ""
Forest.InRangeName = ""
DoctorWhosDesk = Wherigo.Zone(_uVERC)
DoctorWhosDesk.Id = "04bf122e-53e7-4e20-bb2c-571169ea6e21"
DoctorWhosDesk.Name = _214L("\028\122\122\104\033\115\095\060\122\095\100\060\033\058\060\072\095\119\099\060")
DoctorWhosDesk.Description = _214L("\119\099\060\101\013\095\060\122\122\104\033\115\095\104\013\095\104\058\095\069\083\004\093\069\004\116")
DoctorWhosDesk.Visible = true
DoctorWhosDesk.Media = _LJe
DoctorWhosDesk.Icon = _LJe
DoctorWhosDesk.Commands = {}
DoctorWhosDesk.DistanceRange = Distance(-1, "feet")
DoctorWhosDesk.ShowObjects = "OnEnter"
DoctorWhosDesk.ProximityRange = Distance(60, "meters")
DoctorWhosDesk.AllowSetPositionTo = false
DoctorWhosDesk.Active = false
DoctorWhosDesk.Points = {
	ZonePoint(52.6951957106012, 4.75173131939414, 0), 
	ZonePoint(52.6952157097998, 4.75191061941143, 0), 
	ZonePoint(52.6950852461347, 4.75191379732132, 0), 
	ZonePoint(52.695070369804, 4.75173852061744, 0)
}
DoctorWhosDesk.OriginalPoint = ZonePoint(52.6951417590849, 4.75182356418608, 0)
DoctorWhosDesk.DistanceRangeUOM = "Feet"
DoctorWhosDesk.ProximityRangeUOM = "Meters"
DoctorWhosDesk.OutOfRangeName = ""
DoctorWhosDesk.InRangeName = ""

-- Characters --
_srwCf = Wherigo.ZCharacter{
	Cartridge = _uVERC, 
	Container = Bar
}
_srwCf.Id = "79f5b452-b531-4b23-9ac1-98e8ebb14630"
_srwCf.Name = _214L("\032\069\072\058\115\083\057\115\072")
_srwCf.Description = ""
_srwCf.Visible = true
_srwCf.Media = _m0Nj
_srwCf.Icon = _m0Nj
_srwCf.Commands = {
	_fM10 = Wherigo.ZCommand{
		Text = _214L("\028\072\057\115\072\095\069\095\057\072\104\083\106"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}, 
	_cuM = Wherigo.ZCommand{
		Text = _214L("\011\069\065\106\095\058\060\095\058\099\115\095\085\069\072\058\115\083\057\115\072"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_srwCf.Commands._fM10.Custom = true
_srwCf.Commands._fM10.Id = "57a3a645-75e1-4179-918b-9f75c13fc9d8"
_srwCf.Commands._fM10.WorksWithAll = true
_srwCf.Commands._cuM.Custom = true
_srwCf.Commands._cuM.Id = "df1bf23a-81a3-4438-98bd-8025c817afa2"
_srwCf.Commands._cuM.WorksWithAll = true
_srwCf.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_srwCf.Gender = "Male"
_srwCf.Type = "NPC"
_TvI = Wherigo.ZCharacter{
	Cartridge = _uVERC, 
	Container = RandomVillage
}
_TvI.Id = "dba06b99-0d0f-4a76-a9bf-c3df3b47dd0d"
_TvI.Name = _214L("\120\088\088\115\058\095\086\100\060\033\086\095\032\072\060\093\083")
_TvI.Description = ""
_TvI.Visible = true
_TvI.Media = _RYlTZ
_TvI.Icon = _RYlTZ
_TvI.Commands = {
	_JASdq = Wherigo.ZCommand{
		Text = _214L("\011\069\065\106\095\058\060\095\058\099\115\095\100\060\033"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_TvI.Commands._JASdq.Custom = true
_TvI.Commands._JASdq.Id = "2a13c467-ab98-4c3e-a8e2-371f8b76e56f"
_TvI.Commands._JASdq.WorksWithAll = true
_TvI.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_TvI.Gender = "Male"
_TvI.Type = "NPC"
__BDBZ = Wherigo.ZCharacter{
	Cartridge = _uVERC, 
	Container = Area42
}
__BDBZ.Id = "4931cf58-f3cc-430a-8fbb-1472c01d1162"
__BDBZ.Name = _214L("\029\060\083\115\065\004\095\103\083\104\033\060\072\083")
__BDBZ.Description = ""
__BDBZ.Visible = true
__BDBZ.Media = _CRaA
__BDBZ.Icon = _CRaA
__BDBZ.Commands = {
	_tJn = Wherigo.ZCommand{
		Text = _214L("\011\069\065\106\095\058\060\095\058\099\115\095\103\083\104\033\060\072\083"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
__BDBZ.Commands._tJn.Custom = true
__BDBZ.Commands._tJn.Id = "6dd627b0-3832-458e-be7f-294cba3edfbe"
__BDBZ.Commands._tJn.WorksWithAll = true
__BDBZ.ObjectLocation = Wherigo.INVALID_ZONEPOINT
__BDBZ.Gender = "Male"
__BDBZ.Type = "NPC"
IPU = Wherigo.ZCharacter{
	Cartridge = _uVERC, 
	Container = RainbowIsland
}
IPU.Id = "5b4f221b-aa64-4068-a469-34f0c0d17bec"
IPU.Name = _214L("\011\072\069\083\013\065\103\033\115\083\058\095\026\104\083\106\095\036\083\104\033\060\072\083")
IPU.Description = _214L("\026\104\083\106\004\095\122\060\072\095\122\072\104\115\083\057\013")
IPU.Visible = false
IPU.Media = _6VwMs
IPU.Icon = _6VwMs
IPU.Commands = {
	_Nbe = Wherigo.ZCommand{
		Text = _214L("\014\069\067\058\103\072\115"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}, 
	_KHH = Wherigo.ZCommand{
		Text = _214L("\048\060\104\083\095\093\104\058\099\095\088\069\058\115\074\074\074"), 
		CmdWith = true, 
		Enabled = false, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
IPU.Commands._Nbe.Custom = true
IPU.Commands._Nbe.Id = "24be34cd-47dd-4ea2-b3f8-a16f0e41e26a"
IPU.Commands._Nbe.WorksWithAll = true
IPU.Commands._KHH.Custom = true
IPU.Commands._KHH.Id = "ae05b3a3-e84c-4c6f-b895-fd42a81a77b5"
IPU.Commands._KHH.WorksWithAll = false
IPU.Commands._KHH.WorksWithListIds = {
	"4931cf58-f3cc-430a-8fbb-1472c01d1162"
}
IPU.ObjectLocation = Wherigo.INVALID_ZONEPOINT
IPU.Gender = "Female"
IPU.Type = "NPC"
_SMjym = Wherigo.ZCharacter{
	Cartridge = _uVERC, 
	Container = Forest
}
_SMjym.Id = "8ad7fb0f-67d2-4291-a3f2-aa83ec893244"
_SMjym.Name = _214L("\100\072\103\104\057")
_SMjym.Description = _214L("\011\099\104\013\095\110\069\115\065\104\033\095\057\072\103\104\057\095\065\060\060\106\013\095\107\069\052\103\115\065\004\095\122\069\088\104\065\104\069\072\074\095\019\058\095\065\060\060\106\013\095\065\104\106\115\095\099\115\101\013\095\058\072\004\104\083\052\095\058\060\095\099\104\057\115\074\074\074")
_SMjym.Visible = true
_SMjym.Media = _QX7Z
_SMjym.Icon = _QX7Z
_SMjym.Commands = {
	_6kuT2 = Wherigo.ZCommand{
		Text = _214L("\011\069\065\106\095\058\060\095\058\099\115\095\100\072\103\104\057"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_SMjym.Commands._6kuT2.Custom = true
_SMjym.Commands._6kuT2.Id = "b18250f6-19b7-46cf-acc3-a982e4e2a324"
_SMjym.Commands._6kuT2.WorksWithAll = true
_SMjym.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_SMjym.Gender = "Male"
_SMjym.Type = "NPC"
_KngC = Wherigo.ZCharacter{
	Cartridge = _uVERC, 
	Container = Clearing
}
_KngC.Id = "4235a710-d2a5-4895-ad01-8be7ac15932c"
_KngC.Name = _214L("\034\060\088\069\083\095\067\069\058\072\060\065")
_KngC.Description = _214L("\113\095\013\088\069\065\065\095\052\072\060\103\067\095\060\122\095\072\060\088\069\083\095\065\115\052\104\060\083\069\104\072\115\013\095\058\099\069\058\095\067\069\058\072\060\065\095\058\099\115\095\122\060\072\115\013\058\074\095\011\099\115\004\095\065\060\060\106\095\122\104\115\072\033\115\122\103\065\095\038\127\009")
_KngC.Visible = true
_KngC.Media = _43R
_KngC.Icon = _43R
_KngC.Commands = {
	_9Mk = Wherigo.ZCommand{
		Text = _214L("\011\069\065\106"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}, 
	_P5E = Wherigo.ZCommand{
		Text = _214L("\051\104\052\099\058\074\074\074"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_KngC.Commands._9Mk.Custom = true
_KngC.Commands._9Mk.Id = "97025d7b-b1af-4763-b5d9-1979e839d617"
_KngC.Commands._9Mk.WorksWithAll = true
_KngC.Commands._P5E.Custom = true
_KngC.Commands._P5E.Id = "5f5d881d-d34b-4f6e-bcee-efae0ab3310f"
_KngC.Commands._P5E.WorksWithAll = true
_KngC.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_KngC.Gender = "Male"
_KngC.Type = "NPC"
_GIR = Wherigo.ZCharacter{
	Cartridge = _uVERC, 
	Container = DoctorWhosDesk
}
_GIR.Id = "bbf2e4ca-386a-4237-9672-c76b877a762b"
_GIR.Name = _214L("\100\072\074\095\119\099\060")
_GIR.Description = _214L("\026\115\060\067\065\115\095\069\013\013\103\088\115\095\058\099\069\058\095\058\104\088\115\095\104\013\095\069\095\013\058\072\104\033\058\095\067\072\060\052\072\115\013\013\104\060\083\095\060\122\095\033\069\103\013\115\095\058\060\095\115\122\122\115\033\058\074\074\074\095\085\103\058\095\069\033\058\103\069\065\065\004\046\095\122\072\060\088\095\069\095\083\060\083\127\065\104\083\115\069\072\046\095\083\060\083\127\013\103\085\054\115\033\058\104\107\115\095\107\104\115\093\067\060\104\083\058\046\095\104\058\101\013\095\088\060\072\115\095\065\104\106\115\095\069\095\085\104\052\095\085\069\065\065\095\060\122\095\093\104\085\085\065\004\127\093\060\085\085\065\004\074\074\074\095\058\104\088\115\004\127\093\104\088\115\004\074\074\074\095\013\058\103\122\122\074")
_GIR.Visible = true
_GIR.Media = _LJe
_GIR.Icon = _LJe
_GIR.Commands = {
	_Bnc = Wherigo.ZCommand{
		Text = _214L("\011\069\065\106"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = ""
	}
}
_GIR.Commands._Bnc.Custom = true
_GIR.Commands._Bnc.Id = "75ee9fbb-aa78-4805-8ea5-0cffd66c1246"
_GIR.Commands._Bnc.WorksWithAll = true
_GIR.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_GIR.Gender = "Male"
_GIR.Type = "NPC"

-- Items --
_2vO2L = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = FoodHacking
}
_2vO2L.Id = "3b767d02-8bb8-4238-b0c4-0f866e5b9b17"
_2vO2L.Name = _214L("\011\060\088\069\058\060\095\054\103\104\033\115")
_2vO2L.Description = ""
_2vO2L.Visible = true
_2vO2L.Media = _OF3GA
_2vO2L.Icon = _OF3GA
_2vO2L.Commands = {
	_WHO = Wherigo.ZCommand{
		Text = _214L("\110\104\107\115\095\058\060\088\069\058\060\054\103\104\033\115\074\074\074"), 
		CmdWith = true, 
		Enabled = false, 
		EmptyTargetListText = _214L("\011\099\115\072\115\095\104\013\095\083\060\085\060\057\004\095\099\115\072\115\095\058\060\095\052\104\107\115\095\058\099\115\095\058\060\088\069\058\060\095\054\103\104\033\115\095\058\060\074\074\074")
	}, 
	_KSVGz = Wherigo.ZCommand{
		Text = _214L("\011\069\106\115"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_2vO2L.Commands._WHO.Custom = true
_2vO2L.Commands._WHO.Id = "bd26a0dc-c4c0-4d3f-9b06-e9ba76e4fea7"
_2vO2L.Commands._WHO.WorksWithAll = false
_2vO2L.Commands._WHO.WorksWithListIds = {
	"79f5b452-b531-4b23-9ac1-98e8ebb14630"
}
_2vO2L.Commands._KSVGz.Custom = true
_2vO2L.Commands._KSVGz.Id = "58d7344e-238d-4b52-a0d7-5c76795985ce"
_2vO2L.Commands._KSVGz.WorksWithAll = true
_2vO2L.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_2vO2L.Locked = false
_2vO2L.Opened = false
_MaM6x = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = _srwCf
}
_MaM6x.Id = "f9ed8dd4-34ae-4ae5-976c-ca19a991a78d"
_MaM6x.Name = _214L("\114\104\072\052\104\083\095\032\065\060\060\057\004\095\001\069\072\004")
_MaM6x.Description = _214L("\019\083\052\072\115\057\104\115\083\058\013\123\037\032\034\045\037\032\034\045\050\095\005\095\060\125\095\058\060\088\069\058\060\095\054\103\104\033\115\037\032\034\045\050\095\015\047\044\095\060\125\095\065\115\088\060\083\095\054\103\104\033\115\037\032\034\045\050\095\015\095\057\069\013\099\095\060\122\095\119\060\072\033\115\013\058\115\072\013\099\104\072\115\095\013\069\103\033\115\037\032\034\045\050\095\033\115\065\115\072\004\095\013\069\065\058\037\032\034\045\050\095\052\072\060\103\083\057\095\067\115\067\067\115\072\037\032\034\045\050\095\099\060\058\095\067\115\067\067\115\072\095\060\072\095\011\069\085\069\013\033\060\095\013\069\103\033\115\037\032\034\045\050\095\033\115\065\115\072\004\095\013\058\069\065\106\095\122\060\072\095\052\069\072\083\104\013\099\037\032\034\045\050\095\067\104\033\106\065\115\095\052\069\072\083\104\013\099\095\122\060\072\095\052\069\072\083\104\013\099\095\087\060\067\058\104\060\083\069\065\009\037\032\034\045\037\032\034\045\026\072\115\067\069\072\069\058\104\060\083\123\037\032\034\045\050\095\032\103\104\065\057\095\058\099\115\095\065\104\098\103\104\057\095\104\083\052\072\115\057\104\115\083\058\013\095\104\083\058\060\095\069\095\099\104\052\099\085\069\065\065\095\052\065\069\013\013\095\060\107\115\072\095\104\033\115\095\033\103\085\115\013\074\037\032\034\045\050\095\001\104\097\095\093\115\065\065\074")
_MaM6x.Visible = true
_MaM6x.Media = _XPAR
_MaM6x.Icon = _XPAR
_MaM6x.Commands = {
	_cTPsR = Wherigo.ZCommand{
		Text = _214L("\110\104\107\115\095\107\104\072\052\104\083\095\085\065\060\060\057\004\095\088\069\072\004"), 
		CmdWith = true, 
		Enabled = false, 
		EmptyTargetListText = _214L("\011\108\115\072\115\095\104\013\095\083\060\085\060\057\004\095\099\115\072\115\095\058\060\095\052\104\107\115\095\104\058\095\058\060\074\074\074")
	}
}
_MaM6x.Commands._cTPsR.Custom = true
_MaM6x.Commands._cTPsR.Id = "d041642a-f090-45f7-b762-e26bce0c3a1b"
_MaM6x.Commands._cTPsR.WorksWithAll = false
_MaM6x.Commands._cTPsR.WorksWithListIds = {
	"bbf2e4ca-386a-4237-9672-c76b877a762b", 
	"4235a710-d2a5-4895-ad01-8be7ac15932c", 
	"8ad7fb0f-67d2-4291-a3f2-aa83ec893244", 
	"5b4f221b-aa64-4068-a469-34f0c0d17bec", 
	"4931cf58-f3cc-430a-8fbb-1472c01d1162", 
	"dba06b99-0d0f-4a76-a9bf-c3df3b47dd0d", 
	"79f5b452-b531-4b23-9ac1-98e8ebb14630"
}
_MaM6x.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_MaM6x.Locked = false
_MaM6x.Opened = false
_n54 = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = Well
}
_n54.Id = "4403559d-bd59-4aef-926a-0b34af995393"
_n54.Name = _214L("\100\103\013\058\004\095\060\085\054\115\033\058")
_n54.Description = ""
_n54.Visible = true
_n54.Commands = {
	_YLU3 = Wherigo.ZCommand{
		Text = _214L("\011\069\106\115"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}, 
	_MFU1 = Wherigo.ZCommand{
		Text = _214L("\110\104\107\115\095\122\065\103\097\095\033\069\067\069\033\104\058\060\072\095\058\060\095\074\074\074"), 
		CmdWith = true, 
		Enabled = false, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_n54.Commands._YLU3.Custom = true
_n54.Commands._YLU3.Id = "1eee21b7-888e-4f98-9e8a-b4deb6567ff2"
_n54.Commands._YLU3.WorksWithAll = true
_n54.Commands._MFU1.Custom = true
_n54.Commands._MFU1.Id = "df98b93c-db1f-4941-b004-ba50fc19adb2"
_n54.Commands._MFU1.WorksWithAll = false
_n54.Commands._MFU1.WorksWithListIds = {
	"79f5b452-b531-4b23-9ac1-98e8ebb14630", 
	"dba06b99-0d0f-4a76-a9bf-c3df3b47dd0d", 
	"4931cf58-f3cc-430a-8fbb-1472c01d1162", 
	"5b4f221b-aa64-4068-a469-34f0c0d17bec"
}
_n54.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_n54.Locked = false
_n54.Opened = false
_xQtW = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = Bar
}
_xQtW.Id = "0d64dca9-f538-4705-ad1d-92d0327c6574"
_xQtW.Name = _214L("\100\115\065\060\072\104\069\083")
_xQtW.Description = ""
_xQtW.Visible = true
_xQtW.Media = _A_Fi
_xQtW.Icon = _A_Fi
_xQtW.Commands = {
	_aiWP = Wherigo.ZCommand{
		Text = _214L("\100\072\104\107\115"), 
		CmdWith = false, 
		Enabled = false, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}, 
	_LhGa = Wherigo.ZCommand{
		Text = _214L("\110\104\107\115\095\057\115\065\060\072\104\069\083\074\074\074"), 
		CmdWith = true, 
		Enabled = false, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}, 
	_6lt = Wherigo.ZCommand{
		Text = _214L("\120\097\069\088\104\083\115"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_xQtW.Commands._aiWP.Custom = true
_xQtW.Commands._aiWP.Id = "317408fd-4701-4967-ba38-f6f848b7a465"
_xQtW.Commands._aiWP.WorksWithAll = true
_xQtW.Commands._LhGa.Custom = true
_xQtW.Commands._LhGa.Id = "8884c0b7-5236-43e1-9a93-1477f9954152"
_xQtW.Commands._LhGa.WorksWithAll = false
_xQtW.Commands._LhGa.WorksWithListIds = {
	"79f5b452-b531-4b23-9ac1-98e8ebb14630", 
	"dba06b99-0d0f-4a76-a9bf-c3df3b47dd0d", 
	"4931cf58-f3cc-430a-8fbb-1472c01d1162", 
	"5b4f221b-aa64-4068-a469-34f0c0d17bec"
}
_xQtW.Commands._6lt.Custom = true
_xQtW.Commands._6lt.Id = "70dcf79e-1ec4-4c7f-b964-01a2aae94cd5"
_xQtW.Commands._6lt.WorksWithAll = true
_xQtW.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_xQtW.Locked = false
_xQtW.Opened = false
_NtUg = Wherigo.ZItem(_uVERC)
_NtUg.Id = "df6a36ea-0b23-4274-af0e-c9dc708aefdb"
_NtUg.Name = _214L("\011\104\088\115\095\088\069\033\099\104\083\115")
_NtUg.Description = ""
_NtUg.Visible = true
_NtUg.Media = _A_Fi
_NtUg.Commands = {}
_NtUg.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_NtUg.Locked = false
_NtUg.Opened = false
_E_G4 = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = _5jW
}
_E_G4.Id = "741a077d-d776-4cc1-a5f9-51a356a60e1c"
_E_G4.Name = _214L("\001\104\013\058\065\115\058\060\115")
_E_G4.Description = ""
_E_G4.Visible = false
_E_G4.Media = _LuaPT
_E_G4.Commands = {
	_TCx = Wherigo.ZCommand{
		Text = _214L("\110\104\107\115\095\088\104\013\058\065\115\058\060\115"), 
		CmdWith = true, 
		Enabled = false, 
		EmptyTargetListText = _214L("\011\099\115\072\115\095\104\013\095\083\060\085\060\057\004\095\099\115\072\115\095\058\060\095\052\104\107\115\095\058\099\115\095\088\104\013\058\065\115\058\060\115\095\058\060\074\074\074")
	}
}
_E_G4.Commands._TCx.Custom = true
_E_G4.Commands._TCx.Id = "e91b6dc5-6076-4542-97d0-63f900ba08a9"
_E_G4.Commands._TCx.WorksWithAll = false
_E_G4.Commands._TCx.WorksWithListIds = {
	"8ad7fb0f-67d2-4291-a3f2-aa83ec893244", 
	"bbf2e4ca-386a-4237-9672-c76b877a762b", 
	"4235a710-d2a5-4895-ad01-8be7ac15932c", 
	"5b4f221b-aa64-4068-a469-34f0c0d17bec", 
	"4931cf58-f3cc-430a-8fbb-1472c01d1162", 
	"dba06b99-0d0f-4a76-a9bf-c3df3b47dd0d", 
	"79f5b452-b531-4b23-9ac1-98e8ebb14630"
}
_E_G4.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_E_G4.Locked = true
_E_G4.Opened = false
_57Qb = Wherigo.ZItem(_uVERC)
_57Qb.Id = "620bf75a-69bb-44d6-a186-b3018f8cbcce"
_57Qb.Name = _214L("\001\069\052\104\033\095\026\060\058\104\060\083")
_57Qb.Description = ""
_57Qb.Visible = false
_57Qb.Commands = {
	_pD6R = Wherigo.ZCommand{
		Text = _214L("\100\072\104\083\106"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_57Qb.Commands._pD6R.Custom = true
_57Qb.Commands._pD6R.Id = "36ac70ef-e7af-4bd4-a3ef-8b9f4abc1ba1"
_57Qb.Commands._pD6R.WorksWithAll = true
_57Qb.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_57Qb.Locked = false
_57Qb.Opened = false
Water = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = Well
}
Water.Id = "e5603519-8931-463d-b46f-a253e1fcd541"
Water.Name = _214L("\119\069\058\115\072")
Water.Description = ""
Water.Visible = false
Water.Commands = {
	_UJH = Wherigo.ZCommand{
		Text = _214L("\011\069\106\115"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
Water.Commands._UJH.Custom = true
Water.Commands._UJH.Id = "f793d9da-7db1-476d-bae9-bc1cfa65baab"
Water.Commands._UJH.WorksWithAll = true
Water.ObjectLocation = Wherigo.INVALID_ZONEPOINT
Water.Locked = true
Water.Opened = false
_mmnv = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = Well
}
_mmnv.Id = "2b8d469e-7035-4517-9b4b-e6e96d29eaaf"
_mmnv.Name = _214L("\119\069\058\115\072\095\085\069\052")
_mmnv.Description = _214L("\029\060\060\106\013\095\065\104\106\115\095\060\083\115\095\060\122\095\058\099\115\095\013\060\065\057\104\115\072\013\095\057\072\060\067\067\115\057\095\013\060\088\115\058\099\104\083\052\074\074\074")
_mmnv.Visible = false
_mmnv.Commands = {
	_Ko3n = Wherigo.ZCommand{
		Text = _214L("\011\069\106\115\095\093\069\058\115\072\085\069\052"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_mmnv.Commands._Ko3n.Custom = true
_mmnv.Commands._Ko3n.Id = "becfffff-4b90-4c42-ba4a-c1e5737e2d7e"
_mmnv.Commands._Ko3n.WorksWithAll = true
_mmnv.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_mmnv.Locked = true
_mmnv.Opened = false
_LrP = Wherigo.ZItem(_uVERC)
_LrP.Id = "f63fcab2-6322-4ca8-b404-3240d07258cd"
_LrP.Name = _214L("\051\103\065\065\095\119\069\058\115\072\095\032\069\052")
_LrP.Description = _214L("\119\069\058\115\072\095\085\069\052\095\122\104\065\065\115\057\095\093\104\058\099\095\093\069\058\115\072")
_LrP.Visible = false
_LrP.Commands = {
	_TdXI7 = Wherigo.ZCommand{
		Text = _214L("\110\104\107\115\095\093\069\058\115\072\095\085\069\052"), 
		CmdWith = true, 
		Enabled = false, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_LrP.Commands._TdXI7.Custom = true
_LrP.Commands._TdXI7.Id = "9451bac9-23c0-441a-86fc-3a2fcea31371"
_LrP.Commands._TdXI7.WorksWithAll = false
_LrP.Commands._TdXI7.WorksWithListIds = {
	"8ad7fb0f-67d2-4291-a3f2-aa83ec893244", 
	"bbf2e4ca-386a-4237-9672-c76b877a762b", 
	"4235a710-d2a5-4895-ad01-8be7ac15932c", 
	"5b4f221b-aa64-4068-a469-34f0c0d17bec", 
	"4931cf58-f3cc-430a-8fbb-1472c01d1162", 
	"dba06b99-0d0f-4a76-a9bf-c3df3b47dd0d", 
	"79f5b452-b531-4b23-9ac1-98e8ebb14630"
}
_LrP.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_LrP.Locked = true
_LrP.Opened = false
_5jW = Wherigo.ZItem{
	Cartridge = _uVERC, 
	Container = Farm
}
_5jW.Id = "004818a0-2b14-4773-b782-6bbc0ad6529a"
_5jW.Name = _214L("\001\104\013\058\065\115\058\060\115\095\058\072\115\115")
_5jW.Description = _214L("\019\083\095\058\099\115\095\065\103\033\104\060\103\013\095\052\069\072\057\115\083\046\095\004\060\103\095\013\067\060\058\095\069\095\085\115\069\103\058\104\122\103\065\095\088\104\013\058\065\115\058\060\115\095\058\072\115\115")
_5jW.Visible = true
_5jW.Commands = {
	_rx3L = Wherigo.ZCommand{
		Text = _214L("\011\069\106\115\095\088\104\013\058\065\115\058\060\115\095\085\072\069\083\033\099\115\013"), 
		CmdWith = false, 
		Enabled = true, 
		EmptyTargetListText = _214L("\008\060\058\099\104\083\052\095\069\107\069\104\065\069\085\065\115")
	}
}
_5jW.Commands._rx3L.Custom = true
_5jW.Commands._rx3L.Id = "0bc97a4c-ef9d-4bb3-acda-248de6a0c6d7"
_5jW.Commands._rx3L.WorksWithAll = true
_5jW.ObjectLocation = Wherigo.INVALID_ZONEPOINT
_5jW.Locked = false
_5jW.Opened = false

-- Tasks --
_FOkne = Wherigo.ZTask(_uVERC)
_FOkne.Id = "e2d4c39f-74e6-4a32-8f23-1d99f7e27525"
_FOkne.Name = _214L("\110\115\058\095\058\099\115\095\085\069\072\058\115\083\057\115\072\095\013\060\088\115\095\058\060\088\069\058\060\054\103\104\033\115")
_FOkne.Description = _214L("\019\122\095\004\060\103\095\093\069\083\058\095\058\099\115\095\085\069\072\058\115\083\057\115\072\095\058\060\095\088\104\097\095\004\060\103\095\069\095\032\065\060\060\057\004\095\001\069\072\004\095\004\060\103\095\085\115\058\058\115\072\095\052\104\107\115\095\099\104\088\095\013\060\088\115\095\058\060\088\069\058\060\054\103\104\033\115\095\085\115\033\069\103\013\115\095\099\115\095\054\103\013\058\095\072\069\083\095\060\103\058\074")
_FOkne.Visible = true
_FOkne.Active = false
_FOkne.Complete = false
_FOkne.CorrectState = "None"
_99K = Wherigo.ZTask(_uVERC)
_99K.Id = "e1677abb-a54c-4029-bed0-e3322d7c784d"
_99K.Name = _214L("\032\072\104\083\052\095\058\099\115\095\104\083\107\104\013\104\085\065\115\095\067\104\083\106\095\103\083\104\033\060\072\083\095\058\060\095\104\058\013\095\088\069\058\115")
_99K.Description = ""
_99K.Visible = true
_99K.Active = false
_99K.Complete = false
_99K.CorrectState = "None"
_R2y = Wherigo.ZTask(_uVERC)
_R2y.Id = "d6fbea8a-8f34-44dd-a9fd-3c285578e3da"
_R2y.Name = _214L("\032\103\104\065\057\095\069\095\058\104\088\115\095\088\069\033\099\104\083\115")
_R2y.Description = ""
_R2y.Visible = true
_R2y.Active = false
_R2y.Complete = false
_R2y.CorrectState = "None"
_XlcTB = Wherigo.ZTask(_uVERC)
_XlcTB.Id = "efe73675-dd9a-4196-bfb1-82644d293c0b"
_XlcTB.Name = _214L("\110\115\058\095\058\099\115\095\100\060\033\095\069\095\122\065\103\097\095\033\069\067\069\033\104\058\060\072")
_XlcTB.Description = ""
_XlcTB.Visible = true
_XlcTB.Media = _OwS
_XlcTB.Active = false
_XlcTB.Complete = false
_XlcTB.CorrectState = "None"
_lKJm = Wherigo.ZTask(_uVERC)
_lKJm.Id = "49922d62-7b33-4765-8748-b232007763f3"
_lKJm.Name = _214L("\110\115\058\095\058\099\115\095\100\060\033\095\069\095\033\069\072")
_lKJm.Description = ""
_lKJm.Visible = true
_lKJm.Media = _A_Fi
_lKJm.Active = false
_lKJm.Complete = false
_lKJm.CorrectState = "None"
_slOc = Wherigo.ZTask(_uVERC)
_slOc.Id = "a1d4be3f-d561-437f-90d1-a97c8009e9be"
_slOc.Name = _214L("\108\115\065\067\095\058\099\115\095\057\072\103\104\057\095\058\060\095\067\072\115\067\069\072\115\095\069\095\088\069\052\104\033\095\067\060\058\104\060\083")
_slOc.Description = _214L("\108\115\101\013\095\088\104\013\013\104\083\052\095\013\060\088\115\095\104\083\052\072\115\057\104\115\083\058\013\074\074\074")
_slOc.Visible = true
_slOc.Media = _H18h
_slOc.Active = false
_slOc.Complete = false
_slOc.CorrectState = "None"
_1uM = Wherigo.ZTask(_uVERC)
_1uM.Id = "2c4d1d55-a9e1-4684-9abb-97e7118cd624"
_1uM.Name = _214L("\110\115\058\095\058\099\115\095\057\072\103\104\057\095\013\060\088\115\095\088\104\013\065\058\115\058\060\115\095\085\072\069\083\033\099\115\013")
_1uM.Description = ""
_1uM.Visible = true
_1uM.Media = _LuaPT
_1uM.Active = false
_1uM.Complete = false
_1uM.CorrectState = "None"
_i7eO = Wherigo.ZTask(_uVERC)
_i7eO.Id = "ff0c5171-5331-437e-bbda-619d497957ba"
_i7eO.Name = _214L("\110\115\058\095\058\099\115\095\057\072\103\104\057\095\013\060\088\115\095\093\069\058\115\072")
_i7eO.Description = ""
_i7eO.Visible = true
_i7eO.Media = _ad97
_i7eO.Active = false
_i7eO.Complete = false
_i7eO.CorrectState = "None"
_lOu = Wherigo.ZTask(_uVERC)
_lOu.Id = "2fa13f76-2d54-44dd-9bc3-fbbb2ee8036b"
_lOu.Name = _214L("\055\033\069\072\115\095\069\093\069\004\095\058\099\115\095\034\060\088\069\083\095\067\069\058\072\060\065")
_lOu.Description = ""
_lOu.Visible = true
_lOu.Media = _43R
_lOu.Active = false
_lOu.Complete = false
_lOu.CorrectState = "None"

-- Cartridge Variables --
_Lcm = 0
_Titp = ""
Time = _214L("\067\072\115\013\115\083\058")
_AlQ7 = false
_0KX = true
can_leave_tardis = false
super_power = false
_u6BEw = _214L("\051\060\060\057\108\069\033\106\104\083\052")
_5R3 = _214L("\042\013\072\093\014\122")
_yLq = _214L("\042\044\107\028\044\029")
_2E9kB = _214L("\042\051\028\106\083\115")
_DFT5l = _214L("\042\032\076\083\044\122")
_wut = _214L("\057\103\088\088\004")
_uVERC.ZVariables = {
	_Lcm = 0, 
	_Titp = "", 
	Time = _214L("\067\072\115\013\115\083\058"), 
	_AlQ7 = false, 
	_0KX = true, 
	can_leave_tardis = false, 
	super_power = false, 
	_u6BEw = _214L("\051\060\060\057\108\069\033\106\104\083\052"), 
	_5R3 = _214L("\042\013\072\093\014\122"), 
	_yLq = _214L("\042\044\107\028\044\029"), 
	_2E9kB = _214L("\042\051\028\106\083\115"), 
	_DFT5l = _214L("\042\032\076\083\044\122"), 
	_wut = _214L("\057\103\088\088\004")
}

-- Timers --

-- Inputs --
_BYn2f = Wherigo.ZInput(_uVERC)
_BYn2f.Id = "71b48622-867e-481b-a3bc-7614fd9e0fb9"
_BYn2f.Name = _214L("\119\099\069\058\100\072\104\083\106")
_BYn2f.Description = ""
_BYn2f.Visible = true
_BYn2f.Choices = {
	"Martini", 
	"Screwdriver", 
	"Bloody Mary"
}
_BYn2f.InputType = "MultipleChoice"
_BYn2f.Text = _214L("\119\099\069\058\095\093\060\103\065\057\095\004\060\103\095\065\104\106\115\095\058\060\095\057\072\104\083\106\116")
_PgQ9 = Wherigo.ZInput(_uVERC)
_PgQ9.Id = "aac4a784-cd29-41a6-8db5-201cd2a9d289"
_PgQ9.Name = _214L("\055\033\069\072\115\095\060\122\122\095\072\060\088\069\083\013")
_PgQ9.Description = ""
_PgQ9.Visible = true
_PgQ9.Choices = {
	"Yes", 
	"No"
}
_PgQ9.InputType = "MultipleChoice"
_PgQ9.Text = _214L("\011\099\115\095\067\060\058\104\060\083\095\104\013\095\072\115\069\057\004\074\095\011\060\060\095\085\069\057\095\088\004\095\013\058\060\088\069\033\099\095\033\069\083\095\083\060\058\095\058\069\106\115\095\104\058\074\095\019\122\095\019\095\052\104\107\115\095\004\060\103\095\069\095\013\104\067\046\095\093\104\065\065\095\004\060\103\095\013\033\069\072\115\095\060\122\122\095\058\099\115\095\034\060\088\069\083\013\095\122\060\072\095\088\115\116")
_crl3 = Wherigo.ZInput(_uVERC)
_crl3.Id = "ec938ccf-9c5e-448d-befe-f99f0e697a51"
_crl3.Name = _214L("\033\117\010")
_crl3.Description = ""
_crl3.Visible = true
_crl3.Media = _Zi_Nc
_crl3.Choices = {
	"ZX Spectrum", 
	"Commodore 64", 
	"MSX", 
	"Atari", 
	"Philips P2000"
}
_crl3.InputType = "MultipleChoice"
_crl3.Text = _214L("\119\099\069\058\095\058\004\067\115\095\060\122\095\033\060\088\067\103\058\115\072\095\104\013\095\058\099\104\013\116")

-- WorksWithList for object commands --
IPU.Commands._KHH.WorksWithList = {
	__BDBZ
}
_2vO2L.Commands._WHO.WorksWithList = {
	_srwCf
}
_MaM6x.Commands._cTPsR.WorksWithList = {
	_GIR, 
	_KngC, 
	_SMjym, 
	IPU, 
	__BDBZ, 
	_TvI, 
	_srwCf
}
_n54.Commands._MFU1.WorksWithList = {
	_srwCf, 
	_TvI, 
	__BDBZ, 
	IPU
}
_xQtW.Commands._LhGa.WorksWithList = {
	_srwCf, 
	_TvI, 
	__BDBZ, 
	IPU
}
_E_G4.Commands._TCx.WorksWithList = {
	_SMjym, 
	_GIR, 
	_KngC, 
	IPU, 
	__BDBZ, 
	_TvI, 
	_srwCf
}
_LrP.Commands._TdXI7.WorksWithList = {
	_SMjym, 
	_GIR, 
	_KngC, 
	IPU, 
	__BDBZ, 
	_TvI, 
	_srwCf
}

-- functions --
function _uVERC:OnStart()
	_Urwigo.MessageBox{
		Text = _214L("\011\060\095\058\099\115\095\060\099\088\044\090\015\005\095\033\069\088\067\095\093\115\065\033\060\088\115\074\095\012\083\085\013\067\038\076\115\013\046\095\099\088\088\088\074\037\032\034\045\037\032\034\045\055\060\088\115\095\122\103\083\083\004\095\065\060\060\106\104\083\052\095\033\099\069\072\069\033\058\115\072\013\095\069\072\060\103\083\057\095\099\115\072\115\046\095\058\099\115\072\115\095\013\103\072\115\095\069\072\115\074\095\012\083\085\013\067\038\074\095\012\083\085\013\067\038\037\032\034\045\011\060\095\093\069\083\057\115\072\095\069\072\060\103\083\057\095\069\083\057\095\088\115\115\058\095\058\099\115\088\095\122\115\115\065\095\122\072\115\115\074\095\012\083\085\013\067\038\037\032\034\045\037\032\034\045\119\104\058\099\095\004\060\103\095\088\069\004\095\058\099\115\095\122\060\072\033\115\095\085\115\074\074\074\095\012\083\085\013\067\038"), 
		Media = _PWe2d, 
		Callback = function(action)
			if action ~= nil then
				Time = _214L("\067\072\115\013\115\083\058")
				super_power = false
				_kzZ()
			end
		end
	}
end
function _uVERC:OnRestore()
end
function FoodHacking:OnEnter()
	_u6BEw = _214L("\051\060\060\057\108\069\033\106\104\083\052")
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, FoodHacking)
end
function Well:OnEnter()
	_u6BEw = _214L("\119\115\065\065")
	if Wherigo.NoCaseEquals(Time, _214L("\067\072\115\013\115\083\058")) then
		if Player:Contains(_NtUg) == true then
			_Urwigo.MessageBox{
				Text = _214L("\051\065\103\097\095\033\069\067\069\033\104\058\060\072\095\033\099\069\072\052\115\057\074\074\074\037\032\034\045\037\032\034\045\014\072\104\058\104\033\069\065\095\013\067\115\115\057\095\072\115\069\033\099\115\057\074\074\074\037\032\034\045\037\032\034\045\076\060\103\095\069\072\115\095\058\072\069\083\013\067\060\072\058\115\057\095\085\069\033\106\095\058\060\095\069\083\033\104\115\083\058\095\058\104\088\115\013\074\074\074"), 
				Media = _OwS, 
				Buttons = {
					_214L("\028\106")
				}, 
				Callback = function(action)
					if action ~= nil then
						Time = _214L("\072\060\088\069\083")
						_NtUg.Visible = false
						_n54:MoveTo(Well)
						_n54.Name = _214L("\100\103\013\058\004\095\060\085\054\115\033\058")
						Water.Visible = true
						Water.Locked = false
						_mmnv.Visible = true
						_mmnv.Locked = false
						_kzZ()
					end
				end
			}
		elseif _AlQ7 == false then
			_Urwigo.MessageBox{
				Text = _214L("\019\083\095\060\065\057\115\083\095\058\104\088\115\013\095\058\099\104\013\095\093\069\013\095\069\095\093\115\065\065\074\037\032\034\045\026\072\115\065\104\088\104\083\069\072\004\095\060\085\013\115\072\107\069\058\104\060\083\013\095\085\004\095\069\072\033\099\115\060\065\060\052\104\013\058\013\095\099\069\107\115\095\104\083\057\104\033\069\058\115\057\095\058\099\115\095\067\072\115\013\115\083\033\115\095\060\122\095\104\083\060\097\095\104\083\095\058\099\115\095\093\115\065\065\074\037\032\034\045\011\099\115\004\095\069\072\115\095\013\058\104\065\065\095\058\072\004\104\083\052\095\058\060\095\122\104\052\103\072\115\095\104\058\095\060\103\058\074\074\074"), 
				Media = _gHbhY, 
				Callback = function(action)
					if action ~= nil then
						if Well:Contains(_n54) == true then
							_Urwigo.MessageBox{
								Text = _214L("\011\099\115\095\033\060\072\083\115\072\095\060\122\095\069\095\069\095\057\103\013\058\004\095\060\085\054\115\033\058\095\104\013\095\013\058\104\033\106\104\083\052\095\122\072\060\088\095\058\099\115\095\052\072\060\103\083\057\046\095\004\060\103\095\093\060\083\057\115\072\095\093\099\069\058\095\104\058\095\104\013\074\074\074"), 
								Buttons = {
									_214L("\028\106")
								}
							}
						end
					end
				end
			}
		else
			_Urwigo.MessageBox{
				Text = _214L("\019\083\095\060\065\057\115\083\095\058\104\088\115\013\095\058\099\104\013\095\093\069\013\095\069\095\093\115\065\065\074\037\032\034\045\026\072\115\065\104\088\104\083\069\072\004\095\060\085\013\115\072\107\069\058\104\060\083\013\095\085\004\095\069\072\033\099\115\060\065\060\052\104\013\058\013\095\099\069\107\115\095\104\083\057\104\033\069\058\115\057\095\058\099\115\095\067\072\115\013\115\083\033\115\095\060\122\095\104\083\060\097\095\104\083\095\058\099\115\095\093\115\065\065\074\037\032\034\045\019\058\095\104\013\095\085\115\058\058\115\072\095\083\060\058\095\058\115\065\065\095\058\115\065\065\095\058\099\115\088\095\069\085\060\103\058\095\058\099\115\095\057\060\065\060\072\104\069\083\074\074"), 
				Media = _A_Fi, 
				Callback = function(action)
					if action ~= nil then
						if Well:Contains(_n54) == true then
							_Urwigo.MessageBox{
								Text = _214L("\011\099\115\095\033\060\072\083\115\072\095\060\122\095\069\095\069\095\057\103\013\058\004\095\060\085\054\115\033\058\095\104\013\095\013\058\104\033\106\104\083\052\095\122\072\060\088\095\058\099\115\095\052\072\060\103\083\057\046\095\004\060\103\095\093\060\083\057\115\072\095\093\099\069\058\095\104\058\095\104\013\074\074\074"), 
								Buttons = {
									_214L("\028\106")
								}
							}
						end
					end
				end
			}
		end
	end
end
function Area42:OnEnter()
	_u6BEw = _214L("\113\072\115\069\010\044")
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, Area42)
end
function RainbowIsland:OnEnter()
	_u6BEw = _214L("\034\069\104\083\085\060\093\019\013\065\069\083\057")
	Wherigo.PlayAudio(_dBdDe)
end
function RainbowIsland:OnExit()
	_u6BEw = _214L("\034\069\104\083\085\060\093\019\013\065\069\083\057")
	Wherigo.Command "StopSound"
end
function RainbowIsland:OnProximity()
	_u6BEw = _214L("\034\069\104\083\085\060\093\019\013\065\069\083\057")
	Wherigo.PlayAudio(_dBdDe)
end
function RainbowIsland:OnDistant()
	_u6BEw = _214L("\034\069\104\083\085\060\093\019\013\065\069\083\057")
	Wherigo.Command "StopSound"
end
function Bar:OnEnter()
	_u6BEw = _214L("\032\069\072")
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, Bar)
end
function AncientFarm:OnEnter()
	_u6BEw = _214L("\113\083\033\104\115\083\058\051\069\072\088")
	if Wherigo.NoCaseEquals(Time, _214L("\067\072\115\013\115\083\058")) then
		_Urwigo.Dialog(false, {
			{
				Text = _214L("\019\083\095\058\099\115\095\060\065\057\095\057\069\004\095\058\099\104\013\095\013\104\058\115\095\103\013\115\057\095\058\060\095\099\060\103\013\115\095\069\095\122\069\072\088\074")
			}, 
			{
				Text = _214L("\019\058\095\104\013\095\072\103\088\060\072\115\057\095\058\099\069\058\095\069\095\013\058\072\069\083\052\115\065\004\095\033\065\069\057\095\099\115\072\060\095\033\069\065\065\115\057\095\101\108\069\097\060\072\101\095\057\115\122\115\069\058\115\057\095\013\060\088\115\095\072\060\088\069\083\013\095\099\115\072\115\095\103\013\104\083\052\095\069\095\088\069\052\104\033\095\067\060\058\104\060\083\095\099\115\095\052\060\058\095\122\072\060\088\095\069\095\100\072\103\104\057\074"), 
				Buttons = {
					_214L("\028\106")
				}
			}
		}, nil)
	end
end
function RandomVillage:OnExit()
	_u6BEw = _214L("\034\069\083\057\060\088\114\104\065\065\069\052\115")
	_Urwigo.MessageBox{
		Text = _214L("\086\100\060\033\086\095\032\072\060\093\013\095\013\069\004\013\123\095\067\065\115\069\013\115\095\033\060\088\115\095\085\069\033\106\095\065\069\058\115\072\095\058\060\095\033\099\115\033\106\095\088\004\095\067\072\060\052\072\115\013\013\074\074\074"), 
		Buttons = {
			_214L("\028\106")
		}
	}
end
function Farm:OnEnter()
	_u6BEw = _214L("\051\069\072\088")
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, Farm)
end
function BEPB:OnEnter()
	_u6BEw = _214L("\032\120\026\032")
	if _lOu.Complete == false then
		_Urwigo.OldDialog{
			{
				Text = _214L("\055\103\057\057\115\083\065\004\095\058\099\115\095\100\072\103\104\057\095\054\103\088\067\013\095\104\083\095\122\072\060\083\058\095\060\122\095\004\060\103\074\074\074\095"), 
				Media = _QX7Z
			}, 
			{
				Text = _214L("\019\101\088\095\013\060\072\072\004\046\095\085\103\058\095\019\095\033\069\083\083\060\058\095\065\115\058\095\004\060\103\095\115\083\058\115\072\095\058\099\104\013\095\013\058\072\069\083\052\115\095\033\060\083\058\072\069\067\058\104\060\083\095\085\115\122\060\072\095\004\060\103\095\099\069\107\115\095\013\033\069\072\115\057\095\069\093\069\004\095\058\099\115\095\034\060\088\069\083\013")
			}
		}
	else
		_Urwigo.MessageBox{
			Text = _214L("\076\060\103\095\013\058\115\067\095\104\083\058\060\095\058\099\115\095\058\115\065\115\067\099\060\083\115\095\085\060\060\058\099\046\095\104\058\095\065\060\060\106\013\095\069\095\065\060\058\095\085\104\052\052\115\072\095\060\083\095\058\099\115\095\104\083\013\104\057\115\074\074\074"), 
			Media = _1QX
		}
		Time = _214L("\058\069\072\057\104\013")
		_kzZ()
	end
end
function TardisExit:OnEnter()
	_u6BEw = _214L("\011\069\072\057\104\013\120\097\104\058")
	Wherigo.PlayAudio(_22Zmj)
	_Urwigo.MessageBox{
		Text = _214L("\076\060\103\095\122\115\115\065\095\069\095\013\058\072\069\083\052\115\095\013\099\104\122\058\104\083\052\095\013\115\083\013\069\058\104\060\083\074\074\074"), 
		Media = _1QX
	}
end
function TardisExit:OnExit()
	_u6BEw = _214L("\011\069\072\057\104\013\120\097\104\058")
	_Urwigo.Dialog(false, {
		{
			Text = _214L("\076\060\103\095\065\115\069\107\115\095\058\099\115\095\058\069\072\057\104\013\095\069\083\057\095\072\115\058\103\072\083\095\058\060\095\067\072\115\013\115\083\058\095\057\069\004\074\074\074\037\032\034\045\076\060\103\095\013\058\104\065\065\095\099\069\107\115\095\004\060\103\072\095\013\103\067\115\072\095\067\060\093\115\072\013\095\122\072\060\088\095\058\099\115\095\057\072\103\104\057\101\013\095\088\069\052\104\033\095\067\060\058\104\060\083\074"), 
			Media = _1QX
		}, 
		{
			Text = _214L("\113\013\095\004\060\103\095\065\060\060\106\095\058\060\093\069\072\057\013\095\034\069\104\083\085\060\093\095\019\013\065\069\083\057\095\004\060\103\095\013\115\115\095\069\095\093\099\104\122\122\095\060\122\095\069\095\058\072\069\083\013\065\103\033\115\083\058\095\067\104\083\106\095\058\069\104\065\095\115\083\058\115\072\104\083\052\095\058\099\115\095\104\013\065\069\083\057\074"), 
			Media = _6VwMs
		}, 
		{
			Text = _214L("\011\099\115\095\058\069\072\057\104\013\095\057\104\069\067\115\069\072\013\095\085\115\099\104\083\057\095\004\060\103\074\074\074"), 
			Media = _1QX
		}
	}, function(action)
		Wherigo.PlayAudio(_22Zmj)
		Time = _214L("\067\072\115\013\115\083\058")
		_kzZ()
		IPU.Visible = true
	end)
end
function Forest:OnEnter()
	_u6BEw = _214L("\051\060\072\115\013\058")
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, Forest)
end
function DoctorWhosDesk:OnEnter()
	_u6BEw = _214L("\100\060\033\058\060\072\119\099\060\013\100\115\013\106")
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, _GIR)
end
function _BYn2f:OnGetInput(input)
	if input == nil then
		input = ""
	end
	_Titp = input
	_Urwigo.Dialog(false, {
		{
			Text = _214L("\011\099\115\095\085\069\072\058\115\083\057\115\072\095\013\104\125\115\013\095\004\060\103\095\103\067")
		}
	}, function(action)
		if _Lcm == 3 then
			_Urwigo.MessageBox{
				Text = _214L("\055\060\072\072\004\095\004\060\103\095\069\072\115\095\065\060\069\057\115\057\046\095\019\095\033\069\083\083\060\058\095\013\115\072\107\115\095\004\060\103\074\074\074")
			}
		elseif _Lcm == 2 then
			if _srwCf:Contains(_2vO2L) then
				_Urwigo.MessageBox{
					Text = _214L("\076\060\103\095\099\069\107\115\095\099\069\057\095\115\083\060\103\052\099\095\057\072\104\083\106\013\095\069\065\072\115\069\057\004\046\095\019\095\093\104\065\065\095\088\069\106\115\095\004\060\103\095\069\095\101\114\104\072\052\104\083\095\085\065\060\060\057\004\095\088\069\072\004\101\095\104\083\095\013\058\115\069\057\030"), 
					Callback = function(action)
						if action ~= nil then
							Wherigo.ShowScreen(Wherigo.DETAILSCREEN, _MaM6x)
						end
					end
				}
				_Lcm = 3
				_MaM6x:MoveTo(Player)
				_MaM6x.Commands._cTPsR.Enabled = true
				_uVERC:RequestSync()
			else
				_Urwigo.MessageBox{
					Text = _214L("\076\060\103\095\099\069\107\115\095\099\069\057\095\115\083\060\103\052\099\095\057\072\104\083\106\013\095\069\065\072\115\069\057\004\074\095\011\060\060\095\085\069\057\095\019\095\072\069\083\095\060\103\058\095\060\122\095\058\060\088\069\058\060\095\054\103\104\033\115\095\054\103\013\058\095\083\060\093\046\095\060\058\099\115\072\093\104\013\115\095\019\095\033\060\103\065\057\095\099\069\107\115\095\088\069\057\115\095\004\060\103\095\069\095\114\104\072\052\104\083\095\032\065\060\060\057\004\095\001\069\072\004\074\074\074")
				}
				_FOkne.Active = true
				_uVERC:RequestSync()
			end
		else
			_Urwigo.MessageBox{
				Text = (_214L("\011\099\115\095\085\069\072\058\115\083\057\115\072\095\067\060\060\072\013\095\004\060\103\095\004\060\103\072\095\057\072\104\083\106\074\095\104\058\095\104\013\095\058\099\115\095\085\115\013\058\095").._Titp).._214L("\095\004\060\103\095\058\069\013\058\115\057\095\104\083\095\069\095\065\060\083\052\095\058\104\088\115\074")
			}
			_Lcm = _Lcm + 1
			_uVERC:RequestSync()
		end
	end)
end
function _PgQ9:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if _Urwigo.Hash(string.lower(input)) == 34270 then
		super_power = true
		BEPB.Active = true
		BEPB.Visible = true
		_lOu.Active = true
		_Urwigo.OldDialog{
			{
				Text = _214L("\076\060\103\095\057\072\104\083\106\095\058\099\115\095\067\060\058\104\060\083\095\060\122\095\058\099\115\095\013\067\060\060\083\095\058\099\115\095\057\072\103\104\057\095\060\122\122\115\072\013\095\004\060\103\074\095\076\060\103\095\122\115\115\065\095\069\095\013\058\072\069\083\052\115\095\058\104\083\052\065\115\095\052\060\104\083\052\095\057\060\093\083\095\004\060\103\095\013\067\104\083\115\074")
			}, 
			{
				Text = _214L("\076\060\103\095\122\115\115\065\095\013\103\072\072\115\069\065\046\095\069\013\095\104\122\095\093\069\065\106\104\083\052\095\104\083\058\060\095\069\095\100\069\065\104\095\067\069\104\083\058\104\083\052\074\095\113\095\085\065\103\115\095\115\083\052\065\104\013\099\095\067\099\060\083\115\095\085\060\060\058\099\095\093\099\104\033\099\095\065\060\060\106\013\095\093\104\065\057\065\004\095\060\103\058\095\060\122\095\067\065\069\033\115\095\013\115\115\088\013\095\058\060\095\069\067\067\115\069\072\095\060\103\058\095\060\122\095\058\099\104\083\095\069\104\072\074\095")
			}, 
			{
				Text = _214L("\011\099\115\095\057\072\103\104\057\095\013\103\052\052\115\013\058\013\095\058\099\069\058\095\004\060\103\095\067\104\033\106\095\103\067\095\069\095\099\103\052\115\095\072\060\033\106\074\095\076\060\103\095\058\099\104\083\106\095\099\115\101\013\095\052\060\083\115\095\088\069\057\046\095\085\103\058\095\060\057\057\065\004\095\115\083\060\103\052\099\046\095\004\060\103\095\065\104\122\058\095\103\067\095\058\099\115\095\072\060\033\106\095\069\013\095\104\122\095\104\058\095\093\115\072\115\095\088\069\057\115\095\122\072\060\088\095\013\058\004\072\060\122\060\069\088\074\095\055\103\072\072\115\069\065\074\074\074\074")
			}
		}
	else
		_Urwigo.OldDialog{
			{
				Text = _214L("\019\095\052\103\115\013\013\095\019\095\099\069\107\115\095\058\060\095\052\060\095\085\069\033\106\095\104\083\058\060\095\099\104\057\104\083\052\095\069\083\057\095\093\069\104\058\095\122\060\072\095\088\004\095\122\072\104\115\083\057\013\095\058\060\095\013\099\060\093\095\103\067\074\095")
			}
		}
	end
end
function _crl3:OnGetInput(input)
	if input == nil then
		input = ""
	end
	if _Urwigo.Hash(string.lower(input)) == 17428 then
		TardisExit.Active = true
		TardisExit.Visible = true
		_Urwigo.MessageBox{
			Text = _214L("\011\099\069\083\106\095\004\060\103\095\107\115\072\004\095\088\103\033\099\046\095\019\101\107\115\095\088\060\107\115\057\095\058\099\115\095\058\069\072\057\104\013\095\085\069\033\106\095\058\060\095\028\108\001\044\090\015\005\095\093\099\115\072\115\095\058\099\104\013\095\033\060\088\067\103\058\115\072\095\085\115\065\060\083\052\013\074\095\011\099\115\095\115\097\104\058\095\060\122\095\058\099\115\095\058\069\072\057\104\013\095\104\013\095\060\107\115\072\095\058\099\115\072\115\074"), 
			Media = _LJe, 
			Callback = function(action)
				if action ~= nil then
					Wherigo.ShowScreen(Wherigo.DETAILSCREEN, TardisExit)
				end
			end
		}
	else
		_Urwigo.MessageBox{
			Text = _214L("\019\101\088\095\069\122\072\069\104\057\095\058\099\069\058\095\104\013\095\104\083\033\060\072\072\115\033\058\074\074\074")
		}
	end
end
function _srwCf:On_fM10(target)
	_Urwigo.RunDialogs(function()
		Wherigo.GetInput(_BYn2f)
	end)
end
function _srwCf:On_cuM(target)
	_Urwigo.Dialog(false, {
		{
			Text = _214L("\076\060\103\095\013\069\004\095\099\104\095\058\060\095\058\099\115\095\085\069\072\058\115\083\057\115\072\074\074\074"), 
			Media = _m0Nj
		}, 
		{
			Text = _214L("\011\099\115\095\085\069\072\058\115\083\057\115\072\095\013\069\004\013\095\099\104\095\085\069\033\106\074\074\037\032\034\045\037\032\034\045\019\058\095\065\060\060\106\013\095\065\104\106\115\095\099\115\095\093\060\103\065\057\095\065\104\106\115\095\004\060\103\095\058\060\095\060\072\057\115\072\095\069\095\057\072\104\083\106"), 
			Media = _m0Nj, 
			Buttons = {
				_214L("\028\106")
			}
		}
	}, nil)
end
function _TvI:On_JASdq(target)
	if (_TvI:Contains(_n54) and _TvI:Contains(_xQtW)) == false then
		_Urwigo.MessageBox{
			Text = _214L("\019\101\088\095\085\103\104\065\057\104\083\052\095\069\095\058\104\088\115\095\088\069\033\099\104\083\115\074\095\037\032\034\045\113\065\065\095\019\095\083\115\115\057\095\058\060\095\033\060\088\067\065\115\058\115\095\104\058\095\104\013\095\069\095\122\065\103\097\095\033\069\067\069\033\104\058\060\072\095\069\083\057\095\122\069\013\058\095\033\069\072\046\095\067\072\115\122\115\072\069\085\065\004\095\060\083\115\095\088\069\057\115\095\060\122\095\013\058\103\072\057\004\095\013\058\103\122\122\074"), 
			Callback = function(action)
				if action ~= nil then
					_lKJm.Active = true
					_XlcTB.Active = true
					_R2y.Active = true
				end
			end
		}
	else
		_Urwigo.MessageBox{
			Text = _214L("\076\115\013\074\074\095\004\115\013\074\074\095\104\058\095\104\013\095\122\104\083\104\013\099\115\057\074\095\037\032\034\045\019\122\095\004\060\103\095\057\072\104\107\115\095\058\099\115\095\058\104\088\115\095\088\069\033\099\104\083\115\095\058\060\095\058\099\115\095\093\115\065\065\095\069\083\057\095\052\115\058\095\058\099\115\072\115\095\093\104\058\099\104\083\095\102\095\088\104\083\103\058\115\013\095\004\060\103\095\093\104\065\065\095\058\072\069\107\115\065\095\085\069\033\106\095\058\060\095\058\099\115\095\060\065\057\115\083\095\057\069\004\013"), 
			Buttons = {
				_214L("\028\106")
			}, 
			Callback = function(action)
				if action ~= nil then
					_NtUg:MoveTo(Player)
					_NtUg.Visible = true
					_xQtW.Visible = false
					_n54.Visible = false
					_R2y.Complete = true
					_uVERC:RequestSync()
				end
			end
		}
	end
end
function __BDBZ:On_tJn(target)
	_Urwigo.MessageBox{
		Text = _214L("\019\101\107\115\095\065\060\013\058\095\088\004\095\122\072\104\115\083\057\046\095\058\099\115\095\104\083\107\104\013\104\085\065\115\095\067\104\083\106\095\103\083\104\033\060\072\083\074\095\014\069\083\095\004\060\103\095\099\115\065\067\095\088\115\095\122\104\083\057\095\104\058\116\037\032\034\045\037\032\034\045\076\060\103\095\093\104\065\065\095\083\115\115\057\095\058\060\095\057\072\104\083\106\095\069\095\088\069\052\104\033\095\067\060\058\104\060\083\095\058\060\095\013\115\115\095\099\104\088\074"), 
		Media = _CRaA, 
		Buttons = {
			_214L("\028\106")
		}, 
		Callback = function(action)
			if action ~= nil then
				_99K.Active = true
				Wherigo.ShowScreen(Wherigo.DETAILSCREEN, _99K)
			end
		end
	}
end
function IPU:On_Nbe(target)
	if IPU:Contains(_MaM6x) then
		IPU:MoveTo(Player)
		_Urwigo.MessageBox{
			Text = _214L("\008\060\093\095\058\099\069\058\095\058\099\115\095\103\083\104\033\060\072\083\095\057\072\069\083\106\095\004\060\103\095\107\104\072\052\104\083\095\085\065\060\060\057\004\095\088\069\072\004\046\095\013\099\115\095\069\065\065\060\093\013\095\004\060\103\095\058\060\095\033\069\058\033\099\095\099\115\072\115\074\074\074"), 
			Media = _6VwMs
		}
	else
		_Urwigo.MessageBox{
			Text = _214L("\019\058\095\104\013\095\013\069\104\057\095\058\099\069\058\095\060\083\065\004\095\069\095\107\104\072\052\104\083\095\033\069\083\095\033\069\058\033\099\095\069\095\103\083\104\033\060\072\083\074\074\074"), 
			Media = _6VwMs, 
			Callback = function(action)
				if action ~= nil then
					if Player:Contains(_MaM6x) then
						_Urwigo.MessageBox{
							Text = _214L("\034\115\088\115\088\085\115\072\095\058\099\115\095\057\072\104\083\106\095\058\099\115\095\085\069\072\058\115\083\057\115\072\095\052\069\107\115\095\004\060\103\116"), 
							Media = _XPAR
						}
					end
				end
			end
		}
	end
end
function IPU:On_KHH(target)
	_Urwigo.MessageBox{
		Text = _214L("\011\099\069\083\106\095\004\060\103\095\122\060\072\095\122\104\083\057\104\083\052\095\088\004\095\088\069\058\115\030\037\032\034\045\037\032\034\045\026\065\115\069\013\115\095\122\104\083\057\095\069\095\055\033\099\103\085\115\072\052\095\026\099\104\065\104\013\095\067\115\072\013\060\083\095\069\083\057\095\013\099\060\093\095\099\104\088\095\058\099\104\013\095\033\060\057\115\095\058\060\095\052\115\058\095\004\060\103\072\095\072\115\093\069\072\057\074\037\032\034\045\037\032\034\045\019\051\011\019\026\036")..math.random(10000, 65535), 
		Media = _CRaA, 
		Callback = function(action)
			if action ~= nil then
				_99K.Complete = true
				_uVERC.Complete = true
				IPU.Commands._KHH.Enabled = false
				_uVERC:RequestSync()
			end
		end
	}
end
function _SMjym:On_6kuT2(target)
	if _SMjym:Contains(_E_G4) and _SMjym:Contains(_LrP) then
		_slOc.Complete = true
		_Urwigo.Dialog(false, {
			{
				Text = _214L("\011\099\069\083\106\013\095\122\060\072\095\085\072\104\083\052\104\083\052\095\088\115\095\058\099\115\095\088\104\013\013\104\083\052\095\104\083\052\072\115\057\104\115\083\058\013\095\122\060\072\095\058\099\115\095\088\069\052\104\033\095\067\060\093\115\072\095\067\060\058\104\060\083\074")
			}
		}, function(action)
			_Urwigo.RunDialogs(function()
				Wherigo.GetInput(_PgQ9)
			end)
		end)
		_uVERC:RequestSync()
	else
		_Urwigo.OldDialog{
			{
				Text = _214L("\076\060\103\095\058\115\065\065\095\058\099\115\095\100\072\103\104\057\095\058\099\069\058\095\004\060\103\101\072\115\095\083\060\058\095\058\072\004\104\083\052\095\058\060\095\099\103\072\058\095\099\104\088\074\095")
			}, 
			{
				Text = _214L("\060\099\074\074\095\099\115\065\065\060\095\013\058\072\069\083\052\115\072\074\095\076\060\103\095\057\060\095\083\060\058\095\072\115\088\060\058\115\065\004\095\065\060\060\106\095\034\060\088\069\083\074\095\019\122\095\058\099\115\095\013\060\065\057\104\115\072\013\095\033\069\058\033\099\095\088\115\046\095\058\099\115\004\101\065\065\095\058\069\106\115\095\088\115\095\058\060\095\058\099\115\104\072\095\033\069\088\067\095\058\060\095\122\060\072\033\115\095\088\115\095\104\083\058\060\095\088\069\106\104\083\052\095\069\095\088\069\052\104\033\095\067\060\093\115\072\095\067\060\058\104\060\083\095\122\060\072\095\058\099\115\088\074\095\019\122\095\060\083\065\004\095\019\095\099\069\057\095\058\099\115\095\104\083\052\072\115\057\104\115\083\058\013\074\046\095\058\099\115\083\095\019\095\033\060\103\065\057\095\088\069\106\115\095\013\060\088\115\095\069\083\057\095\085\115\095\067\060\093\115\072\122\103\065\065\095\115\083\060\103\052\099\095\058\060\095\013\033\069\072\115\095\058\099\115\095\072\060\088\069\083\013\095\069\093\069\004\074\037\032\034\045\037\032\034\045\019\095\083\115\115\057\095\013\060\088\115\095\088\104\013\058\065\115\058\060\115\013\095\085\072\069\083\033\099\115\013\095\069\083\057\095\013\060\088\115\095\093\069\058\115\072\074")
			}
		}
		_slOc.Active = true
		_1uM.Active = true
		_i7eO.Active = true
	end
end
function _KngC:On_9Mk(target)
	if super_power == false then
		_Urwigo.MessageBox{
			Text = _214L("\076\060\103\095\058\072\004\095\058\060\095\058\069\065\106\095\058\060\095\058\099\115\095\034\060\088\069\083\095\067\069\058\072\060\065\046\095\085\103\058\095\058\099\115\004\095\069\072\115\095\083\060\058\095\107\115\072\004\095\122\072\104\115\083\057\065\004\074\074\074\037\032\034\045\037\032\034\045\055\104\083\033\115\095\004\060\103\095\057\060\083\038\058\095\122\115\115\065\095\107\115\072\004\095\013\058\072\060\083\052\046\095\004\060\103\095\057\115\033\104\057\115\095\083\060\058\095\058\099\115\095\033\099\069\083\033\115\095\104\058\074\074")
		}
	else
		_Urwigo.MessageBox{
			Text = _214L("\076\060\103\095\013\099\060\103\058\123\095\086\108\115\004\095\004\060\103\095\058\104\083\095\033\069\083\101\013\095\122\103\065\065\095\060\122\095\013\067\069\052\099\115\058\058\104\030\030\030\030\086")
		}
	end
end
function _KngC:On_P5E(target)
	if super_power == true then
		_Urwigo.MessageBox{
			Text = _214L("\119\104\058\099\095\058\099\115\095\069\104\057\095\060\122\095\004\060\103\095\013\103\067\115\072\095\067\060\093\115\072\013\095\004\060\103\095\013\033\069\072\115\095\060\122\095\058\099\115\095\072\060\088\069\083\013"), 
			Media = _5x3e, 
			Callback = function(action)
				if action ~= nil then
					_lOu.Complete = true
				end
			end
		}
		_KngC.Visible = false
	else
		_Urwigo.MessageBox{
			Text = _214L("\076\060\103\095\058\069\106\115\095\069\095\107\104\033\104\060\103\013\095\085\115\069\058\104\083\052\095\060\122\095\058\099\115\095\034\060\088\069\083\095\067\069\058\072\060\065\074\037\032\034\045\076\060\103\095\085\115\058\058\115\072\095\083\060\058\095\058\072\004\095\058\099\104\013\095\069\052\069\104\083\074\074\074"), 
			Media = _5x3e, 
			Callback = function(action)
				if action ~= nil then
					_lOu.Complete = true
				end
			end
		}
	end
end
function _GIR:On_Bnc(target)
	_Urwigo.MessageBox{
		Text = _214L("\119\099\069\058\116\095\076\060\103\101\072\115\095\065\060\013\058\095\004\060\103\095\013\069\004\116\095\037\032\034\045\019\013\095\104\058\095\054\103\013\058\095\058\099\115\095\013\067\069\033\104\060\103\013\095\104\083\058\115\072\104\060\103\072\095\060\122\095\058\099\104\013\095\011\069\072\057\104\013\095\060\072\095\069\072\115\095\004\060\103\095\065\060\013\058\095\104\083\095\013\067\069\033\115\095\069\083\057\095\058\104\088\115\095\069\013\095\093\115\065\065\116\037\032\034\045\076\060\103\095\106\083\060\093\095\093\099\069\058\046\095\104\122\095\004\060\103\095\099\115\065\067\095\088\115\095\088\069\106\115\095\013\115\083\013\115\095\060\122\095\058\099\104\013\095\067\103\125\125\115\065\095\019\101\065\065\095\058\069\106\115\095\004\060\103\095\058\060\095\093\099\115\072\115\095\004\060\103\095\093\069\083\058\095\058\060\095\052\060\074"), 
		Media = _LJe, 
		Callback = function(action)
			if action ~= nil then
				_Urwigo.RunDialogs(function()
					Wherigo.GetInput(_crl3)
				end)
			end
		end
	}
end
function _2vO2L:On_WHO(target)
	if target == _srwCf then
		_2vO2L:MoveTo(_srwCf)
		_FOkne.Complete = true
		_Urwigo.MessageBox{
			Text = _214L("\011\099\115\095\085\069\072\057\058\115\083\057\115\072\095\013\069\004\013\123\095\086\011\099\069\083\106\095\004\060\103\095\107\115\072\004\095\088\103\033\099\086"), 
			Buttons = {
				_214L("\028\073")
			}
		}
	else
		_Urwigo.MessageBox{
			Text = target.._214L("\065\060\060\106\013\095\098\103\104\125\104\033\069\065\065\004\095\069\058\095\004\060\103\095\069\083\057\095\099\069\083\057\013\095\085\069\033\106\095\058\099\115\095\054\103\104\033\115\074"), 
			Buttons = {
				_214L("\028\106")
			}
		}
	end
end
function _2vO2L:On_KSVGz(target)
	_Urwigo.MessageBox{
		Text = _214L("\076\060\103\095\058\069\106\115\095\058\099\115\095\085\060\058\058\065\115\095\060\122\095\058\060\088\069\058\060\054\103\104\033\115\095\069\083\057\095\067\103\058\095\104\058\095\104\083\095\004\060\103\072\095\085\069\033\106\067\069\033\106\074"), 
		Buttons = {
			_214L("\028\106")
		}, 
		Callback = function(action)
			if action ~= nil then
				_2vO2L:MoveTo(Player)
				_2vO2L.Commands._WHO.Enabled = true
				_2vO2L.Commands._KSVGz.Enabled = false
				_uVERC:RequestSync()
			end
		end
	}
end
function _MaM6x:On_cTPsR(target)
	if target == IPU then
		_Urwigo.MessageBox{
			Text = _214L("\011\099\115\095\103\083\104\033\060\072\083\095\013\083\104\122\122\013\095\004\060\103\072\095\057\072\104\083\106\095\069\083\057\095\058\069\106\115\013\095\069\095\125\104\067\074\074\074"), 
			Media = _6VwMs, 
			Callback = function(action)
				if action ~= nil then
					_MaM6x:MoveTo(IPU)
					IPU:MoveTo(Player)
					IPU.Commands._KHH.Enabled = true
					IPU.Commands._Nbe.Enabled = false
				end
			end
		}
	else
		_Urwigo.MessageBox{
			Text = _214L("\055\060\072\072\004\046\095\019\095\057\060\083\101\058\095\065\104\106\115\095\058\060\088\069\058\060\115\013\074\074\074")
		}
	end
end
function _n54:On_YLU3(target)
	if Wherigo.NoCaseEquals(Time, _214L("\067\072\115\013\115\083\058")) then
		_Urwigo.MessageBox{
			Text = _214L("\076\060\103\095\067\104\033\106\095\103\067\095\058\099\115\095\060\085\054\115\033\058\095\069\083\057\095\093\099\104\067\115\095\060\122\122\095\058\099\115\095\057\104\072\058\046\095\104\058\095\065\060\060\106\013\095\122\069\088\104\065\104\069\072\095\058\060\095\004\060\103\074\074\074\037\032\034\045\037\032\034\045\113\095\013\103\057\057\115\083\095\122\065\069\013\099\095\060\122\095\072\115\033\060\052\083\104\058\104\060\083\095\099\104\058\013\074\095\076\060\103\095\067\103\058\095\104\058\095\104\083\095\004\060\103\072\095\085\069\033\106\067\069\033\106\074"), 
			Buttons = {
				_214L("\028\106")
			}, 
			Callback = function(action)
				if action ~= nil then
					_n54.Name = _214L("\051\065\103\097\095\033\069\067\069\033\104\058\060\072")
					_n54:MoveTo(Player)
					_n54.Commands._YLU3.Enabled = false
					_n54.Commands._MFU1.Enabled = true
					_0KX = false
					_uVERC:RequestSync()
				end
			end
		}
	else
		_Urwigo.MessageBox{
			Text = _214L("\019\122\095\004\060\103\095\058\069\106\115\095\058\099\115\095\122\065\103\097\095\033\069\067\069\033\104\058\060\072\095\083\060\093\046\095\004\060\103\095\093\104\065\065\095\083\060\058\095\069\085\065\115\095\058\060\095\067\104\033\106\095\104\058\095\103\067\095\104\083\095\058\099\115\095\122\103\058\103\072\115\095\069\083\057\095\058\072\069\107\115\065\095\085\069\033\065\106\095\058\060\095\058\099\104\013\095\058\104\088\115\095\058\060\095\065\115\069\107\115\095\104\058\095\099\115\072\115\095\122\060\072\095\004\060\103\072\013\115\065\122\095\058\060\095\122\104\083\057\074")
		}
	end
end
function _n54:On_MFU1(target)
	if target == _TvI then
		if _TvI:Contains(_xQtW) then
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\065\115\058\095\088\115\095\122\104\058\095\058\099\115\095\122\065\103\097\095\033\069\067\069\033\104\058\060\072\095\104\083\095\058\099\115\095\100\115\065\060\072\104\069\083\095\069\083\057\095\058\069\065\106\095\058\060\095\088\115\095\104\083\095\069\095\122\115\093\095\013\115\033\060\083\057\013\074"), 
				Media = _RYlTZ
			}
		else
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\083\060\093\095\069\065\065\095\019\095\083\115\115\057\095\104\013\095\069\095\013\067\060\072\058\013\095\033\069\072\074\037\032\034\045\037\032\034\045\108\060\093\095\069\085\060\103\058\095\069\095\057\072\104\083\106\095\069\058\095\058\099\115\095\085\069\072\095\093\099\104\065\115\095\019\095\058\072\004\095\058\060\095\052\115\058\095\060\083\115\074\074\074"), 
				Media = _RYlTZ
			}
		end
		_n54:MoveTo(_TvI)
		_XlcTB.Complete = true
		_n54.Commands._YLU3.Enabled = false
		_n54.Commands._MFU1.Enabled = false
		_uVERC:RequestSync()
	else
		_Urwigo.MessageBox{
			Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\019\095\057\060\083\101\058\095\083\115\115\057\095\104\058\074")
		}
	end
end
function _xQtW:On_aiWP(target)
	_Urwigo.MessageBox{
		Text = _214L("\076\060\103\095\069\072\115\095\083\060\093\095\104\083\095\067\060\013\115\013\013\104\060\083\095\060\122\095\069\095\057\115\065\060\072\104\069\083\074"), 
		Media = _A_Fi
	}
	_xQtW:MoveTo(Player)
	_xQtW.Commands._aiWP.Enabled = false
	_xQtW.Commands._LhGa.Enabled = true
	_uVERC:RequestSync()
end
function _xQtW:On_LhGa(target)
	if target == _TvI then
		_xQtW:MoveTo(_TvI)
		_lKJm.Complete = true
		_xQtW.Commands._aiWP.Enabled = false
		_xQtW.Commands._LhGa.Enabled = false
		_xQtW.Commands._6lt.Enabled = false
		_uVERC:RequestSync()
		if _TvI:Contains(_n54) then
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\065\115\058\095\088\115\095\122\104\058\095\058\099\115\095\122\065\103\097\095\033\069\067\069\033\104\058\060\072\095\104\083\095\058\099\115\095\100\115\065\060\072\104\069\083\095\069\083\057\095\058\069\065\106\095\058\060\095\088\115\095\104\083\095\069\095\122\115\093\095\013\115\033\060\083\057\013\074"), 
				Media = _RYlTZ
			}
		else
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\083\060\093\095\069\065\065\095\019\095\083\115\115\057\095\104\013\095\069\095\122\065\103\097\095\033\069\067\069\033\104\058\060\072\074\074\074\037\032\034\045\037\032\034\045\032\004\095\058\099\115\095\093\069\004\046\095\057\104\057\095\004\060\103\095\013\115\115\095\058\099\115\095\083\104\033\115\095\060\065\057\095\093\115\065\065\095\083\115\069\072\085\004\116"), 
				Media = _RYlTZ
			}
		end
	else
		_Urwigo.MessageBox{
			Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\019\095\057\060\083\101\058\095\083\115\115\057\095\104\058")
		}
	end
end
function _xQtW:On_6lt(target)
	_Urwigo.MessageBox{
		Text = _214L("\029\060\060\106\013\095\065\104\106\115\095\013\060\088\115\085\060\057\004\095\067\103\065\065\115\057\095\069\095\086\026\069\069\013\099\103\115\107\115\065\086\095\069\083\057\095\057\072\060\107\115\095\058\099\115\104\072\095\033\069\072\095\069\033\072\060\013\013\095\058\099\115\095\033\069\088\067\052\072\060\103\083\057\013\074\037\032\034\045\048\103\057\052\104\083\052\095\085\004\095\058\099\115\095\093\069\004\095\058\099\115\004\095\067\069\072\106\115\057\095\058\099\115\095\033\069\072\095\069\083\057\095\058\099\115\095\122\069\033\058\095\058\099\069\058\095\058\099\115\095\106\115\004\013\095\069\072\115\095\013\058\104\065\065\095\104\083\095\058\099\115\095\104\052\083\104\058\104\060\083\095\058\099\115\004\095\088\103\013\095\099\069\107\115\095\085\115\115\083\095\057\072\103\106\046\095\060\072\095\060\103\058\095\060\122\095\058\099\115\104\072\095\088\104\083\057\074"), 
		Buttons = {
			_214L("\028\106")
		}, 
		Callback = function(action)
			if action ~= nil then
				_xQtW.Commands._aiWP.Enabled = true
			end
		end
	}
end
function _E_G4:On_TCx(target)
	if target == _SMjym then
		if _SMjym:Contains(_LrP) then
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\019\095\093\104\065\065\095\013\058\069\072\058\095\058\060\095\088\069\106\115\095\058\099\115\095\067\060\058\104\060\083\046\095\058\069\065\106\095\058\060\095\088\115\095\104\083\095\069\095\122\115\093\095\013\115\033\060\083\057\013\095\058\060\095\122\104\083\057\095\060\103\058\095\104\122\095\104\058\095\104\013\095\057\060\083\115\074"), 
				Media = _QX7Z
			}
		else
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\058\101\013\095\060\083\115\095\060\122\095\058\099\115\095\104\083\052\072\115\057\104\115\083\058\013\095\060\122\095\058\099\115\095\088\069\052\104\033\095\067\060\058\104\060\083\074\037\032\034\045\037\032\034\045\011\099\115\095\060\058\099\115\072\095\104\013\095\093\069\058\115\072\074"), 
				Media = _QX7Z
			}
		end
		_E_G4:MoveTo(_SMjym)
		_1uM.Complete = true
		_E_G4.Commands._TCx.Enabled = false
	else
		_Urwigo.MessageBox{
			Text = _214L("\019\101\088\095\013\060\072\072\004\046\095\019\095\057\060\083\101\058\095\106\083\060\093\095\093\099\069\058\095\004\060\103\095\093\069\083\058\095\088\115\095\058\060\095\057\060\095\093\104\058\099\095\058\099\069\058\074\074\074"), 
			Media = _Tzpzp
		}
	end
end
function _57Qb:On_pD6R(target)
	super_power = true
	if Wherigo.NoCaseEquals(Time, _214L("\072\060\088\069\083")) then
		BEPB.Active = true
		BEPB.Visible = true
	end
end
function Water:On_UJH(target)
	if Player:Contains(_LrP) then
		_Urwigo.OldDialog{
			{
				Text = _214L("\076\060\103\095\069\065\072\115\069\057\004\095\122\104\065\065\115\057\095\004\060\103\072\095\085\069\052\095\103\067\095\093\104\058\099\095\093\069\058\115\072\074\095\019\058\095\093\104\065\065\095\083\060\058\095\099\060\065\057\095\069\083\004\095\115\097\058\072\069")
			}
		}
	elseif Player:Contains(_mmnv) then
		_Urwigo.MessageBox{
			Text = _214L("\076\060\103\095\122\104\065\065\095\004\060\103\072\095\093\069\058\115\072\095\085\069\052\095\093\104\058\099\095\093\069\058\115\072\074")
		}
		_mmnv.Visible = false
		_mmnv.Locked = true
		_LrP:MoveTo(Player)
		_LrP.Visible = true
		_LrP.Locked = false
		_LrP.Commands._TdXI7.Enabled = true
	else
		_Urwigo.OldDialog{
			{
				Text = _214L("\055\104\083\033\115\095\004\060\103\095\099\069\107\115\095\083\060\058\099\104\083\052\095\058\060\095\067\103\058\095\058\099\115\095\093\069\058\115\072\095\104\083\046\095\004\060\103\095\057\115\033\104\057\115\095\058\060\095\058\069\106\115\095\069\095\013\104\067\095\060\122\095\104\058\095\104\083\013\058\115\069\057\074")
			}
		}
	end
end
function _mmnv:On_Ko3n(target)
	_mmnv:MoveTo(Player)
	_mmnv.Description = _214L("\113\095\083\104\033\115\095\065\115\069\058\099\115\072\095\093\069\058\115\072\085\069\052\074\095\029\060\060\106\013\095\065\104\106\115\095\058\099\115\095\067\072\115\107\104\060\103\013\095\060\093\083\115\072\095\057\072\069\083\106\095\069\065\065\095\104\058\013\095\033\060\083\058\115\083\058\013\074")
	_mmnv.Commands._Ko3n.Enabled = false
	_mmnv.Visible = true
	_uVERC:RequestSync()
	Wherigo.ShowScreen(Wherigo.DETAILSCREEN, _mmnv)
end
function _LrP:On_TdXI7(target)
	if target == _SMjym then
		_LrP:MoveTo(_SMjym)
		_i7eO.Complete = true
		_LrP.Commands._TdXI7.Enabled = false
		if _SMjym:Contains(_E_G4) then
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\083\106\095\004\060\103\046\095\019\095\093\104\065\065\095\013\058\069\072\058\095\058\060\095\088\069\106\115\095\058\099\115\095\067\060\058\104\060\083\046\095\058\069\065\106\095\058\060\095\088\115\095\104\083\095\069\095\122\115\093\095\013\115\033\060\083\057\013\095\058\060\095\122\104\083\057\095\060\103\058\095\104\122\095\104\058\095\104\013\095\057\060\083\115\074"), 
				Media = _QX7Z
			}
		else
			_Urwigo.MessageBox{
				Text = _214L("\011\099\069\058\101\013\095\060\083\115\095\060\122\095\058\099\115\095\104\083\052\072\115\057\104\115\083\058\013\095\060\122\095\058\099\115\095\088\069\052\104\033\095\067\060\058\104\060\083\074\037\032\034\045\037\032\034\045\011\099\115\095\060\058\099\115\072\095\104\013\095\088\104\013\058\065\115\058\060\115\095\085\072\069\083\033\099\115\013\074\095\011\099\115\072\115\095\104\013\095\069\095\083\104\033\115\095\058\072\115\115\095\069\058\095\058\099\115\095\122\069\072\088\074"), 
				Media = _QX7Z
			}
		end
	else
		_Urwigo.MessageBox{
			Text = _214L("\019\101\088\095\013\060\072\072\004\046\095\019\095\057\060\083\101\058\095\106\083\060\093\095\093\099\069\058\095\004\060\103\095\093\069\083\058\095\088\115\095\058\060\095\057\060\095\093\104\058\099\095\058\099\069\058\074\074\074"), 
			Media = _Tzpzp
		}
	end
end
function _5jW:On_rx3L(target)
	if _E_G4.Locked == true then
		_Urwigo.OldDialog{
			{
				Text = _214L("\076\060\103\095\072\115\069\033\099\095\122\060\072\095\069\095\083\104\033\115\095\085\072\069\083\033\099\046\095\013\083\069\067\095\104\058\095\060\122\095\069\083\057\095\067\065\069\033\115\095\104\058\095\104\083\058\060\095\004\060\103\072\095\085\069\033\106\067\069\033\106\074\095")
			}
		}
		_E_G4.Locked = false
		_E_G4.Commands._TCx.Enabled = true
		_E_G4:MoveTo(Player)
		_E_G4.Visible = true
	else
		_Urwigo.OldDialog{
			{
				Text = _214L("\029\115\069\107\115\095\058\099\115\095\067\060\060\072\095\058\072\115\115\095\069\065\060\083\115\030\095\076\060\103\101\107\115\095\069\065\072\115\069\057\004\095\058\069\106\115\083\095\013\060\088\115\095\085\072\069\083\033\099\115\013\074")
			}
		}
	end
end

-- Urwigo functions --
function _kzZ()
	location_visibility = {
	   { name="AncientFarm" ,       present=true,  roman=false,          tardis=false, timeless=true},
	   { name="Area42" ,            present=true,  roman=false,          tardis=false, timeless=true},
	   { name="Bar" ,               present=true,  roman=false,          tardis=false, timeless=true},
	   { name="FoodHacking" ,       present=true,  roman=false,          tardis=false, timeless=true},
	   { name="Farm" ,              present=false, roman=true,           tardis=false, timeless=true},
	   { name="Forest" ,            present=false, roman=true,           tardis=false, timeless=true},
	   { name="BEPB" ,              present=false, roman=super_power,   tardis=false, timeless=true},
	   { name="IPU" ,              present=super_power, roman=false,   tardis=false, timeless=true},
	   { name="Clearing" ,          present=false, roman=true,           tardis=false, timeless=true},
	   { name="TardisExit" ,        present=false, roman=false,          tardis=false, timeless=true},
	   { name="TardisLivingRoom" ,  present=false, roman=false,          tardis=true, timeless=true},
	   { name="DoctorWhosDesk" , present=false, roman=false,          tardis=true, timeless=true},
	   { name="RainbowIsland" ,     present=true,  roman=false,          tardis=false, timeless=true},
	   { name="RandomVillage" ,     present=true,  roman=false,          tardis=false, timeless=true},
	   { name="Well" ,              present=true,  roman=true,           tardis=false, timeless=true},
	   { name="Water" ,              present=false,  roman=true,           tardis=false, timeless=true}
	}
	
	
	for index,location in pairs(location_visibility) do
	 _G[location["name"]].Active = location[_G["Time"]]
	 -- _G[location["name"]].Display = location[_G["Time"]]
	end
	
	-- tardisexit and BEPD have special flag driven behaviour , since they are only visible when:
	--     BEPD: the power potion has been drunk by the player
	--     tardisexit: only visible when Dr. Who allowed it
	
end

-- Begin user functions --
-- End user functions --
return _uVERC
