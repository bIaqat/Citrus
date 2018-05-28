Effects = setmetatable({
--TweenInfo: Time EasingStyle EasingDirection RepeatCount Reverses DelayTime
--TweenCreate: Instance TweenInfo dictionary
	new = function(name,func)
		getmetatable(Spice.Effects).Effects[name] = func
	end;
	newLocal = function(who,name,func)
		local effects = Spice.Effects
		local storage = getmetatable(effects).Effects
		local id = #storage..'_'..who.Name..'_'..name
		storage[id] = name
		return {
			Name = name;
			ID = id;
			Function = func;
			affect = function(self,who,...)
				effects.affect(who,self.Function,...)
			end;
			affectChildren = function(self,...)
				effects.affectChildren(who,self.Function,...)
			end;
			affectDescendants = function(self,...)
				effects.affectDescendants(who,self.Function,...)
			end;		
			affectChildAdded = function(self,...)
				effects.affectChildAdded(who,self.Function,...)
			end		
		}
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
	affectChildAdded = function(who,name,...)
		who = Spice.Instance.getInstanceOf(who)
		local args = {...}
		who.ChildAdded:connect(function(c)
				Spice.Effects.affect(c,name,unpack(args))
			end)
	end;
	affectAllChildren = function(who, name, ...)
		Spice.Effects.affectChildren(who,name,...)
		Spice.Effects.affectChildAdded(who,name,...)
	end;
},
{
	Effects  = {};
});
