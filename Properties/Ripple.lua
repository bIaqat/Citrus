Citrus.Properties.new('Ripple',function(who,...)
	local trans, speed, color
	for _,arg in next,{...} do
		if type(arg) == 'number' then
			speed = not speed and trans and arg
			trans = not trans and arg
		elseif typeof(arg) == 'Color3' then
			color = arg
		end
	end                                                                                                        
	who.ClipsDescendants = true
	who.MouseButton1Click:connect(function()
		local m = game.Players.LocalPlayer:GetMouse()
		local c = Citrus.Instance.new('Circle',who,{ic = color or Color3.new(0,0,0)})
		Citrus.Effects.affect(c,'Ripple',speed or .6,trans or .9, color, UDim2.new(0,m.X-c.AbsolutePosition.X,0,m.Y-c.AbsolutePosition.Y))
	end)
end)

--A merge of the Ripple effect and property
Citrus.Properties.new('Ripple',function(who,...)
	local trans, speed, color
	for _,arg in next,{...} do
		if type(arg) == 'number' then
			speed = not speed and trans and arg
			trans = not trans and arg
		elseif typeof(arg) == 'Color3' then
			color = arg
		end
	end                                                                                                        
	who.ClipsDescendants = true
	who.MouseButton1Click:connect(function()
		local m = game.Players.LocalPlayer:GetMouse()
		local c = Citrus.Instance.new('Circle',who,{ic = color or Color3.new(0,0,0)})
		coroutine.wrap(function(who,...)
			local oof = who.ClassName:find'Image' and 'Image' or who.ClassName:find'Text' and 'Text' or 'Background'
			local typ = ( oof )..'Transparency'	
			local prop, from, tim, trans, siz, color = {}
			for i,v in pairs({...})do
				if type(v) == 'number' then
					siz = trans and tim and v or siz
					trans = not trans and tim and v or trans
					tim = not tim and v or tim
				elseif typeof(v) == 'UDim2' then
					siz = not siz and from and v or siz
					from = not from and v or from
				elseif type(v) == 'table' then
					prop = v
				elseif typeof(v) == 'Color3' then
					color = v
				end
			end				
			tim = tim or .5
			trans = trans or .8
			siz = siz
			color = color or Color3.new(0,0,0)							
			if not siz then
				local size = Citrus.Misc.Functions.switch(who.Parent.AbsoluteSize.X * 1.5,who.Parent.AbsoluteSize.Y * 1.5):Filter(true,false)
				siz = size(who.Parent.AbsoluteSize.X >= who.Parent.AbsoluteSize.Y)
			end								
			local op = Citrus.Misc.Functions.switch(-1,0,1):Filter(0,.5,1)
			local mid = UDim2.new(.5,op(who.AnchorPoint.X) * siz/2,.5,op(who.AnchorPoint.Y) * siz/2)											
			from = from or mid
			prop[typ] = trans
			prop.pos = from
			prop[oof..'Color3'] = color
			Citrus.Properties.setProperties(who,prop)				
			Citrus.Positioning.tweenObject(who,'both',mid,UDim2.new(0,siz,0,siz),tim,'Quad','Out')
			Citrus.Misc.Functions.tweenService(who,typ,1,tim)
			coroutine.wrap(function()
				wait(tim)
				who:Destroy()
			end)()
		end)(c,speed or .6,trans or .9, color, UDim2.new(0,m.X-c.AbsolutePosition.X,0,m.Y-c.AbsolutePosition.Y))
	end)
end)
