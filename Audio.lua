Audio = setmetatable({
	new = function(name,id,props)
		local sound = setmetatable({
				Name = name;
				Length = 0;
				connect = function(self,...)
					return Citrus.Audio.connect(self,...)
				end;
				disconnect = function(self,...)
					return Citrus.Audio.disconnect(self,...)
				end;
			},{
				Sound = Citrus.newInstance('Sound',{SoundId = 'rbxassetid://'..id});
				__call = function(self,parent,start,en)
					local start, en = start and start or self.StartTime or 0, en and en or self.EndTime or self.Length
					local a = self.so:Clone()
					a.Parent = parent
					a.TimePosition = start
					a:Play()
					Citrus.destroyIn(a,en-start)
				end;
				__index = function(self,ind)
					local soun = getmetatable(self).Sound
					if Citrus.Properties.hasProperty(soun,ind) then
						return Citrus.Misc.getArgument(2,Citrus.Properties.hasProperty(soun,ind))
					elseif ind:sub(1,2):lower() == 'so' then
						return soun
					else
						return false
					end
				end;
		});
		sound.Sound.Parent = workspace
		wait()
		sound.Length = sound.Sound.TimeLength
		sound.Sound.Parent = nil
		getmetatable(Citrus.Audio).Sounds[name] = sound;
		getmetatable(Citrus.Audio).Remotes[name] = {};
		Citrus.Audio.setSoundProperties(sound, props or {})
		return sound
	end;	
	getSound = function(name)
		return Citrus.getAudio(name).Sound
	end;
	getAudio = function(name)
		return type(name) == 'string' and getmetatable(Citrus.Audio).Sounds[name] or type(name) == 'table' and name.Sound and name or false, type(name) == 'string' and name or type(name) == 'table' and name.Sound and name.Name
	end;
	getAudioConnections = function(name)
		local a,b = Citrus.getAudio(name)
		return getmetatable(Citrus.Audio).Remotes[b]
	end;
	setSoundProperties = function(name,prop)
		if type(name) == 'string' then name = Citrus.getSound(name) end
		Citrus.Properties.setProperties(name,prop)
		for i,v in pairs(prop)do
			if i == 'StartTime' or i == 'EndTime' then
				name[i] = v
			end
		end
	end;
	connect = function(name,object,connector,...)
		local audio, name = Citrus.getAudio(name)
		local args = {...}
		local rems = Citrus.getAudioConnections(name)
		if not rems[object] then
			rems[object] = {}
		end
		local connect = object[connector]:connect(function()
			audio(object,unpack(args))
		end)
		rems[object][connector] = connect
	end;
	disconnect = function(name,button,con)
		local audio, name = Citrus.getAudio(name)
		local rems = Citrus.getAudioConnections(name)
		local but = rems[button]
		if not button then
			for butz,v in next,rems do
				for cons, x in next, v do
					Citrus.Audio.disconnect(name,butz,cons)
				end
			end
		elseif not con then
			for i,v in next,but do
				Citrus.Audio.disconnect(name,button,i)
			end
		else
			but[con]:Disconnect()
		end
	end;
	play = function(name,...)
		Citrus.getSound(name)(...)
	end;
},{
	Sounds = {};
	Remotes = {};
});
