Audio = setmetatable({
	Sounds = {};
	Remotes = {};
	},{
	__index = function(self,index)
		for i,v in next, {
			new = function(Name, SoundId, Props)
				local sound = Instance.new'Sound'
				sound.SoundId = type(SoundId) ~= 'string' and 'rbxassetid://'..SoundId or SoundId
				sound.Name = Name
				for i,v in next, Props do
					sound[i] = v
				end
				local audio = setmetatable({
					Name = Name;
					Length = 0;
					Sound = sound
				},{
					__call = function(self, Parent, StartTime, EndTime)
						local start, endt = StartTime or 0, EndTime or self.Length
						local a = self.Sound:Clone()
						a.Parent = Parent
						a.TimePosition = start
						a:Play()
						game:GetService('Debris'):AddItem(a,endt-start)
						if a.Looped and (StartTime or EndTime) then
							self(Parent,StartTime,EndTime)
						end
						return a
					end
				});
				sound.Parent = workspace
				repeat wait() until sound.TimeLength ~= 0
				audio.Length = sound.TimeLength
				sound.Parent = nil
				self.Sounds[Name] = audio
				return sound				
			end;
			get = function(Name)
				return self.Sounds[Name]
			end;
			getSound = function(Name, ...)
				return self.Sounds[Name].Sound
			end;
			getAudioConnections = function(Name)
				return self.Remotes[type(Name) == 'string' and self.Sounds[Name].Sound or Name]
			end;
			connect = function(Name, ConnectingTo, Event, ...)--... Play Args
				local audio = type(Name) == 'string' and self.Sounds[Name] or Name
				local args = {...}
				local remotes = self.Remotes
				if not remotes[audio.Sound] then remotes[audio.Sound] = {} end
				remotes = remotes[audio.Sound]
				if not remotes[ConnectingTo] then remotes[ConnectingTo] = {} end
				local connection = ConnectingTo[Event]:connect(function()
					audio(unpack(args))
				end)
				remotes[ConnectingTo][Event] = connection
			end;
			disconnect = function(Name, Object, Event)
				local audio = type(Name) == 'string' and self.Sounds[Name] or Name
				local remotes = self.Remotes[audio]
				local function dc(Object)
					for i,v in next, Object do
						v:disconnect()
					end
				end
				if not Object and not Event then
					for i,v in next, remotes do
						dc(v)
					end
				elseif Object and not Event then
					dc(remotes[Object])
				elseif not Object and Event then
					for i,v in next, remotes do
						v[Event]:disconnect()
					end
				else
					remotes[Object][Event]:disconnect()
				end
			end;
			play = function(Name,...)
				return self.Sounds[Name](...)
			end;
		} do
			local self = getmetatable(self)
			self.__index = {}
			self.__index[i] = v
			if i == index then
				return v
			end
		end
	end
});