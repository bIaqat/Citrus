Tweening = {
	new = function(what,prop,to,...)
		if type(what) == 'table' and type(what[1]) == 'userdata' then
			local data = {}
			for i,what in next,what do
				data[i] = Spice.Tweening.new(what,prop,to,...)
			end
			return data
		end
		what = Spice.getInstanceOf(what)
		local args = {...}
		local props = {}
		local tim,style,direction,rep,reverse,delay
		for i,v in next,args do
			if type(v) == 'string' or typeof(v) == 'EnumItem' then
				if style == nil then
					style = v and type(v) ~= 'string' or Enum.EasingStyle[v]
				else
					direction = v and type(v) ~= 'string' or Enum.EasingDirection[v]
				end
			elseif type(v) == 'number' then
				if tim == nil then
					tim = v
				elseif rep == nil then
					rep = v
				else
					delay = v
				end
			elseif type(v) == 'boolean' then
				reverse = v
			end
		end
		for i,v in next,type(prop) == 'table' and prop or {prop} do
			props[Spice.Properties[v]] = type(to) ~= 'table' and to or to[i]
		end
		return game:GetService('TweenService'):Create(what,TweenInfo.new(tim,style or Enum.EasingStyle.Linear,direction or Enum.EasingDirection.In,rep or 0,reverse or false,delay or 0),props):Play()
	end;		
	tweenGuiObject = function(object,typ,...)
		typ = typ:lower()
		object = Spice.Instance.getInstanceOf(object)
		local interupt,udim,udim2,time,style,direction,after = true
		for i,v in pairs({...})do
			if typeof(v) == 'UDim2' then
				udim2 = udim and v or nil
				udim = udim and udim or v
			elseif type(v) == 'function' then
				after = v
			elseif type(v) == 'boolean' then
				interupt = v
			elseif type(v) == 'number' then
				time = v
			elseif type(v) == 'string' then
				style = style and style or v
				direction = style and nil or v
			end
		end
		if udim2 then
			object:TweenSizeAndPosition(udim2,udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		elseif typ:find'p' then
			object:TweenPosition(udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		else
			object:TweenSize(udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		end
	end;	
	rotate = function(object, to, timer)
		object = Spice.Instance.getInstanceOf(object)
		Spice.Tweening.new(object, 'Rotation', to, timer)
	end
};