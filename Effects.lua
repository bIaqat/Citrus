Effects = setmetatable({
	--TweenInfo: Time EasingStyle EasingDirection RepeatCount Reverses DelayTime
	--TweenCreate: Instance TweenInfo dictionary
		new = function(name,func)
			getmetatable(Pineapple.Effects).Effects[name] = func
		end;
		getEffect = function(name)
			return Pineapple.Misc.Table.search(getmetatable(Pineapple.Effects).Effects,name)
		end;
		affect = function(who,name,...)
			name = type(name) == 'function' and name or Pineapple.Effects.getEffect(name)
			return name(who,...)
		end;
		affectChildren = function(who,name,...)
			for i,v in next,who:GetChildren() do
				Pineapple.Effects.affect(v,name,...)
			end
		end;
		affectDescendants = function(who,name,...)
			for i,v in next,who:GetDescendants() do
				Pineapple.Effects.affect(v,name,...)
			end
		end;
		massEffect = function(who,name,...)
			who.ChildAdded:connect(function(c)
					Pineapple.Effects.affect(c,name,...)
				end)
		end;
},
	{
		Effects  = {
			Ripple = function(who,speed,to,ex)
				if ex and who.Rotation == 0 then who.Rotation = .001 end
				local typ
				if who.ClassName:find'Image' then
					typ = 'Image'
				elseif who.ClassName:find'Text' then
					typ = 'Text'
				else
					typ = nil
				end
				typ = typ or ''..'Transparency'
				speed = speed or who[typ]/1.8
				local size = to or 900
				local ud = Pineapple.Positioning.new
				if Pineapple.Properties.hasProperty(who.Parent,'AbsoluteSize') and not to then
					size = Pineapple.Misc.Functions.switch(who.Parent.AbsoluteSize.X * 1.5,who.Pareant.AbsoluteSize.Y * 1.5)
					size.type = {true,false}
					size = size(who.Parent.AbsoluteSize.X >= who.Parent.AbsoluteSize.Y)
				end
				Pineapple.Positioning.tweenObject(who,'both',ud(.5,-Size/2,3),ud(size,'o'),speed,'Quad','Out')
				Pineapple.Misc.Functions.tweenService(who,typ,1,speed,'Quint','In')
				coroutine.wrap(function()
						repeat wait() until who[typ] >= 1
						who:Destroy()
					end)()
			end;
		};
	}
)

