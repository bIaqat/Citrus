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

---------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------