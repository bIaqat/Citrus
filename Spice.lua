local Spice
Spice = setmetatable({
	Misc = {
		runTimer = function()
			return setmetatable({time = 0,running = false},{
				__call = function(self,start)
					local gettime
					if start or not self.running then
						self.running = true
						coroutine.wrap(function()
							while self.running and wait(.01) do
								self.time = self.time + .01
							end
						end)()
						return true
					else
						self.running = false
						gettime = self.time
						self.time = 0
					end
					return gettime or self.time
				end
			})
		end;
		searchAPI = function(link,typ)
			local tab = {}
			link = game.HttpService:UrlEncode(link:sub(link:find'?'+1,#link))
			local proxy = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?'
			if not typ then
				link = game:GetService'HttpService':JSONDecode(game:GetService'HttpService':GetAsync(proxy..link))
			else
				link = game:GetService'HttpService':JSONDecode(game:HttpGetAsync(proxy..link))
			end
			for i,v in pairs(link)do
				tab[v.Name] = v
			end
			return tab
		end;
		getArgument = function(num,...)
			return ({...})[num]
		end;
		destroyIn = function(who,seconds)
			game:GetService("Debris"):AddItem(Spice.Instance.getInstanceOf(who),seconds)
		end;
		exists = function(yes)
			return yes ~= nil and true or false
		end;
		tweenService = function(what,prop,to,...)
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
		stringFilterOut = function(string,starting,ending,...)
			local args,disregard,tostr,flip = {...}
			for i,v in pairs(args)do
				if type(v) == 'boolean' then
					if flip == nil then flip = v else tostr = v end
				elseif type(v) == 'string' then
					disregard = v
				end
			end
			local filter,out = {},{}
			for i in string:gmatch(starting) do
				if not Spice.Misc.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
					local filtered = string:sub(string:find(starting),ending and Spice.getArgument(2,string:find(ending)) or Spice.getArgument(2,string:find(starting)))
					local o = string:sub(1,(ending and string:find(ending) or string:find(starting))-1)
					table.insert(filter,filtered~=disregard and filtered or nil)
					table.insert(out,o~=disregard and o or nil)
				else
					table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
				end
				string = string:sub((ending and Spice.getArgument(2,string:find(ending)) or Spice.getArgument(2,string:find(starting))) + 1)
			end
			table.insert(out,string)
			filter = tostr and table.concat(filter) or filter
			out = tostr and table.concat(out) or out
			return flip and out or filter, flip and filter or out
		end;
		dynamicType = function(obj)
			obj = Spice.Instance.getInstanceOf(obj)
			if obj.ClassName:find'Text' then
				return 'Text'
			elseif obj.ClassName:find'Image' then
				return 'Image'
			end
			return 'Background'
		end;
		switch = function(...)
			return setmetatable({filter = {},Default = false,data = {...},
				Filter = function(self,...)
					self.filter = {...}
					return self
				end;	
				Get = function(self,what)
					local yes = Spice.Misc.exists	
					local i = what
					if yes(Spice.Table.find(self.data,what)) then
						i = Spice.Table.indexOf(self.data,what)
					end
					if yes(Spice.Table.find(self.filter,what)) then
						i = Spice.Table.indexOf(self.filter,what)
					end
					return self.data[i]
				end},{
					__call = function(self,what,...)
						local get = self:Get(what)
						return get and (type(get) ~= 'function' and get or get(...)) or self.Default
					end;
				})
		end;
		round = function(num)
			return math.floor(num+.5)
		end;
		contains = function(containing,...)
			for _,content in next,{...} do
				if content == containing then
					return true
				end
			end
			return false
		end;
		operation = function(a,b,opa)
			return Spice.Misc.switch(a+b,a-b,a*b,a/b,a%b,a^b,a^(1/b),a*b,a^b,a^(1/b)):Filter('+','-','*','/','%','^','^/','x','pow','rt')(opa)
		end;
	};
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
	Iconography = setmetatable({
		insertIconList = function(img,xlen,ylen,xgrid,ygrid,names)
			if not names then names = ygrid ygrid = xgrid end
			local count = 1
			for y = 0, ylen-1,1 do
				for x = 0,xlen-1,1 do
					local icon = Instance.new("ImageLabel")
					icon.BackgroundTransparency = 1
					icon.Image = img
					icon.ImageRectOffset = Vector2.new(x*xgrid,y*ygrid)
					icon.ImageRectSize = Vector2.new(xgrid,ygrid)
					local namefil = Spice.Misc.stringFilterOut(names[count] or 'Icon','_',nil,true)
					local name = namefil[#namefil]
					table.remove(namefil,#namefil)
					Spice.Iconography.insertIcon(name,icon,unpack(namefil))
					count = count + 1
				end
			end
		end;			
		insertIcon = function(name,icon,...)
			local index = getmetatable(Spice.Iconography).Icons
			for i,v in next,{...} or {} do
				v = v:sub(1,1):upper()..v:sub(2)
				if not index[v] then
					index[v] = {}
				end
				index = index[v]
			end
			if index[name] and type(index[name]) ~= 'table' then
				index[name] = {index[name]}
			end
			if index[name] then
				table.insert(index[name],icon)
			else
				index[name] = icon
			end			
		end;		
		new = function(name,...)
			local index = getmetatable(Spice.Iconography).Icons
			for i,v in next,{...} or {} do
				v = v:sub(1,1):upper()..v:sub(2)
				index = index[v]
			end
			local icon = Spice.Table.search(index,name,true)
			return icon:Clone()
		end;		
		getIconData = function(...)
			local i = Spice.Iconography.new(...)
			return {Image = i.Image, ImageRectSize = i.ImageRectSize, ImageRectOffset = i.ImageRectOffset}
		end;
	},{
		Icons = {}
		}
	);
	Color = setmetatable({
		fromRGB = function(r,g,b)
			return Color3.fromRGB(r,g,b)
		end;
		toRGB = function(color)
			if not color then return nil end
			local r = Spice.Misc.round
			return r(color.r*255),r(color.g*255),r(color.b*255)
		end;
		editRGB = function(color,...)
			local round,op = Spice.Misc.round,Spice.Misc.operation
			local sign,nr,ng,nb,nc
			local args = {...}
			if type(args[1]) ~= 'string' then
				sign = '+'
				nr,bg,nb = args[1],args[2],args[3]
			else
				sign = args[1]
				nr,ng,nb = args[2],args[3],args[4]
				args[1],args[2],args[3] = nr,ng,nb
			end
			local r,g,b = Spice.Color.toRGB(color)
			nc = {r,g,b}
			if not b then
				if not g then
					g = 1
				end
				nc[g] = op(nc[g],r,sign)
			else
				for i,v in pairs(nc)do
					nc[i] = op(v,args[i],sign)
				end
			end
			return Color3.fromRGB(unpack(nc))
		end;
		setRGB = function(color,...)
			local args = {...}
			local nr,ng,nb,nc
			local r,g,b = Spice.Color.toRGB(color)
			nc = {r,g,b}
			if #args < 3 then
				if not args[2] then
					args[2] = 1
				end
				nc[args[2]] = args[1]
			else
				for i,v in pairs(nc)do
					nc[i] = args[i]
				end
			end
			return Color3.fromRGB(unpack(nc))
		end;
		fromHSV = function(h,s,v)
			return Color3.fromHSV(h/360,s/100,v/100)
		end;
		toHSV = function(color)
			if not color then return nil end
			local r = Spice.Misc.round
			local h,s,v = Color3.toHSV(color)
			return r(h*360),r(s*100),r(v*100)
		end;
		editHSV = function(color,...)
			local round,op = Spice.Misc.round,Spice.Misc.operation
			local sign,nr,ng,nb,nc
			local args = {...}
			if type(args[1]) ~= 'string' then
				sign = '+'
				nr,bg,nb = args[1],args[2],args[3]
			else
				sign = args[1]
				nr,ng,nb = args[2],args[3],args[4]
				args[1],args[2],args[3] = nr,ng,nb
			end
			local r,g,b = Spice.Color.toHSV(color)
			nc = {r,g,b}
			if not b then
				if not g then
					g = 1
				end
				nc[g] = op(nc[g],r,sign)
			else
				for i,v in pairs(nc)do
					nc[i] = op(v,args[i],sign)
				end
			end
			return Spice.Color.fromHSV(unpack(nc))
		end;
		setHSV = function(color,...)
			local args = {...}
			local nr,ng,nb,nc
			local r,g,b = Spice.Color.toHSV(color)
			nc = {r,g,b}
			if #args < 3 then
				if not args[2] then
					args[2] = 1
				end
				nc[args[2]] = args[1]
			else
				for i,v in pairs(nc)do
					nc[i] = args[i]
				end
			end
			return Spice.Color.fromHSV(unpack(nc))
		end;		
		fromHex = function(hex)
			if hex:sub(1,1) == '#' then
				hex = hex:sub(2)
			end
			local r,g,b
			if #hex >= 6 then
				r = tonumber(hex:sub(1,2),16)
				g = tonumber(hex:sub(3,4),16)
				b = tonumber(hex:sub(5,6),16)
			elseif #hex >= 3 then
				r = tonumber(hex:sub(1,1):rep(2),16)
				g = tonumber(hex:sub(2,2):rep(2),16)
				b = tonumber(hex:sub(3,3):rep(2),16)
			end
			return Color3.fromRGB(r,g,b)
		end;
		toHex = function(color,hash)
			if not color then return nil end
			local r,g,b = Spice.Color.toRGB(color)
			r = string.format('%02X',r)
			g = string.format('%02X',g)
			b = string.format('%02X',b)
			return (not hash and '#' or '')..tostring(r)..tostring(g)..tostring(b)
		end;
		fromString = function(pName)
			local colors = {
				Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
				Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
				Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
				BrickColor.new("Bright violet").Color,
				BrickColor.new("Bright orange").Color,
				BrickColor.new("Bright yellow").Color,
				BrickColor.new("Light reddish violet").Color,
				BrickColor.new("Brick yellow").Color
			}
			local value = 0
			for index = 1, #pName do
				local cValue = string.byte(string.sub(pName, index, index))
				local reverseIndex = #pName - index + 1
				if #pName%2 == 1 then
					reverseIndex = reverseIndex - 1
				end
				if reverseIndex%4 >= 2 then
					cValue = -cValue
				end
				value = value + cValue
			end
			return colors[(value % #colors) + 1]
		end;
		getReciprocal = function(color)
			local h,s,v = Spice.Color.toHSV(color)
			return Spice.Color.fromHSV(h,v,s)
		end;
		getInverse = function(color)
			local h,s,v = Spice.Color.toHSV(color)
			return Spice.Color.fromHSV((h + 180) % 360, v, s)
		end;
		getObjectsOfColor = function(color,directory)
			local objs = {}
			for i,obj in pairs(Spice.Instance:getInstanceOf(directory):GetDescendants())do
				for prop, val in pairs(Spice.Properties.getProperties(obj))do
					if val == color then
						table.insert(objs,obj)
					end
				end
			end
			return objs
		end;
		
		insertColor = function(name,col,...)
			local index = getmetatable(Spice.Color).Colors
			local subs = {}
			for i,v in next,{...} or {} do
				if not index[v] then
					index[v] = {}
				end
				index = index[v]
			end
			for i,v in next, type(col) == 'table' and col or {} do
				if type(v) == 'table' then
					rawset(subs,i,v)
					if type(i) == 'number' then
						table.remove(col,i)
					else
						col[i] = nil
					end
				end
			end
			if index[name] then
				Spice.Table.insert(index[name],col)
			else
				index[name] = type(col) == 'table' and col or {col}
			end		
			for i,v in next,subs do
				Spice.Color.insertColor(name,v,unpack({...}),i)
			end	
		end;
		getColor = function(name,id,...)
			local index = getmetatable(Spice.Color).Colors
			for i,v in next,{type(id) == 'string' and id or nil,...} do
				index = Spice.Table.search(index,v)
			end
			local col = index[name]
			return col and col[type(id) == 'number' and id or next(col)]
		end;
		removeColor = function(name,...)
			local index = getmetatable(Spice.Color).Colors
			for i,v in next,{...} or {} do
				index = index[v]
			end
			index[name] = nil
		end;
		
		new = function(...)
			local args = {...}
			if type(args[1]) == 'string' then
				if args[1]:sub(1,1) == '#' then
					return Spice.Color.fromHex(args[1])
				else
					return Spice.Color.getColor(...)
				end
			elseif args[4] and args[4] == true then
				return Spice.Color.fromHSV(args[1],args[2],args[3])
			elseif #args == 3 then
				return Spice.Color.fromRGB(args[1],args[2],args[3])
			end
		end;
	},{
		Colors = {};
	});
	Properties = setmetatable({
		getDefault = function(classname)
			local def = {}
			for i,v in next, getmetatable(Spice.Properties).Default do
				if Spice.Instance.isA(classname,i) or classname == i or i == 'GuiText' and classname:find'Text' then
					table.insert(def,v)
				end
			end
			for i = 2,#def do
				Spice.Table.merge(def[i],def[1])
			end
			return def[1]
		end;
		setDefault = function(classname,properties)
			getmetatable(Spice.Properties).Default[classname] = properties;
		end;
		setPropertiesToDefault = function(who)
			Spice.Properties.setProperties(who,Spice.Properties.getDefault(who.ClassName) or {})
		end;
		new = function(name,func,...)
			local storage = getmetatable(Spice.Properties).Custom
			storage[name] = setmetatable({func,...},{
					__call = function(self,...)
						return self[1](...)
					end;
					__index = function(self,indexed)
						if #self == 1 then
							return true
						end
						for i = 2,#self do
							if self[i]:lower() == 'all' or indexed:IsA(self[i]) or self[i] == 'GuiText' and indexed.ClassName:find'Text' then
								return true
							end
						end
						return false
					end;
			})
		end;
		hasProperty = function(who,prop)
			who = Spice.Instance.getInstanceOf(who)
			if pcall(function() return who[Spice.Properties[prop]] end) then
				return true, who[Spice.Properties[prop]]
			else
				return false
			end
		end;
		getProperties = function(who)
			who = Spice.Instance.getInstanceOf(who)
			local p = getmetatable(Spice.Properties).RobloxAPI
			local new = {}
			for i,v in next,p do
				if Spice.Properties.hasProperty(who,v) then
					rawset(new,v,who[v])
				end
			end
			return new
		end;
		setProperties = function(who,props)
			who = Spice.Instance.getInstanceOf(who)
			local c = getmetatable(Spice.Properties).Custom
			for i,v in next,props do
				if type(i) == 'string' then
					local custom,cargs, normal
					if c[i] and c[i][who] then
						cargs = v
						if type(cargs) ~= 'table' then cargs = {cargs} end
						--custom object check
						--c[i](who,unpack(v))
						custom = c(i)
					end
					if Spice.Properties[i]:find'Color3' and type(v) == 'string' or type(v) == 'table' then
						v = type(v) == 'table' and v or {v}
						Spice.Theming.insertObject(v[1],who,i,unpack(Spice.Table.pack(v,2) or {}))
					elseif Spice.Properties.hasProperty(who,i)  then
						normal = Spice.Properties[i]
						if custom and custom <= normal then
							c[i](who,unpack(cargs))
						else
							pcall(function() who[normal] = v end)
						end
					elseif custom then
						c[i](who,unpack(cargs))
					end
				end
			end
			return who
		end;
		getObjectOfProperty = function(property,directory)
			directory = Spice.Instance.getInstanceOf(directory)
			local objects = {}
			for _,object in next,type(directory) == 'table' and directory or directory:GetDescendants() do
				if Spice.Properties.hasProperty(object,property) then
					table.insert(objects,object)
				end
			end
			return objects
		end;
					
	},{
		__index = function(self,ind)
			return Spice.Table.search(getmetatable(self).RobloxAPI,ind) or ind
		end;
		Default = {};
		Custom = setmetatable({},{
				__call = function(self,ind,take)
					for i,v in next,self do
						if i:sub(1,#ind):lower() == ind:lower() then
							return take and v or i
						end
					end			
					return false			
				end;
				__index = function(self,ind)
					return self(ind,true)
				end});
		RobloxAPI = {
			'Shape','Anchored','BackSurfaceInput','BottomParamA','BottomParamB','BottomSurface','BottomSurfaceInput','BrickColor','CFrame','CanCollide','CenterOfMass','CollisionGroupId','Color','CustomPhysicalProperties','FrontParamA','FrontParamB','FrontSurface','FrontSurfaceInput';
			'LeftParamA','LeftParamB','LeftSurface','LeftSurfaceInput','Locked','Material','Orientation','Reflectance','ResizeIncrement','ResizeableFaces','RightParamA','RightParamB','RightSurface','RightSurfaceInput','RotVelocity','TopParamA','TopParamB','TopSurface','TopSurfaceInput','Velocity';
			'Archivable','ClassName','Name','Parent','AttachmentForward','AttachmentPoint','AttachmentPos','AttachmentRight','AttachmentUp';
			'Animation','AnimationId','IsPlaying','Length','Looped','Priority','Speed','TimePosition','WeightCurrent','WeightTarget','Axis','CFrame','Orientation';
			'Position','Rotation','SeconaryAxis','Visible','WorldAxis','WorldOrientation','WorldPosition','WorldSecondaryAxis','Version','DisplayOrder','ResetOnSpawn','Enabled';
			'AbsolutePosition','AbsoluteRotation','AbsoluteSize','ScreenOrientation','ShowDevelopmentGui','Attachment0','Attachment1','Color','CurveSize0','CurveSize1','FaceCamera';
			'LightEmission','Segments','Texture','TextureLength','TextureMode','TextureSpeed','Transparency','Width0','Width1','ZOffset','AngularVelocity','MaxTorque','P','Force','D';
			'MaxForce','Location','Velocity','CartoonFactor','MaxSpeed','MaxThrust','Target','TargetOffset','TargetRadius','ThrustD','ThrustP','TurnD','TurnP','Value','CameraSubject','CameraType';
			'FieldOfView','Focus','HeadLocked','HeadScale','ViewportSize','HeadColor','HeadColor3','LeftArmColor','LeftArmColor3','LeftLegColor','LeftLegColor3','RightArmColor','RightArmColor3','RightLegColor','RightLegColor3','TorsoColor','TorsoColor3';
			'BaseTextureId','BodyPart','MeshId','OverlayTextureId','PantsTemplate','ShirtTemplate','Graphic','SkinColor','LoadDefaultChat','CursorIcon','MaxActivationDistance','MaxAngularVelocity','PrimaryAxisOnly','ReactionTorqueEnabled','Responsiveness','RigidityEnabled';
			'ApplyAtCenterOfMass','MaxVelocity','ReactionForceEnabled','Radius','Restitution','TwistLimitsEnabled','TwistLowerAngle','TwistUpperAngle','UpperAngle','ActuatorType','AngularSpeed','CurrentAngle','LimitsEnabled','LowerAngle','MotorMaxAcceleration','MotorMaxTorque','ServoMaxTorque','TargetAngle';
			'InverseSquareLaw','Magnitude','Thickness','CurrentPosition','LowerLimit','Size','TargetPosition','UpperLimit','Heat','SecondaryColor';
			'BackgroundColor3','AnchorPoint','BackgroundTransparency','BorderColor3','BorderSizePixel','ClipsDescendants','Draggable','LayoutOrder','NextSelectionDown','NextSelectionLeft','NextSelectionRight','NextSelectionUp','Selectable','SelectionImageObject','SizeConstraint','SizeFromContents','ZIndex';
			'Style','AutoButtonColor','Modal','Selected','Image','ImageColor3','ImageRectOffset','ImageRectSize','ImageTransparency','IsLoaded','ScaleType','SliceCenter','TextSize','TileSize','Font','Text','TextBounds','TextColor3','TextFits';
			'TextScaled','TextStrokeColor3','TextStrokeTransparency','TextTransparency','TextWrapped','TextXAlignment','TextYAlignment','Active','AbsoluteWindowSize','BottomImage','CanvasPosition','CanvasSize','HorizontalScrollBarInset','MidImage','ScrollBarThickness','ScrollingEnabled','TopImage','VerticalScrollBarInset';
			'VerticalScrollBarPosition','ClearTextOnFocus','MultiLine','PlaceholderColor3','PlaceholderText','ShowNativeInput','Adornee','AlwaysOnTop','ExtentsOffset','ExtentsOffsetWorldSpace','LightInfluence','MaxDistance','PlayerToHideForm','SizeOffset','StudsOffset','StudsOffsetWorldSpace','ToolPunchThroughDistance','Face','DecayTime','Density','Diffusion','Duty','Frequency';
			'Depth','Mix','Rate','Attack','GainMakeup','Ratio','Release','SieChain','Threshold','Level','Delay','DryLevel','Feedback','WetLevel','HighGain','LowGain','MidGain','Octave','Volume','MaxSize','MinSize','AspectRatio','DominantAxis','AspectType','MaxTextSize','MinTextSize','CellPadding','CellSize','FillDirectionMaxCells','StartCorner';
			'AbsoluteContentSize','FillDirection','HorizontalAlignment','SortOrder','VerticalAlignment','Padding','Animated','Circular','CurrentPage','EasingDirection','EasingStyle','GamepadInputEnabled','ScrollWhellInputEnabled','TweenTime','TouchImputEnable','FillEmptySpaceColumns','FillEmptySpaceRows','MajorAxis','PaddingBottom','PaddingLeft','PaddingRight','PaddingTop','Scale'
		}
	});
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
	Positioning = {
		new = function(...)
			local args = {...}
			if #args == 4 then
				return UDim2.new(unpack(args))
			else
				local a,b  = args[1], args[3] == nil and args[1] or args[2]
				return Spice.Misc.switch(UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)):Filter('s','o','b','so','os')(args[3] or args[2] or 1)
			end
		end;
		toUDim = function(a,b)
			return Spice.Misc.switch(UDim.new(a,b), UDim.new(a,a))(b and 1 or 2)
		end;
		toVector2 = function(a,b)
			return Spice.Misc.switch(Vector2.new(a,b), Vector2.new(a,a))(b and 1 or 2)
		end;
		fromPosition = function(a,b)
			local x,y
			local pos = Spice.Misc.switch(UDim.new(0,0),UDim.new(.5,0),UDim.new(1,0),UDim2.new(.5,0)):Filter('top','mid','bottom','center')
			y = pos(a) or (pos(b) and b~='mid' and b~='center')
			pos:Filter('left','mid','right','center')
			x = pos(b) or (pos(a) and a~='mid' and a~='center')
			return UDim2.new(x or UDim.new(0,0),y or UDim.new(0,0))
		end;
		fromOffset = function(a,b)
			return UDim2.new(0,a,0,b)
		end;
		fromScale = function(a,b)
			return UDim2.new(a,0,b,0)
		end;
		tweenObject = function(object,typ,...)
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
	};
	Table = {
		insert = function(tabl,...)
			for i,v in pairs(...) do 
				if type(v) == 'table' then
					Spice.Table.insert(tabl,v)
				else
					rawset(tabl,i,v)
				end
			end
		end;
		pack = function(tabl,start,en)
			local new = {}
			for i = start or 1, en or #tabl do
				table.insert(new,tabl[i])
			end
			return new
		end;
		merge = function(from,to)
			for i,v in next, from do
				to[i] = v
			end
			return to
		end;
		clone = function(tab)
			local clone = {}
			for i,v in next,tab do
				if type(v) == 'table' then
					clone[i] = Spice.Table.clone(v)
					if getmetatable(v) then
						local metaclone = Spice.Table.clone(getmetatable(v))
						setmetatable(clone[i],metaclone)
					end
				else
					clone[i] = v
				end
			end
			if getmetatable(tab) then
				local metaclone = getmetatable(tab)
				setmetatable(clone,metaclone)
			end
			return clone
		end;
		contains = function(tabl,contains)
			for i,v in next,tabl do
				if v == contains or (typeof(i) == typeof(contains) and v == contains) or i == contains then
					return true,v,i
				end
			end
			return nil
		end;
		toNumeralIndex = function(tabl)
			local new = {}
			for index,v in next,tabl do
				if type(index) ~= 'number' then
					table.insert(new,{index,v})
				else
					table.insert(new,index,v)
				end
			end
			setmetatable(new,{
					__index = function(self,index)
						for i,v in next,self do
							if type(v) == 'table' and v[1] == index then
								return v[2]
							end
						end
					end
					})
			return new
		end;
		length = function(tab)
			return #Spice.Table.toNumeralIndex(tab)
		end;
		reverse = function(tab)
			local new ={}
			for i,v in next,tab do
				table.insert(new,tab[#tab-i+1])
			end
			return new
		end;
		indexOf = function(tabl,val)
			return Spice.getArgument(3,Spice.Table.contains(tabl,val))
		end;
		valueOfNext = function(tab,nex)
			local i,v = next(tab,nex)
			return v
		end;
		find = function(tabl,this)
			return Spice.getArgument(2,Spice.Table.contains(tabl,this))
		end;
		search = function(tabl,this,extra)
			if not getmetatable(tabl) then setmetatable(tabl,{}) end
			local meta = getmetatable(tabl)
			if not meta['0US3D'] then
				meta['0US3D'] = {}
			end
			local used = meta['0US3D']
			local likely = {}
			if Spice.Table.find(used,this) then
				return unpack(Spice.Table.find(used,this))
			end		
			if Spice.Table.find(tabl,this) then
				used[this] = {Spice.Table.find(tabl,this)}
				return Spice.Table.find(tabl,this)
			end
			for i,v in next,tabl do
				if type(i) == 'string' or type(v) == 'string' then
					local subject = type(i) == 'string' and i or type(v) == 'string' and v
					local caps = Spice.Misc.stringFilterOut(subject,'%u',nil,false,true)
					local numc = caps..(subject:match('%d+$') or '')
					if subject:lower():sub(1,#this) == this:lower() or caps:lower() == this:lower() or numc:lower() == this:lower() then
						if not extra then
							used[this] = {v, i}
							return v, i
						end
						table.insert(likely,subject)
					end
				end
			end
			table.sort(likely,function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end);
			local resin = Spice.Table.indexOf(tabl,likely[1])
			local firstresult = tabl[resin]
			used[this] = {firstresult and firstresult or false, firstresult and Spice.Table.indexOf(tabl,firstresult), likely}
			return firstresult and firstresult or false, firstresult and Spice.Table.indexOf(tabl,firstresult), likely
		end;
		anonSetMetatable = function(tabl,set)
			local old = getmetatable(tabl)
			local new = Spice.Table.clone(setmetatable(tabl,set))
			setmetatable(tabl,old)
			return new
		end;
	};
	Util = {
		AutoUpdate = function(name,typ)
			local ret = false
			local file
			pcall( function()
				if not name then
					file = Spice.Util.gitFile(typ,'Spice')
				elseif name:lower() == 'all' then
					for i,v in next, Spice do
						if type(i) == 'string' and type(v) == 'table' then
							Spice.Util.AutoUpdate(i,typ)
						end
					end
				else
					file = Spice.Util.gitFile(typ,name)
				end
				
				file = file + ('\n return '..(name and name or 'Spice'))
				ret = file()
				if name then
					Spice[name] = ret
				end
			end)
			return ret
		end;
		gitFile = function(typ,...)
			local http
			local htt = not typ and game:GetService('HttpService').GetAsync or game.HttpGet
			function http(link)
				return htt(typ and htt or game:GetService('HttpService'),link)
			end	
			local directory = table.concat({...},'/')
			return setmetatable({Data = http('https://raw.githubusercontent.com/Karmaid/Spice/master/'..directory..'.lua')},{
				__call = function(self,...)
					return loadstring(self.Data)(...)
				end;
				__concat = function(a,b)
					return tostring(a)..tostring(b)
				end;
				__add = function(a,b)
					local val = type(a) == 'string' and a or type(b) == 'string' and b or ''
					local tab = type(a) ~= 'string' and a or type(b) ~= 'string' and b
					tab.Data = tab.Data..val
					return tab
				end;
				__tostring = function(self)
					return tostring(self.Data)
				end
			})
		end;
		getSpiceCompressed = function(upd,typ)
			local main = not upd and Spice or Spice.Util.AutoUpdate()
			local citrus = [[local Spice
	Spice = setmetatable({
		]]
			
		local rest = [[
		},{
		__index = function(self,nam)
			if rawget(self,nam) then
				return rawget(self,nam)
			end
			for i,v in next, self do
				if rawget(v,nam) then
					return rawget(v,nam)
				end
			end
		end
	})
	table.sort(getmetatable(Spice.Properties).RobloxAPI,function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end);
		]]
			for i,v in next,main do
				if type(i) == 'string' and type(v) == 'table' then
					citrus = citrus..string.gsub(''..Spice.Util.gitFile(typ,i),'\n','\n\t')
				end
			end
			return citrus..rest
		end;
	};
	Settings = setmetatable({
		getDefault = function(classname)
			for i,v in next, getmetatable(Spice.Settings).Default do
				if Spice.Instance.isA(classname,i) or classname == i then
					return v
				end
			end
		end;
		setDefault = function(classname,properties)
			getmetatable(Spice.Settings).Default[classname] = properties;
		end;
		newList = function(name)
			getmetatable(Spice.Settings).Settings[name] = {};
		end;
		getList = function(name)
			local settings = getmetatable(Spice.Settings).Settings
			return not name and settings.MAIN or settings[name]
		end;
		new = function(list,name,object,index,defaultval,...)
			local list = Spice.Settings.getList(list)
			local setting = setmetatable({[object] = index, Default = defaultval;
				Set = function(self,newval)
					self.Value = newval
				end;
				toDefault = function(self)
					self:Set(self.Default or self.Value)
				end;
			},	{
					Storage = {...};
					Value = defaultval or object[index];
					__tostring = function(self)
						return ''..getmetatable(self).Value
					end;
					__index = function(self,a)
						if a == 'Value' then
							return getmetatable(self).Value
						elseif a == 'Storage' then
							return getmetatable(self).Storage
						end
					end;
					__newindex = function(self,a,new)
						if a == 'Value' then
							object[index] = new
							rawset(getmetatable(self),a,new)
						elseif a == 'Storage' then
							rawset(getmetatable(self),a,new)
						end
					end;
				}
			)
			if type(object[index]) == 'boolean' then
				function setting:Toggle()
					if setting.Value then
						setting:Set(false)
					else
						setting:Set(true)
					end
				end
			end
			object:GetPropertyChangedSignal(index):connect(function()
				setting:Set(object[index])
			end)	
			list[name] = setting
			return setting
		end;
		getSetting = function(name,list)
			if list then return Spice.Table.find(Spice.Settings.getList(list),name) end
			for i,v in next, getmetatable(Spice.Settings).Settings.MAIN do
				if i == name then
					return v
				end
			end
		end;
		setSetting = function(name,newval,list)
			Spice.Settings.getSetting(name,list and list or nil):Set(newval)
		end;
		Sync = function(self)
			for _,list in next, getmetatable(self).Settings do
				for name, setting in next, list do
					setting:Set(setting.Value)
				end
			end
		end;
		},{
		Default = {};
		Settings = {
			MAIN = {};
		};
	});
	Theming = setmetatable({
		new = function(name,...)
			local vals = {...}
			local th = getmetatable(Spice.Theming).Themes
			th[name] = { Values = vals, Objects = {} }
		end;
		getTheme = function(name)
			return getmetatable(Spice.Theming).Themes[name]
		end;
		getObjects = function(name,obj)
			return obj and Spice.Theming.getTheme(name).Objects[obj] or Spice.Theming.getTheme(name).Objects
		end;
		getValues = function(name,index)
			return not index and Spice.Theming.getTheme(name).Values or Spice.Theming.getTheme(name).Values[index]
		end;
		setTheme = function(name,...)
			Spice.Theming.getTheme(name).Values = {...}
			Spice.Theming.syncTheme(name)
		end;
		setValue = function(name,to,index)
			Spice.Theming.getValues(name)[index or 1] = to
			Spice.Theming.syncTheme(name)
		end;
		setObjects = function(name,...)
			Spice.Theming.getTheme(name).Objects = {}
			Spice.Theming.insertObjects(...)
		end;
		insertObject = function(name,obj,...)
			obj = Spice.Instance.getInstanceOf(obj)
			Spice.Theming.getObjects(name)[obj] = {}
			local ob = Spice.Theming.getObjects(name)[obj]
			local args = {...}
			local count = 1
			for i,val in next,args do
				if type(val) == 'string' and i == count and Spice.Properties.hasProperty(obj,Spice.Properties[val]) then
					count = count + 1
					val = Spice.Properties[val]
					Spice.Theming.insertProperty(name,obj,val,type(args[count]) == 'number' and args[count] or nil)
					if type(args[count]) == 'number' then
						count = count + 1
					end
				end				
			end
		end;
		insertProperty = function(name,obj,prop,index)
			obj = Spice.Instance.getInstanceOf(obj)
			local objs = Spice.Theming.getObjects(name,obj)
			objs[prop] = index or 1
			obj[prop] = Spice.Theming.getValues(name,index or 1)
		end;
		insertObjects = function(name,...)
			for i,v in next,{...} do
				Spice.Theme.insertObject(name,unpack(type(v) == 'table' and v and v or {v}))
			end
		end;
		syncTheme = function(name)
			for i,theme in next, name and {Spice.Theming.getTheme(name)} or getmetatable(Spice.Theming).Themes do
				local val,objs = theme.Values,theme.Objects
				for obj, data in next, objs do
					for prop,index in next,data do
						obj[prop] = val[index]
					end
				end
			end
		end;
	},{
		Themes = {};
	});
	Instance = setmetatable({
		newClass = function(name,funct)
			local self = Spice.Instance
			local pt = Spice.Table
			getmetatable(self).Classes[name] = setmetatable({funct,Objects = {}},{
					__call = function(self,...)
						return self[1](...)
					end;
					__index = function(self,ind)
						return pt.contains(self.Objects,ind)
					end;
				})
		end;
		isA = function(is,a)
			local self = Spice.Instance
			if self.isAClass(is) then
				is = Instance.new(is)
				return is:IsA(a)
			end
			return false
		end;
		isAClass = function(is,custom)
			if pcall(function() return Instance.new(is) end) or custom and getmetatable(Spice.Instance).Classes[is] then
				return true
			else
				return false
			end
		end;
		newPure = function(class,...)
			local args = {...}
			if type(args[#args]) ~= 'table' then
				table.insert(args,{})
			end
			table.insert(args[#args],true)
			return Spice.Instance.new(class,unpack(args))
		end;
		new = function(class,...)
			local self = Spice.Instance
			local pt = Spice.Table
			local args,storage,new,parent,properties = {...},getmetatable(self).Classes
			if typeof(args[1]) == 'Instance' or self.isAnObject(args[1]) then
				parent = self.getInstanceOf(args[1])
				table.remove(args,1)
			end
			if type(args[#args]) == 'table' then
				properties = args[#args]
				table.remove(args,#args)
			end
			new = pt.find(storage,class) and pt.find(storage,class)(unpack(args)) or Instance.new(class)
			new.Parent = parent
			local a = next(properties or {})
			if type(a) ~= 'number' then
				Spice.Properties.setPropertiesToDefault(new)
			else
				table.remove(properties,a)
			end		
			Spice.Properties.setProperties(new,properties or {})
			return new
		end;
		newInstance = function(class,parent,props)
			local new = Instance.new(class)
			local parent = Spice.Instance.getInstanceOf(parent)
			props = props or type(parent) == 'table' and parent
			parent = type(parent) ~= 'table' and parent or nil
			local a = next(props or {})
			return Spice.Properties.setProperties(Instance.new(class,parent),props or {})
		end;
		newObject = function(...)
			local function insert(who)
				rawset(getmetatable(Spice.Instance).Objects,who.Instance,who)
			end
			local args,obj,class,parent,props = {...},{}
			for i,v in next,args do
				class = type(v) == 'string' and Spice.Instance.isAClass(v) and v or class
				parent = typeof(v) == 'Instance' and v or parent
				props = type(v) == 'table' and Spice.Table.length(obj) > 0 and v or props
				obj = type(v) == 'table' and Spice.Table.length(obj) == 0 and v or obj
			end
			local ins = Spice.Instance.newInstance(class,parent,props)
			local new = {Instance = ins,Object = obj}
			local newmeta = {
				Properties = {Index = {}, NewIndex = {}};
				__index = function(self,ind)
					local pro = getmetatable(self).Properties
					if Spice.Table.contains(pro.Index,ind) then
						local ret = Spice.Table.find(pro.Index,ind)
						return type(ret) ~= 'function' and ret or ret(self)
					elseif Spice.Table.contains(self.Object,ind) or not Spice.Properties.hasProperty(self.Instance,ind) then
						return Spice.Table.find(self.Object,ind)
					elseif Spice.Properties.hasProperty(self.Instance,ind) then
						return self.Instance[Spice.Properties[ind]]
					end
				end;
				__newindex = function(self,ind,new)
					local pro = getmetatable(self).Properties
					if Spice.Table.contains(pro.NewIndex,ind) then
						Spice.Table.find(pro.NewIndex,ind)(self,new)
					elseif Spice.Table.contains(self.Object,ind) or not Spice.Properties.hasProperty(self.Instance,ind) or type(new) == 'function' then
						rawset(self.Object,ind,new)
					elseif Spice.Properties.hasProperty(self.Instance,ind) then
						self.Instance[Spice.Properties[ind]] = new
					end
				end;
				__call = function(self,prop)
					Spice.Properties.setProperties(self.Instance,prop)
				end;
			}
			function new:Index(name,what)
				rawset(getmetatable(self).Properties.Index,name,what)
			end;
			function new:NewIndex(name,what)
				if type(what) == 'function' then
					rawset(getmetatable(self).Properties.NewIndex,name,what)
				end
			end;
			function new:Clone(parent,prop)
				return Spice.cloneObject(self,parent,prop)
			end;
			setmetatable(new,newmeta)
			insert(new)
			return new
		end;
		cloneObject = function(obj,parent,prop)
			local ins = obj.Instance:Clone()
			ins.Parent = parent
			local clone = Spice.Table.clone(obj)
			clone.Instance = ins
			Spice.setProperties(clone.Instance, prop and prop or {})
			rawset(getmetatable(Spice.Instance).Objects,clone.Instance,clone)
			return clone
		end;
		getInstanceOf = function(who)
			local self = getmetatable(Spice.Instance).Objects
			return Spice.Table.indexOf(self,who) or who
		end;
		getObjectOf = function(who)
			local self = getmetatable(Spice.Instance).Objects
			return Spice.Table.find(self,who) or nil
		end;
		isAnObject = function(who)
			return Spice.Instance.getObjectOf(who) and true or false
		end;
		getAncestors = function(who)
			local anc = {game}
			who = Spice.Instance.getInstanceOf(who)
			local chain = Spice.Misc.stringFilterOut(who:GetFullName(),'%.','game',nil,true)
			local ind = game
			for i,v in next,chain do
				ind = ind[v]
				table.insert(anc,ind)
			end
			return Spice.Table.pack(Spice.Table.reverse(anc),2)
		end;
	},{
		Classes = {};
		Objects = {};
	});
		},{
	__index = function(self,nam)
		if rawget(self,nam) then
			return rawget(self,nam)
		end
		for i,v in next, self do
			if rawget(v,nam) then
				return rawget(v,nam)
			end
		end
	end
})
table.sort(getmetatable(Spice.Properties).RobloxAPI,function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end);
	