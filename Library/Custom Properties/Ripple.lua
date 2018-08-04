Spice.Properties.Custom.new("Ripple",function(button,...)
	local args = {...}
	button.AutoButtonColor = false
	button.ClipsDescendants = true
	button.MouseButton1Down:connect(function(mx,my)
		local circle
		local props = {Parent = button,AnchorPoint = Vector2.new(.5,.5), Transparency = 1, Name = 'Circle', Position = UDim2.new(0, mx-button.AbsolutePosition.X, -.5, my-button.AbsolutePosition.Y)}
		if Spice.Objects.Classes.isAClass("Circle") then
			circle = Spice.Objects.new("Circle",props)
		else
			circle = Spice.Objects.newInstance("ImageLabel",Spice.Table.merge(props,{Image = 'rbxassetid://1533003925'}))
		end
		local who = circle
		local color, timer, typ, siz, lightness = Color3.new(0,0,0), .8, Spice.Misc.dynamicProperty(who), who.Parent:IsA'GuiObject' and (who.Parent.AbsoluteSize.X > who.Parent.AbsoluteSize.Y and who.Parent.AbsoluteSize.X or who.Parent.AbsoluteSize.Y)
		local mid = false
		for i,v in next, args do
			typ = type(v) == 'string' and v or typ
			color = typeof(v) == 'Color3' and v or color
			timer = lightness and type(v) == 'number' and v or timer
			lightness = not lightness and type(v) == 'number' and v or lightness
			mid = type(v) == 'boolean' and v or mid
		end
		if not lightness then lightness = .85 end
		Spice.Properties.setProperties(who,{[typ..'Color3'] = color, [typ..'Transparency'] = lightness})
		Spice.Misc.destroyIn(who,timer + .01)
		siz = siz*1.5
		if not mid then
			Spice.Motion.tweenServiceTween(who,'siz',UDim2.new(0,siz,0,siz),timer,false,'Sine','Out')
		else
			Spice.Motion.tweenServiceTween(who,'both',UDim2.new(.5, 0, .5, 0),UDim2.new(0,siz,0,siz),timer,false,'Quad','Out')
		end
		Spice.Motion.tweenServiceTween(who,'ImageTransparency',1,timer,false,'Sine','Out')
	end)
end, 'GuiButton')

--For Ripple Effect
Spice.Properties.Custom.new("Ripple",function(button,...)
	local args = {...}
	button.AutoButtonColor = false
	button.ClipsDescendants = true
	button.MouseButton1Click:connect(function(mx,my)
		local circle
		local props = {Parent = button,AnchorPoint = Vector2.new(.5,.5), Transparency = 1, Name = 'Circle', Position = UDim2.new(0, mx-button.AbsolutePosition.X, -.5, my-button.AbsolutePosition.Y)}
		if Spice.Objects.Classes.isAClass("Circle") then
			circle = Spice.Objects.new("Circle",props)
		else
			circle = Spice.Objects.newInstance("ImageLabel",Spice.Table.merge(props,{Image = 'rbxassetid://1533003925'}))
		end
		Spice.Effects.affect(circle,"Ripple",unpack(args))
	end)
end, 'GuiButton')