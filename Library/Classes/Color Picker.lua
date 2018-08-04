Spice.Objects.Classes.new('ColorPicker',function(typ)
	local colorMixer = Spice.Objects.Custom.new('Frame',nil,
		{
			Bar = Spice.Objects.newInstance('Frame',{pos = ud(1,3,0,0),siz = ud(.15,1,1)});
			BarCursor = Spice.Objects.newInstance('Frame',{bc3 = Color3.new(1,1,1),bsp = 2,siz = ud(1,3,0,5),pos = ud(.5,0,1),ap = v2(.5)});
			Mixer = Spice.Objects.newInstance('Frame',{siz = ud(1), bt = 1});
			MixerCursor = Spice.Objects.newInstance('Frame',{siz = ud(25,2), bt = 1,ap = v2(.5)});
			Color = Color3.new(1,1,1);
			Type = '';
			onChanged = function(self,color)
				
			end;
			setType = function(self,new)
				if new == 'Circle' then
					self.Bar.BackgroundTransparency = 0
					self.Mixer.BackgroundTransparency = 1
					self.Mixer.ImageLabel.Image = 'rbxassetid://1854219996'
					self.Bar.ImageLabel.Image = 'rbxassetid://1854239324'
					self.Bar.BackgroundColor3 = Color3.fromHSV(self.colorInHSV[1],1,1-self.BarCursor.Position.Y.Offset/self.AbsoluteSize.Y)
					self.Object.Type = 'Circle'
				else
					self.Bar.BackgroundTransparency = 1
					self.Mixer.BackgroundTransparency = 0
					self.Mixer.BackgroundColor3 = Color3.fromHSV(self.colorInHSV[1],1,1)
					self.Mixer.ImageLabel.Image = 'rbxassetid://1720647524'
					self.Bar.ImageLabel.Image = 'rbxassetid://1852953638'
					self.Object.Type = 'Square'
				end
			end;
			colorInHex = '#ffffff';
			colorInHSV = {0, 0, 100};
		},
		{bt = 1}
	)
	set(Spice.Objects.newInstance('ImageLabel',colorMixer.Mixer,{siz = ud(1), bt = 1}):Clone(),{
		Parent = colorMixer.Bar
	})
	colorMixer.Mixer.Parent = colorMixer.Instance
	colorMixer.Bar.Parent = colorMixer.Mixer
	colorMixer:setType(typ or 'Square')
	
	colorMixer:NewIndex('Type',function(self,new)
		self:setType(new)
	end)

	colorMixer.MixerCursor.Parent = colorMixer.Mixer
	colorMixer.BarCursor.Parent = colorMixer.Bar
	set(Spice.Objects.newInstance('Frame',colorMixer.MixerCursor,{bac = Color3.new(1,1,1),ap = v2(.5,0), pos = ud(.5,0,1), siz = ud(.1,1,1), bsp = 0}):Clone(),{
		ap = v2(0,.5), pos = ud(0,.5,1), siz = ud(1,.1,1), Parent = colorMixer.MixerCursor
	})
	
	local setMixerCursorPosition = function(inp)
		local x, y 
		if typeof(inp) == 'UDim2' then
			x, y = inp.X.Offset, inp.Y.Offset
		else
			x,y = inp.Position.X - colorMixer.Mixer.AbsolutePosition.X, inp.Position.Y - colorMixer.Mixer.AbsolutePosition.Y
		end
		if colorMixer.Type == 'Square' then
			if x >= 0 and x <= colorMixer.Mixer.AbsoluteSize.X and y >= 0 and y <= colorMixer.Mixer.AbsoluteSize.Y then
				colorMixer.MixerCursor.Position = UDim2.new(0,x,0,y)
				setColor(2,x/colorMixer.Mixer.AbsoluteSize.X, 1 - y/colorMixer.Mixer.AbsoluteSize.Y)
				
			end
		else
			local x,y = x-100,y-100
			local rad = math.atan2(y,x)
			local ang = math.deg(rad)
			local tan
			local rx,ry = (math.cos(rad)*100),(math.sin(rad)*100)
			if math.abs(x) <= math.abs(rx) and math.abs(y) <= math.abs(ry) then
				colorMixer.MixerCursor.Position = UDim2.new(.5,x,.5,y)
				tan  = x*x + y*y 
			else
				tan = 100*100
				colorMixer.MixerCursor.Position = UDim2.new(.5,rx,.5,ry)
			end
			local corrected = ang > 0 and 360-ang or -ang
			setColor(5, corrected/360, math.sqrt(tan)/100)
			colorMixer.Bar.BackgroundColor3 = Color3.fromHSV(corrected/360,1,1)
			colorMixer.BarCursor.BackgroundColor3 = Color.setHSV(colorMixer.BarCursor.BackgroundColor3,corrected)
			--colorMixer.MixerCursor.Position = ud(.5,,.5,)
		end
	end
	
	local is = game:GetService("UserInputService")
	colorMixer.Mixer.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local going, up 
			up = is.InputEnded:connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					up:disconnect()
					going:disconnect()
					setMixerCursorPosition(inp)
				end
			end)
			going = is.InputChanged:connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseMovement then
					setMixerCursorPosition(inp)
				end
			end)
		end
	end)
	
	local setBarCursorPosition = function(inp)
		local y 
		if typeof(inp) == 'UDim2' then
			y = inp.Y.Offset
		else
			y = inp.Position.Y - colorMixer.Bar.AbsolutePosition.Y
		end
		if y >= 0 and y <= colorMixer.Bar.AbsoluteSize.Y then
			colorMixer.BarCursor.Position = UDim2.new(.5,0,0,y)
			if colorMixer.Type == 'Square' then
				setColor(1,y/colorMixer.Bar.AbsoluteSize.Y)
				colorMixer.BarCursor.BackgroundColor3 = Color3.fromHSV(y/colorMixer.Bar.AbsoluteSize.Y,1,1)
				colorMixer.Mixer.BackgroundColor3 = Color3.fromHSV(y/colorMixer.Bar.AbsoluteSize.Y,1,1)
			else
				setColor(4, 1-y/colorMixer.Bar.AbsoluteSize.Y)
				colorMixer.BarCursor.BackgroundColor3 = Color3.fromHSV(colorMixer.colorInHSV[1]/360, 1, 1-y/colorMixer.Bar.AbsoluteSize.Y)
			end
		end
	end
	
	colorMixer.Bar.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local going, up 
			up = is.InputEnded:connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					up:disconnect()
					going:disconnect()
					setBarCursorPosition(inp)
				end
			end)
			going = is.InputChanged:connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseMovement then
					setBarCursorPosition(inp)
				end
			end)
		end
	end)	
	function setColor(basedon,a,b)
		if basedon == 1 then
			colorMixer.colorInHSV[1] = a*360
		elseif basedon == 2 then
			colorMixer.colorInHSV[2], colorMixer.colorInHSV[3] = a*100,b*100
		elseif basedon == 3 then
			local h,s,v = Color3.toHSV(a)
			colorMixer.colorInHSV[1] = h*360
			colorMixer.colorInHSV[2], colorMixer.colorInHSV[3] = s*100,v*100
			setMixerCursorPosition(UDim2.new(0,s*colorMixer.Mixer.AbsoluteSize.X,0,colorMixer.Mixer.AbsoluteSize.Y-v*colorMixer.Mixer.AbsoluteSize.Y))
			setBarCursorPosition(UDim2.new(.5,0,0,h*colorMixer.Bar.AbsoluteSize.Y))
		elseif basedon == 4 then
			colorMixer.colorInHSV[3] = a*100
		elseif basedon == 5 then
			colorMixer.colorInHSV[1], colorMixer.colorInHSV[2] = a*360,b*100
		elseif basedon == 6 then
			local h,s,v = Color3.toHSV(a)
			colorMixer.colorInHSV[3] = v*100
			colorMixer.colorInHSV[1], colorMixer.colorInHSV[2] = h*360,s*100
		end
		local col = Color.fromHSV(unpack(colorMixer.colorInHSV))
		colorMixer.Object.Color = col
		colorMixer.Object.colorInHex = Spice.Color.toHex(col)
		colorMixer:onChanged(col);
	end
	
	colorMixer:NewIndex('Color',function(self,new)
		setColor(3, new)
	end)
	
	return colorMixer
end)