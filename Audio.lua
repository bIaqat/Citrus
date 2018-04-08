Audio = setmetatable({
	new = function(name,id,props)
		local sound = setmetatable({},{
			Sound = Citrus.newInstance('Sound');
			__call = function(self,parent,start,en)
				local start, en = start and start or self.StartTime, en and en or self.EndTime
				local a = self.s:Clone()
				a.Parent = parent
				a.TimePosition = start
				Citrus.destroyIn(a,en-start)
			end;
			__index = function(self,ind)
				local soun = getmetatable(self).Sound
				if Citrus.hasProperty(soun,ind) then
					return Citrus.getArgument(2,Citrus.hasProperty(soun,ind))
				elseif ind == 'StartTime' or ind == 'EndTime' then
					return self[ind]
				else
					return soun
				end
			end;
		});
		getmetatable(Citrus.Audio).Sounds[name] = sound;
		Citrus.Audio.setSoundProperies(sound, props)
	end;	
	getSound = function(name)
		return Citrus.getAudio(name).Sound
	end;
	getAudio = function(name)
		return getmetatable(Citrus.Audio).Sounds[name]
	end;
	setSoundProperties = function(name,prop)
		if type(name) == 'string' then name = Citrus.getSound(name) end
		Citrus.Properties.setProperties(name,prop)
		for i,v in pairs(props)do
			if i == 'StartTime' or i == 'EndTime' then
				name[i] = v
			end
		end
	end;
	connectAudioToButton = function(button,name,...)
		getmetatable(Citrus.Audio).Remotes[button] = button.MouseButton1Click:connect(function()
			Citrus.getSound(name)(button,unpack({...}))
		end)
	end;
	disconnectButton = function(button)
		getmetatable(Citrus.Audio).Remotes[button]:Disconnect()
	end;
	play = function(name,...)
		Citrus.getSound(name)(...)
	end;
},{
	Sounds = {};
	Remotes = {};
})