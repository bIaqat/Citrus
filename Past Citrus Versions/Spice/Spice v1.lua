local Spice
Spice = setmetatable({
	Tweening = {
		new = function(what,prop,to,...)
			if type(what) == 'table' and type(what[1]) == 'userdata' then
				local data = {}
				for i,what in next,what do
					data[i] = Spice.Tweening.new(what,prop,to,...)
				end
				return data
			end
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
		tweenGuiObject = function(object,typ,...)
			typ = typ:lower()
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
		rotate = function(object, to, timer)
			object = Spice.Instance.getInstanceOf(object)
			Spice.Tweening.new(object, 'Rotation', to, timer)
		end
	};
	Misc = {
		getTextSize = function(text)
			if type(text) == 'string' then
				text = Spice.Instance.new("TextLabel",{Text = text})
			end
			return game:GetService("TextService"):GetTextSize(text.Text,text.TextSize,text.Font,text.AbsoluteSize)
		end;
		getPlayer = function(speaker, ...)
			local players = setmetatable({},{
				__call = function(self, plr)
					if not Spice.Table.contains(self,plr) then
						table.insert(self,plr)
					end
				end
			})
			local gp = game:GetService("Players")
			for _,v in next, {...} do
				if v == 'all' then
					for _,plr in next, gp:GetPlayers() do
						players(plr)
					end
				elseif v == 'others' then
					for _, plr in next, gp:Players() do
						if plr ~= speaker then
							players(plr)
						end
					end
				elseif v == 'me' then
					players(speaker)
				else
					local results = Spice.Table.search(gp:GetPlayers(), v, true, true)
					for i, plr in next, results do
						print(typeof(plr), plr, typeof(Spice.Table.search(gp:GetPlayers(), v)))
						players(plr)
					end
				end
			end
			return setmetatable(players,{__call = function(self, func) for i,v in next,self do func(v) end end})
		end;
		doAfter = function(wai,fun,...)
			local args = {...}
			spawn(function()
				wait(wai)
				do fun(unpack(args)) end
			end)
		end;
		runTimer = function()
			return setmetatable({startTime = 0,running = false},{
				__call = function(self,start)
					local gettime
					if start or not self.running then
						self.running = true
						self.startTime = tick()
						return true, tick()
					else
						self.running = false
						gettime = tick() - self.startTime
						self.startTime = 0
					end
					return gettime or self.startTime
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
		dynamicProperty = function(obj,to)
			obj = Spice.Instance.getInstanceOf(obj)
			if obj.ClassName:find'Text' then
				return 'Text'
			elseif obj.ClassName:find'Image' then
				return 'Image'
			end
			return 'Background'..to or ''
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
			if type(icon) == 'number' then local tempi = Instance.new("ImageLabel") tempi.Image = 'rbxassetid://'..icon icon = tempi end
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
			local props
			for i,v in next,{...} or {} do
				if type(v) == 'table' then props = v else
				v = v:sub(1,1):upper()..v:sub(2)
				index = index[v]
				end
			end
			local icon = Spice.Table.search(index,name)
			local times = 3
			repeat times = times - 1
			if type(icon) == 'table' then
				_, icon = next(icon)
			end
			until times == 0 or type(icon) == 'userdata'
			return props and Spice.Properties.setProperties(icon:Clone(), props) or icon:Clone() or nil
		end;		
		getIconData = function(...)
			local i = Spice.Iconography.new(...)
			return {Image = i.Image, ImageRectSize = i.ImageRectSize, ImageRectOffset = i.ImageRectOffset}
		end;
		newButton = function(...)
			local args, props = {}
			for i,v in next, {...} do
				if type(v) == 'table' then props = v else
					table.insert(args,v)
				end
			end
			local i = Spice.Table.merge(Spice.Iconography.getIconData(unpack(args)), props)
			return Spice.Instance.newInstance('ImageButton',i)
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
					nc[i] = args[i] and args[i] or nc[i]
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
			local set = type(id) == 'string' and Spice.Color.getColorSet(name,id,...) or Spice.Color.getColorSet(name,...)
			return set and set[type(id) == 'number' and id or next(set)]
		end;
		getColorSet = function(name,...)
			local set = {}
			local index = getmetatable(Spice.Color).Colors
			for i,v in next,{...} do
				index = Spice.Table.search(index,v)
			end
			local col = index[name]	
			for i,v in next, col do
				if typeof(v) == 'Color3' then
					set[i] = v
				end
			end
			return set	
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
				if type(i) == 'number' then
					for i,v in next, v do
						if Spice.Instance.isA(classname,i) or classname == i or (i == 'GuiText' and classname:find'Text') then
							table.insert(def,Spice.Table.clone(v))
						end
					end
				else
					if Spice.Instance.isA(classname,i) or classname == i or (i == 'GuiText' and classname:find'Text') then
						table.insert(def,Spice.Table.clone(v))
					end					
				end
			end
			for i = 2,#def do
				def[1] = Spice.Table.mergeTo(def[i],def[1])
			end
			return def[1]
		end;
		setDefault = function(classname,properties,arch)
			if arch then
				local d = getmetatable(Spice.Properties).Default
				if not d[arch] then
					d[arch] = {[classname] = properties}
				else
					d[arch][classname] = properties
				end
			else
				getmetatable(Spice.Properties).Default[classname] = properties
			end
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
							if self[i]:lower() == 'all' or indexed:IsA(self[i]) or (self[i] == 'GuiText' and indexed.ClassName:find'Text') then
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
			local vanil = who
			who = Spice.Instance.getInstanceOf(who)
			local c = getmetatable(Spice.Properties).Custom
			for i,v in next,props do
				local hasnormal, hassub =  pcall(function() return vanil[i] and true or false end),pcall(function() return vanil[Spice.Properties[i]] and true or false end)
				if type(i) == 'string' then
					local custom,cargs, normal
					if c[i] and c[i][who] then
						cargs = v
						if type(cargs) ~= 'table' then cargs = {cargs} end
						custom = c(i)
					end
					if Spice.Properties[i]:find'Color3' and (type(v) == 'string' or type(v) == 'table') then
						v = type(v) == 'table' and v or {v}
						Spice.Theming.insertObject(v[1],vanil,Spice.Properties[i],unpack(Spice.Table.pack(v,2) or {}))
					elseif hasnormal or hassub then
						local normal
						if hasnormal then
							normal = i
						else
							normal = Spice.Properties[i]
						end
						if custom and custom <= normal then
							c[i](who,unpack(cargs))
						else
							pcall(function() vanil[normal] = v end)
						end
					elseif custom then
						c[i](who,unpack(cargs))
					end
				end
			end
			return vanil
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
		__call = function(self,ind)
			return Spice.Table.search(getmetatable(self).RobloxAPI,ind)
		end;
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
	Positioning = {
		new = function(...)
			local args = {...}
			if #args == 4 or (typeof(args[1]) == 'UDim' or typeof(args[2]) == 'UDim')  then
				return UDim2.new(unpack(args))
			else
				local a,b  = args[1], args[3] == nil and args[1] or args[2]
				return Spice.Misc.switch(UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)):Filter('s','o','b','so','os')(args[3] or args[2] or 1)
			end
		end;
		fromUDim = function(a,b)
			return Spice.Misc.switch(UDim.new(a,b), UDim.new(a,a))(b and 1 or 2)
		end;
		fromVector2 = function(a,b)
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
		mergeTo = function(from,to)
			for i,v in next, from do
				to[i] = v
			end
			return to
		end;
		merge = function(a,b)
			local a,b = Spice.Table.clone(a), Spice.Table.clone(b)
			return Spice.Table.mergeTo(b,a)
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
					clone[i] = Spice.Instance.getObjectOf(v) or v
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
			return Spice.Misc.getArgument(3,Spice.Table.contains(tabl,val))
		end;
		valueOfNext = function(tab,nex)
			local i,v = next(tab,nex)
			return v
		end;
		find = function(tabl,this)
			return Spice.Misc.getArgument(2,Spice.Table.contains(tabl,this))
		end;
		search = function(tabl,this,extra,keep)
			if not getmetatable(tabl) then setmetatable(tabl,{}) end
			local meta = getmetatable(tabl)
			if not meta['0US3D'] then
				meta['0US3D'] = {}
			end
			local used = meta['0US3D']
			local likely = {}
			if used[this] then
				return unpack(used[this])
			end
			if Spice.Table.contains(tabl,this) then
				local found = Spice.Table.find(tabl,this)
				if not extra then used[this] = {found} return found end
				table.insert(likely, found)
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
						table.insert(likely,v)
					end
				end
			end
			table.sort(likely,function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end);
			local resin = Spice.Table.indexOf(tabl,likely[1])
			local firstresult = tabl[resin]
			used[this] = {keep and #likely > 0 and likely or firstresult and firstresult or false, firstresult and Spice.Table.indexOf(tabl,firstresult), likely}
			return keep and #likely > 0 and likely or firstresult and firstresult or false, firstresult and Spice.Table.indexOf(tabl,firstresult), likely
		end;
		anonSetMetatable = function(tabl,set)
			local old = getmetatable(tabl)
			local new = Spice.Table.clone(setmetatable(tabl,set))
			setmetatable(tabl,old)
			return new
		end;
	};
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
			new.Parent = parent or new.Parent
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
			local ins = Spice.Instance.newInstance(class,parent)
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
			Spice.Properties.setProperties(new,props)
			return new
		end;
		clone = function(ins,parent,prop)
			if type(ins) == 'table' then
				return Spice.Instance.cloneObject(ins,parent,prop)
			else
				local clone = ins:Clone()
				clone.Parent = typeof(parent) == 'Instance' and parent or nil
				Spice.Properties.setProperties(clone, prop or type(parent) == 'table' or {})
				return clone
			end
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
	Theming = setmetatable({
		new = function(name,...)
			local theme = {
				AutoSync = true;
				Name = name;
				Values = setmetatable({...},{
					__call = function(self,index,typ)
						local vals = typ and {} or self
						if typ then
							for i,v in next, self do
								if type(v) == typ then
									table.insert(vals,v)
								end
							end
						end
						return vals[index or 1], vals
					end;
				});
				Objects = {};
				Set = function(self,...)
					Spice.Theming.setTheme(self,...)
				end;
				Insert = function(self,...)
					Spice.Theming.insertObject(self,...)
				end;
				Sync = function(self,...)
					Spice.Theming.sync(self,...)
				end;
			}
			getmetatable(Spice.Theming).Themes[name] = theme
			return theme
		end;
		getTheme = function(name,index,typ)
			local theme = type(name) == 'table' and name or type(name) == 'string' and getmetatable(Spice.Theming).Themes[name]
			return index and theme.Values(index,typ) or theme
		end;
		setTheme = function(name,...)
			local theme = type(name) == 'table' and name or Spice.Theming.getTheme(name)
			local args = {...}
			if #args == 2 and type(args[2]) == 'number' then
				theme.Values[args[2]] = args[1]
			else
				theme.Values = setmetatable({...},getmetatable(theme.Values))
			end
			local run = theme.AutoSync and theme:Sync()
		end;
		insertObject = function(name,obj,prop,ind)
			local theme = type(name) == 'table' and name or Spice.Theming.getTheme(name)
			local value = theme.Values(ind,type(obj[prop]))
			if not Spice.Instance.isAnObject(obj) then
				prop = Spice.Properties[prop]
			end
			if not theme.Objects[obj] then
				theme.Objects[obj] = {}
			end
			theme.Objects[obj][prop] = ind or 1
			obj[prop] = theme.AutoSync and value or obj[prop]
		end;
		sync = function(name,lerp,tim,...)
			if not name then
				for i,v in next, getmetatable(Spice.Theming).Themes do
					Spice.Theming.sync(v)
				end
			else
				name = type(name) == 'table' and name or Spice.Theming.getTheme(name)
				for obj,v in next, name.Objects do
					for prop,ind in next, v do
						local value = name.Values(ind,type(obj[prop]))
						if not lerp then
							obj[prop] = value
						else
							Spice.Tweening.new(obj,prop,value,tim or 1,...)
						end
					end
				end
			end
		end
	},{
		Themes = {};
	});
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

local appleGlyphsPart1 = {
	'iOS11_About','iOS11_Add User','iOS11_Address Book','iOS11_Advertising', 'iOS11_Air Play', 'iOS11_Airdrop','iOS11_Airplane Mode On', 'iOS11_Albums', 'iOS11_Attention', 'iOS11_Apple';
	'iOS11_Alarm Clock', 'iOS11_Approval', 'iOS11_Attach', 'iOS11_Bar Chart', 'iOS11_Bank Cards', 'iOS11_Bank Card Back', 'iOS11_Audio', 'iOS11_Ball Point Pen', 'iOS11_Automation', 'iOS11_Book';
	'iOS11_Calendar', 'iOS11_Businessman', 'iOS11_Browse Podcasts', 'iOS11_Briefcase', 'iOS11_Bookmark', 'iOS11_Box', 'iOS11_Bookmark Ribbon', "Bell", 'iOS11_Bed', 'iOS11_Buy';
	'iOS11_Cell Phone', 'iOS11_Camera', 'iOS11_Car', 'iOS11_Cancel', 'iOS11_Calculator', 'iOS11_Cellular Network', 'iOS11_Chat', 'iOS11_Circled Play', 'iOS11_Checked', 'iOS11_Checked Checkbox';
	'iOS11_Contact Card', 'iOS11_Compass', 'iOS11_Compact Camera', 'iOS11_Computer', 'iOS11_Comments', 'iOS11_Combo Chart', 'iOS11_Collaboartion', 'iOS11_Clock', 'iOS11_Coins', 'iOS11_Cloud';
	'iOS11_Download', 'iOS11_Documents', 'iOS11_Define Location', 'iOS11_Decline', 'iOS11_Delivery', 'iOS11_Database', 'iOS11_Create New', 'iOS11_Conference', 'iOS11_Copy', 'iOS11_Document';
	'iOS11_Filter', 'iOS11_Folder', 'iOS11_Flash Light', 'iOS11_Facebook', 'iOS11_Face ID', 'iOS11_File', 'iOS11_Exit', 'iOS11_Duplicate', 'iOS11_Worldwide Location', 'iOS11_Error';
	'iOS11_Dashboard', 'iOS11_Following', 'iOS11_For You', 'iOS11_Gallery', 'iOS11_Geo Fence', 'iOS11_Globe', 'iOS11_Genuis', 'iOS11_Game Controller', 'iOS11_Contacts', 'iOS11_Globe Earth';
	'iOS11_Gift', 'iOS11_Hand Cursor', 'iOS11_Graduation Cap', 'iOS11_Health Data', 'iOS11_Happy', 'iOS11_Health Sources', 'iOS11_Handshake', 'iOS11_Help', 'iOS11_Heart', 'iOS11_High Battery';
	'iOS11_Instagram', 'iOS11_Invisible', 'iOS11_Investment', 'iOS11_Image File', 'iOS11_Idea', 'iOS11_Info', 'iOS11_Home Automation', 'iOS11_Home', 'iOS11_High Priority', 'iOS11_iPhone';
}
local appleGlyphsPart2 = {
	'iOS11_iPhone X', 'iOS11_Key', 'iOS11_Layers', 'iOS11_Keypad', 'iOS11_Laptop', 'iOS11_Link', 'iOS11_List', 'iOS11_Lock', 'iOS11_Literature', 'iOS11_Line Chart';
	'iOS11_Lock Orientation', 'iOS11_Moon Symbol', 'iOS11_Money Bag', 'iOS11_Monitor', 'iOS11_Money Box', 'iOS11_Minus', 'iOS11_Microphone', 'iOS11_Money', 'iOS11_Message', 'iOS11_Menu';
	'iOS11_Memories', 'iOS11_Marker', 'iOS11_Meeting', 'iOS11_Medical ID', 'iOS11_Map', 'iOS11_Maintenance', 'iOS11_Map Marker', 'iOS11_Paper Plane', 'iOS11_Paper Money', 'iOS11_Order';
	'iOS11_Ok', 'iOS11_Open', 'iOS11_Online Support', 'iOS11_News', 'iOS11_Musical Notes', 'iOS11_Note', 'iOS11_Music Library', 'iOS11_Movie', 'iOS11_Resturant', 'iOS11_Report Card';
	'iOS11_Refresh', 'iOS11_Product', 'iOS11_Radio Waves', 'iOS11_QR Code', 'iOS11_Price Tag', 'iOS11_Plus', 'iOS11_Print', 'iOS11_Play', 'iOS11_Planner', 'iOS11_Pie Chart';
	'iOS11_People', 'iOS11_Picture', 'iOS11_Phone', 'iOS11_PDF', 'iOS11_Password', 'iOS11_Pencil', 'iOS11_Search', 'iOS11_Server', 'iOS11_Security Checked', 'iOS11_Save';
	'iOS11_Rocket', 'iOS11_Screenshot', 'iOS11_Shopping Cart', 'iOS11_Shopping Bag', 'iOS11_Shopping Cart Loaded', 'iOS11_Shop', 'iOS11_Settings', 'iOS11_Services', 'iOS11_SMS', 'iOS11_Star';
	'iOS11_Stack of Photos', 'iOS11_Spotlight', 'iOS11_Shutdown', 'iOS11_Speech Bubble', 'iOS11_Support', 'iOS11_Thumbs Up', 'iOS11_Synchronize', 'iOS11_Stopwatch', 'iOS11_Statistics', 'iOS11_Sun';
	'iOS11_Trash', 'iOS11_Truck', 'iOS11_Training', 'iOS11_Today Apps', 'iOS11_Timer', 'iOS11_Voicemail', 'iOS11_Wallet', 'iOS11_Visible', 'iOS11_Wallet App', 'iOS11_Wifi';
	'iOS11_Trophy', 'iOS11_Video Call', 'iOS11_User Male', 'iOS11_Videos Purchase', 'iOS11_User Group Mixed', 'iOS11_User Group Men', 'iOS11_US Dollar', 'iOS11_Twitter', 'iOS11_Upload', 'iOS11_Unlock';
}
local names = {
	 'gentle_about', 'gentle_accept database', 'gentle_add_column', 'gentle_add_database', 'gentle_add_image', 'gentle_add_row', 'gentle_address book';
	 'gentle_advance', 'gentle_advertising', 'gentle_alarm_clock', 'gentle_sorting_az','gentle_sorting_za','gentle_answers','gentle_approval','gentle_approve','gentle_chart_area';
	 'gentle_assistant', 'gentle_file_audio', 'gentle_automatic', 'gentle_automovitve', 'gentle_decision_bad', 'gentle_chart_bar', 'gentle_bearish', 'gentle_binoculars';
	 'gentle_biohazard', 'gentle_biomass', 'gentle_biotech', 'gentle_bookmark', 'gentle_briefcase', 'gentle_broken link', 'gentle_bullish', 'gentle_business', 'gentle_business contact';
	 'gentle_businessman', 'gentle_businesswoman', 'gentle_butting in', 'gentle_cable release', 'gentle_calculator', 'gentle_calendar', 'gentle_call transfer', 'gentle_callback', 'gentle_camcorder', 'gentle_camcorder pro';
	 'gentle_camera_camera','gentle_camera_addon','gentle_camera_identification','gentle_cancel','gentle_candle sticks','gentle_capacitor','gentle_cell phone','gentle_battery_charge','gentle_checkmark','gentle_circuit','gentle_clapperboard';
	 'gentle_clear flters','gentle_clock','gentle_rose', 'gentle_cloth','gentle_collaboration','gentle_arrow_collapse', 'gentle_collect', 'gentle_chart_combo','gentle_comments', 'gentle_camera_compact', 'gentle_conference call', 'gentle_contacts', 'gentle_copyleft','gentle_copyright';
	 'gentle_crystal oscillator','gentle_currency rxchange','gentle_cursor','gentle_customer support','gentle_dam','gentle_data_backup','gentle_data_configuration','gentle_data_encryption','gentle_data_protection','gentle_data_recovery','gentle_data_sheet';
	 'gentle_database','gentle_debt', 'gentle_decision_decision','gentle_delete_column','gentle_delete_database','gentle_delete_row','gentle_department','gentle_deployment','gentle_diploma_1','gentle_diploma_2','gentle_disapprove','gentle_disclaimer','gentle_dislike','gentle_display';
	 'gentle_do not_inhale','gentle_do not_insert','gentle_do not_mix','gentle_document','gentle_donate','gentle_chart_doughnut','gentle_arrow_down','gentle_arrow_down left','gentle_arrow_down right','gentle_download','gentle_edit image','gentle_electrical_sensor';
	 'gentle_electrical_threshold','gentle_electricity','gentle_electro devices','gentle_electronics','gentle_battery_empty', 'gentle_trash_empty','gentle_end call','gentle_engineering','gentle_entering heaven','gentle_arrow_expand','gentle_expired';
	 'gentle_export','gentle_external','gentle_factory','gentle_factory breakdown','gentle_faq','gentle_feed in','gentle_feedback','gentle_file_file','gentle_filing cabinet';
	 'gentle_filled filter', 'gentle_film_film','gentle_film_reel','gentle_filter','gentle_fine print','gentle_flash_auto','gentle_flash_off','gentle_flash_on','gentle_chart_flow','gentle_folder','gentle_frame';
	 'gentle_battery_full', 'gentle_trash_full','gentle_gallery', 'gentle_genealogy','gentle_sorting_longest','gentle_sorting_shortest','gentle_globe','gentle_decision_good','gentle_graduation cap';
	 'gentle_grid','gentle_headset','gentle_heat map','gentle_battery_high','gentle_high priority','gentle_home','gentle_icons8','gentle_idea','gentle_file_image','gentle_import','gentle_in transit','gentle_info';
	 'gentle_inspection','gentle_integrated webcam','gentle_internal','gentle_invite','gentle_ipad','gentle_iphone','gentle_key','gentle_kindle','gentle_landscape','gentle_leave','gentle_arrow_left','gentle_arrow_left down','gentle_arrow_left down curve','gentle_arrow_left up','gentle_arrow_left up curve';
	 'gentle_library','gentle_light at the end of tunnel','gentle_like_like','gentle_like_placeholder','gentle_chart_line','gentle_link','gentle_list','gentle_lock','gentle_landscape','gentle_portrait','gentle_battery_low','gentle_priority_low','gentle_decision_make','gentle_manager';
	 'gentle_priority_medium','gentle_menu','gentle_battery_middle','gentle_mind map','gentle_minus','gentle_missed call','gentle_mms','gentle_money transfer','gentle_multiple_cameras','gentle_multiple_devices','gentle_multiple_inputs','gentle_multiple_smartphones','gentle_music';
	 'gentle_negative dynamic','gentle_decision_neutral','gentle_neutral trading','gentle_news','gentle_arrow_next','gentle_night_landscape','gentle_night_portrait','gentle_no idea','gentle_no video','gentle_nook','gentle_sorting_123','gentle_sorting_321','gentle_ok','gentle_camera_old','gentle_online support','gentle_opened folder';
	 'gentle_org unit','gentle_organization','gentle_overtime','gentle_package','gentle_paid','gentle_panorama','gentle_parallel tasks','gentle_phone','gentle_android','gentle_photo reel','gentle_picture','gentle_chart_pie','gentle_planner','gentle_plus','gentle_podium_audience','gentle_podium_speaker','gentle_podium_no speaker','gentle_portrait mode','gentle_positive dynamic','gentle_arrow_previous';
	 'gentle_print','gentle_privacy','gentle_process','gentle_puzzel','gentle_questions','gentle_radar plot','gentle_rating','gentle_ratings','gentle_reading','gentle_reading ebook','gentle_redo','gentle_refresh','gentle_registered trademark','gentle_remove image','gentle_reuse','gentle_arrow_right','gentle_arrow_right down','gentle_arrow_right down curve','gentle_arrow_right up','gentle_arrow_right up curve';
	 'gentle_camera_rotate','gentle_to landscape','gentle_to portrait','gentle_ruler','gentle_rules','gentle_safe','gentle_sales performance','gentle_scatter plot','gentle_search','gentle_kiosk','gentle_slefie','gentle_serial tasks','gentle_service mark','gentle_services','gentle_settings','gentle_share','gentle_shipped','gentle_shop','gentle_signature';
	 'gentle_sim_card','gentle_sim_Card chip','gentle_slr back','gentle_tablet','gentle_sms','gentle_sound recording copyright','gentle_speaker','gentle_sports mode','gentle_multiple_photos','gentle_start','gentle_statistics','gentle_support','gentle_survey','gentle_camera_switch','gentle_synchornize','gentle_tablet andriod','gentle_template';
	 'gentle_timeline','gentle_todo lst','gentle_smartphone','gentle_trademark','gentle_tree structure','gentle_two smartphones','gentle_undo','gentle_unlock','gentle_arrow_up','gentle_arrow_up left','gentle_arrow_up right','gentle_upload','gentle_video call','gentle_file_video','gentle_video projector','gentle_view details','gentle_vip','gentle_voice presentation','gentle_voicemail','gentle_webcam','gentle_workflow'
}

Spice.Iconography.insertIconList('rbxassetid://1784678984',21, 15, 48, 48, names)
Spice.Iconography.insertIconList('rbxassetid://1574419350',10, 10, 90, 90, appleGlyphsPart1)
Spice.Iconography.insertIconList('rbxassetid://1573947013',10, 10, 90, 90, appleGlyphsPart2)

Spice.Color.fromMaterial = function(name,i,ac)
	local id = Spice.Misc.switch(1,2,3,4,5,6,7,8,9,10):Filter(unpack(Spice.Misc.switch({50,100,200,300,400,500,600,700,800,900},{100,200,400,700}):Filter(false,true)(Spice.Misc.exists(ac))))
	id = id(i or 500)
	return id and Spice.Color.getColor(name,id,'Material',ac and 'Accent')
end;

Spice.Color.insertColor('Red',{Spice.Color.fromRGB(255, 235, 238),Spice.Color.fromRGB(255, 205, 210),Spice.Color.fromRGB(239, 154, 154),Spice.Color.fromRGB(229, 115, 115),Spice.Color.fromRGB(239, 83, 80),Spice.Color.fromRGB(244, 67, 54),Spice.Color.fromRGB(229, 57, 53),Spice.Color.fromRGB(211, 47, 47),Spice.Color.fromRGB(198, 40, 40),Spice.Color.fromRGB(183, 28, 28),}, 'Material')
Spice.Color.insertColor('Pink',{Spice.Color.fromRGB(252, 228, 236),Spice.Color.fromRGB(248, 187, 208),Spice.Color.fromRGB(244, 143, 177),Spice.Color.fromRGB(240, 98, 146),Spice.Color.fromRGB(236, 64, 122),Spice.Color.fromRGB(233, 30, 99),Spice.Color.fromRGB(216, 27, 96),Spice.Color.fromRGB(194, 24, 91),Spice.Color.fromRGB(173, 20, 87),Spice.Color.fromRGB(136, 14, 79),}, 'Material')
Spice.Color.insertColor('Purple',{Spice.Color.fromRGB(243, 229, 245),Spice.Color.fromRGB(225, 190, 231),Spice.Color.fromRGB(206, 147, 216),Spice.Color.fromRGB(186, 104, 200),Spice.Color.fromRGB(171, 71, 188),Spice.Color.fromRGB(156, 39, 176),Spice.Color.fromRGB(142, 36, 170),Spice.Color.fromRGB(123, 31, 162),Spice.Color.fromRGB(106, 27, 154),Spice.Color.fromRGB(74, 20, 140),}, 'Material')
Spice.Color.insertColor('Deep purple',{Spice.Color.fromRGB(237, 231, 246),Spice.Color.fromRGB(209, 196, 233),Spice.Color.fromRGB(179, 157, 219),Spice.Color.fromRGB(149, 117, 205),Spice.Color.fromRGB(126, 87, 194),Spice.Color.fromRGB(103, 58, 183),Spice.Color.fromRGB(94, 53, 177),Spice.Color.fromRGB(81, 45, 168),Spice.Color.fromRGB(69, 39, 160),Spice.Color.fromRGB(49, 27, 146),}, 'Material')
Spice.Color.insertColor('Indigo',{Spice.Color.fromRGB(232, 234, 246),Spice.Color.fromRGB(197, 202, 233),Spice.Color.fromRGB(159, 168, 218),Spice.Color.fromRGB(121, 134, 203),Spice.Color.fromRGB(92, 107, 192),Spice.Color.fromRGB(63, 81, 181),Spice.Color.fromRGB(57, 73, 171),Spice.Color.fromRGB(48, 63, 159),Spice.Color.fromRGB(40, 53, 147),Spice.Color.fromRGB(26, 35, 126),}, 'Material')
Spice.Color.insertColor('Blue',{Spice.Color.fromRGB(227, 242, 253),Spice.Color.fromRGB(187, 222, 251),Spice.Color.fromRGB(144, 202, 249),Spice.Color.fromRGB(100, 181, 246),Spice.Color.fromRGB(66, 165, 245),Spice.Color.fromRGB(33, 150, 243),Spice.Color.fromRGB(30, 136, 229),Spice.Color.fromRGB(25, 118, 210),Spice.Color.fromRGB(21, 101, 192),Spice.Color.fromRGB(13, 71, 161),}, 'Material')
Spice.Color.insertColor('Light blue',{Spice.Color.fromRGB(225, 245, 254),Spice.Color.fromRGB(179, 229, 252),Spice.Color.fromRGB(129, 212, 250),Spice.Color.fromRGB(79, 195, 247),Spice.Color.fromRGB(41, 182, 246),Spice.Color.fromRGB(3, 169, 244),Spice.Color.fromRGB(3, 155, 229),Spice.Color.fromRGB(2, 136, 209),Spice.Color.fromRGB(2, 119, 189),Spice.Color.fromRGB(1, 87, 155),}, 'Material')
Spice.Color.insertColor('Cyan',{Spice.Color.fromRGB(224, 247, 250),Spice.Color.fromRGB(178, 235, 242),Spice.Color.fromRGB(128, 222, 234),Spice.Color.fromRGB(77, 208, 225),Spice.Color.fromRGB(38, 198, 218),Spice.Color.fromRGB(0, 188, 212),Spice.Color.fromRGB(0, 172, 193),Spice.Color.fromRGB(0, 151, 167),Spice.Color.fromRGB(0, 131, 143),Spice.Color.fromRGB(0, 96, 100),}, 'Material')
Spice.Color.insertColor('Teal',{Spice.Color.fromRGB(224, 242, 241),Spice.Color.fromRGB(178, 223, 219),Spice.Color.fromRGB(128, 203, 196),Spice.Color.fromRGB(77, 182, 172),Spice.Color.fromRGB(38, 166, 154),Spice.Color.fromRGB(0, 150, 136),Spice.Color.fromRGB(0, 137, 123),Spice.Color.fromRGB(0, 121, 107),Spice.Color.fromRGB(0, 105, 92),Spice.Color.fromRGB(0, 77, 64),}, 'Material')
Spice.Color.insertColor('Green',{Spice.Color.fromRGB(232, 245, 233),Spice.Color.fromRGB(200, 230, 201),Spice.Color.fromRGB(165, 214, 167),Spice.Color.fromRGB(129, 199, 132),Spice.Color.fromRGB(102, 187, 106),Spice.Color.fromRGB(76, 175, 80),Spice.Color.fromRGB(67, 160, 71),Spice.Color.fromRGB(56, 142, 60),Spice.Color.fromRGB(46, 125, 50),Spice.Color.fromRGB(27, 94, 32),}, 'Material')
Spice.Color.insertColor('Light green',{Spice.Color.fromRGB(241, 248, 233),Spice.Color.fromRGB(220, 237, 200),Spice.Color.fromRGB(197, 225, 165),Spice.Color.fromRGB(174, 213, 129),Spice.Color.fromRGB(156, 204, 101),Spice.Color.fromRGB(139, 195, 74),Spice.Color.fromRGB(124, 179, 66),Spice.Color.fromRGB(104, 159, 56),Spice.Color.fromRGB(85, 139, 47),Spice.Color.fromRGB(51, 105, 30),}, 'Material')
Spice.Color.insertColor('Lime',{Spice.Color.fromRGB(249, 251, 231),Spice.Color.fromRGB(240, 244, 195),Spice.Color.fromRGB(230, 238, 156),Spice.Color.fromRGB(220, 231, 117),Spice.Color.fromRGB(212, 225, 87),Spice.Color.fromRGB(205, 220, 57),Spice.Color.fromRGB(192, 202, 51),Spice.Color.fromRGB(175, 180, 43),Spice.Color.fromRGB(158, 157, 36),Spice.Color.fromRGB(130, 119, 23),}, 'Material')
Spice.Color.insertColor('Yellow',{Spice.Color.fromRGB(255, 253, 231),Spice.Color.fromRGB(255, 249, 196),Spice.Color.fromRGB(255, 245, 157),Spice.Color.fromRGB(255, 241, 118),Spice.Color.fromRGB(255, 238, 88),Spice.Color.fromRGB(255, 235, 59),Spice.Color.fromRGB(253, 216, 53),Spice.Color.fromRGB(251, 192, 45),Spice.Color.fromRGB(249, 168, 37),Spice.Color.fromRGB(245, 127, 23),}, 'Material')
Spice.Color.insertColor('Amber',{Spice.Color.fromRGB(255, 248, 225),Spice.Color.fromRGB(255, 236, 179),Spice.Color.fromRGB(255, 224, 130),Spice.Color.fromRGB(255, 213, 79),Spice.Color.fromRGB(255, 202, 40),Spice.Color.fromRGB(255, 193, 7),Spice.Color.fromRGB(255, 179, 0),Spice.Color.fromRGB(255, 160, 0),Spice.Color.fromRGB(255, 143, 0),Spice.Color.fromRGB(255, 111, 0),}, 'Material')
Spice.Color.insertColor('Orange',{Spice.Color.fromRGB(255, 243, 224),Spice.Color.fromRGB(255, 224, 178),Spice.Color.fromRGB(255, 204, 128),Spice.Color.fromRGB(255, 183, 77),Spice.Color.fromRGB(255, 167, 38),Spice.Color.fromRGB(255, 152, 0),Spice.Color.fromRGB(251, 140, 0),Spice.Color.fromRGB(245, 124, 0),Spice.Color.fromRGB(239, 108, 0),Spice.Color.fromRGB(230, 81, 0),}, 'Material')
Spice.Color.insertColor('Deep orange',{Spice.Color.fromRGB(251, 233, 231),Spice.Color.fromRGB(255, 204, 188),Spice.Color.fromRGB(255, 171, 145),Spice.Color.fromRGB(255, 138, 101),Spice.Color.fromRGB(255, 112, 67),Spice.Color.fromRGB(255, 87, 34),Spice.Color.fromRGB(244, 81, 30),Spice.Color.fromRGB(230, 74, 25),Spice.Color.fromRGB(216, 67, 21),Spice.Color.fromRGB(191, 54, 12),}, 'Material')
Spice.Color.insertColor('Brown',{Spice.Color.fromRGB(239, 235, 233),Spice.Color.fromRGB(215, 204, 200),Spice.Color.fromRGB(188, 170, 164),Spice.Color.fromRGB(161, 136, 127),Spice.Color.fromRGB(141, 110, 99),Spice.Color.fromRGB(121, 85, 72),Spice.Color.fromRGB(109, 76, 65),Spice.Color.fromRGB(93, 64, 55),Spice.Color.fromRGB(78, 52, 46),Spice.Color.fromRGB(62, 39, 35),}, 'Material')
Spice.Color.insertColor('Grey',{Spice.Color.fromRGB(250, 250, 250),Spice.Color.fromRGB(245, 245, 245),Spice.Color.fromRGB(238, 238, 238),Spice.Color.fromRGB(224, 224, 224),Spice.Color.fromRGB(189, 189, 189),Spice.Color.fromRGB(158, 158, 158),Spice.Color.fromRGB(117, 117, 117),Spice.Color.fromRGB(97, 97, 97),Spice.Color.fromRGB(66, 66, 66),Spice.Color.fromRGB(33, 33, 33),}, 'Material')
Spice.Color.insertColor('Blue grey',{Spice.Color.fromRGB(236, 239, 241),Spice.Color.fromRGB(207, 216, 220),Spice.Color.fromRGB(176, 190, 197),Spice.Color.fromRGB(144, 164, 174),Spice.Color.fromRGB(120, 144, 156),Spice.Color.fromRGB(96, 125, 139),Spice.Color.fromRGB(84, 110, 122),Spice.Color.fromRGB(69, 90, 100),Spice.Color.fromRGB(55, 71, 79),Spice.Color.fromRGB(38, 50, 56),}, 'Material')
Spice.Color.insertColor('Red',{Spice.Color.fromRGB(255, 138, 128),Spice.Color.fromRGB(255, 82, 82),Spice.Color.fromRGB(255, 23, 68),Spice.Color.fromRGB(213, 0, 0),}, 'Material', 'Accent')
Spice.Color.insertColor('Pink',{Spice.Color.fromRGB(255, 128, 171),Spice.Color.fromRGB(255, 64, 129),Spice.Color.fromRGB(245, 0, 87),Spice.Color.fromRGB(197, 17, 98),}, 'Material', 'Accent')
Spice.Color.insertColor('Purple',{Spice.Color.fromRGB(234, 128, 252),Spice.Color.fromRGB(224, 64, 251),Spice.Color.fromRGB(213, 0, 249),Spice.Color.fromRGB(170, 0, 255),}, 'Material', 'Accent')
Spice.Color.insertColor('Deep purple',{Spice.Color.fromRGB(179, 136, 255),Spice.Color.fromRGB(124, 77, 255),Spice.Color.fromRGB(101, 31, 255),Spice.Color.fromRGB(98, 0, 234),}, 'Material', 'Accent')
Spice.Color.insertColor('Indigo',{Spice.Color.fromRGB(140, 158, 255),Spice.Color.fromRGB(83, 109, 254),Spice.Color.fromRGB(61, 90, 254),Spice.Color.fromRGB(48, 79, 254),}, 'Material', 'Accent')
Spice.Color.insertColor('Blue',{Spice.Color.fromRGB(130, 177, 255),Spice.Color.fromRGB(68, 138, 255),Spice.Color.fromRGB(41, 121, 255),Spice.Color.fromRGB(41, 98, 255),}, 'Material', 'Accent')
Spice.Color.insertColor('Light blue',{Spice.Color.fromRGB(128, 216, 255),Spice.Color.fromRGB(64, 196, 255),Spice.Color.fromRGB(0, 176, 255),Spice.Color.fromRGB(0, 145, 234),}, 'Material', 'Accent')
Spice.Color.insertColor('Cyan',{Spice.Color.fromRGB(132, 255, 255),Spice.Color.fromRGB(24, 255, 255),Spice.Color.fromRGB(0, 229, 255),Spice.Color.fromRGB(0, 184, 212),}, 'Material', 'Accent')
Spice.Color.insertColor('Teal',{Spice.Color.fromRGB(167, 255, 235),Spice.Color.fromRGB(100, 255, 218),Spice.Color.fromRGB(29, 233, 182),Spice.Color.fromRGB(0, 191, 165),}, 'Material', 'Accent')
Spice.Color.insertColor('Green',{Spice.Color.fromRGB(185, 246, 202),Spice.Color.fromRGB(105, 240, 174),Spice.Color.fromRGB(0, 230, 118),Spice.Color.fromRGB(0, 200, 83),}, 'Material', 'Accent')
Spice.Color.insertColor('Light green',{Spice.Color.fromRGB(204, 255, 144),Spice.Color.fromRGB(178, 255, 89),Spice.Color.fromRGB(118, 255, 3),Spice.Color.fromRGB(100, 221, 23),}, 'Material', 'Accent')
Spice.Color.insertColor('Lime',{Spice.Color.fromRGB(244, 255, 129),Spice.Color.fromRGB(238, 255, 65),Spice.Color.fromRGB(198, 255, 0),Spice.Color.fromRGB(174, 234, 0),}, 'Material', 'Accent')
Spice.Color.insertColor('Yellow',{Spice.Color.fromRGB(255, 255, 141),Spice.Color.fromRGB(255, 255, 0),Spice.Color.fromRGB(255, 234, 0),Spice.Color.fromRGB(255, 214, 0),}, 'Material', 'Accent')
Spice.Color.insertColor('Amber',{Spice.Color.fromRGB(255, 229, 127),Spice.Color.fromRGB(255, 215, 64),Spice.Color.fromRGB(255, 196, 0),Spice.Color.fromRGB(255, 171, 0),}, 'Material', 'Accent')
Spice.Color.insertColor('Orange',{Spice.Color.fromRGB(255, 209, 128),Spice.Color.fromRGB(255, 171, 64),Spice.Color.fromRGB(255, 145, 0),Spice.Color.fromRGB(255, 109, 0),}, 'Material', 'Accent')
Spice.Color.insertColor('Deep orange',{Spice.Color.fromRGB(255, 158, 128),Spice.Color.fromRGB(255, 110, 64),Spice.Color.fromRGB(255, 61, 0),Spice.Color.fromRGB(221, 44, 0),}, 'Material', 'Accent')

local hsv,hex = Spice.fromHSV, Spice.fromHex

Spice.Color.insertColor('Red',{
	[-1] = hsv(358,65,100);
	[0] = hsv(358,71,100);
	[1] = hsv(358,76,93);
	[2] = hsv(357,83,82);
},'Citrus')
Spice.Color.insertColor('Red',{
	[-1] = hsv(359,30,100);
	[0] = hsv(359,47,100);
	[1] = hsv(358,59,100);
	[2] = hsv(358,50,91)
},'Citrus','Light')
Spice.Color.insertColor('Peach',{
	[-1] = hsv(3,65,100);
	[0] = hsv(3,71,100);
	[1] = hsv(2,76,93);
	[2] = hsv(3,83,82);
},'Citrus')
Spice.Color.insertColor('Peach',{
		[-1] = hsv(3,30,100);
		[0] = hsv(4,47,100);
		[1] = hsv(3,59,100);
		[2] = hsv(4,50,91)
},'Citrus','Light')
Spice.Color.insertColor('Orange',{
	[-1] = hsv(13,65,100);
	[0] = hsv(13,71,100);
	[1] = hsv(13,76,93);
	[2] = hsv(12,83,82);
},'Citrus')
Spice.Color.insertColor('Orange',{
		[-1] = hsv(14,30,100);
		[0] = hsv(13,47,100);
		[1] = hsv(13,59,100);
		[2] = hsv(14,50,91)
},'Citrus','Light')
Spice.Color.insertColor('Yellow',{
	[-1] = hsv(41,65,100);
	[0] = hsv(41,71,100);
	[1] = hsv(41,76,93);
	[2] = hsv(40,83,82);
},'Citrus')
Spice.Color.insertColor('Yellow',{
		[-1] = hsv(42,30,100);
		[0] = hsv(41,47,100);
		[1] = hsv(40,59,100);
		[2] = hsv(42,50,91)
},'Citrus','Light')
Spice.Color.insertColor('Lime',{
	[-1] = hex'AFEF51';
	[0] = hex'A4E542';
	[1] = hex'94D82F';
	[2] = hex'80C41B';
},'Citrus')
Spice.Color.insertColor('Lime',{
		[-1] = hex'DEFFB2';
		[0] = hex'CDFF87';
		[1] = hex'BFF76C';
		[2] = hex'B7EA75';
},'Citrus','Light')
Spice.Color.insertColor('Green',{
	[-1] = hsv(121,66,93);
	[0] = hsv(121,71,89);
	[1] = hsv(121,78,84);
	[2] = hsv(121,86,76);
	Light = {
		[-1] = hsv(122,30,100);
		[0] = hsv(122,47,100);
		[1] = hsv(121,56,96);
		[2] = hsv(123,50,91)
	};
},'Citrus')
Spice.Color.insertColor('Teal',{
	Light = {
		[-1] = hex'B8FEF6';
		[0] = hex'90FEF1';
		[1] = hex'78F6E7';
		[2] = hex'75EADF';
	};	
	[-1] = hex'5EEFDC';
	[0] = hex'51E6D2';
	[1] = hex'3ED8C4';
	[2] = hex'2CC6B1';			
},'Citrus')
Spice.Color.insertColor('Cyan',{
	Light = {
		[-1] = hex'B8FAFE';
		[0] = hex'90F9FE';
		[1] = hex'78F0F6';
		[2] = hex'75E2EA'
	};
	[-1] = hex'5EEAEF';
	[0] = hex'51E1E6';
	[1] = hex'3ED2D8';
	[2] = hex'2CC1C6';
},'Citrus')
Spice.Color.insertColor('Blue',{
	Light = {
		[2] = hsv(210,50,92);
		[-1] = hsv(209,30,100);
		[0] = hsv(209,47,100);
		[1] = hsv(207,59,100);
	};
	[-1] = hsv(208,65,100);
	[0] = hsv(208,71,100);
	[1] = hsv(207,76,93);
	[2] = hsv(208,83,82);
},'Citrus')
Spice.Color.insertColor('Naval coacoa',{
	Light = {
		[-1] = hsv(230,19,90);
		[0] = hsv(230,32,86);
		[1] = hsv(229,41,83);
		[2] = hsv(231,37,83)
	};
	[-1] = hsv(230,47,81);
	[0] = hsv(230,53,79);
	[1] = hsv(230,58,72);
	[2] = hsv(230,64,62);
},'Citrus')
Spice.Color.insertColor('Indigo',{
	Light = {
			[-1] = hsv(244,30,100);
			[0] = hsv(244,47,100);
			[1] = hsv(242,59,100);
			[2] = hsv(245,50,91)
		};
		[-1] = hsv(243,65,100);
		[0] = hsv(243,71,100);
		[1] = hsv(242,76,93);
		[2] = hsv(243,83,82);
},'Citrus')
Spice.Color.insertColor('Purple',{
	Light = {
		[-1] = hsv(261,30,100);
		[0] = hsv(261,47,100);
		[1] = hsv(259,59,100);
		[2] = hsv(261,50,91)
	};
	[-1] = hsv(260,65,100);
	[0] = hsv(260,71,100);
	[1] = hsv(259,76,93);
	[2] = hsv(260,83,82);
},'Citrus')
Spice.Color.insertColor('Pink',{
	Light = {
		[-1] = hsv(326,24,100);
		[0] = hsv(326,38,100);
		[1] = hsv(324,48,100);
		[2] = hsv(329,40,93)
	};
	[-1] = hsv(324,52,100);
	[0] = hsv(325,58,100);
	[1] = hsv(324,61,94);
	[2] = hsv(325,65,85);
},'Citrus')
Spice.Color.insertColor('Amaranth',{
	Light = {
		[-1] = hsv(345,28,100);
		[0] = hsv(345,44,100);
		[1] = hsv(343,55,100);
		[2] = hsv(346,45,92)
	};
	[-1] = hsv(344,61,100);
	[0] = hsv(344,67,100);
	[1] = hsv(344,72,94);
	[2] = hsv(344,77,83);	
},'Citrus')
Spice.Color.insertColor('Grey',{
	Light = {
		[-1] = hsv(0,0,98);
		[0] = hsv(0,0,96);
		[1] = hsv(0,0,87);
		[2] = hsv(0,0,80)			
	};
	Blue = {
		[-1] = hsv(219,21,36);
		[0] = hsv(219,25,34);
		[1] = hsv(220,25,27);
		[2] = hsv(218,25,21)				
	};
	Dark = {
		[-1] = hsv(0,0,25);
		[0] = hsv(0,0,21);
		[1] = hsv(0,0,12);
		[2] = hsv(0,0,2);			
	};
	[-1] = hsv(220,10,32);
	[0] = hsv(213,12,27);
	[1] = hsv(217,12,24);
	[2] = hsv(220,12,18);
},'Citrus')
Spice.Color.insertColor('Brown',{
	Light = {
		[-1] = hex'7B6C67';
		[0] = hex'745D56';
		[1] = hex'6F5149';
		[2] = hex'6A534C'			
	};
	[-1] = hex'6D4C43';
	[0] = hex'6B463C';
	[1] = hex'623D33';
	[2] = hex'543127'	
},'Citrus')

function citrusColor(name,main,inverse,...)
	local alias = {...}
	for i,v in pairs(main)do
		main[i] = Spice.Color.fromHex(v)
	end
	local inv = {}
	for i,v in pairs(inverse)do
		inverse[i] = Spice.Color.fromHex(v)
		inv[#inverse-i+1] = inverse[i]
	end
	local new = main
	main.Inverse = inv
	Spice.Color.insertColor(name,new,'CitrusV4')
end

citrusColor('Ruby',{'EA8A97';
				'E06071';
				'CF3F4E';
				'C43140';
				'9E1F2C';
				'891A27';
				'77111F';}, {'EE8896';
						'E57683';
						'E0616E';
						'CE3B4A';
						'C0303F';
						'9F1F30';
'751522';},'Royale ruby','Brick red')
citrusColor('Red',{'EA8B8A','E06260','CF463F','C43831','9E251F','891E1A','771211'},
	{'EE8988','E57A76','E06761','CE423B','C03730','9F211F','751615'},'Mahogany'
)
citrusColor('Deep orange',{'EA958A','E06F60','CF543F','C44731','9E321F','89291A','771D11'},
	{'EE9488','E58576','E07461','CE513B','C04530','9F2E1F','752015'},'Peach','Mojo'
)
citrusColor('Orange',{'EAA58A','E08460','CF6C3F','C45F31','9E471F','893B1A','772E11'},
	{'EEA588','E59776','E08961','CE693B','C05D30','9F431F','753015'},'Raw sienna','Tuscany'
)
citrusColor('Yellow',{'EAC58A','E0AF60','CF9C3F','C49031','9E711F','89601A','775011'},
	{'EEC788','E5BC76','E0B361','CE9A3B','C08D30','9F6E1F','755015'},'Gold'
)
citrusColor('Lime',{'C7EA8A','B1E060','96CF3F','8AC431','6C9E1F','5F891A','527711'},
	{'C9EE88','BBE576','AEE061','94CE3B','87C030','709F1F','527515'}, 'Pear','Atlantis'
)
citrusColor('Mint',{'8AEABD','60E0A4','3FCF90','31C484','1F9E67','1A8957','117747'},
	{'88EEBE','76E5B3','61E0A9','3BCE8E','30C081','1F9F63','157548'},'Jade','Shamrock','Jewel'
)
citrusColor('Green',{'8AEA95','60E06F','3FCF54','31C447','1F9E32','1A8929','11771D'},
	{'88EE94','76E585','61E074','3BCE51','30C045','1F9F2E','157520'},'Apple','Emerald'
)
citrusColor("Teal",{'8AEADD','60E0CF','3FCFC0','31C4B5','1F9E91','1A897C','117769'},
	{'88EEE0','76E5D8','61E0D3','3BCEBF','30C0B1','1F9F8E','157568'},'Aquamarine'
)
citrusColor("Cyan",{'8ADFEA','60D1E0','3FBACF','31AEC4','1F8B9E','1A7A89','116C77'},
	{'88E3EE','76D6E5','61CDE0','3BB8CE','30ABC0','1F909F','156A75'}
)
citrusColor("Light blue",{'8ACFEA','60BCE0','3FA2CF','3196C4','1F769E','1A6889','115B77'},
	{'88D2EE','76C4E5','61B8E0','3BA0CE','3093C0','1F7B9F','155A75'},'Cornflower','Blumine'
)
citrusColor('Blue',{'8AAFEA','6091E0','3F72CF','3165C4','1F4C9E','1A4389','113877'},
	{'88AFEE','769FE5','618EE0','3B6FCE','3063C0','1F509F','153A75'},'Indigo','Cerulean blue'
)
citrusColor('Purple',{'AD8AEA','8F60E0','783FCF','6C31C4','521F9E','441A89','361177'},
	{'AD88EE','A076E5','9461E0','763BCE','6930C0','4E1F9F','381575'}
)
citrusColor('Pink',{'EA8ADF','E060D1','CF3FBA','C431AE','9E1F8B','891A7A','77116B'},
	{'EE88E2','E576D6','E061CD','CE3BB8','C030AB','9F1F90','75156A'},'Violet','Orchid'
)
citrusColor('Hot pink',{'EA8AB7','E0609C','CF3F7E','C43171','9E1F56','891A4C','771141'},
	{'EE88B8','E576A8','E06198','CE3B7B','C0306F','9F1F5B','751542'},'Rose'
)



Spice.Properties.new("Ripple",function(button,...)
	local args = {...}
	button.AutoButtonColor = false
	button.ClipsDescendants = true
	button.MouseButton1Down:connect(function(mx,my)
		local circle
		local props = {Parent = button,AnchorPoint = Vector2.new(.5,.5), Transparency = 1, Name = 'Circle', Position = UDim2.new(0, mx-button.AbsolutePosition.X, -.5, my-button.AbsolutePosition.Y)}
		if Spice.Instance.isAClass("Circle",true) then
			circle = Spice.Instance.newPure("Circle",props)
		else
			circle = Spice.Instance.newInstance("ImageLabel",Spice.Table.merge(props,{Image = 'rbxassetid://1533003925'}))
		end
		local who = circle
		local color, timer, typ, siz, lightness = Color3.new(0,0,0), .8, Spice.Misc.dynamicProperty(who), who.Parent:IsA'GuiObject' and (who.Parent.AbsoluteSize.X > who.Parent.AbsoluteSize.Y and who.Parent.AbsoluteSize.X or who.Parent.AbsoluteSize.Y)
		local mid = false
		for i,v in next, args do
			typ = type(v) == 'string' and v or typ
			color = typeof(v) == 'Color3' and v or color
			timer = lightness and type(v) == 'number' and v or timer
			lightness = not lightness and type(v) == 'number' and v or lightness
			mid = type(v) == 'boolean' and v or mid
		end
		if not lightness then lightness = .85 end
		Spice.Properties.setProperties(who,{[typ..'Color3'] = color, [typ..'Transparency'] = lightness})
		Spice.Misc.destroyIn(who,timer + .01)
		siz = siz*1.5
		if not mid then
			Spice.Tweening.tweenGuiObject(who,'siz',UDim2.new(0,siz,0,siz),timer,'Sine','Out')
		else
			Spice.Tweening.tweenGuiObject(who,'both',UDim2.new(.5, 0, .5, 0),UDim2.new(0,siz,0,siz),timer,'Quad','Out')
		end
		Spice.Tweening.new(who,'ImageTransparency',1,timer,'Sine','Out')
	end)
end, 'GuiButton')

Spice.Properties.new("Draggable",function(gui, tween,...)
    local UserInputService = game:GetService("UserInputService")
	local args = {...}
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        if not tween then
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        else
            Spice.Tweening.new(gui,'Position', UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), tween or .1,unpack(args))
        	--wait(time or .3)
		end
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)    
end)
Spice.Instance.newClass("RoundedGuiObject",function(radius) --radius is udim2
	local roundFolder = Spice.Instance.newInstance('Folder',{Name = 'Round'})
	local radiusFolder = Spice.Instance.newInstance('Folder',roundFolder,{Name = 'RadiusValues'})
	local getRadius = function(...)
		local args = type(({...})[1]) == 'table' and ({...})[1] or {...}
		if #args >= 4 then
			return {args[1],args[2],args[3],args[4]}
		elseif #args >= 2 then
			return {args[1],args[2],args[2],args[3] or args[1]}
		elseif #args == 1 then
			return {args[1],args[1],args[1],args[1]}
		else
			return {0,0,0,0}
		end
	end
	local radii = getRadius(radius)
	local lRT = {{Vector2.new(0,0),Vector2.new(1,0),Vector2.new(0,1),Vector2.new(1,1)}, {UDim2.new(0,0,0,0),UDim2.new(1,0,0,0),UDim2.new(0,0,1,0),UDim2.new(1,0,1,0)}, {Vector2.new(0,0),Vector2.new(250,0),Vector2.new(0,250),Vector2.new(250,250)}}
	Spice.Instance.newInstance('Frame',roundFolder,{Name = 'Center',BorderSizePixel = 0;BackgroundColor3 = Color3.new(.2,.2,.2)})
	for i = 1,4 do
		local roundSize = radii[i]
		local c = Spice.Instance.newInstance('ImageLabel',roundFolder,{
			ImageColor3 = Color3.new(.2,.2,.2);
			Name = 'Corner_'..i;
			Image = 'rbxassetid://1487012691';
			BackgroundTransparency = 1;
			Size = UDim2.new(0,roundSize,0,roundSize);
			AnchorPoint = lRT[1][i];
			Position = lRT[2][i];
			ImageRectSize = Vector2.new(250,250);
			ImageRectOffset = lRT[3][i];
		})
		Spice.Instance.newInstance('IntValue', radiusFolder, {Name = c.Name, Value = roundSize}).Changed:connect(function(a)
			c.Size = UDim2.new(0,a,0,a)
		end)
		c:GetPropertyChangedSignal('Size'):connect(function()
			local id = i
			local c1,c2,c3,c4 = roundFolder.Corner_1,roundFolder.Corner_2,roundFolder.Corner_3,roundFolder.Corner_4
			local cs1,cs2,cs3,cs4 = c1.Size.X.Offset, c2.Size.X.Offset, c3.Size.X.Offset, c4.Size.X.Offset
			if id == 1 or id == 2 then
				roundFolder.Top.Position = UDim2.new(0,cs1,0,0)
				roundFolder.Top.Size = UDim2.new(1, -(cs1+cs2), 0, (cs1 >= cs2 and cs1 or cs2))
			end
			if id == 1 or id == 3 then
				roundFolder.Left.Position = UDim2.new(0,0,0,cs1)
				roundFolder.Left.Size = UDim2.new(0,(cs1 >= cs3 and cs1 or cs3), 1, -(cs1+cs3))
			end			
			if id == 2 or id == 4 then
				roundFolder.Right.Position = UDim2.new(1,0,0,cs2)
				roundFolder.Right.Size = UDim2.new(0,(cs2 >= cs4 and cs2 or cs4), 1, -(cs4+cs2))
			end		
			if id == 3 or id == 4 then
				roundFolder.Bottom.Position = UDim2.new(0,cs3,1,0)
				roundFolder.Bottom.Size = UDim2.new(1, -(cs3+cs4), 0, (cs3 >= cs4 and cs3 or cs4))
			end	
			roundFolder.Center.Position = UDim2.new(0, roundFolder.Left.Size.X.Offset, 0, roundFolder.Top.Size.Y.Offset)
			roundFolder.Center.Size = UDim2.new(1, - (roundFolder.Right.Size.X.Offset + roundFolder.Left.Size.X.Offset) , 1, - (roundFolder.Bottom.Size.Y.Offset + roundFolder.Top.Size.Y.Offset) )
		end)
	end
	lRT = {{Vector2.new(0,0), Vector2.new(0,0), Vector2.new(0,1), Vector2.new(1,0)},{UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), UDim2.new(0,0,1,0), UDim2.new(1,0,0,0)}, {'Top','Left','Bottom','Right'}}
	for i = 1,4 do
		local roundSize = radii[i]
		Spice.Instance.newInstance("Frame",roundFolder,{
			Size = UDim2.new(0,0,0,0);
			Position = lRT[2][i];
			BorderSizePixel = 0;
			Name = lRT[3][i];
			BackgroundColor3 = Color3.new(.2,.2,.2);
			AnchorPoint = lRT[1][i];
		})
	end
	local connected
	local function spacesaver(prop,to)
		roundFolder.Top[prop] = roundFolder.Parent[prop]
		roundFolder.Bottom[prop] = roundFolder.Parent[prop]
		roundFolder.Left[prop] = roundFolder.Parent[prop]
		roundFolder.Right[prop] = roundFolder.Parent[prop]
		roundFolder.Center[prop] = roundFolder.Parent[prop]
		roundFolder.Corner_1[to or prop] = roundFolder.Parent[prop]
		roundFolder.Corner_2[to or prop] = roundFolder.Parent[prop]
		roundFolder.Corner_3[to or prop] = roundFolder.Parent[prop]
		roundFolder.Corner_4[to or prop] = roundFolder.Parent[prop]
	end
	local connect = function(prop,to)
		if connected then connected:Disconnect() end
		pcall(function()		
			spacesaver(prop,to)
			connected = roundFolder.Parent:GetPropertyChangedSignal(prop):connect(function()
				spacesaver(prop,to)
			end)
		end)
	end
	roundFolder.AncestryChanged:connect(function()
		pcall(function() roundFolder.Parent.BackgroundTransparency = 1 connect('BackgroundColor3','ImageColor3') end)
	end)
	connect('BackgroundColor3','ImageColor3')
	return roundFolder
end)
Spice.Properties.new("Round",function(who, ...)
	local round = Spice.Instance.new('RoundedGuiObject',{Size = UDim2.new(1,0,1,0), Name = 'RoundedGuiObject'})
	local setRound = function(who,...)
		local function getRadius(...)
			local args = type(({...})[1]) == 'table' and ({...})[1] or {...}
			if #args >= 4 then
				return {args[1],args[2],args[3],args[4]}
			elseif #args >= 2 then
				return {args[1],args[2],args[2],args[3] or args[1]}
			elseif #args == 1 then
				return {args[1],args[1],args[1],args[1]}
			else
				return {0,0,0,0}
			end
		end
		local rad = getRadius(...)
		local val = who.RadiusValues
		val.Corner_1.Value = rad[1]
		val.Corner_2.Value = rad[2]
		val.Corner_3.Value = rad[3]
		val.Corner_4.Value = rad[4]
	end
	setRound(round,...)
	who.ZIndex = who.ZIndex + 1
	round.Parent = who
end)

Spice.Instance.newClass('RoundedFrame',function(roundsize)
	local frame = Spice.Instance.newObject('Frame',{TopBarColor3 = Color3.fromRGB(163,162,165),BottomBarColor3 = Color3.fromRGB(163,162,165),BackgroundTransparency = 0, RoundSize = roundsize or 8},{Round = roundsize or 8})
	frame:NewIndex('RoundSize',function(self,new)
		for i,v in next, self.Instance.RoundedGuiObject.RadiusValues:GetChildren() do
			v.Value = new
		end
		self.Object.RoundSize = new
	end)
	frame:NewIndex('BackgroundTransparency',function(self,new)
		self.Object.BackgroundTransparency = new
		for i,v in next, self.Instance.RoundedGuiObject:GetChildren() do
			if v:IsA'GuiObject' then
				if v.ClassName == 'ImageLabel' then
					v.ImageTransparency = new
				else
					v.BackgroundTransparency = new
				end
			end
		end
	end)
	frame:NewIndex('TopBarColor3',function(self,new)
		local round = self.Instance.RoundedGuiObject
		round.Corner_1.ImageColor3 = new
		round.Corner_2.ImageColor3 = new
		round.Top.BackgroundColor3 = new
		self.Object.TopBarColor3 = new
	end)
	frame:NewIndex('BottomBarColor3',function(self,new)
		local round = self.Instance.RoundedGuiObject
		round.Corner_3.ImageColor3 = new
		round.Corner_4.ImageColor3 = new
		round.Top.BackgroundColor3 = new
		self.Object.BottomBarColor3 = new
	end)
	frame:NewIndex('TopBarRoundSize',function(self,new)
		local round = self.Instance.RoundedGuiObject.RadiusValues
		round.Corner_1.Value = new
		round.Corner_2.Value = new
	end)
	frame:NewIndex('BottomBarRoundSize',function(self,new)
		local round = self.Instance.RoundedGuiObject.RadiusValues
		round.Corner_3.Value = new
		round.Corner_4.Value = new
	end)
	frame:Index('TopBarRoundSize',function(self)
		return self.Instance.RoundedGuiObject.RadiusValues.Corner_1.Value
	end)
	frame:Index('BottomBarRoundSize',function(self)
		return self.Instance.RoundedGuiObject.RadiusValues.Corner_3.Value
	end)
	return frame
end)

Spice.Instance.newClass("Icon",function(...)
	return Spice.Iconography.new(...)
end)
Spice.Instance.newClass("IconButton",function(...)
	return Spice.Instance.newInstance("ImageButton",Spice.Table.merge(Spice.Iconography.getIconData(...),{BackgroundTransparency = 1}))
end)

Spice.Properties.new("List",function(who, props)
	Spice.Instance.newInstance('UIListLayout',who, props and type(props) == 'table' and props or nil)
end)
Spice.Properties.new("Grid",function(who, props)
	Spice.Instance.newInstance('UIGridLayout',who, props and type(props) == 'table' and props or nil)
end)
Spice.Properties.new("Page",function(who, props)
	Spice.Instance.newInstance('UIPageLayout',who, props and type(props) == 'table' and props or nil)
end)
Spice.Properties.new("Spacing",function(who, props)
	Spice.Instance.newInstance('UIPadding',who, props and type(props) == 'table' and props or nil)
end)


return Spice
