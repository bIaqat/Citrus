---------------------------------------------------------------------------------------------------------
--[[		Audio		
	The Audio table is used for sound storage and easy sound usage
]]

--To Create Audio you would use the Audio.new function
Spice.Audio.new("FairyDust", 563008363, {PlaybackSpeed = 2})

--Lets say we want this magical sound to play when you reapwn to do so you would use the Audio.connect function to connect the Sound to the Player's "CharacterAdded" event
Spice.Audio.connect('FairyDust',game.Players.LocalPlayer,'CharacterAdded',workspace)

--To change the Sound's Properties after creation you would need to get the sound using the Audio.getSound function
do
	local sound = Spice.Audio.getSound('FairyDust')
	sound.PlaybackSpeed = 1 
end

--to simply play the sound with out events you would use the Audio.play function
-- Since the sound is so long, you could use the the last to arguments to start and stop the sound at a certain point
Spice.Audio.play('FairyDust',workspace,0,3.4) --0 is the starting point and 3.4 is the ending point

--you can disconnect audio from events using the Audio.disconnect function
Spice.Audio.disconnect('FairyDust',game.Players.LocalPlayer,'CharacterAdded')

---------------------------------------------------------------------------------------------------------
--[[		Color		
	The Color table is used to replace and add on to the Color3 functions
	and to store Color / Sets of Colors 
]]


local Part = Instance.new("Part",workspace)

--[[
the Color.fromHSV function differes from the Color3.fromHSV in which the arguments are not limited from 0-1
i.e |  h: 0-360, s: 0-100, v: 0-100
this is also seen in Color.toRGB and Color.toHSV in which the functions return the numbers
ranging from their full range instead of 0-1
--]]
Part.Color = Spice.Color.fromHSV(0,100,100)
print(Spice.Color.toRGB(Part.Color)) -->> 255 0 0

--the Color table also has Color.fromHex to use Hexadecimals 
Part.Color = Spice.Color.fromHex('FF0000')

--[[
Lets say we want to add on some blue to the Part's color to make purple:
to do this we would use the Color.setRGB function 
(there is a Color.setHSV as well but since we are only adding blue we will use the setRGB function)	
--]]
Part.Color = Spice.Color.setRGB(Part.Color, nil, nil, 255) --the 4th argument is for Blue, respectively the 3rd and 2nd arguments match with Green and Red

--A fun little function to invert your color is Color.toInverse
Part.Color = Spice.Color.toInverse(Part.Color)

--[[
Lets also say we want another part thats just a little bit darker than the previous one just cause
to do this we would use the Color.editHSV function
(there is a Color.editRGB as well but its easiest to edit darkness using HSV)
--]]
local Part2 = Instance.new("Part",workspace)
Part2.Color = Spice.Color.editHSV(Part.Color,'-',0,0,10)

--To store a color you use either the Color.storeColore or Color.Colors.new function
local red = Color3.new(1,0,0)
Spice.Color.Colors.new("Red",red)
--you can also store sets of colors
local reds = {} do --creates a table of 9 shades of red
	for i = .9, .1, -.1 do
		table.insert(reds,Color3.new(i,0,0))
	end
end
Spice.Color.Colors.new("Red",reds)

--Just as easily, to get the color, use the Color.fromStored function
Part.Color = Spice.Color.fromStored("Red")
--[[
because we added a set of colors, the Part's color above will be the first found color in the Red set
to find a specific color in the set you can use arguments
--]]
Part2.Color = Spice.Color.fromStored("Red",6)

--To get a set of colors you can use the Spice.Color.Colors.get function
table.foreach(Spice.Color.Colors.get("Red"),
	function(_,color)
		print(color)
	end
)
--[[
>> 1, 0, 0
>> 0.9, 0, 0
>> 0.8, 0, 0
>> 0.7, 0, 0
>> 0.6, 0, 0
>> 0.5, 0, 0
>> 0.4, 0, 0
>> 0.3, 0, 0
>> 0.2, 0, 0
>> 0.1, 0, 0
--]]

local notificationBox = Instance.new("TextBox",Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui))
notificationBox.Size = UDim2.new(1,0,0,50)
notificationBox.BackgroundTransparency = 1
notificationBox.Text = ''
notificationBox.Font = Enum.Font.SourceSansBold
notificationBox.TextSize = 30

--The Color.fromString function uses the same algorithm as the function used to get your name tag color.
for _,player in next, game.Players:GetPlayers() do
	player.Chatted:connect(function(message)
		notificationBox.TextColor3 = Spice.Color.fromString(player.Name) --the text will be the same color as your name tag
		notificationBox.Text = player.Name..' SAYS: '..message
		wait(3)
		notificationBox.Text = ''
	end)
end

--[[
The Color.new function can be used to accomplish much shown above in getting colors

Color.new(a,b,c)  		|  Color.fromRGB(a,b,c)
Color.new(a,b,c,true)	|  Color.fromHSV(a,b,c)
Color.new('#HEX')		|  Color.fromHex(HEX)
Color.new([String]a,...)|  Color.fromStored(a,...)
--]]

---------------------------------------------------------------------------------------------------------
--[[		Effects
The Effects table is a glorified function table.
--]]

--To create a new Effect just use the Effects.new function
Spice.Effects.new("BurnToDeath", function(player, fireColor)
	player.CharacterAdded:connect(function(char)
		
		--there are many ways to affect things one being the affectChildren which applies the effect or function to all the children of an object
		Spice.Effects.affectChildren(char,function(who)
			if who:isA"Part" then 
				Instance.new("Fire",who).Color = fireColor or Color3.new(1,.5,0)
			end
		end)
		
		--**All Effects.affect functions accept the Effect name or a function as the 2nd argument**
		
		wait(3)
		char:BreakJoints()		
	end)
end)

--The Effects.massAffect function is a combination of the affectChildren and affectOnChildAdded functions

Spice.Effects.massAffect(game.Players, "BurnToDeath", Color3.new(1,0,1)) 

--**Any argument after the effect name or function will be counted as that function's argument for instance the Color3 is applies to the fireColor argument in the BurnToDeath effect**

---------------------------------------------------------------------------------------------------------
--[[		Imagery		
	The Imagery table is used for sound storage and easy sound usag
]]

--To Create an Image you would use the Imagery.Images.new function
Spice.Imagery.Images.new("RedHoodie", 149369874, {BackgroundTransparency = 1})

--To get the Image you store, we use the Imagery.Images.get function
--To get clones of images stored we use the Imagery.Images.getImage function for instance: Spice.Imagery.Images.getImage('RedHoodie')
do
	local hoodie = Spice.Imagery.Images.get('RedHoodie')
	hoodie.ImageTransparency = .3
end

--You can create an image set from a sprite sheet using the Imagery.Images.newFromSheet function
Spice.Imagery.Images.newFromSheet(2246780302,6,3,48,48,nil,'Sun')
local sg = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
local ImageFrame = Instance.new("ImageLabel",sg)
ImageFrame.Size = UDim2.new(0,150,0,150)
ImageFrame.Position = UDim2.new(.5,0,.5,0)

--You can play an image set as a gif using the Imagery.playGif function
Spice.Imagery.playGif(ImageFrame, .1, false, 'Sun')
--you can stop gifs with Imagery.stopGif
Spice.Imagery.stopGif(ImageFrame)

--There are two ways to create ImageLabel/Buttons using your saved Images

--1 using the Imagery.setImage function to set the image to an already created Object
Spice.Imagery.setImage(ImageFrame, 'RedHoodie')

--2 using the Imagery.newInstance function
Spice.Imagery.newInstance("ImageLabel", sg, {Size = UDim2.new(0,150,0,150), Position = UDim2.new(.5,-155,.5,0)}, 'Sun')

---------------------------------------------------------------------------------------------------------
--[[		Misc
	The table full of random but usefull functions
--]]

--Misc.getAssetId returns the proper ID for assets such as Decals, Shirts, etc
local oldId = 2133212275
local newId = Spice.Misc.getAssetId(oldId)
print(newId) -->> 2133212269

--Misc.getTextSizes returns the Vector2 X and Y Exact Sizes of a Text based on your parameters

--Misc.getPlayer ... gets players (inclde me, others, and all as alternate arguments than names) and it allows you to directly affect the player once gotten.
Spice.Misc.getPlayer(game.Players.LocalPlayer, 'me')(function(playerEffected)
	Instance.new("ForceField",playerEffected.Character)
end)

--Misc.timer acts as a runtimer if you dont know how to make oen (its easy btw but still)
local runTimer = Spice.Misc.timer()
print('Start')
runTimer()

for i = 0, 10 do
	print(i)
	wait(.1)
end

print('EndTime:',runTimer())

--Misc.searchAPI correctly uses the Roblox Catalog Search Api

local audioSearchLink = 'https://search.roblox.com/catalog/json?CatalogContext=2&SortAggregation=5&LegendExpanded=true&Category=9'
local results = Spice.Misc.searchAPI(audioSearchLink)
local firstResult,dataTable = next(results)

local sound = Instance.new("Sound", workspace)
sound.Name = dataTable.Name
sound.SoundId = 'rbxassetid://'..dataTable.AssetId
sound:Play()


--Misc.getArgument returns arg[#] out of a list of args
local tabl = {apple = Color3.new(1,0,0), grape = Color3.new(1,0,1)}
local firstResultValue = Spice.Misc.getArgument(2,next(tabl))
print(firstResultValue) -->> 1, 0, 0

--Misc.destroyIn is the same as using the Debri service aka it destroys i object in a given amount of time
local part = Instance.new("Part",workspace)
Spice.Misc.destroyIn(part,5) --Part will be destroyed in 5 seconds

--Misc.exists is dumb if it exists it will return true so if it isnt nil its true...
print(Spice.Misc.exists(false),Spice.Misc.exists(nil))-->> true false

--Misc.dynamicProperty gets a property automatically (hard to explain youll see tho)
print(
	Spice.Misc.dynamicProperty(
		Instance.new("ImageLabel"),
		'Transparency'
	),
	Spice.Misc.dynamicProperty(
		Instance.new("Frame"),
		'Transparency'
	)
) -->> ImageTransparency BackgroundTransparency

--Misc.round rounds a number...
print(Spice.Misc.round(.735,2)) -->> 0.74

--Misc.contains checks if a list of arguments includes something
print(Spice.Misc.contains('ga','a','b',1,5,2,2,5,35,46,'e','g','ga')) -->>true

--Misc.operation executes a math operation
print(Spice.Misc.operation(25, 2, '^/'))-->> 5

---------------------------------------------------------------------------------------------------------
--[[		Motion
	Table for tweening and lerping :)
--]]
local screenGui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)

local Frame = Instance.new("TextLabel", screenGui)
Frame.Size = UDim2.new(0,200,0,200)
Frame.Position = UDim2.new(.5,0,.5,0)
Frame.AnchorPoint = Vector2.new(.5,.5)

--To tween using TweenService we use the Motion.tweenServiceTween function whos arguments are in the index
Spice.Motion.tweenServiceTween(Frame, {'Size', 'Rotation'}, {UDim2.new(0,300,0,300), 270}, 1, true, 'Bounce', 'Out', nil, true).Completed:Wait()

--To easily rotate an object we can use the Motion.rotate function
Spice.Motion.rotate(Frame, 720, 1, false, true, 'Quad', 'InOut', nil, true).Completed:Wait()

--to lerp a value we can use the Motion.lerp function (the lerp function can also use custom easing)
local red = Color3.new(1,0,0)
local blue = Color3.new(0,0,1)
local inBetweenRedAndBlue = Spice.Motion.lerp(red, blue, .5)
print(inBetweenRedAndBlue) -->> .5, 0, .5

--using the Motion.Easings table we can also create custom Easing Styles :) and using Bezier functions as well (more info on bezier: http://cubic-bezier.com/#0,0,1,1)
Spice.Motion.Easings.newStyle('LinEase', {
	In = Spice.Motion.Easings.fromBezier(.75,0,.75,1);
	Out = Spice.Motion.Easings.fromBezier(.25,0,.25,1);
	InOut = Spice.Motion.Easings.fromBezier(.25,0,.75,1);
	OutIn = Spice.Motion.Easings.fromBezier(.75,0,.25,1);
})

--along with creating custom Easing Styles we can create custom Lerps for DataTypes into the Motion.Lerps table
Spice.Motion.Lerps.string = function(old,new,alpha)
	local ol,nl = #old, #new
	local alo, aln = math.floor((1 - alpha) * ol + .5), math.floor(alpha * nl + .5)
	return new:sub(1,aln)..(alo == 0 and '' or old:sub(-(alo)))
end

--To tween using custom easings we use the Motion.customTween function
Spice.Motion.customTween(Frame, {'Size','Text'}, {UDim2.new(0,300,0,300), 'TweenedText'}, 1, true, 'LinEase', 'Out'):Wait()

---------------------------------------------------------------------------------------------------------
--[[		Objects
	big gay table to help create classes, custom objects for oop, and make making instances more efficient
--]]

--the Objects table can be used to create Instance like with Instance.new but with less effort for instance:
local Part = Spice.Objects.newInstance("Part", workspace,{
	Name = 'MyPart';
	trans = .3;
	brickc = BrickColor.new('Really red')
})

--cloning an Object is also made simpler with Objects.clone
local PartClone = Spice.Objects.clone(Part,workspace,{
	brickc = BrickColor.Blue()
})

--Just like Instace:GetChildren() the Objects.getAncestors function gets the ancestry chain for an object
for i,v in next, Spice.Objects.getAncestors(Part) do
	print(v.ClassName,v)
end
--[[
>> Workspace Workspace
>> DataModel game
--]]

--to create a custom Class we use Objects.Classes.new function
Spice.Objects.Classes.new("SparklePart",function(isNeon)
	
	--to create custom Objects we use the Objects.Custom.new function
	local self = Spice.Objects.Custom.new("Part",nil,{
		Name = "SparklePart";
		Material = isNeon and Enum.Material.Neon or Enum.Material.Plastic;
		Transparency = .1;
	},{
		ClassName = "SparklePart";
	})
	
	local sparkles = Instance.new("Sparkles",self.Instance) --You can acess the created Instance in a custom object using object.Instance and likewise you can get the CustomObject table of properties using object.Object
	sparkles.SparkleColor = Color3.new(.5,.5,.5)
	
	--custom Objects are a little advanced to use... in comparison to most other stuff in Spice
	self:NewIndex("SparkleColor",function(self,new)
		self.Instance.Sparkles.SparkleColor = new
	end)
	self:Index("SparkleColor",function(self)
		return self.Instance.Sparkles.SparkleColor
	end)
	
	return self
end)

--To use custom Classes we use the Objects.new or Objects.newDefault function
	--the Objects.newDefault creates an Instance under stored default properties [see in Properties examples]
local sparklePart = Spice.Objects.new("SparklePart",workspace,true,{SparkleColor = Color3.new(1,0,0)})
print(sparklePart.ClassName) -->> SparklePart

---------------------------------------------------------------------------------------------------------
--[[		Positioning
	useless table to making getting values from udim, vector2, udim2, faster...
--]]

--There are many ways to use the Positioning.new function:
--[[List of Possible Variants:
	Arguments				|	Results
	a						|	UDim2.new(a, 0, a, 0)
	
	a, 1 or 's'				|	UDim2.new(a, 0, a, 0)
	a, 2 or 'o'				|	UDim2.new(0, a, 0, a)
	a, 3 or 'b'				|	UDim2.new(a, a, a, a)
	a, 4 or 'so'			|	UDim2.new(a, 0, 0, a)
	a, 5 or 'os'			|	UDim2.new(0, a, a, 0)
	
	a, b, 1 or 's'			|	UDim2.new(a, 0, b, 0)
	a, b, 2 or 'o'			|	UDim2.new(0, a, 0, b)
	a, b, 3 or 'b'			|	UDim2.new(a, b, a, b)
	a, b, 4 or 'so'			|	UDim2.new(a, 0, 0, b) *
	a, b, 5 or 'os'			|	UDim2.new(0, a, b, 0)
	
	a, b, c, d				|	UDim2.new(a, b, c, d)
--]]
print(Spice.Positioning.new(1, 4, 4)) -->> {1, 0}, {0, 4} *

--The other UDim2 returning function is Positioning.fromPosition who's arguments are Strings...
print(Spice.Positioning.fromPosition('Top','Right')) -->> {1, 0}, {0, 0}

--The Positioning.fromUDim and Positioning.fromVector2 are the same as UDim.new and Vector2.new except they can accept a single argument
print(Spice.Positioning.fromVector2(.5)) -->> 0.5, 0.5

---------------------------------------------------------------------------------------------------------
--[[		Properties
	Big yotes stors RobloxApi, custom, and Default pRoPeRtIeS; is called by most functions in the Objects table
--]]
--Before using the Properties table it is highly reccomended that you sort the RobloxAPI with Properties.RobloxAPI:sort()
Spice.Properties.RobloxAPI:sort(function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end)

--You can also search through all the properties in the RobloxApi with Properties.RobloxAPI:search()
print(Spice.Properties.RobloxAPI:search('bac')) --[COULD CHANGE]>> BackgroundColor3 252 

local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local Frame = Instance.new("Frame", ScreenGui)
--set Properties of an Object with Properties.setVanillaProperties
Spice.Properties.setVanillaProperties(Frame, {
	Size = UDim2.new(0,200,0,200);
	Position = UDim2.new(.5,0,.5,0);
})

--Default Properties can be made using the Properties.Default.set (these are based off vanilla properties)
Spice.Properties.Default.set("Frame", {BorderSizePixel = 0, BackgroundColor3 = Color3.new(1,0,0)})

--You can set already made Objects to default properties using the Properties.Default.toDefaultProperties function
Spice.Properties.Default.toDefaultProperties(Frame)

--Check to see if an Object has a special propert with Properties.hasProperty
print(Spice.Properties.hasProperty(Frame, 'Transparency')) -->>true 0

--get all an Object's Properties with Properties.getProperties
for i,v in next, Spice.Properties.getProperties(Frame) do
	print(i,v)
end
--[[
>> Visible true
>> Active false
>> AbsoluteRotation 0
>> Style Enum.FrameStyle.Custom
>> AnchorPoint 0, 0
>> Selectable false
>> SizeConstraint Enum.SizeConstraint.RelativeXY
>> ZIndex 1
>> Archivable true
>> Size {0, 200}, {0, 200}
>> Draggable false
etc
--]]

--To create custom properties we use the Properties.Custom.new function...
Spice.Properties.Custom.new("BackgroundColor3", function(Object, newColor)
	spawn(function()--bad scripting shut up
		for i = 0, 1, .03 do
			Object.BackgroundColor3 = Object.BackgroundColor3:lerp(newColor,i)
			wait(.1)
		end
	end)
end)

--Set Properties of an Object that can connect to default, custom, and short cuts of properties if you so choose with Properties.setProperties
Spice.Properties.setProperties(Frame,{ap = Vector2.new(.5,.5), bac = Color3.new(0,1,1)})

---------------------------------------------------------------------------------------------------------
--[[		Table
	a Table similar to Misc but only for table managing functions :)
--]]


--Table.pack is similar to the select function but its A. for tables and B. has an end point
local tabl = {'a','b','c',1,2,3,'x','y','z',Instance.new("Part",workspace)}
print(table.concat(Spice.Table.pack(tabl,4,8),', ')) -->> 1, 2, 3, x, y

--Table.mergeTo merges table 1 into table 2...
local table_a = {'a','b','c'}
local table_b = {4,5,6}
print(table.concat(Spice.Table.mergeTo(table_b,table_a),', ')) -->> a, b, c, 4, 5, 6

--Table.clone clones a table and all its content...
local tabl_clone = Spice.Table.clone(tabl)
print(tabl[#tabl].Parent) --old part >> Workspace
print(tabl_clone[#tabl_clone].Parent) -- cloned part >> nil

--Table.length gets the real length of a table...
local tabl = {apple = 1, ban = 2, die = 3, 4, 5, 6}
print(#tabl, Spice.Table.length(tabl))-->> 3 6

--Table.find and Table.search help find content in a table
local dictionary = {
	Roblox = "A massively multiplayer online game",
	Wiki = "A Web site developed collaboratively by a community of users",
	Lua = "A lightweight multi-paradigm programming language"
}

print(Spice.Table.find(dictionary, 'Lua')) -->> A lightweight multi-paradigm programming language Lua
print(Spice.Table.search(dictionary, 'online', false, false, false, true)) -->> A massively multiplayer online game Roblox

---------------------------------------------------------------------------------------------------------
--[[		Theming
	The most remade table ever.
	oh and its used to theme stuff like colors ¯\_(ツ)_/¯
--]]

--To create a Theme use Theming.new
Spice.Theming.new("FakeRedParts", Color3.new(1,0,0))

for i = 1, 10 do
	local part = Instance.new("Part",workspace)
	local chance = math.random(1,2) == 2
	if chance then
		--to insert an Object into a theme we use the Theming.insertObject function
		Spice.Theming.insertObject('FakeRedParts', part, 'Color')
	else
		part.Color = Color3.new(1,0,0)
	end
end

--To set the theme after creation you use the Theming.setTheme function
Spice.Theming.setTheme('FakeRedParts',Color3.new(1,0,1))

--Although Themes sync automatically by default you can change it so you can sync manually (the manual sync allows tweening):
Spice.Theming.getTheme('FakeRedParts').AutoSync = false
Spice.Theming.setTheme('FakeRedParts',Color3.new(.5,0,0))
Spice.Theming.sync('FakeRedParts',true,2)