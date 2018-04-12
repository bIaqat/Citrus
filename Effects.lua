Effects = setmetatable({
--TweenInfo: Time EasingStyle EasingDirection RepeatCount Reverses DelayTime
--TweenCreate: Instance TweenInfo dictionary
	new = function(name,func)
		getmetatable(Spice.Effects).Effects[name] = func
	end;
	getEffect = function(name)
		return Spice.Table.search(getmetatable(Spice.Effects).Effects,name)
	end;
	affect = function(who,name,...)
		who = Spice.Instance.getInstanceOf(who)
		name = type(name) == 'function' and name or Spice.Effects.getEffect(name)
		return name(who,...)
	end;
	affectChildren = function(who,name,...)
		who = Spice.Instance.getInstanceOf(who)
		for i,v in next,who:GetChildren() do
			Spice.Effects.affect(v,name,...)
		end
	end;
	affectDescendants = function(who,name,...)
		who = Spice.Instance.getInstanceOf(who)
		for i,v in next,who:GetDescendants() do
			Spice.Effects.affect(v,name,...)
		end
	end;
	massAffect = function(who,name,...)
		who = Spice.Instance.getInstanceOf(who)
		local args = {...}
		who.ChildAdded:connect(function(c)
				Spice.Effects.affect(c,name,args)
			end)
	end;
},
{
	Effects  = {};
}
);
