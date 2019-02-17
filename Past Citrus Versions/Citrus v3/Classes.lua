local lush = require(script.Parent)

sm = setmetatable
gm = getmetatable
Shortcuts = lush.Shortcuts
Instances = lush.Instances
Tweening = lush.Position.Tweening
UD = lush.Position.UDim
Color = lush.Color
Colours = Color.Colours
Sync = lush.Synchronous
bSync = gm(lush).Sync
Icon = lush.Iconography
bIcon = gm(lush).Icon
Misc = lush.Miscellaneous
Metas = gm(lush).Metatables
tableEdit = gm(lush).EditTable
local create = Instances.newInstance
local set = Instances.setProperties
local create2 = Instances.createObject
	createObj = create2
local tween = Tweening.tweenGuiObject
local rotate = Tweening.Rotate
local lerp = Tweening.tween
local pop = gm(lush).ExternalRipple
local toPos = UD.pos
local ud = UD.new
local v2 = Vector2.new
local hsv = Color.fromHSV
local rgb = Color.fromRGB
local hex = Color.fromHex
local newKey = Color.newKeyframes
local Theme = {}
Theme.New = Sync.Theming.insertThemes
Theme.Set = Sync.Theming.setTheme
Theme.Get = Sync.Theming.getTheme
local toTheme = Instances.toTheme
local icons = Icon.icons
local round = Misc.round
local ET = tableEdit
local create3 = gm(lush).Create
local newClass = Instances.newClass
local newEvent = gm(lush).newEvent

newClass("Circle",function(siz,typ)
	local circle
	if typ then
		circle = create("ImageButton")
	else
		circle = create("ImageLabel")
	end
	set(circle,{im = 'rbxassetid://550829430',bt = 1,siz = ud(siz,'o')})
	return circle
end)



return lush