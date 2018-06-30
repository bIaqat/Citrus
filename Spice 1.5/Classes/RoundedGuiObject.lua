Spice.Instance.newClass("RoundedGuiObject",function(radius) --radius is udim2
	local roundFolder = Spice.Instance.newInstance('Folder',{Name = 'Round'})
	local radiusFolder = Spice.Instance.newInstance('Folder',roundFolder,{Name = 'RadiusValues'})
	local getRadius = function(...)
		local args = type(({...})[1]) == 'table' and ({...})[1] or {...}
		if #args >= 4 then
			return {args[1],args[2],args[3],args[4]}
		elseif #args >= 2 then
			return {args[1],args[2],args[2],args[3] or args[1]}
		elseif #args == 1 then
			return {args[1],args[1],args[1],args[1]}
		else
			return {0,0,0,0}
		end
	end
	local radii = getRadius(radius)
	local lRT = {{Vector2.new(0,0),Vector2.new(1,0),Vector2.new(0,1),Vector2.new(1,1)}, {UDim2.new(0,0,0,0),UDim2.new(1,0,0,0),UDim2.new(0,0,1,0),UDim2.new(1,0,1,0)}, {Vector2.new(0,0),Vector2.new(250,0),Vector2.new(0,250),Vector2.new(250,250)}}
	Spice.Instance.newInstance('Frame',roundFolder,{Name = 'Center',BorderSizePixel = 0;BackgroundColor3 = Color3.new(.2,.2,.2)})
	for i = 1,4 do
		local roundSize = radii[i]
		local c = Spice.Instance.newInstance('ImageLabel',roundFolder,{
			ImageColor3 = Color3.new(.2,.2,.2);
			Name = 'Corner_'..i;
			Image = 'rbxassetid://1487012691';
			BackgroundTransparency = 1;
			Size = UDim2.new(0,roundSize,0,roundSize);
			AnchorPoint = lRT[1][i];
			Position = lRT[2][i];
			ImageRectSize = Vector2.new(250,250);
			ImageRectOffset = lRT[3][i];
		})
		Spice.Instance.newInstance('IntValue', radiusFolder, {Name = c.Name, Value = roundSize}).Changed:connect(function(a)
			c.Size = UDim2.new(0,a,0,a)
		end)
		c:GetPropertyChangedSignal('Size'):connect(function()
			local id = i
			local c1,c2,c3,c4 = roundFolder.Corner_1,roundFolder.Corner_2,roundFolder.Corner_3,roundFolder.Corner_4
			local cs1,cs2,cs3,cs4 = c1.Size.X.Offset, c2.Size.X.Offset, c3.Size.X.Offset, c4.Size.X.Offset
			if id == 1 or id == 2 then
				roundFolder.Top.Position = UDim2.new(0,cs1,0,0)
				roundFolder.Top.Size = UDim2.new(1, -(cs1+cs2), 0, (cs1 >= cs2 and cs1 or cs2))
			end
			if id == 1 or id == 3 then
				roundFolder.Left.Position = UDim2.new(0,0,0,cs1)
				roundFolder.Left.Size = UDim2.new(0,(cs1 >= cs3 and cs1 or cs3), 1, -(cs1+cs3))
			end			
			if id == 2 or id == 4 then
				roundFolder.Right.Position = UDim2.new(1,0,0,cs2)
				roundFolder.Right.Size = UDim2.new(0,(cs2 >= cs4 and cs2 or cs4), 1, -(cs4+cs2))
			end		
			if id == 3 or id == 4 then
				roundFolder.Bottom.Position = UDim2.new(0,cs3,1,0)
				roundFolder.Bottom.Size = UDim2.new(1, -(cs3+cs4), 0, (cs3 >= cs4 and cs3 or cs4))
			end	
			roundFolder.Center.Position = UDim2.new(0, roundFolder.Left.Size.X.Offset, 0, roundFolder.Top.Size.Y.Offset)
			roundFolder.Center.Size = UDim2.new(1, - (roundFolder.Right.Size.X.Offset + roundFolder.Left.Size.X.Offset) , 1, - (roundFolder.Bottom.Size.Y.Offset + roundFolder.Top.Size.Y.Offset) )
		end)
	end
	lRT = {{Vector2.new(0,0), Vector2.new(0,0), Vector2.new(0,1), Vector2.new(1,0)},{UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), UDim2.new(0,0,1,0), UDim2.new(1,0,0,0)}, {'Top','Left','Bottom','Right'}}
	for i = 1,4 do
		local roundSize = radii[i]
		Spice.Instance.newInstance("Frame",roundFolder,{
			Size = UDim2.new(0,0,0,0);
			Position = lRT[2][i];
			BorderSizePixel = 0;
			Name = lRT[3][i];
			BackgroundColor3 = Color3.new(.2,.2,.2);
			AnchorPoint = lRT[1][i];
		})
	end
	local connected
	local function spacesaver(prop,to)
		roundFolder.Top[prop] = roundFolder.Parent[prop]
		roundFolder.Bottom[prop] = roundFolder.Parent[prop]
		roundFolder.Left[prop] = roundFolder.Parent[prop]
		roundFolder.Right[prop] = roundFolder.Parent[prop]
		roundFolder.Center[prop] = roundFolder.Parent[prop]
		roundFolder.Corner_1[to or prop] = roundFolder.Parent[prop]
		roundFolder.Corner_2[to or prop] = roundFolder.Parent[prop]
		roundFolder.Corner_3[to or prop] = roundFolder.Parent[prop]
		roundFolder.Corner_4[to or prop] = roundFolder.Parent[prop]
	end
	local connect = function(prop,to)
		if connected then connected:Disconnect() end
		pcall(function()		
			spacesaver(prop,to)
			connected = roundFolder.Parent:GetPropertyChangedSignal(prop):connect(function()
				spacesaver(prop,to)
			end)
		end)
	end
	roundFolder.AncestryChanged:connect(function()
		pcall(function() roundFolder.Parent.BackgroundTransparency = 1 connect('BackgroundColor3','ImageColor3') end)
	end)
	connect('BackgroundColor3','ImageColor3')
	return roundFolder
end)