--Cicle

Spice.Objects.new('Circle', sg, 300)
Spice.Objects.new('Circle', sg, 300,true).MouseButton1Click:connect(function()
	print'clicked'
end)


--Color Picker

Spice.Objects.new('ColorPicker',sg,'Circle',{Position = UDim2.new(.5,0,.5,0),Size = UDim2.new(0,400,0,400)}).onChanged = function(who)
	print(who)
end
Spice.Objects.new('ColorPicker',sg,'Square',{Position = UDim2.new(.5,0,.5,0),Size = UDim2.new(0,400,0,400)}).onChanged = function(who)
	print(who)
end


--Field and Bar

local main = Instance.new('Frame',sg)
main.Position = UDim2.new(.5,0,.5,0)
main.Size = UDim2.new(0,300,0,300)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(.5,.5)

Spice.Objects.new('Field',main,50,100,true,50,Color3.new(1,0,0))
local bar = Spice.Objects.new('Bar',main,20)
bar:TweenColor3(Color3.new(1,0,0),1)
wait(1)
bar:TweenWidth(2, .3)
wait(1)
bar:TweenThickness(3, .3)


--Icon

Spice.Objects.new('IconButton',sg,'search','gentle',{Size = UDim2.new(.5,0,.5,0)})


--Rounded Frame

local main = Spice.Objects.new('RoundedFrame',sg,{100,50,50,200},{Size = UDim2.new(0,250,0,400)})


--Color Sets

local main = Spice.Objects.newInstance('Frame',sg,{Size = UDim2.new(0,250,0,250), Position = UDim2.new(.5,0,.5,0), AnchorPoint = Vector2.new(.5,.5), BorderSizePixel = 0})
local colorSet = Spice.Color.Colors.get('CitrusV4')
for i,v in next, colorSet do
	main.BackgroundColor3 = v[1]
	wait(1)
end


--Custom Properties

local primary = Spice.Theming.new('Primary',Color3.new(1,0,0))
local main = Spice.Objects.new('Frame',sg,{Size = UDim2.new(0,200,0,200), Position = UDim2.new(.5,0,.5,0),BackgroundColor3 = 'Primary',Draggable = .3, Shadow = true})

local button = Instance.new('TextButton',sg)
button.Position = UDim2.new(.5,0,.5,0)
button.Size = UDim2.new(0,200,0,200)
Spice.Properties.setProperties(button,{Ripple = true})