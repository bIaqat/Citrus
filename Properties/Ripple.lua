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


--For Ripple Effect
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
		Citrus.Effects.affect(circle,"Ripple",unpack(args))
	end)
end, 'GuiButton')