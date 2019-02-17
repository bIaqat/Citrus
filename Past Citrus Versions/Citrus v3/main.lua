local version = 1.5
local lush = require(script.CitrusV3).req()
local beta = getmetatable(lush)
--															  					 вy:v4rx Rouge
local gm = getmetatable
local sm = setmetatable
--Basic functions
local create = beta.Create -- Citrus version of Instance.new | create(Class,Parent,Properties) or create(Class,Parent,args...,Properties)
local set = lush.Instances.setProperties -- edit the properties of a Class | set(who,Properties)
local rotate = lush.Position.Tweening.Rotate -- self explanitory | rotate(who,ToWhat,Speed)
local tween = lush.Position.Tweening.tweenGuiObject -- Citrus version of Tween gui functions | tween(who,"pos" "size" or "both",UDims...,Speed) 
local pop = beta.ExternalRipple -- does the ripple effect outside of a GuiObject | pop(who,Size (integer),Speed,Color)
local ud = lush.Position.UDim.new --[[ Citrus version of UDim2 functions | ud(XScale,XOffset,YScale,YOffset)
																	| ud(a,"s")				-- [same as] UDim2.new(a,0,a,0)
																	| ud(a,"o") 				-- [same as] UDim2.new(0,a,0,a)
																	| ud(a,b,1) or ud(a,b,"s") 	-- [same as] UDim2.new(a,0,b,0)
																	| ud(a,b,2) or ud(a,b,"o") 	-- [same as] UDim2.new(0,a,0,#2)
																	| ud(a,b,3) 				-- [same as] UDim2.new(a,b,a,#2)
																	| ud(a,b,4) 				-- [same as] UDim2.new(a,0,0,#2)
																	| ud(a,b,5) 				-- [same as] UDim2.new(0,a,b,0)
																	| ud(a,b,c,d)				 -- [same as] UDim2.new(a,b,c,d)																
--]]
local Color = lush.Color 
	local rgb = Color.fromRGB --same as Color3.fromRGB
	local hsv = Color.fromHSV --Citrus version of Color3.fromHSV | hsv(1-360,1-100,1-100)
	local hex = Color.fromHex --gets a color from a hexadecimal | hex'hexadecimal' [EXAMPLE: hex'#FF0000' or hex'FF0000' or hex'#F00' or hex'F00']
local round = lush.Miscellaneous.round --rounds a number to the nearest integer | round(1.6) >> 2

--Semi advanced functions  
local lerp = lush.Position.Tweening.tween -- Citrus version of TweenService functions | lerp(who,Property,ToWhat,Speed)
local fromPos = lush.Position.UDim.pos -- gets a UDim2 from a string position | fromPos(stringPositions...) [EXAMPLE: fromPos("Center") fromPos("Top","Left") fromPos("Middle","Right") fromPos("Top","Middle")]
local Theme = {
	New = lush.Synchronous.Theming.insertThemes; --creates new Themes | Theming.New({ThemeName,ColorSet}) [EXAMPLE: Theming.New({"Primary",rgb(255,0,0)},{"Secondary",{rgb(0,0,0),rgb(255,255,255)})]
	Set = lush.Synchronous.Theming.setTheme; --sets an existing Theming to a new ColorSet | Theming.Set(ThemeName,Color,ColorSetNumber) [Example: Theming.Set("Primary",rgb(0,255,0)) Theming.Set("Secondary",hsv(0,0,12),2) [the 2 would set the 2nd color in the Secondary ColorSet to 2]]
	Get = lush.Synchronous.Theming.getTheme; --gets an existing Theme's ColorSet | Theming.Get(ThemeName,ColorSetNumber) [Exmaple: Theming.Get("Primary",1) [the 1 would return the 1st color in the ColorSet instead of the ColorSet (table)] Theming.Get("Secondary")
	Sync = function() lush.Synchronous.Theming:Sync() end; --Syncs all Themes (useless unless something goes wrong) } Theming.Sync()
	toTheme = lush.Instances.toTheme; --Sets an Object to a Theme | Theming.toTheme(who,Property,ThemeName,ColorSetNumber) [Exmaple: Theming.toTheme(Frame,"BackgroundColor3","Primary",1) or Theming.toTheme(Frame,"bc","Primary") [the default ColorSetNumber is 1] [Properties have shortcuts]
}
local EditTable = beta.EditTable --[[ a table of functions for editing tables 
									Includes:
										tableReverse | Reverses a table | tab = {1,2,3} tableReverse(tab) >> {3,2,1}
										tableClone | Clones a table
										tableFind | Finds something specific in a table | tab2 = {"apples","oranges","eat"} tableFind(tab,"oranges") or tableFind(tab,2) >> "oranges"
										tableSearch | Searches through a table for something similar to a string | tableSearch(tab,"ora") >> "oranges"
										tableMerge | Merges 2 tables together | tableMerge(tab,tab2) >> {3,2,1,"apples",'oranges',"eat"}
--]]

--advancedish?
local newClass = lush.Instances.newClass --creates a new Class that can be used with the create function | newClass(ClassName,function)
local newKeyframes = Color.newKeyframes --Citrus version of Emitter color keyframes for GuiObjects | newKeyframes(colors...) !!! for more info contant me if u need it
local EditColor = { --table of functions to help organize a color pallete
	New = function(...) return Color.Colors:insertNewColor(...) end; --creates a new Color with or without a ColorSet | New(ColorName) new(ColorName,ColorSet)
	Add = function(...) return Color.Colors:insertNewColorSet(...) end; --adds a ColorSet to na existing color | Add(ColorSetName,ColorName,ColorSet)
	Get = function(...) return Color.Colors:getColorSet(...) end; --gets a ColorSet from an existing Color | Get(ColorName,ColorSetName...)
}
local Sync = { --you know how much i love sync functions
	New = function(...) return lush.Synchronous:insertNewChannel(...) end; --creates a Sync Channel | New(ChannelName,ChannelValue,{Object,Properties...}...) [Example: primary = Sync.New("PrimaryColor",rgb(255,0,0)) primary:Insert(Frame,"BackgroundColor3","BorderColor3") or Sync.New("PrimaryColor",rgb(255,0,0),{Frame,"BackgroundColor3","BorderColor3"})
	newAnon = function(...)return  lush.Synchronous:insertAnonChannel(...) end; --creates an anonymous Sync channel so the channel name can not repeat | newAnon(ChannelValue,{Object,Properties...}...)
	Get = function(...) return lush.Synchronous:findChannel(...) end; --gets an existing Channel from the Channel name | Get(ChannelName) [Example: Sync.New("PrimaryColor",rgb(255,0,0)) pimary = Sync.Get("Primary")
	Set = lush.Synchronous.editChannelValue; --sets the value of an existing Channel to a new value | Set(ChannelName,newChannelValue)
	Reset = function(...) return lush.Synchronous:resetChannel(...) end; --Resets every part of a  channel to its initial value (first values and objects you had in it) | Reset(ChannelName)
	Delete = function(...)return  lush.Synchronous:deleteChannel(...) end; --Deletes the channel | Delete(ChannelName)
}
local Icon = { --Iconography is fundamental so why not organize it !!! for more info contant me if u need it
	Icons = lush.Iconography.Icons;
	New = lush.Iconography.insertIcons; --inserts a set of icons from a grid of icons into the Icons table | New(IconNamesSet,ImageId,GridX,GridY,ImageSize)
	Get = lush.Iconography.getIconInfo; --gets an icon's info {OriginalImage, ImageRectOffset, ImageRectSize, otherProperty} | Get(icon) >> {icon.Image,icon.ImageRectOffset,icon.ImageRectSize}
	Equals = function(...) return lush.Iconography:isIcon(...) end; --checks if an icon is the same icon as another | Equals(Icon,Icon2)
}
local Misc = lush.Miscellaneous --Includes things like Dropbox and CatalogApi
 
--kinda hard >:O but not relly
local newProperty = function(...) lush.Instances.Functions:newCustomProperty(...) end --creates a new Property that can be used with the create and set functions | newProperty(Name,ClassesAllowed,function(who) {first argument is always who is effected},AbleToHaveAShortcut (boolean)) [Example: newProperty("toColor","TextButton",function(who,color) who.BackgoundColor3 = color end,true) set(TextButton,{toc = rgb(255,0,0)}) >> TextButton.BackgroundColor3 = Red
local createObject = lush.Instances.createObject --you've heard me rant on create2 :) -- the supiror edit to Instance.new that is made for Object Oriented Programming | create2(Class,Parent,ObjectProperties,Properties) [Example: Frame = createObject("Frame",ScreenGui,{Apples = 'cool'}) print(Frame.Apples) >> "cool"
	local create2 = createObject
local betaSync = { -- new form of SyncChannels (doesnt have anon channels however) with the abilities to have more than one type of value
	New = beta.Sync.insertNewChannel; 
	Get = beta.Sync.getChannel;
	getType = beta.Sync.getChannelType; --gets the ChannelValueType in a Channel | getType(ChannelName or ChannelId)
	Edit = beta.Sync.channelEditValue; -- same as Sync.Set
	Sync = beta.Sync.SyncAll; --syncs all channels | Sync()
}
local betaIcon = { --alternate to Icon still in testing better at organizing and can read different types of organization !!! for more info contant me if u need it
	Icons = beta.Icon.Icons;
	New = beta.Icon.insertIcons;  --inserts a set of icons from a grid of icons into the Icons table | New(IconNamesSet,ImageId,GridX,GridY,ImageSize)
}
local newEvent = beta.newEvent

local v2 = function(a,b)
	if not b then
		return Vector2.new(a,a)
	else
		return Vector2.new(a,b)
	end
end

