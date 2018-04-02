--[[
	local color = Color3.new(0,0,0) --color
	local timer = .8 --how fast it goes
	local lightness = .85 --lightness	
	local siz = button2.AbsoluteSize.X > button2.AbsoluteSize.Y and button2.AbsoluteSize.X or button2.AbsoluteSize.Y	
	local circle = Instance.new("ImageLabel",button2)
	circle.AnchorPoint = Vector2.new(.5,.5)
	circle.Transparency = 1
	circle.Name = "Circle"
	circle.Position = UDim2.new(0, mx-button2.AbsolutePosition.X, -.5, my-button2.AbsolutePosition.Y)
	circle.Image = 'rbxassetid://1533003925' --800mx-button2.AbsolutePosition.X800 circle
	circle.ImageColor3 = color
	circle.ImageTransparency = lightness
	circle:TweenSize(UDim2.new(0,siz,0, siz), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, timer, true)
	local siz = button2.AbsoluteSize.X > button2.AbsoluteSize.Y and button2.AbsoluteSize.X or button2.AbsoluteSize.Y	
	game:GetService('TweenService'):Create(circle,TweenInfo.new(timer, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0),{ImageTransparency = 1}):Play()	
	game:GetService("Debris"):AddItem(circle,timer + .01)
	game:GetService('TweenService'):Create(button2,TweenInfo.new(timer, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0),{BackgroundColor3 = Color3.new(1,1,1)}):Play()
	circle:TweenSize(UDim2.new(0,1.5 * siz,0, 1.5 * siz), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, timer, true)
]]
Citrus.Effects.new("Ripple",function(who,...)
	local color, timer, typ, siz, lightness = Color3.new(0,0,0), .8, Citrus.Misc.dynamicType(who), who.Parent:IsA'GuiObject' and (who.Parent.AbsoluteSize.X > who.Parent.AbsoluteSize.Y and who.Parent.AbsoluteSize.X or who.Parent.AbsoluteSize.Y)
	local args = {...}
	for i,v in next, args do
		typ = type(v) == 'string' and v or typ
		color = type(v) == 'Color3' and v or color
		timer = lightness and type(v) == 'number' and v or timer
		lightness = not lightness and type(v) == 'number' and v or lightness
	end
	if not lightness then lightness = .85 end
	if not siz then siz = who.AbsoluteSize.X * 5 end
	Citrus.Properties.setProperties(who,{[typ..'Color3'] = color, [typ..'Transparency'] = lightness})
	Citrus.Misc.destroyIn(who,timer + .01)
	Citrus.Positioning.tweenObject(who,'siz',UDim2.new(0,siz,0,siz),timer,'Sine','Out')
	Citrus.Misc.tweenService(who,'ImageTransparency',1,timer,'Sine','Out')
end)

Citrus.Properties.new("Ripple",function(button,...)
	local args = {...}
	button.AutoButtonColor = false
	button.ClipsDescendants = true
	button.MouseButton1Click:connect(function(mx,my)
		local circle
		local props = {Parent = button,AnchorPoint = Vector2.new(.5,.5), Transparency = 1, Name = 'Circle', Position = UDim2.new(0, mx-button.AbsolutePosition.X, -.5, my-button.AbsolutePosition.Y)}
		if Citrus.Instance.isAClass("Circle",true) then
			circle = Citrus.Instance.newPure("Circle",props)
		else
			circle = Citrus.Instance.newInstance("ImageLabel",Citrus.Table.merge(props,{Image = 'rbxassetid://1533003925'}))
		end
		--Citrus.Effects.affect(circle,'Ripple',unpack(args))
		local who = circle
		local color, timer, typ, siz, lightness = Color3.new(0,0,0), .8, Citrus.Misc.dynamicType(who), who.Parent:IsA'GuiObject' and (who.Parent.AbsoluteSize.X > who.Parent.AbsoluteSize.Y and who.Parent.AbsoluteSize.X or who.Parent.AbsoluteSize.Y)
		for i,v in next, args do
			typ = type(v) == 'string' and v or typ
			color = type(v) == 'Color3' and v or color
			timer = lightness and type(v) == 'number' and v or timer
			lightness = not lightness and type(v) == 'number' and v or lightness
		end
		if not lightness then lightness = .85 end
		if not siz then siz = who.AbsoluteSize.X * 5 end
		Citrus.Properties.setProperties(who,{[typ..'Color3'] = color, [typ..'Transparency'] = lightness})
		Citrus.Misc.destroyIn(who,timer + .01)
		Citrus.Positioning.tweenObject(who,'siz',UDim2.new(0,siz,0,siz),timer,'Sine','Out')
		Citrus.Misc.tweenService(who,'ImageTransparency',1,timer,'Sine','Out')
	end)
end, 'GuiButton')