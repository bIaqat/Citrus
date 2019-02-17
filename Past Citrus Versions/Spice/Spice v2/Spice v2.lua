local Spice
Spice = {
Audio = setmetatable({
	Sounds = {};
	Remotes = {};
	},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			new = function(Name, SoundId, Props)
				local sound = Instance.new'Sound'
				sound.SoundId = type(SoundId) ~= 'string' and 'rbxassetid://'..SoundId or SoundId
				sound.Name = Name
				for i,v in next, Props or {} do
					sound[i] = v
				end
				local audio = setmetatable({
					Name = Name;
					Length = 0;
					Sound = sound;
					connect = function(ad,...)
						self.connect(ad,...)
					end;
					disconnect = function(ad,...)
						self.disconnect(ad,...)
					end;
					reset = function(ad)
						local sound = ad.Sound
						sound.Parent = workspace
						repeat wait() until sound.TimeLength ~= 0
						ad.Length = sound.TimeLength
						sound.Parent = nil							
					end;
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
				sound:GetPropertyChangedSignal('PlaybackSpeed'):connect(function()
					audio:reset()
				end)
				audio:reset()
				self.Sounds[Name] = audio
				return audio				
			end;
			get = function(Name)
				return self.Sounds[Name]
			end;
			getSound = function(Name)
				return self.Sounds[Name].Sound
			end;
			getAudioConnections = function(Name)
				return self.Remotes[type(Name) == 'string' and self.Sounds[Name].Sound or Name]
			end;
			connect = function(Name, ConnectingTo, Event, ...)--... Play Args
				local audio = type(Name) == 'string' and self.Sounds[Name] or Name
				local args = {...}
				local parent
				if typeof(args[1]) == 'Instance' then
					parent = args[1]
					args = {select(2,unpack(args))}
				else
					parent = ConnectingTo
				end
				local remotes = self.Remotes
				if not remotes[audio.Sound] then remotes[audio.Sound] = {} end
				remotes = remotes[audio.Sound]
				if not remotes[ConnectingTo] then remotes[ConnectingTo] = {} end
				local connection = ConnectingTo[Event]:connect(function()
					audio(parent,unpack(args))
				end)
				remotes[ConnectingTo][Event] = connection
			end;
			disconnect = function(Name, Object, Event)
				local audio = type(Name) == 'string' and self.Sounds[Name].Sound or Name
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
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
Color = setmetatable({
	fromRGB = function(r,g,b)
		return Color3.fromRGB(r,g,b)
	end;
	toRGB = function(Color)
		return math.floor(Color.r*255),math.floor(Color.g*255),math.floor(Color.b*255)
	end;
	editRGB = function(Color, operation, r, g, b)
		local operation, cr,cg, cb = operation or '+', Color.r, Color.g, Color.b
		cr, cg, cb = cr * 255, cg * 255, cb * 255
		return 
		operation == '+' and Color3.fromRGB(cr + r, cg + g, cb + b) or
		operation == '-' and Color3.fromRGB(cr - r, cg - g, cb - b) or
		operation == '/' and Color3.fromRGB(cr / r, cg / g, cb / b) or		
		(operation == '*' or operation == 'x') and Color3.fromRGB(cr * r, cg * g, cb * b) or
		operation == '^' and Color3.fromRGB(cr ^ r, cg ^ g, cb ^ b) or
		(operation == 'rt' or operation == '^/') and Color3.fromRGB(cr ^ (1/r), cg ^ (1/g), cb ^ (1/b)) or
		operation == '%' and Color3.fromRGB(cr % r, cg % g, cb % b)
	end;
	setRGB = function(Color, newR, newG, newB)
		return Color3.fromRGB(newR or Color.r*255, newG or Color.g*255, newB or Color.b*255)
	end;	
	fromHSV = function(h,s,v)
		return Color3.fromHSV(h/360,s/100,v/100)
	end;
	toHSV = function(Color,i)
		local h,s,v = Color3.toHSV(Color)
		return math.floor(h*360),math.floor(s*100),math.floor(v*100)
	end;
	editHSV = function(Color, operation, h, s, v)
		local operation ,ch,cs,cv = operation or '+', Color3.toHSV(Color)
		h,s,v = h/360, s/100, v/100
		return 
		operation == '+' and Color3.fromHSV(ch + h, cs + s, cv + v) or
		operation == '-' and Color3.fromHSV(ch - h, cs - s, cv - v) or
		operation == '/' and Color3.fromHSV(ch / h, cs / s, cv / v) or		
		(operation == '*' or operation == 'x') and Color3.fromHSV(ch * h, cs * s, cv * v) or
		operation == '^' and Color3.fromHSV(ch ^ h, cs ^ s, cv ^ v) or
		(operation == 'rt' or operation == '^/') and Color3.fromHSV(ch ^ (1/h), cs ^ (1/s), cv ^ (1/v)) or
		operation == '%' and Color3.fromHSV(ch % h, cs % s, cv % v)
	end;
	setHSV = function(Color, newH, newS, newV)
		local h,s,v = Color3.toHSV(Color)
		return Color3.fromHSV(newH and newH / 360 or h,newS and newS / 100 or s,newV and newV / 100 or v)
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
		return (includeHash and '#' or '')..string.format('%02X',Color.r*255)..string.format('%02X',Color.g*255)..string.format('%02X',Color.b*255)
	end;
	fromString = function(String, replace, ...)
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
			if replace then colors = {} end
			for i,v in next, {...} do
				table.insert(colors,v)
			end
		end
		return colors[value % #colors + 1]
	end;
	toInverse = function(Color)
		local r,g,b = Color.r,Color.g,Color.b
		return Color3.new(1-r,1-g,1-b)
	end;
	Colors = setmetatable({},{
		__index = function(self,ind)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = function(Name, Color, ...) --... Index
					local index = self
					for i,v in next, {...} do
						if not index[v] then
							index[v] = {}
						end
						index = index[v]
					end
					if not index[Name] then index[Name] = Color
					else
						if type(index[Name]) ~= 'table' then index[Name] = {index[Name]} end
						for i,v in next, type(Color) == 'table' and Color or {Color}  do
							if type(i) == 'string' then
								index[Name][i] = v
							else
								table.insert(index[Name],v)
							end
						end
					end
				end;
				get = function(...) --... Index
					local index = self
					for i,v in next, {...} do
						index = index[v]
					end
					return index
				end;
				remove = function(Name, ...) --... Index
					local index = self
					for i,v in next, {...} do
						index = index[v]
					end		
					index[Name] = nil
				end;
			} do
				gelf.__index[i] = v
				if i == ind then
					return v
				end
			end
		end
	});
},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			fromStored = function(Name, Key, ...) --... Index
				local index = self.Colors
				for i,v in next, {...} do
					index = index[v]
				end
				local colors = index[Name]
				return colors and colors[type(Key) == 'number' and Key or next(colors)]
			end;
			new = function(...)
				local args = {...}
				return
					type(args[1]) == 'string' and (args[1]:sub(1,1) == '#' and self.fromHex(args[1]) or self.fromStored(...)) or
					type(args[1]) ~= 'string' and (args[4] and Color3.fromHSV(args[1]/360,args[2]/100,args[3]/100)) or
					type(args[1]) ~= 'string' and Color3.fromRGB(args[1],args[2],args[3]) or
					nil
			end;
			storeColor = self.Colors.new;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
Effects = setmetatable({
	Effects = {}
	},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
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
				return Object.ChildAdded:connect(function(Object)
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
			affectOnDescendantAdded = function(Object, Name,...)
				local args = {...}
				return Object.DescendantAdded:connect(function(Object)
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
			affectAncestors = function(Object,Name,...)
				for _,Object in next, Spice.Instance.getAncestors(Object) do
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
				end
			end;
			massAffect = function(...)
				return self.affectChildren(...),
				self.affectOnChildAdded(...)
			end;
			affectOnEvent = function(Object, EventName, Name, ...)
				local args = {...}
				return Object[EventName]:connect(function(arg)
					if typeof(arg) == 'Instance' then Object = arg else
						table.insert(args,1,arg)
					end
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
Imagery = setmetatable({
	Images = setmetatable({},{
		SortedStorage = {};
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
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
					table.insert(index,Image)
					index[Name] = Image
				end;
				get = function(...) --... Directory
					local index = self
					for i,v in next, {...} do
						index = index[v]
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
							for name in (Names and Names[namesIndex] or string.format('Icon-%.3i', namesIndex)):gsub('_','\0'):gmatch('%Z+') do
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
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end
	})},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			newInstance = function(Class, Parent, Props, ...) --...Directory
				local image
				if Class and Class ~= 'ImageLabel' then
					image = self.setImage(Class, ...)
				else
					image = self.Images.getImage(...)
				end
				image.Parent = Parent
				for i,v in next, Props or {} do
					image[i] = v
				end
				return image
			end;
			playGif = function(ImageObject, Speed, Repeat, ...) --...Directory
				local sheet = self.Images.get(...)
				local br
				ImageObject.ChildAdded:connect(function(who)
					if who.Name == 'STOPGIF' then
						Repeat = false
						br = true
						game:GetService('Debris'):AddItem(who,.01)
					end
				end)
				spawn(function()
					local once = false
					repeat
						for i,image in next, sheet do
							if not Repeat and once or br then break end
							if typeof(image) == 'Instance' then
								for i,image in next, {ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3} do
									ImageObject[i] = image
								end
							end
							wait(Speed)
						end
						once = true
					until not Repeat
				end)
			end;
			stopGif = function(ImageObject)
				local stop = Instance.new("IntValue")
				stop.Name = 'STOPGIF' 
				stop.Parent = ImageObject
			end;
			setImage = function(ImageObject, ...) --...Directory
				if type(ImageObject) == 'string' then ImageObject = Instance.new(ImageObject) end
				local image = self.Images.getImage(...)
				for i,v in next, {Name = image.Name,ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3, BackgroundTransparency = image.BackgroundTransparency, ImageTransparency = image.ImageTransparency} do
					ImageObject[i] = v
				end
				return ImageObject
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
Misc = {
	getAssetId = function(id)
		id = game:GetService('InsertService'):LoadAsset(tonumber(id)):GetChildren()[1]
		local idn = id.ClassName
		id = id[idn == 'ShirtGraphic' and 'Graphic' or idn == 'Shirt' and 'ShirtTemplate' or 'Pants' and 'PantsTemplate' or 'Decal' and 'Texture']
		return id:sub(id:find'='+1)
	end;
	getTextSize = function(text,prop)
		local textl
		if type(text) == 'string' then
			textl = Instance.new('TextLabel')
			textl.Text = text
			for i,v in next, prop or {} do
				textl[i] = v
			end
		end
		return game:GetService('TextService'):GetTextSize(text, textl.TextSize, textl.Font, textl.AbsoluteSize)
	end;
	getPlayer = function(speaker, ...)
		local plrs = {}
		local has = {}
		local function insert(a)
			if not has[a] then
				table.insert(plrs,a)
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
		return setmetatable(plrs,{__call = function(self, func) for i,v in next,self do func(v) end end})
	end;
	--what have a "doAfter" function when there is already a delay(WaitTime, Function) already thonk
	timer = function()
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
			end;
			__concat = function(self,value)
				return ''..tick()-self.startTime..value
			end;
			__tostring = function(self)
				return ''..tick()-self.startTime
			end;
		})
	end;
	searchAPI = function(ApiLink)
		local exploiting = pcall(function() return game.HttpGet end) and true or false
		local httpget =  exploiting and game.HttpGet or game:GetService('HttpService').GetAsync
		local proxyLink = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?'
		local jsonData
		jsonData = game:GetService('HttpService'):JSONDecode(httpget(exploiting and httpget or game:GetService'HttpService',proxyLink..ApiLink:match('Category=%d+')))
		for i,v in next, jsonData do
			setmetatable(v,{
				__tostring = function(self)
					return 'Datatable:\t'..self.Name
				end
			})
		end
		return jsonData
	end;
	getArgument = function(num,...)
		return ({...})[num]
	end;
	destroyIn = function(who,seconds)
		game:GetService("Debris"):AddItem(who,seconds)
	end;
	exists = function(yes)
		return yes ~= nil and true or false
	end;
	--Redo StringFilterOut  and Switch
	dynamicProperty = function(Object, Typ)
		local cn = Object.ClassName
		return (cn:find'Text' and 'Text' or cn:find'Image' and 'Image' or 'Background')..(Typ or 'Color3')
	end;
	round = function(number, placement)
		local mult = math.pow(10,placement or 0)
		return math.floor(number*mult + .5)/mult;
	end;
	contains = function(containing,...)
		for i,content in next,{...} do
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
	Easings = setmetatable({
		},{
		__index = function(self, index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				newStyle = function(Name, Types,...) --creates a section for new easings under a keyname such as Quad
					if ... then Types = self.fromBezier(Types,...) end
					self[Name] = Types and (type(Types) == 'table' and Types or type(Types) == 'function' and {Out = Types}) or {}
				end;
				newDirection = function(Style, Name, Function,...) --creates a type (typically a direction) for a easing style such as InOut
					if ... then Function = self.fromBezier(Function,...) end
					if not self[Style] then self[Style] = {} end
					self[Style][Name] = Function
				end;
				getStyle = function(Name)
					return self[Name]
				end;
				getDirection = function(Style, Type)
					return self[Style][Type or 'Out']
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
					return function(t, b, c, d)
						t = (c or 1)*t / (d or 1) + (b or 0)
						if t == 0 or t == 1 then -- Make sure the endpoints are correct
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
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
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
	tweenedObjects = {};
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			customTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat)
				Property = type(Property) == 'table' and Property or {Property}
				if cancel then self.cancelTween(Object,table.concat(Property)) end
				for i = 1,#Property do
					local v = Property[i]
					local EndValue = type(EndValue) == 'table' and EndValue[i] or EndValue
					Property[v] = {Object[v],EndValue,self.Lerps[typeof(EndValue)]}
					Property[i] = nil
				end
				local easingFunction = EasingStyle and (type(EasingStyle) == 'function' and EasingStyle or self.Easings.getDirection(EasingStyle, EasingDirection or 'Out'))
				local time, rep, elapsed
				local heart = game:GetService('RunService').Heartbeat
				local function reset()
					time, rep = Duration or 0, Repeat or 0
					elapsed = 0
				end
				reset()	
				local function tween(en,rep)
					for i,v in next, Property do
						if rep then
							Object[i] = v[1]
						elseif not en then
							Object[i] = v[3](v[1],v[2], easingFunction and easingFunction(elapsed, 0, 1, Duration) or elapsed/Duration)
						else
							Object[i] = v[2]
						end
					end
				end	
				local playing, connection = false
				local function stepped(step)
					if not (elapsed == 0 and step > 1) then
						local function go()
							elapsed = elapsed + step
							if time > elapsed then
								tween()
							else
								tween(true)
								playing = 'check'
							end	
						end
						
						if playing == true then
							go()
						elseif playing == 'check' and (rep == true or rep > 0 or rep < 0) then
							rep = rep == true or rep - 1
							elapsed = 0
							tween(false,true)
							playing = true
						else
							playing = false
							connection:Disconnect()
						end		
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
						Wait = function(self)
							repeat wait() until playing == false
						end
					}
				})
				tween:Play()
				local to = getmetatable(self).tweenedObjects
				if not to[Object] then to[Object] = {} end
				for i,v in next, Property do
					to[Object][i] = tween
				end
				return tween
			end;
			tweenServiceTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat, Reverse, Delay)
				local Property = type(Property) == 'table' and Property or {Property}
				if cancel then self.cancelTween(Object,table.concat(Property)) end
				for i = 1,#Property do
					local v = Property[i]
					Property[v] = type(EndValue) == 'table' and EndValue[i] or EndValue
					Property[i] = nil
				end
				local tween = game:GetService('TweenService'):Create(Object,
					TweenInfo.new(Duration,
						EasingStyle and (type(EasingStyle) == 'string' and Enum.EasingStyle[EasingStyle] or EasingStyle) or Enum.EasingStyle.Quad,
						EasingDirection and (type(EasingDirection) == 'string' and Enum.EasingDirection[EasingDirection] or EasingDirection) or Enum.EasingDirection.Out,
						Repeat and (Repeat == true and -1 or Repeat) or 0, Reverse or false, Delay or 0
					),
					Property
				)
				tween:Play()
				local to = getmetatable(self).tweenedObjects
				if not to[Object] then to[Object] = {} end
				local str = ''
				for i,v in next, Property do
					to[Object][i] = tween
				end
				return tween
			end;
			lerp = function(BeginingValue, EndValue, Alpha, EasingStyle, EasingDirection)
				local Lerps = self.Lerps
				return Lerps[typeof(BeginingValue)](BeginingValue, EndValue, 
					EasingStyle and ((type(EasingStyle) == 'string' and self.Easings[EasingStyle][EasingDirection or 'Out'](Alpha, 0, 1, 1) ) or
						type(EasingStyle) == 'function' and EasingStyle(Alpha, 0, 1, 1) 
					) or
					Alpha
				)
			end;
			cancelTween = function(Object,Property)
				pcall(function() --im lazy lol
					if Object and Property then
						for i,v in next, getmetatable(self).tweenedObjects[Object] do
							if i:find(Property) then
								v:Cancel()
							end
						end
					elseif Object then
						for i,v in next, Object do
							v:Cancel()
						end
					else
						for i,Object in next, getmetatable(self).tweenedObjects do
							for i,v in next, Object do
								v:Cancel()
							end
						end
					end
				end)
			end;
			rotate = function(Object, Angle, Speed,Custom, ...)
				local EndValue = Object.Rotation + Angle
				return Custom and self.customTween(Object,'Rotation',EndValue,Speed,...) or self.tweenServiceTween(Object,'Rotation',EndValue,Speed,...)
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
Objects = setmetatable({
	getAncestors = function(Object)
		local directory = {game};
		local ind = game
		for name in Object:GetFullName():gsub('%.','\0'):gmatch('%Z+') do
			local temp = ind[name]
			if not name == 'game' and game:GetService(name) or temp:IsAncestorOf(Object) then
				ind = temp
				table.insert(directory,ind)
			end
		end
		local final = {}
		for i,v in next, directory do
			final[#directory-i+1] = v
		end
		return final
	end;
	Classes = setmetatable({},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = function(ClassName, onCreated)
					self[ClassName] = setmetatable({onCreated = onCreated, Objects = {}},{
						__call = function(self,...)
							local me = self.onCreated(...)
							table.insert(self.Objects,me)
							return me
						end
					});
				end;
				isA = function(Object, ClassName)
					return Object:IsA(ClassName) or self.ClassName.Objects[Object] or false
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end		
	});
	Custom = setmetatable({},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				getCustomFromInstance = function(Object)
					return self[Object] or typeof(Object) == 'userdata' and Object or false
				end;
				isCustom = function(Object)
					return self[Object] and true or false
				end;
				new = function(ClassName, Parent, Props, CustomProps)
					local instance = type(ClassName) ~= 'string' and ClassName or Instance.new(ClassName)
					instance.Parent = Parent
					local object = newproxy(true)
					getmetatable(object).__index = {setmetatable = function(self, tab) for i,v in next, getmetatable(self) do getmetatable(self)[i] = nil end for i,v in next, tab do getmetatable(self)[i] = v end end}
					local objectMeta
					objectMeta = {
						['Instance'] = instance, Object = CustomProps or {}, Index = {}, NewIndex = {};
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
							if type(name) ~= 'string' then return getmetatable(proxy).__call(proxy,...) end
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
									local clone = newproxy(true)
									getmetatable(clone).__index = {setmetatable = function(self, tab) for i,v in next, getmetatable(self) do getmetatable(self)[i] = nil end for i,v in next, tab do getmetatable(self)[i] = v end end}
									local clonemeta = Spice.Table.clone(objmeta)
									clonemeta.Instance.Parent = parent
									clone:setmetatable(clonemeta)
									for i,v in next, prop or {} do
										if pcall(function() return clone[i] end) then
											clone[i] = v
											prop[i] = nil
										end
									end
									if prop then Spice.Properties.setProperties(clonemeta.Instance,prop) end
									return clone
								end;
							}
							if default[name] then return default[name](unpack(args)) end
							if objmeta.Object[name] and type(objmeta.Object[name]) == 'function' then
								return objmeta.Object[name](proxy,unpack(args))
							end
							if pcall(function() return objmeta.Instance[name] end) and type(objmeta.Instance[name]) == 'function' then
								return objmeta.Instance[name](objmeta.Instance,unpack(args))
							end
						end;
						__tostring = function(self)
							return 'Custom'..self.Instance.ClassName
						end;
					}
					object:setmetatable(objectMeta)
					rawset(self,instance,object)
					object(Props or {})
					return object					
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end		
	});
},{
	__index = function(self,index)	
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			new = function(ClassName, Parent, ...) --faster
				local args, instance, props = {...}
				if type(args[#args]) == 'table' then
					props = args[#args]
					args[#args] = nil
				end
				instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
				instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
				if props then
				Spice.Properties.setProperties(instance, props) end
				return instance
			end;
			newInstance = function(ClassName, Parent, Props)
				local instance = Instance.new(ClassName, Parent)
				for i,v in next, Props or {} do
					if not pcall(function() return instance[i] and true or false end) then
						Spice.Properties.setProperties(instance,Props)
					else
						instance[i] = v
						Props[i] = nil
					end
				end
				return instance
			end;
			newDefault = function(ClassName, Parent, ...)
				local args, instance, props = {...}
				instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
				instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
				if type(args[#args]) == 'table' then
					props = args[#args]
					args[#args] = nil
				end	
				Spice.Properties.Default.toDefaultProperties(instance)	
				if props then		
				Spice.Properties.setProperties(instance, props) end
				return instance					
			end;
			clone = function(Object, Parent, Props)
				local clone = Object:Clone()
				clone.Parent = Parent
				if Props then
				Spice.Properties.setProperties(Object,Props) end
				return clone
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end		
});
Positioning = {
	new = function(...)
		local args = {...}
		if #args == 4 or (typeof(args[1]) == 'UDim' or typeof(args[2]) == 'UDim')  then
			return UDim2.new(unpack(args))
		else
			local a,b  = args[1], args[3] == nil and args[1] or args[2]
			local val = args[3] or args[2] or 1
			local alt, main = {s = 1,o = 2,b = 3,so = 4,['os'] = 5},{UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)}
			return alt[val] and main[alt[val]] or main[val]
		end
	end;
	fromUDim = function(a,b)
		return b and UDim.new(a,b) or UDim.new(a,a)
	end;
	fromVector2 = function(a,b)
		return b and Vector2.new(a,b) or Vector2.new(a,a)
	end;
	fromPosition = function(a,b)
		a,b = a:lower(), b:lower()
		local x,y = (a == 'left' or a == 'right') and a or (b == 'left' or b == 'right') and b or nil,( a == 'top' or a == 'bottom') and a or (b == 'top' or b == 'bottom') and b or nil
		local alt, main = {top = 1, mid = 2, bottom = 3, center = 4}, {UDim.new(0,0),UDim.new(.5,0),UDim.new(1,0),UDim.new(.5,0)}
		local vy = main[alt[y]] or (b ~= x and (alt[b] and main[alt[b]] or main[b]))
		alt = {left = 1, mid = 2, right = 3, center = 4}
		local vx = main[alt[x]] or (a ~= y and (alt[a] and main[alt[a]] or main[a]))
		return UDim2.new(vx or UDim.new(0,0),vy or UDim.new(0,0))
	end;
	fromOffset = function(a,b)
		return UDim2.new(0,a,0,b)
	end;
	fromScale = function(a,b)
		return UDim2.new(a,0,b,0)
	end;			
};
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
			if type(i) == 'string' then
				rawset(to,i,v)
			else
				table.insert(to,v)
			end
		end
		return to
	end;
	clone = function(tab)
		local clone
		clone = function(x)
			local cloned = {}
			for i,v in next,x do
				if type(v) == 'table' then
					rawset(cloned,i,clone(v))
				else
					if typeof(i) == 'Instance' then i = i:Clone() end
					if typeof(v) == 'Instance' then v = v:Clone() end
					rawset(cloned,i,v)
				end
			end	
			if getmetatable(x) then
				local metaclone = getmetatable(x)
				setmetatable(cloned,metaclone)
			end		
			return cloned
		end
		return clone(tab)
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
		for i,v in next, tabl do
			count = count + 1
		end
		return count
	end;
	concat = function(tabl, seperation, decludeIndex, decludeVariable)
		local check = table.concat(tabl,seperation) --lol sorry ;-;
		if #check >= 1 then return check end
		local con = ''
		for i,v in next, tabl do
			con = con..(not decludeIndex and tostring(i) or '')..(not decludeIndex and not decludeVariable and ' = ' or '')..(not decludeVariable and tostring(v) or '')..(next(tabl, i) and seperation or '')
		end
		return con
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
		local compareFunctions = {...}
		if #compareFunctions == 0 then compareFunctions = nil end
		for i,v in next, tabl do
			if i == this or v == this or 
				(type(this) == 'string' and (
					 type(i) == 'string'  and i:sub(1,#this):lower() == this:lower() or 
					 type(v) == 'string' and v:sub(1,#this):lower() == this:lower() or
					 typeof(v) == 'Instance' and v.Name:sub(1,#this):lower() == this:lower()
				)) or compareFunctions and ({pcall(function()	
						for _,compareFunction in next, compareFunctions do
							if compareFunction(this,i,v) then
								return true
							end
						end 
					return false
				end)})[2] == true
			then
				if not keepFound then
					return v, i
				else
					table.insert(found,{v,i})
				end
			end
		end
		if keepFound then return found end
	end;
},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			mergeClone = function(a,b) --bypasses no call back rule
				local a,b = self.clone(a), self.clone(b)
				return self.mergeTo(b,a)
			end;
			search = function(tabl, this, skipStored, keepSimilar, returnFirst, subStringSearch, capSearch, ...) --relies on Table.find; bypasses no call back rule
				local index, value, capAlg, subAlg
				--Saved Results means less elapsed time if searched again
				if not getmetatable(tabl) then setmetatable(tabl,{}) end
				local meta = getmetatable(tabl) 
				if not meta['SpiceSearchResultsStorage'] then
					meta['SpiceSearchResultsStorage'] = {}
				end
				local usedStorage = meta['SpiceSearchResultsStorage']		
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
							if strin:lower() == comparative:lower() then
								return true
							end
						end
						return false
					end
				end	
				if subStringSearch then
					function subAlg(comparative, ind, val)
						local subject, subject2 = (type(ind) == 'string' and ind or type(val) == 'string' and val):lower(),(type(ind) == 'string' and type(val) == 'string' and val):lower()
						return subject and subject:find(comparative:lower(), 1, true) and true or subject2 and subject2:find(comparative:lower(), 1, true) and true or false
					end
				end
				--Checks the Used Storage for 'this' and returns if exists
				if not skipStored then
					local stored = usedStorage[this]
					if stored then
						value, index = stored[1], stored[2]
					end
					if value and index then
						usedStorage[this] = {value, index}
						return value, index
					end
				end	
				--Checks if 'this' is found with chosen specified means
				value, index = self.find(tabl, this, keepSimilar or false,
					subAlg, capAlg, ...
				)
				if value and index then
					usedStorage[this] = {value, index}
					return value, index
				end	
				--Returns the results if keepSimilar
				if keepSimilar and value and value[1] then
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
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
Properties = setmetatable({
	Default = setmetatable({},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
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
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
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
	RobloxAPI = setmetatable({"C0","C1","F0","F1","F2","F3","Hit","hit","Mix","Sit","Axes","Axis","Drag","Duty","Face","Font","Grip","Heat","Icon","Jump","Line","Loop","Name","Port","Rate","SIMD","size","Size","Text","Time","Tone","Angle","Coils","Color","Delay","Delta","Depth","Faces","focus","Focus","Force","force","Genre","Guest","Image","InOut","InUse","JobId","Level","Modal","OsVer","Pitch","Point","Range","Ratio","Scale","Score","Shape","Shiny","Speed","Steer","Style","Title","TurnD","TurnP","Value","Active","Attack","CFrame","cframe","Color3","FaceId","FogEnd","GameId","GripUp","Health","Height","Length","Locked","Looped","MeshId","Octave","Offset","Origin","Radius","Source","Spread","Status","Ticket","Torque","userId","UserId","Volume","Weight","Width0","Width1","ZIndex","Ambient","BaseUrl","BinType","Damping","Density","Enabled","GcLimit","GcPause","GfxCard","Graphic","Gravity","GripPos","KeyCode","LowGain","MaxSize","MidGain","MinSize","Neutral","Opacity","Padding","PlaceId","Playing","Purpose","Release","RigType","Shadows","SoundId","summary","Texture","ThrustD","ThrustP","Timeout","ToolTip","UnitRay","Version","Visible","ZOffset","ActionId","Anchored","Animated","AutoRuns","BodyPart","CellSize","ChatMode","Circular","Contrast","DataCost","Disabled","DryLevel","Duration","Feedback","FogColor","FogStart","FontSize","Friction","GridSize","HighGain","IsLoaded","IsPaused","IsSmooth","JobCount","Lifetime","LocaleId","Localize","location","Location","Material","maxForce","MaxForce","MaxItems","MaxSpeed","MaxValue","MeshType","MidImage","MinValue","Outlines","position","Position","Priority","Rotation","RotSpeed","Segments","Selected","SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","Specular","TextFits","TextSize","TextWrap","Throttle","TileSize","TopImage","UseCSGv2","Velocity","velocity","VRDevice","WetLevel","BaseAngle","Browsable","ClassName","className","ClockTime","Condition","CreatorId","DataModel","DataReady","DecayTime","Diffusion","Draggable","EnableFRM","Frequency","GcStepMul","GripRight","HeadColor","HeadScale","HipHeight","Intensity","IsBackend","IsEnabled","IsPlaying","isPlaying","IsWindows","JumpPower","LeftRight","Magnitude","MajorAxis","maxHealth","MaxHealth","MaxLength","MaxThrust","MaxTorque","maxTorque","MinLength","MultiLine","OsIs64Bit","PackageId","PrintBits","ScaleType","SkinColor","SortOrder","StarCount","StatusTip","Stiffness","TeamColor","TestCount","TextColor","TextureId","TextureID","Thickness","Threshold","TimeOfDay","TintColor","TopBottom","TopParamA","TopParamB","Transform","TurnSpeed","TweenInfo","TweenTime","UIMaximum","UIMinimum","VersionId","ViewSizeX","ViewSizeY","VREnabled","WalkSpeed","WarnCount","WorldAxis","AccountAge","AllowSleep","Archivable","archivable","AspectType","AutoRotate","BackParamA","BackParamB","brickColor","BrickColor","Brightness","BubbleChat","CameraMode","CameraType","CanCollide","CanvasSize","ColorShift","Constraint","CursorIcon","CurveSize0","CurveSize1","DataGCRate","Deprecated","Elasticity","ErrorCount","Expression","FaceCamera","formFactor","FormFactor","FreeLength","Fullscreen","GainMakeup","HeadColor3","HeadLocked","HoverImage","Insertable","IsFinished","LeftParamA","LeftParamB","LineHeight","LowerAngle","LowerLimit","MaskWeight","MaxExtents","MaxPlayers","MenuIsOpen","NavBarSize","NearPlaneZ","NumPlayers","numPlayers","OsPlatform","PaddingTop","ReceiveAge","RelativeTo","Saturation","Selectable","ShouldSkip","SizeOffset","SteerFloat","Teleported","TextBounds","TextColor3","TextScaled","TimeLength","TopSurface","TorsoColor","UINumTicks","UpperAngle","UpperLimit","UserDialog","WaterColor","WidthScale","WireRadius","AlwaysOnTop","AnchorPoint","AnimationId","AspectRatio","BackSurface","BlastRadius","BorderColor","BottomImage","CellPadding","ChatHistory","ChatVisible","ClassicChat","ControlMode","CreatorType","CurrentLine","CycleOffset","Description","DisplayName","EasingStyle","EmitterSize","EmptyCutoff","FieldOfView","FrontParamA","FrontParamB","GcFrequency","GripForward","HttpEnabled","ImageColor3","IsDebugging","IsTreeShown","LayoutOrder","LeftSurface","LuaRamLimit","MaxDistance","MaxTextSize","MaxVelocity","MinDistance","MinTextSize","Orientation","PaddingLeft","PlayerCount","PrintEvents","ReceiveRate","Reflectance","Restitution","RightParamA","RightParamB","RollOffMode","RotVelocity","ShadowColor","SizeInCells","SliceCenter","SpreadAngle","StartCorner","StudsOffset","TargetAngle","TargetPoint","TextureMode","TextureSize","TextWrapped","TorsoColor3","VertexColor","VideoMemory","VIPServerId","WalkToPoint","WorldCFrame","AbsoluteSize","Acceleration","ActuatorType","AngularSpeed","AttachmentUp","AutoFRMLevel","AutoLocalize","BehaviorType","BorderColor3","BottomParamA","BottomParamB","CameraOffset","CanBeDropped","CenterOfMass","CurrentAngle","DataSendKbps","DataSendRate","DesiredAngle","DisableCSGv2","DisplayOrder","DominantAxis","DopplerScale","FollowUserId","FrontSurface","GraphicsMode","LeftArmColor","LeftLegColor","LinkedSource","LockedToPart","MasterVolume","ModalEnabled","MouseEnabled","OsPlatformId","PaddingRight","PlaceVersion","PlayOnRemove","PressedImage","PrintFilters","PrintTouches","QualityLevel","ReloadAssets","ResetOnSpawn","RightSurface","RiseVelocity","RobloxLocked","RolloffScale","RotationType","SparkleColor","StickyWheels","SunTextureId","SurfaceColor","TargetOffset","TargetRadius","TeleportedIn","TextTruncate","TextureSpeed","TimePosition","TouchEnabled","Transparency","UsePartColor","VideoQuality","ViewportSize","VRDeviceName","WeightTarget","AmbientReverb","AttachmentPos","BaseTextureId","BlastPressure","BottomBarSize","BottomSurface","CartoonFactor","ClassCategory","ContactsCount","CurrentLength","DataMtuAdjust","ExplorerOrder","ExplosionType","ExtentsOffset","FillDirection","FloorMaterial","GlobalShadows","GoodbyeDialog","HardwareMouse","HasEverUsedVR","ImageRectSize","InitialPrompt","InstanceCount","IsModalDialog","LeftArmColor3","LeftLegColor3","LightEmission","LimitsEnabled","LineThickness","LocalizedText","MaxSlopeAngle","MeshCacheSize","MoonTextureId","MotorMaxForce","MouseBehavior","MoveDirection","NameOcclusion","PaddingBottom","PantsTemplate","PlatformStand","PlaybackSpeed","PlaybackState","RightArmColor","RightLegColor","RobloxVersion","SchedulerRate","ScriptContext","SecondaryAxis","ServoMaxForce","ShirtTemplate","SoftwareSound","StatusBarSize","StudsPerTileU","StudsPerTileV","SurfaceColor3","TargetSurface","TextureLength","ThrottleFloat","TouchSendRate","TriangleCount","TriggerOffset","UserInputType","WaterWaveSize","WeightCurrent","WorldPosition","WorldRotation","AreOwnersShown","AutoAssignable","AutomaticRetry","CanvasPosition","DataComplexity","DistanceFactor","ErrorReporting","GamepadEnabled","HeadsUpDisplay","IgnoreGuiInset","IsSleepAllowed","LightInfluence","MembershipType","MotorMaxTorque","OutdoorAmbient","PrintInstances","RequiresHandle","ResponseDialog","Responsiveness","RightArmColor3","RightLegColor3","RobloxLocaleId","SecondaryColor","ServoMaxTorque","SizeConstraint","SourceLocaleId","SunAngularSize","SystemLocaleId","TargetPosition","TextXAlignment","TextYAlignment","ThreadPoolSize","TrackDataTypes","UserHeadCFrame","UserInputState","VelocitySpread","WaterWaveSpeed","ZIndexBehavior","angularvelocity","AngularVelocity","AreAnchorsShown","AreRegionsShown","AttachmentPoint","AttachmentRight","AutoButtonColor","AutoJumpEnabled","BackgroundColor","BorderSizePixel","CameraYInverted","CoordinateFrame","CurrentDistance","CurrentPosition","DataReceiveKbps","DefaultWaitTime","EasingDirection","EditingDisabled","ElasticBehavior","ExtraMemoryUsed","HeartbeatTimeMs","ImageRectOffset","IsSFFlagsLoaded","KeyboardEnabled","LoadDefaultChat","MoonAngularSize","NumberOfPlayers","OnTopOfCoreBlur","PhysicsSendKbps","PhysicsSendRate","PlaceholderText","PreferredParent","PrimaryAxisOnly","PrimitivesCount","PrintProperties","ResizeableFaces","ResizeIncrement","RigidityEnabled","ScriptsDisabled","ShowNativeInput","SpecificGravity","TopSurfaceInput","TriggerDistance","TwistLowerAngle","TwistUpperAngle","AbsolutePosition","AbsoluteRotation","BackgroundColor3","BackSurfaceInput","ChatScrollLength","ClearTextOnFocus","ClipsDescendants","CollisionEnabled","CollisionGroupId","ComparisonMethod","ConstrainedValue","DataSendPriority","DebuggingEnabled","EditQualityLevel","FilteringEnabled","FrameRateManager","FreeMemoryMBytes","GearGenreSetting","GyroscopeEnabled","InclinationAngle","InverseSquareLaw","IsLuaChatEnabled","LeftSurfaceInput","MouseIconEnabled","MouseSensitivity","NetworkOwnerRate","OverlayTextureId","PhysicsMtuAdjust","PlaybackLoudness","PreferredParents","PreferredPlayers","ProcessUserInput","RequestQueueSize","ScrollingEnabled","SimulationRadius","StreamingEnabled","TextStrokeColor3","TextTransparency","ThreadPoolConfig","VIPServerOwnerId","WaterReflectance","WorldOrientation","AppearanceDidLoad","AreBodyTypesShown","AreHingesDetected","AttachmentForward","EmissionDirection","FrontSurfaceInput","HealthDisplayType","ImageTransparency","IsReceiveAgeShown","PhysicsStepTimeMs","PlaceholderColor3","PrintSplitMessage","RightSurfaceInput","RobloxProductName","SavedQualityLevel","ScreenOrientation","ShowBoundingBoxes","SystemProductName","TouchInputEnabled","TouchMovementMode","VerticalAlignment","WaterTransparency","WorldRotationAxis","AbsoluteWindowSize","AdditionalLuaState","AngularRestitution","AreAssembliesShown","AreMechanismsShown","ArePartCoordsShown","BottomSurfaceInput","BubbleChatLifetime","CharacterAutoLoads","DevEnableMouseLock","DevTouchCameraMode","EagerBulkExecution","ExplorerImageIndex","FillEmptySpaceRows","GeographicLatitude","GuiInputUserCFrame","LegacyNamingScheme","ManualFocusRelease","MaxAngularVelocity","MaxCollisionSounds","MaxPlayersInternal","OverlayNativeInput","PhysicsReceiveKbps","PrintPhysicsErrors","SchedulerDutyCycle","ScrollBarThickness","ScrollingDirection","ShowDevelopmentGui","SimulateSecondsLag","SizeRelativeOffset","ThrottleAdjustTime","TwistLimitsEnabled","WorldSecondaryAxis","AbsoluteContentSize","AngularActuatorType","ApplyAtCenterOfMass","AreModelCoordsShown","AreWorldCoordsShown","AutoColorCharacters","CharacterAppearance","DataComplexityLimit","DevelopmentLanguage","DisplayDistanceType","DistributedGameTime","GamepadInputEnabled","GoodbyeChoiceActive","HorizontalAlignment","NameDisplayDistance","PhysicsSendPriority","PreferredClientPort","ReportSoundWarnings","RotationAxisVisible","SurfaceTransparency","TrackPhysicsDetails","UsedHideHudShortcut","VelocityInheritance","VideoCaptureEnabled","VRRotationIntensity","AccelerometerEnabled","AllowThirdPartySales","AllTutorialsDisabled","AngularLimitsEnabled","AutoSelectGuiEnabled","BubbleChatMaxBubbles","CelestialBodiesShown","CollisionSoundVolume","ComputerMovementMode","ConversationDistance","CustomizedTeleportUI","DevTouchMovementMode","ExecuteWithStudioRun","GazeSelectionEnabled","GuiNavigationEnabled","IsLuaHomePageEnabled","IsQueueErrorComputed","IsTextScraperRunning","ManualActivationOnly","MotorMaxAcceleration","OnboardingsCompleted","OnScreenKeyboardSize","ReactionForceEnabled","ScrollBarImageColor3","StudsBetweenTextures","WaitingThreadsBudget","AllowCustomAnimations","AllowInsertFreeModels","AreContactPointsShown","CameraMaxZoomDistance","CameraMinZoomDistance","CharacterAppearanceId","ClientPhysicsSendRate","CollisionSoundEnabled","DevComputerCameraMode","EnableMouseLockOption","ExportMergeByMaterial","FillDirectionMaxCells","FillEmptySpaceColumns","HealthDisplayDistance","HostWidgetWasRestored","IsLuaGamesPageEnabled","MaxActivationDistance","MouseDeltaSensitivity","MovingPrimitivesCount","OverrideStarterScript","ReactionTorqueEnabled","RenderStreamedRegions","ResetPlayerGuiOnSpawn","StudsOffsetWorldSpace","UsePhysicsPacketCache","AllowTeamChangeOnTouch","AreContactIslandsShown","AreUnalignedPartsShown","BackgroundTransparency","DevCameraOcclusionMode","Is30FpsThrottleEnabled","IsFmodProfilingEnabled","IsUsingCameraYInverted","PhysicsAnalyzerEnabled","ReportAbuseChatHistory","TextStrokeTransparency","UseInstancePacketCache","VerticalScrollBarInset","AreScriptStartsReported","AutomaticScalingEnabled","ComparisonDiffThreshold","ComparisonPsnrThreshold","DevComputerMovementMode","ExtentsOffsetWorldSpace","IncommingReplicationLag","LoadCharacterAppearance","MaximumSimulationRadius","OnScreenKeyboardVisible","OnScreenProfilerEnabled","PerformanceStatsVisible","RenderCSGTrianglesDebug","RespectFilteringEnabled","ScrollWheelInputEnabled","TouchCameraMovementMode","AreAwakePartsHighlighted","AreJointCoordinatesShown","CoreGuiNavigationEnabled","CurrentScreenOrientation","CustomPhysicalProperties","FallenPartsDestroyHeight","GamepadCameraSensitivity","HorizontalScrollBarInset","LegacyInputEventsEnabled","MicroProfilerWebServerIP","OnScreenKeyboardPosition","PreferredPlayersInternal","PrintStreamInstanceQuota","ShowActiveAnimationAsset","TickCountPreciseOverride","ToolPunchThroughDistance","AdditionalCoreIncludeDirs","DestroyJointRadiusPercent","ForcePlayModeGameLocaleId","LocalTransparencyModifier","OverrideMouseIconBehavior","ShowDecompositionGeometry","VerticalScrollBarPosition","CanLoadCharacterAppearance","ComputerCameraMovementMode","DevTouchCameraMovementMode","MicroProfilerWebServerPort","ScrollBarImageTransparency","UsedCoreGuiIsVisibleToggle","ClickableWhenViewportHidden","ForcePlayModeRobloxLocaleId","IsScriptStackTracingEnabled","MotorMaxAngularAcceleration","MouseSensitivityFirstPerson","MouseSensitivityThirdPerson","ArePhysicsRejectionsReported","PhysicsEnvironmentalThrottle","UsedCustomGuiIsVisibleToggle","DevComputerCameraMovementMode","MicroProfilerWebServerEnabled","IsPhysicsEnvironmentalThrottled","IsUsingGamepadCameraSensitivity","RobloxForcePlayModeGameLocaleId","OnScreenKeyboardAnimationDuration","RobloxForcePlayModeRobloxLocaleId","TemporaryLegacyPhysicsSolverOverride"}
		,{
		FullAPI = setmetatable({},{__index = function(self, index) local gelf, ret = getmetatable(self) gelf.__index = {} for i,v in next, {
			ShirtGraphic = setmetatable({'Graphic'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LocalizationTable = setmetatable({'DevelopmentLanguage', 'SourceLocaleId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginGuiService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginMouse = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Mouse(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterGui = setmetatable({'ProcessUserInput', 'ResetPlayerGuiOnSpawn', 'ScreenOrientation', 'ShowDevelopmentGui'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePlayerGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Accoutrement = setmetatable({'AttachmentForward', 'AttachmentPoint', 'AttachmentPos', 'AttachmentRight', 'AttachmentUp'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AdService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebuggerManager = setmetatable({'DebuggingEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CharacterAppearance = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiMain = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ScreenGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VectorForce = setmetatable({'ApplyAtCenterOfMass', 'Force', 'RelativeTo'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionLasso = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HumanoidController = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Controller(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MeshContentProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CacheableContentProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Handles = setmetatable({'Faces', 'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandlesBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataClasses = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RemoteEvent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ValueBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Hole = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Feature(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Smoke = setmetatable({'Color', 'Enabled', 'Opacity', 'RiseVelocity', 'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			KeyframeSequenceProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CSGDictionaryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FlyweightService(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			UIScale = setmetatable({'Scale'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TimerService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CFrameValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InputObject = setmetatable({'Delta', 'KeyCode', 'Position', 'UserInputState', 'UserInputType'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ImageLabel = setmetatable({'Image', 'ImageColor3', 'ImageRectOffset', 'ImageRectSize', 'ImageTransparency', 'IsLoaded', 'ScaleType', 'SliceCenter', 'TileSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiLabel(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			NotificationService = setmetatable({'IsLuaChatEnabled', 'IsLuaGamesPageEnabled', 'IsLuaHomePageEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIListLayout = setmetatable({'Padding'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Torque = setmetatable({'RelativeTo', 'Torque'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HandleAdornment = setmetatable({'AlwaysOnTop', 'CFrame', 'SizeRelativeOffset', 'ZIndex'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PointLight = setmetatable({'Range'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Light(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TweenBase = setmetatable({'PlaybackState'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DoubleConstrainedValue = setmetatable({'ConstrainedValue', 'MaxValue', 'MinValue', 'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RocketPropulsion = setmetatable({'CartoonFactor', 'MaxSpeed', 'MaxThrust', 'MaxTorque', 'TargetOffset', 'TargetRadius', 'ThrustD', 'ThrustP', 'TurnD', 'TurnP'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CoreGui = setmetatable({'Version'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePlayerGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEvents = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReplicatedFirst = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpotLight = setmetatable({'Angle', 'Face', 'Range'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Light(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ButtonBindingWidget = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NegateOperation = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartOperation(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ChorusSoundEffect = setmetatable({'Depth', 'Mix', 'Rate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Tool = setmetatable({'CanBeDropped', 'Enabled', 'Grip', 'GripForward', 'GripPos', 'GripRight', 'GripUp', 'ManualActivationOnly', 'RequiresHandle', 'ToolTip'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BackpackItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Texture = setmetatable({'StudsPerTileU', 'StudsPerTileV'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Decal(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PhysicsSettings = setmetatable({'AllowSleep', 'AreAnchorsShown', 'AreAssembliesShown', 'AreAwakePartsHighlighted', 'AreBodyTypesShown', 'AreContactIslandsShown', 'AreContactPointsShown', 'AreJointCoordinatesShown', 'AreMechanismsShown', 'AreModelCoordsShown', 'AreOwnersShown', 'ArePartCoordsShown', 'AreRegionsShown', 'AreUnalignedPartsShown', 'AreWorldCoordsShown', 'DisableCSGv2', 'IsReceiveAgeShown', 'IsTreeShown', 'PhysicsAnalyzerEnabled', 'PhysicsEnvironmentalThrottle', 'ShowDecompositionGeometry', 'ThrottleAdjustTime', 'UseCSGv2'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Script = setmetatable({'Source'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BaseScript(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Terrain = setmetatable({'IsSmooth', 'MaxExtents', 'WaterColor', 'WaterReflectance', 'WaterTransparency', 'WaterWaveSize', 'WaterWaveSpeed'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			OrderedDataStore = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GlobalDataStore(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LineHandleAdornment = setmetatable({'Length', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RenderingTest = setmetatable({'CFrame', 'ComparisonDiffThreshold', 'ComparisonMethod', 'ComparisonPsnrThreshold', 'Description', 'FieldOfView', 'Orientation', 'Position', 'QualityLevel', 'ShouldSkip', 'Ticket'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			PVAdornment = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextBox = setmetatable({'ClearTextOnFocus', 'Font', 'FontSize', 'LineHeight', 'ManualFocusRelease', 'MultiLine', 'OverlayNativeInput', 'PlaceholderColor3', 'PlaceholderText', 'ShowNativeInput', 'Text', 'TextBounds', 'TextColor', 'TextColor3', 'TextFits', 'TextScaled', 'TextSize', 'TextStrokeColor3', 'TextStrokeTransparency', 'TextTransparency', 'TextTruncate', 'TextWrap', 'TextWrapped', 'TextXAlignment', 'TextYAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); KeyframeSequence = setmetatable({'Loop', 'Priority'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FunctionalTest = setmetatable({'Description'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServerScriptService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BillboardGui = setmetatable({'Active', 'AlwaysOnTop', 'ClipsDescendants', 'ExtentsOffset', 'ExtentsOffsetWorldSpace', 'LightInfluence', 'MaxDistance', 'Size', 'SizeOffset', 'StudsOffset', 'StudsOffsetWorldSpace'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Feature = setmetatable({'FaceId', 'InOut', 'LeftRight', 'TopBottom'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MarketplaceService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Team = setmetatable({'AutoAssignable', 'AutoColorCharacters', 'Score', 'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlangeSoundEffect = setmetatable({'Depth', 'Mix', 'Rate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MouseService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiButton = setmetatable({'AutoButtonColor', 'Modal', 'Selected', 'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIGridStyleLayout = setmetatable({'AbsoluteContentSize', 'FillDirection', 'HorizontalAlignment', 'SortOrder', 'VerticalAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UILayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); JointsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkPeer = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UITextSizeConstraint = setmetatable({'MaxTextSize', 'MinTextSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AdvancedDragger = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadata = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PointsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			GuiBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyGyro = setmetatable({'CFrame', 'D', 'MaxTorque', 'P'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Path = setmetatable({'Status'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiLabel = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpecialMesh = setmetatable({'MeshType'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FileMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InstancePacketCache = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Folder = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			FileMesh = setmetatable({'MeshId', 'TextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DataModelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Shirt = setmetatable({'ShirtTemplate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Clothing(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SlidingBallConstraint = setmetatable({'ActuatorType', 'CurrentPosition', 'LimitsEnabled', 'LowerLimit', 'MotorMaxAcceleration', 'MotorMaxForce', 'Restitution', 'ServoMaxForce', 'Size', 'Speed', 'TargetPosition', 'UpperLimit', 'Velocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Animator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GlobalDataStore = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SolidModelContentProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CacheableContentProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SkateboardPlatform = setmetatable({'Steer', 'StickyWheels', 'Throttle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebuggerWatch = setmetatable({'Expression'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataModelMesh = setmetatable({'Offset', 'Scale', 'VertexColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SkateboardController = setmetatable({'Steer', 'Throttle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Controller(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextLabel = setmetatable({'Font', 'FontSize', 'LineHeight', 'LocalizedText', 'Text', 'TextBounds', 'TextColor', 'TextColor3', 'TextFits', 'TextScaled', 'TextSize', 'TextStrokeColor3', 'TextStrokeTransparency', 'TextTransparency', 'TextTruncate', 'TextWrap', 'TextWrapped', 'TextXAlignment', 'TextYAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiLabel(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Mouse = setmetatable({'Hit', 'Icon', 'Origin', 'TargetSurface', 'UnitRay', 'ViewSizeX', 'ViewSizeY', 'X', 'Y'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Constraint = setmetatable({'Color', 'Enabled', 'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BindableFunction = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataCallbacks = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ImageHandleAdornment = setmetatable({'Image', 'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Clothing = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Lighting = setmetatable({'Ambient', 'Brightness', 'ClockTime', 'ColorShift', 'ColorShift', 'FogColor', 'FogEnd', 'FogStart', 'GeographicLatitude', 'GlobalShadows', 'OutdoorAmbient', 'Outlines', 'ShadowColor', 'TimeOfDay'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RenderSettings = setmetatable({'AutoFRMLevel', 'EagerBulkExecution', 'EditQualityLevel', 'EnableFRM', 'ExportMergeByMaterial', 'FrameRateManager', 'GraphicsMode', 'MeshCacheSize', 'QualityLevel', 'ReloadAssets', 'RenderCSGTrianglesDebug', 'ShowBoundingBoxes'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ObjectValue = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			CharacterMesh = setmetatable({'BaseTextureId', 'BodyPart', 'MeshId', 'OverlayTextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuidRegistryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GameSettings = setmetatable({'AdditionalCoreIncludeDirs', 'BubbleChatLifetime', 'BubbleChatMaxBubbles', 'ChatHistory', 'ChatScrollLength', 'CollisionSoundEnabled', 'CollisionSoundVolume', 'HardwareMouse', 'MaxCollisionSounds', 'OverrideStarterScript', 'ReportAbuseChatHistory', 'SoftwareSound', 'VideoCaptureEnabled', 'VideoQuality'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TotalCountTimeIntervalItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEnum = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			HandlesBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FaceInstance = setmetatable({'Face'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Toolbar = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyColors = setmetatable({'HeadColor', 'HeadColor3', 'LeftArmColor', 'LeftArmColor3', 'LeftLegColor', 'LeftLegColor3', 'RightArmColor', 'RightArmColor3', 'RightLegColor', 'RightLegColor3', 'TorsoColor', 'TorsoColor3'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FriendService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ColorCorrectionEffect = setmetatable({'Brightness', 'Contrast', 'Saturation', 'TintColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CookiesService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RopeConstraint = setmetatable({'CurrentDistance', 'Length', 'Restitution', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PVInstance = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionBox = setmetatable({'LineThickness', 'SurfaceColor', 'SurfaceColor3', 'SurfaceTransparency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VehicleSeat = setmetatable({'AreHingesDetected', 'Disabled', 'HeadsUpDisplay', 'MaxSpeed', 'Steer', 'SteerFloat', 'Throttle', 'ThrottleFloat', 'Torque', 'TurnSpeed'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebugSettings = setmetatable({'DataModel', 'ErrorReporting', 'GfxCard', 'InstanceCount', 'IsFmodProfilingEnabled', 'IsScriptStackTracingEnabled', 'JobCount', 'LuaRamLimit', 'OsIs64Bit', 'OsPlatform', 'OsPlatformId', 'OsVer', 'PlayerCount', 'ReportSoundWarnings', 'RobloxProductName', 'RobloxVersion', 'SIMD', 'SystemProductName', 'TickCountPreciseOverride', 'VideoMemory'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServerStorage = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); IntValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FloorWire = setmetatable({'CycleOffset', 'StudsBetweenTextures', 'Texture', 'TextureSize', 'Velocity', 'WireRadius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiRoot = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Controller = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Motor = setmetatable({'CurrentAngle', 'DesiredAngle', 'MaxVelocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Glue = setmetatable({'F0', 'F1', 'F2', 'F3'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIGridLayout = setmetatable({'CellPadding', 'CellSize', 'FillDirectionMaxCells', 'StartCorner'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			LayerCollector = setmetatable({'Enabled', 'ResetOnSpawn', 'ZIndexBehavior'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase2d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GlobalSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GenericSettings(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Geometry = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ManualWeld = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ManualSurfaceJointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SoundGroup = setmetatable({'Volume'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiObject = setmetatable({'Active', 'AnchorPoint', 'BackgroundColor', 'BackgroundColor3', 'BackgroundTransparency', 'BorderColor', 'BorderColor3', 'BorderSizePixel', 'ClipsDescendants', 'Draggable', 'LayoutOrder', 'Position', 'Rotation', 'Selectable', 'Size', 'SizeConstraint', 'Transparency', 'Visible', 'ZIndex'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase2d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebuggerBreakpoint = setmetatable({'Condition', 'IsEnabled', 'Line'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SunRaysEffect = setmetatable({'Intensity', 'Spread'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			CorePackages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Status = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Model(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Pose = setmetatable({'CFrame', 'EasingDirection', 'EasingStyle', 'MaskWeight', 'Weight'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PlayerMouse = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Mouse(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AnimationTrack = setmetatable({'IsPlaying', 'Length', 'Looped', 'Priority', 'Speed', 'TimePosition', 'WeightCurrent', 'WeightTarget'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AnalyticsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LogService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AlignPosition = setmetatable({'ApplyAtCenterOfMass', 'MaxForce', 'MaxVelocity', 'ReactionForceEnabled', 'Responsiveness', 'RigidityEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InsertService = setmetatable({'AllowInsertFreeModels'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HingeConstraint = setmetatable({'ActuatorType', 'AngularSpeed', 'AngularVelocity', 'CurrentAngle', 'LimitsEnabled', 'LowerAngle', 'MotorMaxAcceleration', 'MotorMaxTorque', 'Radius', 'Restitution', 'ServoMaxTorque', 'TargetAngle', 'UpperAngle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Message = setmetatable({'Text'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Player = setmetatable({'AccountAge', 'AppearanceDidLoad', 'AutoJumpEnabled', 'CameraMaxZoomDistance', 'CameraMinZoomDistance', 'CameraMode', 'CanLoadCharacterAppearance', 'CharacterAppearance', 'CharacterAppearanceId', 'ChatMode', 'DataComplexity', 'DataComplexityLimit', 'DataReady', 'DevCameraOcclusionMode', 'DevComputerCameraMode', 'DevComputerMovementMode', 'DevEnableMouseLock', 'DevTouchCameraMode', 'DevTouchMovementMode', 'DisplayName', 'FollowUserId', 'Guest', 'HealthDisplayDistance', 'LocaleId', 'MaximumSimulationRadius', 'MembershipType', 'NameDisplayDistance', 'Neutral', 'OsPlatform', 'SimulationRadius', 'TeamColor', 'Teleported', 'TeleportedIn', 'UserId', 'VRDevice'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ContentProvider = setmetatable({'BaseUrl', 'RequestQueueSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BoxHandleAdornment = setmetatable({'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScrollingFrame = setmetatable({'AbsoluteWindowSize', 'BottomImage', 'CanvasPosition', 'CanvasSize', 'ElasticBehavior', 'HorizontalScrollBarInset', 'MidImage', 'ScrollBarImageColor3', 'ScrollBarImageTransparency', 'ScrollBarThickness', 'ScrollingDirection', 'ScrollingEnabled', 'TopImage', 'VerticalScrollBarInset', 'VerticalScrollBarPosition'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ManualSurfaceJointInstance = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Humanoid = setmetatable({'AutoJumpEnabled', 'AutoRotate', 'AutomaticScalingEnabled', 'CameraOffset', 'DisplayDistanceType', 'FloorMaterial', 'Health', 'HealthDisplayDistance', 'HealthDisplayType', 'HipHeight', 'Jump', 'JumpPower', 'MaxHealth', 'MaxSlopeAngle', 'MoveDirection', 'NameDisplayDistance', 'NameOcclusion', 'PlatformStand', 'RigType', 'Sit', 'TargetPoint', 'WalkSpeed', 'WalkToPoint'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MeshPart = setmetatable({'MeshId', 'TextureID'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CylinderHandleAdornment = setmetatable({'Height', 'Radius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			PhysicsPacketCache = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RunningAverageItemDouble = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BloomEffect = setmetatable({'Intensity', 'Size', 'Threshold'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Attachment = setmetatable({'Axis', 'CFrame', 'Orientation', 'Position', 'Rotation', 'SecondaryAxis', 'Visible', 'WorldAxis', 'WorldCFrame', 'WorldOrientation', 'WorldPosition', 'WorldRotation', 'WorldSecondaryAxis'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Light = setmetatable({'Brightness', 'Color', 'Enabled', 'Shadows'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RobloxReplicatedStorage = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyMover = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AssetService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); WedgePart = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FormFactorPart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScriptService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ImageButton = setmetatable({'HoverImage', 'Image', 'ImageColor3', 'ImageRectOffset', 'ImageRectSize', 'ImageTransparency', 'IsLoaded', 'PressedImage', 'ScaleType', 'SliceCenter', 'TileSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiButton(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HapticService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiBase2d = setmetatable({'AbsolutePosition', 'AbsoluteRotation', 'AbsoluteSize', 'AutoLocalize', 'Localize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DialogChoice = setmetatable({'GoodbyeChoiceActive', 'GoodbyeDialog', 'ResponseDialog', 'UserDialog'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NumberValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); JointInstance = setmetatable({'C0', 'C1'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CylindricalConstraint = setmetatable({'AngularActuatorType', 'AngularLimitsEnabled', 'AngularRestitution', 'AngularSpeed', 'AngularVelocity', 'CurrentAngle', 'InclinationAngle', 'LowerAngle', 'MotorMaxAngularAcceleration', 'MotorMaxTorque', 'RotationAxisVisible', 'ServoMaxTorque', 'TargetAngle', 'UpperAngle', 'WorldRotationAxis'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SlidingBallConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); WeldConstraint = setmetatable({'Enabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CollectionService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Visit = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Configuration = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			VirtualUser = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VirtualInputManager = setmetatable({'AdditionalLuaState'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Accessory = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Accoutrement(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			SelectionPointLasso = setmetatable({'Point'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SelectionLasso(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Skin = setmetatable({'SkinColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			GamePassService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Vector3Value = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StringValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); IntConstrainedValue = setmetatable({'ConstrainedValue', 'MaxValue', 'MinValue', 'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataMember = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AnalysticsSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GenericSettings(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HopperBin = setmetatable({'Active', 'BinType'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BackpackItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RuntimeScriptService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HttpService = setmetatable({'HttpEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BrickColorValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlyweightService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RodConstraint = setmetatable({'CurrentDistance', 'Length', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MotorFeature = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Feature(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); EqualizerSoundEffect = setmetatable({'HighGain', 'LowGain', 'MidGain'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Model = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BinaryStringValue = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VRService = setmetatable({'GuiInputUserCFrame', 'VRDeviceName', 'VREnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Snap = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyAngularVelocity = setmetatable({'AngularVelocity', 'MaxTorque', 'P'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VelocityMotor = setmetatable({'CurrentAngle', 'DesiredAngle', 'MaxVelocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UserInputService = setmetatable({'AccelerometerEnabled', 'BottomBarSize', 'GamepadEnabled', 'GazeSelectionEnabled', 'GyroscopeEnabled', 'KeyboardEnabled', 'LegacyInputEventsEnabled', 'ModalEnabled', 'MouseBehavior', 'MouseDeltaSensitivity', 'MouseEnabled', 'MouseIconEnabled', 'NavBarSize', 'OnScreenKeyboardAnimationDuration', 'OnScreenKeyboardPosition', 'OnScreenKeyboardSize', 'OnScreenKeyboardVisible', 'OverrideMouseIconBehavior', 'StatusBarSize', 'TouchEnabled', 'UserHeadCFrame', 'VREnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			SurfaceSelection = setmetatable({'TargetSurface'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UserGameSettings = setmetatable({'AllTutorialsDisabled', 'CameraMode', 'CameraYInverted', 'ChatVisible', 'ComputerCameraMovementMode', 'ComputerMovementMode', 'ControlMode', 'Fullscreen', 'GamepadCameraSensitivity', 'HasEverUsedVR', 'IsUsingCameraYInverted', 'IsUsingGamepadCameraSensitivity', 'MasterVolume', 'MicroProfilerWebServerEnabled', 'MicroProfilerWebServerIP', 'MicroProfilerWebServerPort', 'MouseSensitivity', 'MouseSensitivityFirstPerson', 'MouseSensitivityThirdPerson', 'OnScreenProfilerEnabled', 'OnboardingsCompleted', 'PerformanceStatsVisible', 'RotationType', 'SavedQualityLevel', 'TouchCameraMovementMode', 'TouchMovementMode', 'UsedCoreGuiIsVisibleToggle', 'UsedCustomGuiIsVisibleToggle', 'UsedHideHudShortcut', 'VREnabled', 'VRRotationIntensity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Part = setmetatable({'Shape'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FormFactorPart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FriendPages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterPack = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StandardPages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SoundService = setmetatable({'AmbientReverb', 'DistanceFactor', 'DopplerScale', 'RespectFilteringEnabled', 'RolloffScale'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UITableLayout = setmetatable({'FillEmptySpaceColumns', 'FillEmptySpaceRows', 'MajorAxis', 'Padding'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); KeyboardService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataStorePages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DynamicRotate = setmetatable({'BaseAngle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UISizeConstraint = setmetatable({'MaxSize', 'MinSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ArcHandles = setmetatable({'Axes'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandlesBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LoginService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Players = setmetatable({'BubbleChat', 'CharacterAutoLoads', 'ClassicChat', 'MaxPlayers', 'MaxPlayersInternal', 'NumPlayers', 'PreferredPlayers', 'PreferredPlayersInternal'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIAspectRatioConstraint = setmetatable({'AspectRatio', 'AspectType', 'DominantAxis'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIConstraint = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BaseScript = setmetatable({'Disabled', 'LinkedSource'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LuaSourceContainer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIComponent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			ClusterPacketCache = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			VehicleController = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Controller(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RayValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RotateP = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DynamicRotate(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Camera = setmetatable({'CFrame', 'CameraType', 'CoordinateFrame', 'FieldOfView', 'Focus', 'HeadLocked', 'HeadScale', 'NearPlaneZ', 'ViewportSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TweenService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlagStandService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyForce = setmetatable({'Force'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIPageLayout = setmetatable({'Animated', 'Circular', 'EasingDirection', 'EasingStyle', 'GamepadInputEnabled', 'Padding', 'ScrollWheelInputEnabled', 'TouchInputEnabled', 'TweenTime'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PartOperationAsset = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ModuleScript = setmetatable({'LinkedSource', 'Source'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LuaSourceContainer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			Motor6D = setmetatable({'Transform'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Motor(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TouchInputService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIPadding = setmetatable({'PaddingBottom', 'PaddingLeft', 'PaddingRight', 'PaddingTop'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BasePart = setmetatable({'Anchored', 'BackParamA', 'BackParamB', 'BackSurface', 'BackSurfaceInput', 'BottomParamA', 'BottomParamB', 'BottomSurface', 'BottomSurfaceInput', 'BrickColor', 'CFrame', 'CanCollide', 'CenterOfMass', 'CollisionGroupId', 'Color', 'CustomPhysicalProperties', 'Elasticity', 'Friction', 'FrontParamA', 'FrontParamB', 'FrontSurface', 'FrontSurfaceInput', 'LeftParamA', 'LeftParamB', 'LeftSurface', 'LeftSurfaceInput', 'LocalTransparencyModifier', 'Locked', 'Material', 'Orientation', 'Position', 'ReceiveAge', 'Reflectance', 'ResizeIncrement', 'ResizeableFaces', 'RightParamA', 'RightParamB', 'RightSurface', 'RightSurfaceInput', 'RotVelocity', 'Rotation', 'Size', 'SpecificGravity', 'TopParamA', 'TopParamB', 'TopSurface', 'TopSurfaceInput', 'Transparency', 'Velocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Explosion = setmetatable({'BlastPressure', 'BlastRadius', 'DestroyJointRadiusPercent', 'ExplosionType', 'Position', 'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextFilterResult = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TestService = setmetatable({'AutoRuns', 'Description', 'ErrorCount', 'ExecuteWithStudioRun', 'Is30FpsThrottleEnabled', 'IsPhysicsEnvironmentalThrottled', 'IsSleepAllowed', 'NumberOfPlayers', 'SimulateSecondsLag', 'TestCount', 'Timeout', 'WarnCount'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PartAdornment = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TerrainRegion = setmetatable({'IsSmooth', 'SizeInCells'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataStoreService = setmetatable({'AutomaticRetry', 'LegacyNamingScheme'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TeleportService = setmetatable({'CustomizedTeleportUI'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ClientReplicator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkReplicator(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextButton = setmetatable({'Font', 'FontSize', 'LineHeight', 'LocalizedText', 'Text', 'TextBounds', 'TextColor', 'TextColor3', 'TextFits', 'TextScaled', 'TextSize', 'TextStrokeColor3', 'TextStrokeTransparency', 'TextTransparency', 'TextTruncate', 'TextWrap', 'TextWrapped', 'TextXAlignment', 'TextYAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiButton(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Teams = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Sound = setmetatable({'EmitterSize', 'IsLoaded', 'IsPaused', 'IsPlaying', 'Looped', 'MaxDistance', 'MinDistance', 'Pitch', 'PlayOnRemove', 'PlaybackLoudness', 'PlaybackSpeed', 'Playing', 'RollOffMode', 'SoundId', 'TimeLength', 'TimePosition', 'Volume'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			TaskScheduler = setmetatable({'SchedulerDutyCycle', 'SchedulerRate', 'ThreadPoolConfig', 'ThreadPoolSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			RunningAverageTimeIntervalItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RunningAverageItemInt = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StatsItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Stats = setmetatable({'ContactsCount', 'DataReceiveKbps', 'DataSendKbps', 'HeartbeatTimeMs', 'InstanceCount', 'MovingPrimitivesCount', 'PhysicsReceiveKbps', 'PhysicsSendKbps', 'PhysicsStepTimeMs', 'PrimitivesCount'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterCharacterScripts = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StarterPlayerScripts(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScriptContext = setmetatable({'ScriptsDisabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpawnLocation = setmetatable({'AllowTeamChangeOnTouch', 'Duration', 'Enabled', 'Neutral', 'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyPosition = setmetatable({'D', 'MaxForce', 'P', 'Position'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterPlayerScripts = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterPlayer = setmetatable({'AllowCustomAnimations', 'AutoJumpEnabled', 'CameraMaxZoomDistance', 'CameraMinZoomDistance', 'CameraMode', 'DevCameraOcclusionMode', 'DevComputerCameraMovementMode', 'DevComputerMovementMode', 'DevTouchCameraMovementMode', 'DevTouchMovementMode', 'EnableMouseLockOption', 'HealthDisplayDistance', 'LoadCharacterAppearance', 'NameDisplayDistance'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScreenGui = setmetatable({'DisplayOrder', 'IgnoreGuiInset', 'OnTopOfCoreBlur'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterGear = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataYieldFunctions = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpawnerService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Sparkles = setmetatable({'Color', 'Enabled', 'SparkleColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Dialog = setmetatable({'BehaviorType', 'ConversationDistance', 'GoodbyeChoiceActive', 'GoodbyeDialog', 'InUse', 'InitialPrompt', 'Purpose', 'Tone', 'TriggerDistance', 'TriggerOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ThirdPartyUserService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CacheableContentProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ForceField = setmetatable({'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TremoloSoundEffect = setmetatable({'Depth', 'Duty', 'Frequency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReverbSoundEffect = setmetatable({'DecayTime', 'Density', 'Diffusion', 'DryLevel', 'WetLevel'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ControllerService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PitchShiftSoundEffect = setmetatable({'Octave'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); EchoSoundEffect = setmetatable({'Delay', 'DryLevel', 'Feedback', 'WetLevel'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DistortionSoundEffect = setmetatable({'Level'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			Dragger = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Animation = setmetatable({'AnimationId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SoundEffect = setmetatable({'Enabled', 'Priority'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PathfindingService = setmetatable({'EmptyCutoff'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PostEffect = setmetatable({'Enabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Color3Value = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GenericSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ServiceProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ManualGlue = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ManualSurfaceJointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Platform = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataModel = setmetatable({'CreatorId', 'CreatorType', 'GameId', 'GearGenreSetting', 'Genre', 'IsSFFlagsLoaded', 'JobId', 'PlaceId', 'PlaceVersion', 'VIPServerId', 'VIPServerOwnerId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ServiceProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServiceProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Seat = setmetatable({'Disabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LineForce = setmetatable({'ApplyAtCenterOfMass', 'InverseSquareLaw', 'Magnitude', 'MaxForce', 'ReactionForceEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScriptDebugger = setmetatable({'CurrentLine', 'IsDebugging', 'IsPaused'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RunService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReplicatedStorage = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PlayerGui = setmetatable({'CurrentScreenOrientation', 'ScreenOrientation'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePlayerGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RemoteFunction = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataProperties = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEnumItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Debris = setmetatable({'MaxItems'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataClass = setmetatable({'ExplorerImageIndex', 'ExplorerOrder', 'Insertable', 'PreferredParent', 'PreferredParents'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			ReflectionMetadataItem = setmetatable({'Browsable', 'ClassCategory', 'Constraint', 'Deprecated', 'EditingDisabled', 'IsBackend', 'ScriptContext', 'UIMaximum', 'UIMinimum', 'UINumTicks'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GoogleAnalyticsConfiguration = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataFunctions = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkClient = setmetatable({'Ticket'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkPeer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ParticleEmitter = setmetatable({'Acceleration', 'Color', 'Drag', 'EmissionDirection', 'Enabled', 'Lifetime', 'LightEmission', 'LightInfluence', 'LockedToPart', 'Rate', 'RotSpeed', 'Rotation', 'Size', 'Speed', 'SpreadAngle', 'Texture', 'Transparency', 'VelocityInheritance', 'VelocitySpread', 'ZOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			Flag = setmetatable({'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Tool(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NonReplicatedCSGDictionaryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FlyweightService(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEnums = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BlurEffect = setmetatable({'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HttpRbxApiService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SphereHandleAdornment = setmetatable({'Radius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UserSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GenericSettings(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginManager = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Button = setmetatable({'ClickableWhenViewportHidden', 'Enabled', 'Icon'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginAction = setmetatable({'ActionId', 'StatusTip', 'Text'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkServer = setmetatable({'Port'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkPeer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Backpack = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Plugin = setmetatable({'CollisionEnabled', 'GridSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PhysicsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkMarker = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CustomEventReceiver = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PlayerScripts = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BasePlayerGui = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ParabolaAdornment = setmetatable({'A', 'B', 'C', 'Range', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BadgeService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BevelMesh = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DataModelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Trail = setmetatable({'Color', 'Enabled', 'FaceCamera', 'Lifetime', 'LightEmission', 'LightInfluence', 'MaxLength', 'MinLength', 'Texture', 'TextureLength', 'TextureMode', 'Transparency', 'WidthScale'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Sky = setmetatable({'CelestialBodiesShown', 'MoonAngularSize', 'MoonTextureId', 'SkyboxBk', 'SkyboxDn', 'SkyboxFt', 'SkyboxLf', 'SkyboxRt', 'SkyboxUp', 'StarCount', 'SunAngularSize', 'SunTextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UnionOperation = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartOperation(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DockWidgetPluginGui = setmetatable({'HostWidgetWasRestored'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PluginGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiService = setmetatable({'AutoSelectGuiEnabled', 'CoreGuiNavigationEnabled', 'GuiNavigationEnabled', 'IsModalDialog', 'IsWindows', 'MenuIsOpen'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BallSocketConstraint = setmetatable({'LimitsEnabled', 'Radius', 'Restitution', 'TwistLimitsEnabled', 'TwistLowerAngle', 'TwistUpperAngle', 'UpperAngle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkSettings = setmetatable({'ArePhysicsRejectionsReported', 'ClientPhysicsSendRate', 'DataGCRate', 'DataMtuAdjust', 'DataSendPriority', 'DataSendRate', 'ExtraMemoryUsed', 'FreeMemoryMBytes', 'IncommingReplicationLag', 'IsQueueErrorComputed', 'NetworkOwnerRate', 'PhysicsMtuAdjust', 'PhysicsSendPriority', 'PhysicsSendRate', 'PreferredClientPort', 'PrintBits', 'PrintEvents', 'PrintFilters', 'PrintInstances', 'PrintPhysicsErrors', 'PrintProperties', 'PrintSplitMessage', 'PrintStreamInstanceQuota', 'PrintTouches', 'ReceiveRate', 'RenderStreamedRegions', 'ShowActiveAnimationAsset', 'TouchSendRate', 'TrackDataTypes', 'TrackPhysicsDetails', 'UseInstancePacketCache', 'UsePhysicsPacketCache'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Translator = setmetatable({'LocaleId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UILayout = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PackageLink = setmetatable({'PackageId', 'VersionId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			AnimationController = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GroupService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AlignOrientation = setmetatable({'MaxAngularVelocity', 'MaxTorque', 'PrimaryAxisOnly', 'ReactionTorqueEnabled', 'Responsiveness', 'RigidityEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BlockMesh = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BevelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Chat = setmetatable({'LoadDefaultChat'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SurfaceGui = setmetatable({'Active', 'AlwaysOnTop', 'CanvasSize', 'ClipsDescendants', 'Face', 'LightInfluence', 'ToolPunchThroughDistance', 'ZOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Selection = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Workspace = setmetatable({'AllowThirdPartySales', 'DistributedGameTime', 'FallenPartsDestroyHeight', 'FilteringEnabled', 'Gravity', 'StreamingEnabled', 'TemporaryLegacyPhysicsSolverOverride'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Model(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Pants = setmetatable({'PantsTemplate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Clothing(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionSphere = setmetatable({'SurfaceColor', 'SurfaceColor3', 'SurfaceTransparency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GamepadService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TrussPart = setmetatable({'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServerReplicator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkReplicator(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CompressorSoundEffect = setmetatable({'Attack', 'GainMakeup', 'Ratio', 'Release', 'Threshold'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlagStand = setmetatable({'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PartOperation = setmetatable({'TriangleCount', 'UsePartColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Hat = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Accoutrement(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BindableEvent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionPartLasso = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SelectionLasso(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			FormFactorPart = setmetatable({'FormFactor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PrismaticConstraint = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SlidingBallConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CornerWedgePart = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TouchTransmitter = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InventoryPages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Hint = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Message(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpringConstraint = setmetatable({'Coils', 'CurrentLength', 'Damping', 'FreeLength', 'LimitsEnabled', 'MaxForce', 'MaxLength', 'MinLength', 'Radius', 'Stiffness', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Fire = setmetatable({'Color', 'Enabled', 'Heat', 'SecondaryColor', 'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkReplicator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyThrust = setmetatable({'Force', 'Location'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Tween = setmetatable({'TweenInfo'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.TweenBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LuaWebService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LocalScript = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Script(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LuaSourceContainer = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LuaSettings = setmetatable({'AreScriptStartsReported', 'DefaultWaitTime', 'GcFrequency', 'GcLimit', 'GcPause', 'GcStepMul', 'WaitingThreadsBudget'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CoreScript = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BaseScript(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CylinderMesh = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BevelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ConeHandleAdornment = setmetatable({'Height', 'Radius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LocalizationService = setmetatable({'ForcePlayModeGameLocaleId', 'ForcePlayModeRobloxLocaleId', 'IsTextScraperRunning', 'RobloxForcePlayModeGameLocaleId', 'RobloxForcePlayModeRobloxLocaleId', 'RobloxLocaleId', 'SystemLocaleId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CustomEvent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Weld = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); QWidgetPluginGui = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PluginGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BoolValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			TextService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Pages = setmetatable({'IsFinished'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Beam = setmetatable({'Color', 'CurveSize0', 'CurveSize1', 'Enabled', 'FaceCamera', 'LightEmission', 'LightInfluence', 'Segments', 'Texture', 'TextureLength', 'TextureMode', 'TextureSpeed', 'Transparency', 'Width0', 'Width1', 'ZOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ChangeHistoryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ClickDetector = setmetatable({'CursorIcon', 'MaxActivationDistance'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginGui = setmetatable({'Title'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Instance = setmetatable({'Archivable', 'ClassName', 'DataCost', 'Name', 'RobloxLocked'},{__call = function(me) return me end}); Hopper = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BackpackItem = setmetatable({'TextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Frame = setmetatable({'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SurfaceLight = setmetatable({'Angle', 'Face', 'Range'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Light(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Decal = setmetatable({'Color3', 'LocalTransparencyModifier', 'Shiny', 'Specular', 'Texture', 'Transparency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FaceInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RotateV = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DynamicRotate(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ContextActionService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiBase3d = setmetatable({'Color', 'Color3', 'Transparency', 'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Rotate = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyVelocity = setmetatable({'MaxForce', 'P', 'Velocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Keyframe = setmetatable({'Time'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
		} do gelf.__index[i] = v if i == index then ret = v end end return ret end});
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				sort = function(self,func)
					table.sort(self,func)
				end;
				search = function(hmm, index, keepSimilar)
					return Spice.Table.search(type(hmm) == 'string' and getmetatable(self).FullAPI[hmm](true) or self,index,false,keepSimilar, true, false,true)
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end;
	});
},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = self.Custom.new;
				hasProperty = function(Object,Property)
					local has = pcall(function() return Object[Property] and true end)
					return has, has and Object[Property] or nil
				end;
				getProperties = function(Object, full)
					local props = {}
					local op = getmetatable(self.RobloxAPI).FullAPI
					for _, prop in next, op[Object.ClassName](full) do
						props[prop] = Object[prop]
					end
					return props
				end;
				getChildrenOfProperty = function(Object, Property, Value)
					local children = {}
					for i,child in next, Object:GetChildren() do
						if pcall(function() return child[Property] and true end) then
							if Value and child[Property] == Value then
								table.insert(children,child)
							end
						end
					end
					return children
				end;
				getDescendantsOfProperty = function(Object, Property, Value)
					local descendants = {}
					for i,desc in next, Object:GetDescendants() do
						if pcall(function() return desc[Property] and true end) then
							if Value and desc[Property] == Value then
								table.insert(descendants,desc)
							end
						end
					end
					return descendants
				end;
				setProperties = function(Object, Properties, dontIncludeShorts, dontIncludeCustom, includeDefault)
					local custom, api, default = self.Custom, self.RobloxAPI, self.Default
					if includeDefault then
						self.Default.toDefaultProperties(Object,type(includeDefault) == 'number' or nil)
					end
					for property, value in next, Properties do
						if not dontIncludeShorts then property = self.RobloxAPI.search(Object.ClassName, property) or property end
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
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end;	
});
Theming = setmetatable({
	Themes = {}
	},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
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
					Set = function(me,...)
						self.setTheme(me,...)
					end;
					Insert = function(me,...)
						self.insertObject(me,...)
					end;
					Sync = function(me,...)
						self.sync(me,...)
					end;
				}
				self.Themes[name] = theme
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
								game:GetService('TweenService'):Create(obj,TweenInfo.new(tim or 1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,...),{[prop] = value}):Play()
							end
						end
					end
				end
			end			
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
})
}