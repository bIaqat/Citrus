Spice.Properties.Custom.new("Ripple",function(button, ...)
	local args = {...}
	button.AutoButtonColor = false
	button.ClipsDescendants = true
	button.MouseButton1Down:connect(function(mx,my)
		local m = game.Players.LocalPlayer:GetMouse()
		local mx,my = m.X,m.Y
		local transparency, color, tween, speed = .85, Color3.new(0,0,0), false
		for i,v in next, args do
			transparency = type(v) == 'number' and speed and v or transparency
			speed = type(v) == 'number' and not speed and v or speed
			color = typeof(v) == 'Color3' and v or color
			tween = type(v) == 'boolean' and v or tween
		end
		speed = speed or .8
		local endSize = button.AbsoluteSize.X > button.AbsoluteSize.Y and button.AbsoluteSize.X or button.AbsoluteSize.Y

		local circle = Instance.new("ImageLabel",button)
		circle.AnchorPoint = Vector2.new(.5,.5)
		circle.Transparency = 1
		circle.Name = "Circle"
		circle.Position = UDim2.new(0, mx-button.AbsolutePosition.X, 0, my-button.AbsolutePosition.Y)
		circle.Image = 'rbxassetid://1533003925' --800mx-button.AbsolutePosition.X800 circle
		circle.ImageColor3 = color
		circle.ImageTransparency = transparency	

		game:GetService("Debris"):AddItem(circle,speed+.01) --removes the circle when speed runs out
		if tween then
			circle:TweenSizeAndPosition(UDim2.new(0,1.5 * endSize,0, 1.5 * endSize), UDim2.new(.5,0,.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, speed, true)
		else
			circle:TweenSize(UDim2.new(0,1.5 * endSize,0, 1.5 * endSize), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, speed, true)
		end
		game:GetService('TweenService'):Create(circle,TweenInfo.new(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0),{ImageTransparency = 1}):Play()	
	end)
end, 'GuiButton')
