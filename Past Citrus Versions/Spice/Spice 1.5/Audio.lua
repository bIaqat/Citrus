Audio = setmetatable({
	new = function(name,id,props)
		local sound = setmetatable({
				Name = name;
				Length = 0;
				connect = function(self,...)
					return Spice.Audio.connect(self,...)
				end;
				disconnect = function(self,...)
					return Spice.Audio.disconnect(self,...)
				end;
			},{
				Sound = Spice.newInstance('Sound',{SoundId = 'rbxassetid://'..id});
				__call = function(self,parent,start,en)
					local start, en = start and start or self.StartTime or 0, en and en or self.EndTime or self.Length
					local a = self.so:Clone()
					a.Parent = parent
					a.TimePosition = start
					a:Play()
					Spice.destroyIn(a,en-start)
				end;
				__index = function(self,ind)
					local soun = getmetatable(self).Sound
					if Spice.Properties.hasProperty(soun,ind) then
						return Spice.Misc.getArgument(2,Spice.Properties.hasProperty(soun,ind))
					elseif ind:sub(1,2):lower() == 'so' then
						return soun
					else
						return false
					end
				end;
		});
		sound.Sound.Parent = workspace
		repeat wait() until sound.Sound.TimeLength ~= 0
		sound.Length = sound.Sound.TimeLength
		sound.Sound.Parent = nil
		getmetatable(Spice.Audio).Sounds[name] = sound;
		getmetatable(Spice.Audio).Remotes[name] = {};
		Spice.Audio.setSoundProperties(sound, props or {})
		return sound
	end;	
	getSound = function(name)
		return Spice.getAudio(name).Sound
	end;
	getAudio = function(name)
		return type(name) == 'string' and getmetatable(Spice.Audio).Sounds[name] or type(name) == 'table' and name.Sound and name or false, type(name) == 'string' and name or type(name) == 'table' and name.Sound and name.Name
	end;
	getAudioConnections = function(name)
		local a,b = Spice.getAudio(name)
		return getmetatable(Spice.Audio).Remotes[b]
	end;
	setSoundProperties = function(name,prop)
		if type(name) == 'string' then name = Spice.getSound(name) end
		Spice.Properties.setProperties(name,prop)
		for i,v in pairs(prop)do
			if i == 'StartTime' or i == 'EndTime' then
				name[i] = v
			end
		end
	end;
	connect = function(name,object,connector,...)
		local audio, name = Spice.getAudio(name)
		local args = {...}
		local rems = Spice.getAudioConnections(name)
		if not rems[object] then
			rems[object] = {}
		end
		local connect = object[connector]:connect(function()
			audio(object,unpack(args))
		end)
		rems[object][connector] = connect
	end;
	disconnect = function(name,button,con)
		local audio, name = Spice.getAudio(name)
		local rems = Spice.getAudioConnections(name)
		local but = rems[button]
		if not button then
			for butz,v in next,rems do
				for cons, x in next, v do
					Spice.Audio.disconnect(name,butz,cons)
				end
			end
		elseif not con then
			for i,v in next,but do
				Spice.Audio.disconnect(name,button,i)
			end
		else
			but[con]:Disconnect()
		end
	end;
	play = function(name,...)
		Spice.getSound(name)(...)
	end;
},{
	Sounds = {};
	Remotes = {};
});
