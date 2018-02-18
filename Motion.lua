Motion = {
	--TweenInfo: Time EasingStyle EasingDirection RepeatCount Reverses DelayTime
	--TweenCreate: Instance TweenInfo dictionary
	tween = function(what,prop,to,...)
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
		for i,v in next,prop and type(prop) == 'table' or {prop} do
			props[Pineapple.Properties[v]] = to and type(to) ~= 'table' or to[i]
		end
		return game:GetService('TweenService'):Create(what,TweenInfo.new(tim,style or Enum.EasingStyle.Linear,direction or Enum.EasingDirection.In,rep or 0,reverse or false,delay = 0),props):Play()
	end;
	
}
