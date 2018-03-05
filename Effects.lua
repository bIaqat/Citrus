Effects = setmetatable({
	--TweenInfo: Time EasingStyle EasingDirection RepeatCount Reverses DelayTime
	--TweenCreate: Instance TweenInfo dictionary
		new = function(name,func)
			getmetatable(Citrus.Effects).Effects[name] = func
		end;
		getEffect = function(name)
			return Citrus.Misc.Table.search(getmetatable(Citrus.Effects).Effects,name)
		end;
		affect = function(who,name,...)
			name = type(name) == 'function' and name or Citrus.Effects.getEffect(name)
			return name(who,...)
		end;
		affectChildren = function(who,name,...)
			for i,v in next,who:GetChildren() do
				Citrus.Effects.affect(v,name,...)
			end
		end;
		affectDescendants = function(who,name,...)
			for i,v in next,who:GetDescendants() do
				Citrus.Effects.affect(v,name,...)
			end
		end;
		massAffect = function(who,name,...)
			local args = {...}
			who.ChildAdded:connect(function(c)
					Citrus.Effects.affect(c,name,args)
				end)
		end;
},
	{
		Effects  = {
		};
	}
)