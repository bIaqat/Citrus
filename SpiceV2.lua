Spice = {
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
	Color = setmetatable({
		fromRGB = function(r,g,b)
			return Color3.fromRGB(r,g,b)
		end;
		toRGB = function(Color)
			return math.ceil(Color.r*255),math.ceil(Color.g*255),math.ceil(Color.b*255)
		end;
		editRGB = function(Color, operation, r, g, b)
			operation = operation or '+'
			return 
			operation == '+' and Color3.fromRGB(Color.r + r, Color.g + g, Color.b + b) or
			operation == '-' and Color3.fromRGB(Color.r - r, Color.g - g, Color.b - b) or
			operation == '/' and Color3.fromRGB(Color.r / r, Color.g / g, Color.b / b) or		
			(operation == '*' or operation == 'x') and Color3.fromRGB(Color.r * r, Color.g * g, Color.b * b) or
			operation == '^' and Color3.fromRGB(Color.r ^ r, Color.g ^ g, Color.b ^ b) or
			(operation == 'rt' or operation == '^/') and Color3.fromRGB(Color.r ^ (1/r), Color.g ^ (1/g), Color.b ^ (1/b)) or
			operation == '%' and Color3.fromRGB(Color.r % r, Color.g % g, Color.b % b)
		end;
		setRGB = function(Color, newR, newG, newB)
			return Color3.fromRGB(newR or Color.r, newG or Color.g, newB or Color.b)
		end;	
		fromHSV = function(h,s,v)
			return Color3.fromHSV(h/360,s/100,v/100)
		end;
		toHSV = function(Color)
			local h,s,v = Color3.toHSV(Color)
			return math.ceil(h*360),math.ceil(s*100),math.ceil(v*100)
		end;
		editHSV = function(Color, operation, h, s, v)
			local operation ,ch,cs,cv = operation or '+', Color3.fromHSV(Color)
			return operation == '+' and Color3.fromHSV(ch + h, cs + s, cv + v) or
			operation == '-' and Color3.fromHSV(ch - h, cs - s, cv - v) or
			operation == '/' and Color3.fromHSV(ch / h, cs / s, cv / v) or		
			(operation == '*' or operation == 'x') and Color3.fromHSV(ch * h, cs * s, cv * v) or
			operation == '^' and Color3.fromHSV(ch ^ h, cs ^ s, cv ^ v) or
			(operation == 'rt' or operation == '^/') and Color3.fromHSV(ch ^ (1/h), cs ^ (1/s), cv ^ (1/v)) or
			operation == '%' and Color3.fromHSV(ch % h, cs % s, cv % v)
		end;
		setHSV = function(Color, newH, newS, newV)
			local h,s,v = Color3.toHSV(Color)
			return Color3.fromHSV((newH or h)/360,(newS or s)/100,(newV or v)/100)
		end;	
		fromHex = function(Hex)
			Hex = Hex:sub(1,1) == '#' and Hex:sub(2) or Hex
			local r,g,b =
				#Hex >= 6 and tonumber(Hex:sub(1,2),16) or #Hex >= 3 and tonumber(Hex:sub(1,1):rep(2),16),
				#Hex >= 6 and tonumber(Hex:sub(3,4),16) or #Hex >= 3 and tonumber(Hex:sub(2,2):rep(2),16),
				#Hex >= 6 and tonumber(Hex:sub(5,6),16) or #Hex >= 3 and tonumber(Hex:sub(3,3):rep(2),16)
			return Color3.fromRGB(r,g,b)
		end;
		toHex = function(Color, includeHash)
			return (includeHash and '#' or '')..string.format('%02X',Color.r)..string.format('%02X',Color.g)..string.format('%02X',Color.b)
		end;
		fromString = function(String, ...)
			local value = 0
			for i = 1,#String do
				local byteString = String:sub(i,i):byte()
				local inverse_i = #String - i + 1
				inverse_i = #String == 1 and inverse_i - 1 or inverse_i
				byteString = inverse_i % 4 >= 2 and -byteString or byteString
				value = value + byteString
			end
			local colors = {Color3.new(0.992157, 0.160784, 0.262745), Color3.new(0.00392157, 0.635294, 1), Color3.new(0.00784314, 0.721569, 0.341176), Color3.new(0.419608, 0.196078, 0.486275), Color3.new(0.854902, 0.521569, 0.254902), Color3.new(0.960784, 0.803922, 0.188235), Color3.new(0.909804, 0.729412, 0.784314), Color3.new(0.843137, 0.772549, 0.603922)}
			if ... then
				for i,v in next, {...} do
					table.insert(v)
				end
			end
			return colors[value % #colors + 1]
		end;
		toInverse = function(Color)
			local h,s,v = Color3.toHSV(Color)
			return Color3.fromHSV(1 - h, 1 - s, 1 - v)
		end;
		Colors = setmetatable({},{
			__index = function(self,ind)
				for i,v in next, {
					new = function(Name, Color, ...) --Name, ColorSet,...   ... Index
						local index = self
						for i,v in next, {...} do
							if not index[v] then
								index[v] = {}
							end
							index = index[v]
						end
						if not index[Name] then index[Name] = type(Color) == 'table' and Color or {Color}
						else
							for i,v in next, type(Color) == 'table' and Color or {Color}  do
								index[Name][i] = v
							end
						end
					end;
					get = function(Name, ...) --... Index
						local index = self
						for i,v in next, {...} do
							index = index[v]
						end
						return index[Name]
					end;
					remove = function(Name, ...) --... Index
						local index = sself
						for i,v in next, {...} do
							index = index[v]
						end		
						index[Name] = nil
					end;
				} do
					local self = getmetatable(self)
					self.__index = {}
					self.__index[i] = v
					if i == ind then
						return v
					end
				end
			end
		});
	},{
		__index = function(self,index)
			for i,v in next, {
				fromStored = function(Name, Key, ...) --... Index
					local index = self.Colors
					for i,v in next, {...} do
						index = index[v]
					end
					local colors = index[Name]
					return colors[type(Key) == 'number' and Key or next(colors)]
				end;
				new = function(...)
					local args = {...}
					return
						type(args[1]) == 'string' and (args[1]:sub(1,1) == '#' and self.fromHex(args[1]) or self.fromStored(...)) or
						args[4] and Color3.fromHSV(args[1]/360,args[2]/100,args[3]/100) or
						Color3.fromRGB(args[1],args[2],args[3]) 
				end;
				storeColor = self.Colors.new;
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
	Effects = setmetatable({
		Effects = {}
		},{
		__index = function(self,index)
			for i,v in next, {	
				new = function(Name, Function)
					self.Effects[Name] = Function;
				end;
				get = function(Name)
					return self.Effects[Name]
				end;
				affect = function(Object, Name, ...) --... Function Args
					return (type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
				end;
				affectChildren = function(Object, Name, ...)
					for _,Object in next, Object:GetChildren() do
						(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
					end
				end;
				affectDescendants = function(Object, Name, ...)
					for _,Object in next, Object:GetDescendants() do
						(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
					end
				end;
				affectOnChildAdded = function(Object, Name, ...)
					local args = {...}
					Object.onChildAdded:connect(function(Object)
						(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
					end)
				end;
				affectOnDescendantAdded = function(Object, Name,...)
					local args = {...}
					Object.onDescendantAdded:connect(function(Object)
						(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
					end)
				end;
				affectAncestors = function(Object,Name,...)
					for _,Object in next, Spice.Instance.getAncestors(Object) do
						(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
					end
				end;
				massAffect = function(Object, Name, ...)
					self.affectChildren(...)
					self.affectOnChildAdded(...)
				end;
				affectOnEvent = function(Object, EventName, Name, ...)
					local args = {...}
					Object[EventName]:connect(function(arg)
						(type(Name) == 'string' and self.Effects[Name] or Name)(typeof(arg) == 'Instance' and arg or Object, unpack(args))
					end)
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
	Imagery = setmetatable({
		Images = setmetatable({},{
			__index = function(self,index)
				for i,v in next, {
					new = function(Name, ImageId, Props, ...) --... Directory
						ImageId = type(ImageId) ~= 'string' and 'rbxassetid://'..ImageId or ImageId
						Props = Props or {}
						Props.Name, Props.Image, Props.BackgroundTransparency = Name, ImageId, 1
						local Image = Instance.new("ImageLabel")
						for i,v in next, Props do
							Image[i] = v
						end
						local index = self
						for i,v in next, {...} do
							if not index[v] then index[v] = {} 
							elseif type(index[v]) ~= 'table' then index[v] = {index[v]} end
							index = index[v]
						end
						index[Name] = Image
					end;
					get = function(...) --... Directory
						local index = self
						for i,v in next, {...} do
							index = self[v]
						end
						return index
					end;
					getImage = function(Name, ...)
						local image = self.get(...)[Name]
						if type(image) == 'table' then
							for i,v in next, image do
								if typeof(v) == 'Instance' then
									return v:Clone()
								end
							end
						end
						return image:Clone()
					end;
					newFromSheet = function(ImageId, XAmt, YAmt, XSiz, YSiz, Names, ...) --...Directory
						local namesIndex = 1
						for y = 0, YAmt - 1 do
							for x = 0, XAmt - 1 do
								local index = {}
								for name in (Names[namesIndex] or 'Icon'):gsub('_','\0'):gmatch('%Z+') do
									table.insert(index,name)
								end
								local name = index[#index]
								table.remove(index,#index)
								self.new(name, ImageId, {ImageRectOffset = Vector2.new(x*XSiz, y*YSiz), ImageRectSize = Vector2.new(XSiz, YSiz)}, ..., unpack(index))
								namesIndex = namesIndex + 1
							end
						end			
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
		__index = function(self,index)
			for i,v in next, {
				newInstance = function(LabelOrButton, Parent, Props, ...) --...Directory
						local image = self.Images.getImage(...)
						Props.Parent = Parent
						for i,v in next, Props do
							image[i] = v
						end
						return image
					end;
				playGif = function(ImageObject, Speed, Repeat, ...) --...Directory
					local sheet = self.Images.get(...)
					ImageObject.onChildAdded:connect(function(who)
						if who.Name == 'STOPGIF' then
							Repeat = false
							who:Destroy()
						end
					end)
					spawn(function()
						repeat
							for i,image in next, sheet do
								if typeof(image) == 'Instance' then
									for i,image in next, {ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3} do
										ImageObject[i] = image
									end
								end
								wait(Speed)
							end
						until not Repeat
					end)
				end;
				stopGif = function(ImageObject)
					Instance.new("IntValue",ImageObject).Name = 'STOPGIF' 
				end;
				setImage = function(ImageObject, ...) --...Directory
					local image = self.getImage(...)
					for i,v in next, {ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3} do
						ImageObject[i] = v
					end
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
	Misc = {
		getAssetId = function(id)
			id = game:GetService('InsertService'):LoadAsset(tonumber(id)):GetChildren()[1]
			local idn = id.ClassName
			id = id[idn == 'ShirtGraphic' and 'Graphic' or idn == 'Shirt' and 'ShirtTemplate' or 'Pants' and 'PantsTemplate' or 'Decal' and 'Texture']
			return id:sub(id:find'='+1)
		end;
		getTextSize = function(text)
			local textl
			if type(text) == 'string' then
				textl = Instance.new('TextLabel')
				textl.Text = text
			end
			return game:GetService('TextService'):GetTextService(text, textl.TextSize, textl.Font, textl.AbsoluteSize)
		end;
		getPlayer = function(speaker, ...)
			local players = {}
			local has = {}
			local function insert(a)
				if not has[a] then
					table.insert(players,a)
					has[a] = true;
				end
			end
			local players = game:GetService'Players'
			for _,v in next, {...} do
				if v == 'all' then 
					for _, player in next, players:GetPlayers() do
						insert(player)
					end
				elseif v == 'others' then
					for _, player in next, players:GetPlayers() do
						if player ~= speaker then
							insert(player)
						end
					end
				elseif v == 'me' then
					insert(speaker)
				else
					for _, player in next, players:GetPlayers() do
						if player.Name:sub(1,#v):lower() == v:lower() then
							insert(player)
						end
					end
				end
			end
			return setmetatable(players,{__call = function(self, func) for i,v in next,self do func(v) end end})
		end;
		--what have a "doAfter" function when there is already a delay(WaitTime, Function) already thonk
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
		searchAPI = function(ApiLink, Exploiting)
			local http = game:GetService'HttpService'
			local proxyLink = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?'
			local data = {}
			ApiLink = http:UrlEncode(ApiLink:sub(ApiLink:find'?'+1,#ApiLink))
			local jsonData
			jsonData = Exploiting and http:JSONDecode(game:HttpGetAsync(proxyLink..ApiLink))
				or http:JSONDecode(http:GetAsync(proxyLink..ApiLink))
			for i,v in next, jsonData do
				data[v.Name] = v
			end
			return data
		end
		getArgument = function(num,...)
			return ({...})[num]
		end;
		destroyIn = function(who,seconds)
			game:GetService("Debris"):AddItem(who,seconds)
		end;
		exists = function(yes)
			return yes ~= nil and true or false
		end;
		--Redo StringFilterOut Later and Switch
		dynamicProperty = function(Object, Typ)
			local cn = Object.ClassName
			return (cn:find'Text' and 'Text' or cn:find'Image' and 'Image' or 'Background')..(Typ or '')
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
		operation = function(a,b,op)
			return 
			op == '+' and a + b or
			op == '-' and a - b or
			(op == '*' or op == 'x') and a * b or
			op == '/' and a / b or
			op == '%' and a % b or
			(op == 'pow' or op == '^') and a ^ b or
			(op == 'rt' or op == '^/') and a ^ (1/b)
		end;
	};
	Motion = setmetatable({
		Easings = setmetatable({},{
			__index = function(self, index)
				for i,v in next, {
					newStyle = function(Name, Types,...) --creates a section for new easings under a keyname such as Quad
						if ... then Types = self.fromBezier(Types,...) end
						self[Name] = Types and (type(Types) == 'table' and Types or type(Types) == 'function' and {Out = Types}) or {}
					end;
					newStyleType = function(Style, Name, Function,...) --creates a type (typically a direction) for a easing style such as InOut
						if ... then Function = self.fromBezier(Function,...) end
						if not self[Style] then self[Style] = {} end
						self[Style][Name] = Function
					end;
					getStyle = function(Name)
						return self[Name]
					end;
					getStyleType = function(Style, Type)
						return self[Style][Type]
					end;
					fromBezier = function(x1, y1, x2, y2)--function from RoStrap
						if not (x1 and y1 and x2 and y2) then error("Need 4 numbers to construct a Bezier curve") end
						if not (0 <= x1 and x1 <= 1 and 0 <= x2 and x2 <= 1) then error("The x values must be within range [0, 1]") end
						if x1 == y1 and x2 == y2 then
							return function(x) return x end
						end
						local e, f = 3*x1, 3*x2
						local g, h, i = 1 - f + e, f - 2*e, 3*(1 - f + e)
						local j, k = 2*h, 3*y1
						local l, m = 1 - 3*y2 + k, 3*y2 - 2*k
						local SampleValues = {}
						for a = 0, 10 do
							local z = a*0.1
							SampleValues[a] = ((g*z + h)*z + e)*z -- CalcBezier
						end
						return function(t)
							if t == 0 or t == 1 then
								return t
							end
							local CurrentSample = 9
							for a = 1, CurrentSample do
								if SampleValues[a] > t then
									CurrentSample = a - 1
									break
								end
							end
							local IntervalStart = CurrentSample*0.1
							local GuessForT = IntervalStart + 0.1*(t - SampleValues[CurrentSample]) / (SampleValues[CurrentSample + 1] - SampleValues[CurrentSample])
							local InitialSlope = (i*GuessForT + j)*GuessForT + e
							if InitialSlope >= 0.001 then
								for NewtonRaphsonIterate = 1, 4 do
									local CurrentSlope = (i*GuessForT + j)*GuessForT + e
									if CurrentSlope == 0 then break end
									GuessForT = GuessForT - (((g*GuessForT + h)*GuessForT + e)*GuessForT - t) / CurrentSlope
								end
							elseif InitialSlope ~= 0 then
								local IntervalStep = IntervalStart + 0.1
				
								for BinarySubdivide = 1, 10 do
									GuessForT = IntervalStart + 0.5*(IntervalStep - IntervalStart)
									local BezierCalculation = ((g*GuessForT + h)*GuessForT + e)*GuessForT - t
				
									if BezierCalculation > 0 then
										IntervalStep = GuessForT
									else
										IntervalStart = GuessForT
										BezierCalculation = -BezierCalculation
									end
				
									if BezierCalculation <= 0.0000001 then break end
								end
							end
							return ((l*GuessForT + m)*GuessForT + k)*GuessForT
						end
					end;
				} do
					local self = getmetatable(self)
					self.__index = {}
					self.__index[i] = v
					if i == index then
						return v
					end
				end
			end;
		});
	 	Lerps = {
			['Color3'] = Color3.new().Lerp;
			['Vector2'] = Vector2.new().Lerp;
			['UDim2'] = UDim2.new().Lerp;
			['CFrame'] = CFrame.new().Lerp;
			['Vector3'] = Vector3.new().Lerp;
			['UDim'] = function(a, b, c)
				local function x(y)
					return a[y] + c * (b[y] - a[y])
				end
				return UDim.new(x'Scale',x'Offset')
			end;
			number = function(a,b,c)
				return a + c * (b - a)
			end
		};
	},{
		tweenedObjects = {}
		__index = function(self,index)
			for i,v in next, {
				customTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat)
					if cancel then self.cancelTween(Object) end
					for i,v in next, type(Property) == 'table' and Property or {Property} do
						Property[v] = {Object[v],type(EndValue) == 'table' and EndValue[i] or EndValue}
						Property[v][3] = self.Lerps[typeof(Property[v])]
						Property[i] = nil
					end
					local easingFunction = EasingStyle and type(EasingStyle) == 'function' and EasingStyle or self.Easings.getType(EasingStyle or 'Quad', EasingDirection or 'Out')
					local time, rep, elapsed
					local heart = game:GetService('RunService').Heartbeat
					local function reset()
						time, rep = Duration or 0, Repeat or 0
						elapsed = 0
					end
					reset()	
					local function tween(en)
						for i,v in next, Property do
							if not en then
								Object[i] = v[3](v[1],v[2], easingFunction(elapsed))
							else
								Object[i] = v[2]
							end
						end
					end	
					local playing, connection = false
					local function stepped(step)
						local function go()
							elapsed = elapsed + step
							if time > elapsed then
								tween()
							else
								connection:Disconnect()
								tween(true)
							end	
						end
						if playing then
							go()
						elseif rep > 0 or rep < 0 then
							rep = rep - 1
							go()
						else
							connection:Disconnect()
						end		
					end	
					local tween = setmetatable({},{
						__index = {
							Play = function(self)
								playing = true
								connection = heart:connect(stepped)
							end;
							Pause = function(self)
								playing = false
							end;
							Cancel = function(self)
								playing = false
								reset()
							end;
						}
					})
					tween:Play()
					table.insert(getmetatable(self).tweenedObjects,tween)
					return tween
				end;
				tweenServiceTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat, Reverse, Delay)
					if cancel then self.cancelTween(Object) end
					for i,v in next, type(Property) == 'table' and Property or {Property} do
						Property[v] = type(EndValue) == 'table' and EndValue[i] or EndValue
						Property[i] = nil
					end
					local tween = game:GetService('TweenService'):Create(Object,
						TweenInfo.new(Duration,
							EasingStyle and (type(EasingStyle) == 'string' and Enum.EasingStyle[EasingStyle] or EasingStyle) or Enum.EasingStyle.Quad,
							EasingDirection and (type(EasingDirection) == 'string' and Enum.EasingDirection[EasingDirection] or EasingDirection) or Enum.EasingDirection.Out,
							Repeat or 0, Reverse or false, Delay or 0
						),
						Property
					)
					tween:Play()
					table.insert(getmetatable(self).tweenedObjects,tween)
					return tween
				end;
				lerp = function(BeginingValue, EndValue, Alpha, EasingStyle, EasingDirection)
					local Lerps = self.Lerps
					return Lerps[typeof(BeginingValue)](BeginingValue, EndValue, 
						EasingStyle and ((type(EasingStyle) == 'string' and self.Easings[EasingStyle][EasingDirection or 'Out'](Alpha) ) or
							type(EasingStyle) == 'function' and EasingStyle(Alpha) 
						) or
						Alpha
					)
				end;
				cancelTween = function(Object)
					pcall(function() --im lazy lol
						if Object then
							getmetatable(self).tweenedObjects[Object]:Cancel()
						else
							for i,v in next, getmetatable(self).tweenedObjects do
								v:Cancel()
							end
						end
					end)
				end;
				asymmetricTween = function(Object, Property, End, tim, cancel, easing)--function from RoStrap
					if cancel then self.cancelTween(Object) end
					local easing = easing or self.Easings.fromBezier(0.4, 0.0, 0.2, 1)
					local Heartbeat = game.GetService('RunService').Heartbeat
					local StartX = Object[Property].X
					local StartY = Object[Property].Y
					local EndX = End.X
					local EndY = End.Y	
					local XStartScale = StartX.Scale
					local XStartOffset = StartX.Offset
					local YStartScale = StartY.Scale
					local YStartOffset = StartY.Offset	
					local XScaleChange = EndX.Scale - XStartScale
					local XOffsetChange = EndX.Offset - XStartOffset
					local YScaleChange = EndY.Scale - YStartScale
					local YOffsetChange = EndY.Offset - YStartOffset
					local ElapsedTime, Connection = 0
					local Clone = Object:Clone()
					Clone.Name = ""
					Clone[Property] = End
					Clone.Visible = false
					Clone.Parent = Object.Parent
					if Object.AbsoluteSize.X * Object.AbsoluteSize.Y < Clone.AbsoluteSize.X * Clone.AbsoluteSize.Y then
						Clone:Destroy()
						local Duration = tim or 0.375
						local HeightStart = Duration*0.1
						local WidthDuration = Duration*0.75
						Connection = Heartbeat:Connect(function(Step)
							ElapsedTime = ElapsedTime + Step
							if Duration > ElapsedTime then
								local XScale, XOffset, YScale, YOffset

								if WidthDuration > ElapsedTime then
									local WidthAlpha = easing(ElapsedTime, 0, 1, WidthDuration)
									XScale = XStartScale + WidthAlpha*XScaleChange
									XOffset = StartX.Offset + WidthAlpha*XOffsetChange
								else
									XScale = Object[Property].X.Scale
									XOffset = Object[Property].X.Offset
								end

								if ElapsedTime > HeightStart then
									local HeightAlpha = easing(ElapsedTime - HeightStart, 0, 1, Duration)
									YScale = YStartScale + HeightAlpha*YScaleChange
									YOffset = YStartOffset + HeightAlpha*YOffsetChange
								else
									YScale = YStartScale
									YOffset = YStartOffset
								end

								Object[Property] = UDim2.new(math.ceil(XScale), math.ceil(XOffset), math.ceil(YScale), math.ceil(YOffset))
							else
								Connection:Disconnect()
								Object[Property] = End
							end
						end)
					else
						Clone:Destroy()
						local Duration = tim or .375
						local WidthStart = Duration*0.15
						local HeightDuration = Duration*0.95
						Connection = Heartbeat:Connect(function(Step)
							ElapsedTime = ElapsedTime + Step
							if Duration > ElapsedTime then
								local XScale, XOffset, YScale, YOffset
					
								if HeightDuration > ElapsedTime then
									local HeightAlpha = easing(ElapsedTime, 0, 1, HeightDuration)
									YScale = YStartScale + HeightAlpha*YScaleChange
									YOffset = YStartOffset + HeightAlpha*YOffsetChange
								else
									YScale = Object[Property].Y.Scale
									YOffset = Object[Property].Y.Offset
								end
					
								if ElapsedTime > WidthStart then
									local WidthAlpha = easing(ElapsedTime - WidthStart, 0, 1, Duration)
									XScale = XStartScale + WidthAlpha*XScaleChange
									XOffset = XStartOffset + WidthAlpha*XOffsetChange
								else
									XScale = XStartScale
									XOffset = XStartOffset
								end
					
								Object[Property] = UDim2.new(math.ceil(XScale), math.ceil(XOffset), math.ceil(YScale), math.ceil(YOffset))
							else
								Connection:Disconnect()
								Object[Property] = End
							end
						end)
					end
					return Connection
				end;
				rotate = function(Object, Angle, Custom, ...)
					local EndValue = Object.Rotation + Angle
					return Custom and self.customTween(Object,'Rotation',EndValue,...) or self.tweenServiceTween(Object,'Rotation',EndValue,...)
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
	Objects = setmetatable({
		getAncenstors = function(Object)
			local directory = {game};
			local ind = game
			for name in Object:GetFullName():gsub('%.','\0'):gmatch('%Z+') do
				local temp = ind[name]
				if not name == 'game' and temp:IsAncestorOf(Object) then
					ind = temp
					table.insert(directory,ind)
				end
			end
			return directory
		end;
		Classes = setmetatable({},{
			__index = function(self,index)
				for i,v in next, {
					new = function(ClassName, onCreated)
						self[ClassName] = {onCreated = onCreated, Objects = {}}
					end;
					isA = function(Object, ClassName)
						return Object:IsA(ClassName) or self.ClassName.Objects[Object] or false
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
		Customs = setmetatable({},{
			__index = function(self,index)
				for i,v in next, {
					getCustomFromInstance = function(Object)
						return self[Object] or typeof(Object) == 'userdata' and Object or false
					end;
					cloneCustom = function(Object, Parent, Props)
						local ins = Object.Instance:Clone()
						ins.Parent = Parent
						local clone = Spice.Table.clone(Object)
						clone.Instance = ins
						Spice.Properties.setProperties(clone.Instance, Props and Props or {})
						rawset(self,clone.Instance,clone)
						return clone					
					end;
					isCustom = function(Object)
						return self[Object] and true or false
					end;
					new = function(ClassName, Parent, Props, CustomProps)
						local instance = type(ClassName) ~= 'string' and ClassName or Instance.new(ClassName)
						local object = newproxy(true)
						local objectMeta
						objectMeta = {
							Instance = instance, Object = CustomProps or {}, Index = {}, NewIndex = {};
							__index = function(proxy,ind)
								local objmeta = getmetatable(proxy)
								if ind == 'Instance' or ind == 'Object' then return objmeta[ind] end
								if objmeta.Index[ind] then
									local ret = objmeta.Index[ind]
									return type(ret) ~= 'function' and ret or ret(proxy)
								elseif objmeta.Object[ind] or not pcall(function() return objmeta.Instance[ind] or false end) then
									return objmeta.Object[ind]
								elseif objmeta.Instance[ind] then
									return objmeta.Instance[ind]
								end
							end;	
							__newindex = function(proxy,ind,new)
								local objmeta = getmetatable(proxy)
								if objmeta.NewIndex[ind] then
									objmeta.NewIndex[ind](objmeta,new)
								elseif objmeta.Object[ind] or not pcall(function() return objmeta.Instance[ind] or false end) or type(new) == 'function' then
									rawset(objmeta.Object,ind,new)
								elseif pcall(function() return objmeta.Instance[ind] or false end) then
									objmeta.Instance[ind] = new
								end
							end;
							__call = function(objmeta,prop)
								local objmeta = getmetatable(objmeta)
								Spice.Properties.setProperties(objmeta.Instance,prop)
							end;
							__namecall = function(proxy, ...)
								local args = {...}
								local name = args[#args]
								table.remove(args,#args)
								local objmeta = getmetatable(proxy)
								local default = {
									Index = function(name,what)
										rawset(objmeta.Index,name,what)
									end;
									NewIndex = function(name,what)
										if type(what) == 'function' then
											rawset(objmeta.NewIndex,name,what)
										end
									end;
									Clone = function(parent,prop)
										return self.cloneCustom(proxy,parent,prop)
									end;
								}
								if default[name] then return default[name](unpack(args)) end
								if objmeta.Instance[name] and type(objmeta.Instance[name]) == 'function' then
									return objmeta.Instance[name](objmeta.Instance,unpack(args))
								end
							end;	
						}
						setmetatable(object,objectMeta)
						rawset(self,instance,object)
						object(Props)
						return object					
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
	},{
		__index = function(self,index)	
				for i,v in next, {
					newBasic = function(ClassName, Parent, ...) --faster
						local args, instance, props = {...}
						instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
						instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
						if type(args[#args]) == 'table' then
							props = args[#args]
							args[#args] = nil
						end
						Spice.Properties.setProperties(instance, props)
						return instance
					end;
					newInstance = function(ClassName, Parent, Props)
						local instance = Instance.new(ClassName, Parent)
						for i,v in next, Props do
							if not pcall(function() return instance[i] and true or false end) then
								Spice.Properties.setProperties(ClassName,Props)
							else
								instance[i] = v
								Props[i] = nil
							end
						end
						return instance
					end;
					new = function(ClassName, Parent, ...)
						local args, instance, props = {...}
						instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
						instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
						if type(args[#args]) == 'table' then
							props = args[#args]
							args[#args] = nil
						end	
						Spice.Propeties.Defaualt.toDefaultProperties(instance)			
						Spice.Properties.setProperties(instance, props)
						return instance					
					end;
					clone = function(Object, Parent, Props)
						local clone = Object:Clone()
						clone.Parent = Parent
						Spice.Properties.setProperties(Object,Props)
						return clone
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
	Properties = setmetatable({
		Default = setmetatable({},{
			__index = function(self,index)
				for i,v in next, {
					set = function(ClassName, Properties, Z) --If the Z is higher it overlaps the Zs lower
						if not self[Z or 0] then self[Z or 0] = {} end
						self[Z or 0][ClassName] = Properties
					end;
					get = function(ClassName, Z)
						local props = {}
						local function checkAndGet(i,v)
							if pcall(function() return Instance.new(ClassName):IsA(i) end) or i == ClassName then
								for i,v in next, v do
									props[i] = v
								end
							end						
						end
						if Z then
							for i,v in next, self[Z] do
								checkAndGet(i,v)
							end
						else
							for i,v in next, self do
								for i,v in next, v do
									checkAndGet(i,v)
								end
							end
						end
						return props
					end;
					toDefaultProperties = function(Object,Z)
						local props = self.get(Object.ClassName,Z)
						for i,v in next, props do
							Object[i] = v
						end
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
		Custom = setmetatable({},{
			__index = function(self,index)
				getmetatable(self).__index = {}
				getmetatable(self).__index.new = function(Name, Function, ...) --... Classes that can use this property
					self[Name] = setmetatable({Function = Function,Classes = {...}},{
						__index = function(self, Object)
							local class = self.Classes
							if #class == 0 then
								return true
							end
							for i,ClassName in next, class do
								if Object:IsA(ClassName) or ClassName == 'all' then
									return true
								end
							end
							return false
						end;
						__call = function(self,Object,...)
							if self[Object] then
								self.Function(Object,...)
							end
						end;
					})
				end
				if index == 'new' then return getmetatable(self).__index.new end
			end
		});
		RobloxAPI = setmetatable({
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
		},{
			__index = function(self,index)
				for i,v in next, {
					sort = function(self,func)
						table.sort(self,func)
					end;
					search = function(self, index, keepSimilar, returnFirstResult)
						return Spice.Table.search(self,index,false,keepSimilar or false, returnFirstResult ~= nil and returnFirstResult or true, true)
					end;
				} do
					local self = getmetatable(self)
					self.__index = {}
					self.__index[i] = v
					if i == index then
						return v
					end
				end
			end;
		});
	},{
			__index = function(self,index)
				for i,v in next, {
					new = self.Custom.new;
					hasProperty = function(Object,Property)
						local has = pcall(function() return Object[Property] and true end)
						return has, has and Object[Property] or nil
					end;
					getProperties = function(Object)
						local props = {}
						for i,property in next, self.RobloxAPI do
							if  pcall(function() return Object[property] and true end) then
								rawset(props,property,Object[property])
							end
						end
						return props
					end;
					getChildrenOfProperty = function(Object, Property)
						local children = {}
						for i,child in next, Object:GetChildren() do
							if pcall(function() return child[Property] and true end) then
								table.insert(children,child)
							end
						end
						return children
					end;
					getDescendantsOfProperty = function(Object, Property)
						local desc = {}
						for i,child in next, Object:GetDescendants() do
							if pcall(function() return child[Property] and true end) then
								table.insert(desc,child)
							end
						end
						return desc
					end;
					setProperties = function(Object, Properties, dontIncludeShorts, dontIncludeCustom, includeDefault)
						local custom, api, default = self.Custom, self.RobloxAPI, self.Default
						if includeDefault then
							self.Default.toDefaultProperties(Object,type(includeDefault) == 'number' or nil)
						end
						for property, value in next, Properties do
							if not dontIncludeShorts then property = self.RobloxApi:search(property) or property end
							if not dontIncludeCustom and self.Custom[property] then
								self.Custom[property](Object,type(value) == 'table' and unpack(value) or value)
							elseif pcall(function() return Object[property] and true end) then
								Object[property] = value
							end
						end
						return Object
					end;
					setVanillaProperties = function(Object, Properties)
						for i,v in next, Properties do
							Object[i] = v
						end
					end;
				} do
					local self = getmetatable(self)
					self.__index = {}
					self.__index[i] = v
					if i == index then
						return v
					end
				end
			end;	
	});
	Table = setmetatable({
		insert = function(tabl, ...)--... inserting
			local insert
			insert = function(x)
				for i,v in next, x do
					if type(v) == 'table' then
						insert(v)
					else
						rawset(tabl,i,v)
					end
				end
			end;
			insert({...})
			return tabl
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
		clone = function(tab)
			local cloned, clone = {}
			clone = function(x)
				for i,v in next,x do
					if type(v) == 'table' then
						cloned[i] = clone(v)
						if getmetatable(v) then
							local metaclone = clone(getmetatable(v))
							setmetatable(cloned[i],metaclon)
						end
					else
						cloned[i] = v
					end
				end	
				if getmetatable(x) then
					local metaclone = getmetatable(x)
					setmetatable(cloned,metaclone)
				end		
			end
			clone(tab)
			return cloned
		end;
		contains = function(tabl,contains)
			for i,v in next,tabl do
				if v == contains or i == contains then
					return true
				end
			end
			return nil
		end;
		toNumeralIndex = function(tabl)
			for i,v in next, tabl do
				if type(i) ~= 'number' then
					table.insert(tabl,v)
					tabl[i] = nil
				end
			end
			return tabl
		end;
		length = function(tabl)
			local count = 0
			for i,v in next, tab do
				count = count + 1
			end
			return count
		end;
		reverse = function(tabl)
			local new = {}
			for i,v in next, tabl do
				if type(i) == 'number' then
					new[#tabl-i+1] = v
				else
					new[i] = v
				end
				tabl[i] = nil
			end
			for i,v in next, new do
				tabl[i] = v
			end
			return tabl
		end;
		indexOf = function(tabl,val)
			for i,v in next, tabl do
				if v == val then
					return i
				end
			end
		end;
		find = function(tabl,this, keepFound,...) --...compareFunction function(this, index, value)
			local found = {}
			for i,v in next, tabl do
				if i == this or v == this or 
					(type(this) == 'string' and (
						 type(i) == 'string'  and i:sub(1,#this):lower() == this:lower() or 
						 type(v) == 'string' and v:sub(1,#this):lower() == this:lower() or
						 typeof(v) == 'Instance' and v.Name:sub(1,#this):lower() == this:lower()
					)) or 
					if ... then for _,comp in next, {...} do
						comp(this,i,v)
					end end
				then
					if not keepFound then
						return v, i
					else
						table.insert(found,{v,i})
					end
				end
			end
			if keepFound then return 
				found
			end
		end;
	},{
		__index = function(self,index)
			for i,v in next, {
				mergeClone = function(a,b) --bypasses no call back rule
					local a,b = self.clone(a), self.clone(b)
					return self.mergeTo(b,a)
				end;
				search = function(tabl, this, skipStored, keepSimilar, returnFirst, capSearch, ...) --relies on Table.find; bypasses no call back rule
					local index, value, capAlg	
					--Saved Results means less elapsed time if searched again
					if not getmetatable(tabl) then setmetatable(tabl,{}) end
					local meta = getmetatable(tabl) 
					if not meta['SpiceSearchResultsStorage'] then
						meta['SpiceSearchResultsStorage'] = {}
					end
					local usedStorage = meta['SpiceSearchResultsStorage']		
					--Stops the search or continues
					local function stopSearch()
						if value and index then
							usedStorage[this] = {value, index}
							return value, index
						end
					end		
					--Search functions
					if capSearch then
						function capAlg(comparative, ind, val)
							local subject = type(ind) == 'string' and ind or type(val) == 'string' and val
							if subject then
								local strin = ''
								for cap in subject:gmatch('%u') do
									strin = strin..cap
								end
								strin = strin..(subject:match('%d+$') or '')
								if strin == comparative then
									return true
								end
							end
							return false
						end
					end	
					function subAlg(comparative, ind, val)
						local subject = type(ind) == 'string' and ind or type(val) == 'string' and val
							if subject then
								if subject:find(comparative, 1, true) then
									return true
								end
							end
						return false
					end
					--Checks the Used Storage for 'this' and returns if exists
					if not skipStored then
						local stored = usedStorage[this]
						if stored then
							value, index = stored[1], stored[2]
						end
						stopSearch()
					end	
					--Checks if 'this' is found with chosen specified means
					value, index = self.find(tabl, this, keepSimilar or false,
						subAlg, capSearch and capAlg or nil, ...
					)
					stopSearch()		
					--Returns the results if keepSimilar
					if keepSimilar and value then
						table.sort(value,function(a,b)
							a, b = a[1], b[1]
							local function get(x) 
								return type(x) == 'table' and #x or type(x) == 'string' and #x:lower() or type(x) == 'number' and x or typeof(x) == 'Instance' and #x.Name or type(x) == 'boolean' and (x == true and 4 or x == false and 5) 
							end
							local lena, lenb = get(a), get(b)
							if type(a) == 'string' and type(b) == 'string' then if lena == lenb then return a:lower() < b:lower() else  return lena < lenb end end 
							return lena < lenb
						end);
						return returnFirst and value[1][1] or value, returnFirst and value[1][2] or nil
					end
					return false
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
	Theming = setmetatable({
		Themes = {}
		},{
		__index = function(self,index)
			for i,v in next, {
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
							self.setTheme(self,...)
						end;
						Insert = function(self,...)
							self.insertObject(self,...)
						end;
						Sync = function(self,...)
							self.sync(self,...)
						end;
					}
					getmetatable(self).Themes[name] = theme
					return theme
				end;
				getTheme = function(name,index,typ)
					local theme = type(name) == 'table' and name or type(name) == 'string' and self.Themes[name]
					return index and theme.Values(index,typ) or theme
				end;
				setTheme = function(name,...)
					local theme = type(name) == 'table' and name or self.getTheme(name)
					local args = {...}
					if #args == 2 and type(args[2]) == 'number' then
						theme.Values[args[2]] = args[1]
					else
						theme.Values = setmetatable({...},getmetatable(theme.Values))
					end
					local run = theme.AutoSync and theme:Sync()
				end;
				insertObject = function(name,obj,prop,ind)
					local theme = type(name) == 'table' and name or self.getTheme(name)
					local value = theme.Values(ind,type(obj[prop]))
					if not theme.Objects[obj] then
						theme.Objects[obj] = {}
					end
					theme.Objects[obj][prop] = ind or 1
					obj[prop] = theme.AutoSync and value or obj[prop]
				end;
				sync = function(name,lerp,tim,...)
					if not name then
						for i,v in next, self.Themes do
							self.sync(v)
						end
					else
						name = type(name) == 'table' and name or self.getTheme(name)
						for obj,v in next, name.Objects do
							for prop,ind in next, v do
								local value = name.Values(ind,type(obj[prop]))
								if not lerp then
									obj[prop] = value
								else
									game:GetService('TweenService'):Create(obj,TweenInfo.new(tim or 1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,...),{prop = value}):Play()
								end
							end
						end
					end
				end			
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
}