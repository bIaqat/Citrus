local lush = require(script.Parent)
f = lush.Instances.Functions
--Theming
f:newCustomProperty("DynamicColor3",'All',function(who,new,typ)
	local tipe
	if who.ClassName:find'Image' then
		tipe = 'Image'
	elseif typ then
		tipe = lush.Shortcuts[typ]:sub(1,lush.Shortcuts[typ]:find'Color3'-1)
	else
		tipe = 'Background'
	end
	if type(new) == 'string' then
		lush.Instances.toTheme(who,tipe..'Color3',new)
	else
		who[tipe..'Color3'] = new
	end
end,true)
f:newCustomProperty("DynamicTransparency",'All',function(who,new,typ)
	local tipe
	if who.ClassName:find'Image' then
		tipe = 'Image'
	elseif typ then
		tipe = lush.Shortcuts[typ]:sub(1,lush.Shortcuts[typ]:find'Transparency'-1)
	else
		tipe = 'Background'
	end
	who[tipe..'Transparency'] = new
end,true)
f:newCustomProperty('BackgroundColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'bc',typ,what)
	else
		who.BackgroundColor3 = typ
	end
end)
f:newCustomProperty('BorderColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'borderc',typ,what)
	else
		who.BorderColor3 = typ
	end
end)
f:newCustomProperty('TextColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'tc',typ,what)
	else
		who.TextColor3 = typ
	end
end)
f:newCustomProperty('ImageColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'ic',typ,what)
	else
		who.ImageColor3 = typ
	end
end)
f:newCustomProperty('Image',{'ImageLabel','ImageButton'},function(who,typ)
	if type(typ) == 'userdata' then
		local icon = lush.Iconography.getIconInfo(typ)
		lush.Instances.setProperties(who,{image = icon[1],iro = icon[2],irs = icon[3]})	
	elseif not typ:find('rbxassetid') or type(typ) == 'number' then
		who.Image = "rbxassetid://"..typ
	else
		who.Image = typ	
	end		
end)
f:newCustomProperty('Image','ScrollingFrame',function(who,image)
	image = 'rbxassetid://'..image
	lush.Instances.setProperties(who,{ti = image,bi = image,mi = image})
end)
f:newCustomProperty('Ripple',{'TextButton','ImageButton'},function(who,trans,typ)
	if trans and type(trans) == 'string' or type(trans) == 'userdata' then 
		local ty = trans 
		trans = typ 
		typ = ty 
	end
	local Button = who	
	Button.ClipsDescendants = true
	Button.AutoButtonColor = false
	
	Button.MouseButton1Click:connect(function()
		coroutine.resume(coroutine.create(function()
			if trans and trans == true then trans = .9 end
			local Circle = lush.Instances.newInstance('ImageLabel',Button,{name = 'Circle',ic = Color3.new(0,0,0),bt = 1,z = 10,ima = 'rbxassetid://550829430',it = .9})	
			if trans then Circle.ImageTransparency = trans end
			if typ then 
				lush.Instances.setProperties(Circle,{ic = typ})
			elseif lush.Color.toHSV(who.BackgroundColor3)[3] < 25 then
				 Circle.ImageColor3 = Color3.new(1,1,1)
			else
				Circle.ImageColor3 = Color3.new(0,0,0)
			end
			local m = game.Players.LocalPlayer:GetMouse()
			--rbxassetid://550829430 'rbxassetid://266543268'
			local NewX = m.X - Circle.AbsolutePosition.X
			local NewY = m.Y - Circle.AbsolutePosition.Y
			Circle.Position = UDim2.new(0,NewX,0,NewY)
			local Size = 0
			if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.X*1.5
			elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.Y*1.5
			elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																																																																														
				Size = Button.AbsoluteSize.X*1.5
			end							
			local Time = Circle.ImageTransparency/1.8
			lush.Position.Tweening.tweenGuiObject(Circle,'both',UDim2.new(.5,-Size/2,.5,-Size/2),UDim2.new(0,Size,0,Size),Time,'Out','Quad')
			repeat
				Circle.ImageTransparency = Circle.ImageTransparency + Time/(Time*10)^2
				wait(Time/10)
			until Circle.ImageTransparency >= 1
			Circle:Destroy()
		end))
	end)
end)

f:newCustomProperty('Shadow','All',function(who,typ,typ2)
	local many,siz = 1,7
	if typ then 
		if type(typ) == 'number' then many = typ
		elseif type(typ) == 'table' then many,siz = typ[1],typ[2]
		elseif typ == 'hover' then typ2 = true
		end 
	end
	local shadow = lush.Instances.newInstance('ImageLabel',nil,{n = 'Shadow',Rotation = 0.0001,Position = UDim2.new(0,0,1,0),Size = UDim2.new(1,0,0,siz),Image = 'rbxasset://textures/ui/TopBar/dropshadow@2x.png',BackgroundTransparency = 1})
	local fol = Instance.new'Folder'
	for i = 1,many,1 do
		lush.Instances.setProperties(shadow:Clone(),{parent = fol})
	end
	fol.Parent = who
	if typ2 and typ2 == true then
		for i,v in pairs(fol:GetChildren())do
			v.Size = UDim2.new(1,0,0,1)
		end	
		who.MouseEnter:connect(function()
			for i,v in pairs(fol:GetChildren())do
				lush.Position.Tweening.tweenGuiObject(v,'size',UDim2.new(1,0,0,7),.1)
			end
		end)
		who.MouseLeave:connect(function()
			for i,v in pairs(fol:GetChildren())do
				lush.Position.Tweening.tweenGuiObject(v,'size',UDim2.new(1,0,0,1),.1)
			end
		end)			
	end
end)
f:newCustomProperty('TableLayout','All',function(who,...)
	lush.Instances.newInstance('UITableLayout',who,...)
end)
f:newCustomProperty('TextConstraint','All',function(who,...)
	lush.Instances.newInstance('UITextSizeConstraint',who,...)
end)
f:newCustomProperty('SizeConstraint','All',function(who,...)
	lush.Instances.newInstance('UISizeConstraint',who,...)
end)
f:newCustomProperty('AspectRatio','All',function(who,...)
	lush.Instances.newInstance('UIAspectRatioConstraint',who,...)
end)
f:newCustomProperty('Draggable','All',function(who)
	who.Active = true
	who.Draggable = true
end)
f:newCustomProperty('List','All',function(who,...)
	lush.Instances.newInstance('UIListLayout',who,...)
end)
f:newCustomProperty('Grid','All',function(who,...)
	lush.Instances.newInstance('UIGridLayout',who,...)
end)
f:newCustomProperty('Page','All',function(who,...)
	lush.Instances.newInstance('UIPageLayout',who,...)
end)
f:newCustomProperty('Spacing','All',function(who,...)
	lush.Instances.newInstance('UIPadding',who,...)
end)
f:newCustomProperty('Pop','All',function(who,siz,...)
	local args = {...}
	return error('Sorry Pop has been removed from lush temporarily')
	--spawn(function()
		--lush.Position.Tweening.ExternalRipple(who,siz,unpack(args))
	--end)
end)
f:newCustomProperty('BypassClip','All',function(who)
	who.Rotation = .0001
end,true)
return lush
