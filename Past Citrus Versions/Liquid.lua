--[[
 								ℓιqυι∂  вy: 𝔩𝔞_𝔰𝔞𝔥𝔦𝔯𝔞
									  Based on:
							       𝓒𝔦𝓽𝔯𝓾ş вy: 𝓻𝓸𝓾𝓰𝒆
--]]

local sm,gm = setmetatable,getmetatable
local round = function(num)
	return math.floor(num+.5)
end
local checkAll = function(x,...) --returns true if x == ...
	for i,v in pairs({...})do
		if v == x then
			return true
		end
	end
	return false
end
local getPlayer = function(...)
	local player = {}
	local speaker = game.Players.LocalPlayer
	for i,v in pairs({...})do
		if v == 'all' then
			for z,x in pairs(game:GetService('Players'):GetPlayers())do
				if not checkAll(x,unpack(player)) then
					table.insert(player,x)
				end
			end
		elseif v == 'others' then
			for z,x in pairs(game:GetService('Players'):GetPlayers())do
				if x ~= speaker then
					if not checkAll(x,unpack(player)) then
						table.insert(player,x)
					end
				end
			end
		elseif v == 'me' then
			if not checkAll(speaker,unpack(player)) then
				table.insert(player,speaker)
			end
		else
			local plrs = sm(game:GetService('Players'):GetPlayers(),{__index = function(self,is)
				local ret = {}
				for i,v in pairs(self)do
					if v.Name:sub(1,#is):lower() == is:lower() then
						table.insert(ret,v)
					end
				end
				if #ret > 1 then
					return ret
				elseif #ret == 1 then
					return ret[1]
				else
					return nil
				end
			end})
			if not checkAll(plrs[v],unpack(player)) then
				table.insert(player,plrs[v])
			end
		end
	end
	return (#player == 1 and player[1]) or player
end
local operation = function(x,y,op) --for color stuff
	if not op then op = '+' end
	if op == '+' then
		return x+y
	elseif op == '-' then
		return x-y
	elseif op == '/' then
		return x/y 
	elseif op == '*' or op == 'x' then
		return x*y
	elseif op == '^' then
		return x^y
	elseif op == '%' then
		return x%y
	elseif op == '^/' or 'rt' then
		return x^(1/y)
	end
end
function tableClone(tab)
	local clone = {}
	for i,v in pairs(tab)do
		if type(v) == 'table' then
			clone[i] = tableClone(v)
			if gm(v) then
				local metaclone = tableClone(gm(v))
				sm(clone[i],metaclone)
			end
		else
			clone[i] = v
		end
	end
	return clone
end

local tableMerge = function(who,what)
	for i,v in pairs(who)do 
		if what[i] then 
			for a,z in pairs(v)do 
				what[i][a] = z 
			end 
		else 
		what[i] = v 
		end 
	end 
	return what 
end 
local tableLen = function(tab) --#table doesnt add if index isnt a #
	local x = 0
	for i,v in pairs(tab)do
		x = x + 1
	end
	return x
end
local switch = function(...) --thanks Rouge
	return sm({type = {},D4 = false,Get = function(self,number)
		if type(number) ~= 'number' then
			for i,v in pairs(self.type)do
				if v == number then
					number = i
				end
			end
			if type(number)~= 'number' then
				number = nil
			end
		end
		if number == nil then
			return self.D4
		else
			return self[number]
		end
	end,...},{
		__index = function(self,index)
			return self:Get(index)
		end;
		__newindex = function(self,index,new)
			if index == 'Default' then
				self['D4'] = new
			end
		end;
		__call = function(self,type,...)
			if typeof(self[type]) == 'function' then
				return self:Get(type)(...)
			else
				return self[type]
			end
		end;
	})
end
local Color, Properties, Theme, Create, Tweening, Placement, Icon, Icons
local Liquid
Liquid = {
	Properties = sm({ --lol I hope there are no spelling errors lmao
		new = function(name,filter,funct)
			local new = {Do = funct}
			local cust = gm(Properties).Custom
			if type(filter) ~= 'table' then
				filter = {filter}
			end
			for i,v in pairs(filter)do
				local f = (v == 'All' and 'All') or v
				if not cust[f] then cust[f] = {} end
				cust[f][name] = new
			end
		end;
		hasProperty = function(who,prop)
			if pcall(function() return who[Properties[prop]] end) then
				return true
			else
				return false
			end
		end;
		setProperties = function(who,props)
			for i,v in pairs(props)do
				if gm(Properties).Custom[i] then
					if type(v) ~= 'table' then v = {v} end
					if type(who) == 'table' and typeof(who[1]) == 'Instance' then who = who[1] end
					gm(Properties).Custom(i,who,unpack(v))
				elseif Properties.hasProperty(who,i) then
					pcall(function() who[Properties[i]] = v end)
				end
			end
			return who
		end;
		getProperties = function(who)
			local p = gm(Properties).Properties
			local new = {}
			for i,v in pairs(p)do
				if  Properties.hasProperty(who,v) then
					rawset(new,v,who[v])
				end
			end
			return new
		end;		
	},{
		Custom = sm({},{
			__index = function(self,ind)
				for filter,v in pairs(self)do
					for name,t in pairs(v)do
						if ind:lower() == name:lower():sub(1,#ind) then
							local filters = {}
							for z,x in pairs(self)do
								for q,w in pairs(x)do
									if w == t then
										table.insert(filters,z)
									end
								end
							end
							return sm({t.Do,unpack(filters)},{__call = function(self,...) self[1](...) end})
						end
					end
				end
				return false
			end;
			__call = function(self,index,who,...)
				if self[index] then
					local prop = self[index]
					if checkAll(who.ClassName,unpack(prop)) or checkAll('All',unpack(prop)) then
						prop(who,...)
					end
				end
			end;
		});
		Properties ={
				'Archivable','ClassName','Name','Parent','AttachmentForward','AttachmentPoint','AttachmentPos','AttachmentRight','AttachmentUp';
			'Animation','AnimationId','IsPlaying','Length','Looped','Priority','Speed','TimePosition','WeightCurrent','WeightTarget','Axis','CFrame','Orientation';
			'Position','Rotation','SeconaryAxis','Visible','WorldAxis','WorldOrientation','WorldPosition','WorldSecondaryAxis','Version','DisplayOrder','ResetOnSpawn','Enabled';
			'AbsolutePosition','AbsoluteRotation','AbsoluteSize','ScreenOrientation','ShowDevelopmentGui','Attachment0','Attachment1','Color','CurveSize0','CurveSize1','FaceCamera';
			'LightEmission','Segments','Texture','TextureLength','TextureMode','TextureSpeed','Transparency','Width0','Width1','ZOffset','AngularVelocity','MaxTorque','P','Force','D';
			'MaxForce','Location','Velocity','CartoonFactor','MaxSpeed','MaxThrust','Target','TargetOffset','TargetRadius','ThrustD','ThrustP','TurnD','TurnP','Value','CameraSubject','CameraType';
			'FieldOfView','Focus','HeadLocked','HeadScale','ViewportSize','HeadColor','HeadColor3','LeftArmColor','LeftArmColor3','LeftLegColor','LeftLegColor3','RightArmColor','RightArmColor3','RightLegColor','RightLegColor3','TorsoColor','TorsoColor3';
			'BaseTextureId','BodyPart','MeshId','OverlayTextureId','PantsTemplate','ShirtTemplate','Graphic','SkinColor','LoadDefaultChat','CursorIcon','MaxActivationDistance','MaxAngularVelocity','PrimaryAxisOnly','ReactionTorqueEnabled','Responsiveness','RigidityEnabled';
			'ApplyAtCenterOfMass','MaxVelocity','ReactionForceEnabled','Radius','Restitution','TwistLimitsEnabled','TwistLowerAngle','TwistUpperAngle','UpperAngle','ActuatorType','AngularSpeed','CurrentAngle','LimitsEnabled','LowerAngle','MotorMaxAcceleration','MotorMaxTorque','ServoMaxTorque','TargetAngle';
			'InverseSquareLaw','Magnitude','CurrentDistance','Thickness','CurrentPosition','LowerLimit','Size','TargetPosition','UpperLimit','Heat','SecondaryColor';
			'BackgroundColor3','AnchorPoint','BackgroundTransparency','BorderColor3','BorderSizePixel','ClipsDescendants','Draggable','LayoutOrder','NextSelectionDown','NextSelectionLeft','NextSelectionRight','NextSelectionUp','Selectable','SelectionImageObject','SizeConstraint','SizeFromContents','ZIndex';
			'Style','AutoButtonColor','Modal','Selected','Image','ImageColor3','ImageRectOffset','ImageRectSize','ImageTransparency','IsLoaded','ScaleType','SliceCenter','TileSize','Font','Text','TextBounds','TextColor3','TextFits';
			'TextScaled','TextSize','TextStrokeColor3','TextStrokeTransparency','TextTransparency','TextWrapped','TextXAlignment','TextYAlignment','Active','AbsoluteWindowSize','BottomImage','CanvasPosition','CanvasSize','HorizontalScrollBarInset','MidImage','ScrollBarThickness','ScrollingEnabled','TopImage','VerticalScrollBarInset';
			'VerticalScrollBarPosition','ClearTextOnFocus','MultiLine','PlaceholderColor3','PlaceholderText','ShowNativeInput','Adornee','AlwaysOnTop','ExtentsOffset','ExtentsOffsetWorldSpace','LightInfluence','MaxDistance','PlayerToHideForm','SizeOffset','StudsOffset','StudsOffsetWorldSpace','ToolPunchThroughDistance','Face','DecayTime','Density','Diffusion','Duty','Frequency';
			'Depth','Mix','Rate','Attack','GainMakeup','Ratio','Release','SieChain','Threshold','Level','Delay','DryLevel','Feedback','WetLevel','HighGain','LowGain','MidGain','Octave','Volume','MaxSize','MinSize','AspectRatio','DominantAxis','AspectType','MaxTextSize','MinTextSize','CellPadding','CellSize','FillDirectionMaxCells','StartCorner';
			'AbsoluteContentSize','FillDirection','HorizontalAlignment','SortOrder','VerticalAlignment','Padding','Animated','Circular','CurrentPage','EasingDirection','EasingStyle','GamepadInputEnabled','ScrollWhellInputEnabled','TweenTime','TouchImputEnable','FillEmptySpaceColumns','FillEmptySpaceRows','MajorAxis','PaddingBottom','PaddingLeft','PaddingRight','PaddingTop','Scale'
	
		};
		__index = function(self,ind)
			if type(ind) ~= 'string' then return rawget(self,ind) end
			for i,v in pairs(gm(Properties).Properties)do
				if (i == ind and type(i) == 'string') or (v == ind) then
					return v
				end
			end
			local tab,tex = {},''
			for i,v in pairs(gm(self).Properties)do
				if type(v) == 'string' then
					if v:sub(1,1):lower() == ind:sub(1,1):lower() then
						for w in v:gmatch('%u')do
							table.insert(tab,w)
						end
						for _,e in pairs(tab)do
							tex = tex..e
						end
						if ind:lower() == tex:lower() then
							return v
						elseif v:sub(1,#ind):lower() == ind:lower() then
							return v
						else
							tex = ''
							tab = {}
						end
					end
				end
			end
			return false,ind
		end
	});
	Color = sm({
		new = function(...)
			local args = {...}
			local colors = gm(Color).Colours
			if type(args[1]) == 'string' then
				if args[1]:sub(1,1) == '#' then
					return Color.fromHex(args[1])
				else
					return (type(colors[args[1]]) ~= 'table' and colors[args[1]]) or ( colors[args[1]][args[2]] or colors[args[1]][1] )
				end
			elseif args[4] then
				return Color.fromHSV(args[1],args[2],args[3])
			else
				return Color.fromRGB(args[1],args[2],args[3])
			end
		end;
		
		fromRGB = function(r,g,b)
			return Color3.fromRGB(r,g,b)
		end;
		toRGB = function(color)
			return round(color.r*255),round(color.g*255),round(color.b*255)
		end;
		editRGB = function(color,...)
			local sign,nr,ng,nb,nc
			local args = {...}
			if type(args[1]) ~= 'string' then
				sign = '+'
				nr,ng,nb = args[1],args[2],args[3]
			else
				sign = args[1]
				nr,ng,nb = args[2],args[3],args[4]
				args[1],args[2],args[3] = nr,ng,nb
			end
			local r,g,b = round(color.r*255),round(color.g*255),round(color.b*255)
			nc = {r,g,b}
			if not b then				
				if not g then
					g = 1
				end
				nc[g] = operation(nc[g],r,sign)
			--	loadstring('return '..nc[g]..sign..r)()
			else
				for i,v in pairs(nc) do
					nc[i] = operation(v,args[i],sign)
					--nc[i] = loadstring('return '..v..sign..args[i])()
				end
			end
			return Color3.fromRGB(unpack(nc))			
		end;
		setRGB = function(color,...)
			local args = {...}
			local nr,ng,nb,nc
			local r,g,b = round(color.r*255),round(color.g*255),round(color.b*255)
			nc = {r,g,b}
			if #args < 3 then
				if not args[2] then
					args[2] = 1
				end
				nc[args[2]] = args[1]
			else
				for i,v in pairs(nc) do
					nc[i] = args[i]
				end
			end
			return Color3.fromRGB(unpack(nc))
		end;
				
		fromHSV = function(h,s,v)
			return Color3.fromHSV(h/360,s/100,v/100)
		end;
		toHSV = function(color)
			local h,s,v = Color3.toHSV(color)
			return round(h*360),round(s*100),round(v*100)
		end;
		editHSV = function(color,...)
			local sign,nr,ng,nb,nc
			local args = {...}
			if type(args[1]) ~= 'string' then
				sign = '+'
				nr,ng,nb = args[1],args[2],args[3]
			else
				sign = args[1]
				nr,ng,nb = args[2],args[3],args[4]
				args[1],args[2],args[3] = nr,ng,nb
			end
			local r,g,b = round(({Color3.toHSV(color)})[1]*360),round(({Color3.toHSV(color)})[2]*100),round(({Color3.toHSV(color)})[3]*100)
			nc = {r,g,b}
			if not b then				
				if not g then
					g = 1
				end
				nc[g] = operation(nc[g],r,sign)
				--loadstring('return '..nc[g]..sign..r)()
			else
				for i,v in pairs(nc) do
					nc[i] = operation(v,args[i],sign)
				--	nc[i] = loadstring('return '..v..sign..args[i])()
				end
			end
			return Color3.fromHSV(nc[1]/360,nc[2]/100,nc[3]/100)			
		end;
		setHSV = function(color,...)
			local args = {...}
			local nr,ng,nb,nc
			local r,g,b = round(({Color3.toHSV(color)})[1]*360),round(({Color3.toHSV(color)})[2]*100),round(({Color3.toHSV(color)})[3]*100)
			nc = {r,g,b}
			if #args < 3 then
				if not args[2] then
					args[2] = 1
				end
				nc[args[2]] = args[1]
			else
				for i,v in pairs(nc) do
					nc[i] = args[i]
				end
			end
			return Color3.fromHSV(nc[1]/360,nc[2]/100,nc[3]/100)		
		end;
			
		--credit to Rouge for Hex functions
		fromHex = function(hex) 
			if hex:sub(1,1) == '#' then
				hex = hex:sub(2,#hex)			
			end
			local r,g,b
			if #hex >= 6 then
				r = tonumber(hex:sub(1, 2), 16)
				g = tonumber(hex:sub(3, 4), 16)
				b = tonumber(hex:sub(5, 6), 16)
			elseif #hex >= 3 then
				r = tonumber(hex:sub(1, 1)..hex:sub(1, 1), 16)
				g = tonumber(hex:sub(2, 2)..hex:sub(2, 2), 16)
				b = tonumber(hex:sub(3, 3)..hex:sub(3, 3), 16)	
			end	
			return Color3.fromRGB(r,g,b)
		end;
		toHex = function(a,b,c,d)
			local r,g,b,hex,ro
			local ts = tostring
			if c then
				a = Color3.fromRGB(a,b,c)
			end
			r =("%02X"):format(round(a.r*255))
			g =("%02X"):format(round(a.g*255))
			b =("%02X"):format(round(a.b*255))
			hex = ts(r)..ts(g)..ts(b)
			if not c and b then
				hex = '#'..hex
			elseif d then
				hex = '#'..hex
			end
			return hex
		end;

		lerp = function(who,prop,starting,ending,time,rev,rep)
			if rep ==  true then rep = -1 end
			who[Properties[prop]] = starting
			return Tweening.tween(who,prop,ending,time,rep,rev)
			--return game:GetService("TweenService"):Create(who,TweenInfo.new(time,nil,nil,rep,true),{[Properties[prop]] = ending})
		end;
		
		newColor = function(name,val)
			local colors = gm(Color).Colours
			if typeof(val) == 'Color3' or type(val) == 'table' then
				colors[name] = val
			else
				return error('Not a valid value')
			end
		end;
		addColor = function(name,index,val)
			local colors = gm(Color).Colours
			local color = colors[name]
			if not val then
				val = index
				index = nil
			end
			if type(color) ~= 'table' then
				color = {color}
			end
			if typeof(val) == 'Color3' then
				if not index then index = #color + 1 end
				table.insert(color,index,val)
			else
				return error('Not a valid value')
			end
			colors[name] = color
		end

	},{Colours = sm({},{
		__index = function(self,index)
			for i,v in pairs(self)do
				if i:sub(1,#index):lower() == index:lower() then
					return v
				end
			end
		end
		})
	});
	Theming = sm({
		new = function(name,val,...)
			local args,theme,value = {...},{},{}
			if type(val) ~= 'table' then
				val = {val}
			end
			for i,v in pairs(val)do
				if type(i) == 'string' and Properties[i] then
					if type(v) == 'function' then
						value[Properties[i]] = {v,args}
					else
						value[Properties[i]] = v
					end
					
				elseif type(v) == 'function' then
					if #val == 1 then
						value[v] = args
					else
						value[v] = {}
					end
				elseif type(v) == 'table' or type(i) == 'number' then
					value[i] = v
				end
			end
			local theme = sm({
				Value = value;
				Objects  = {};
			},{
				__newindex = function(self,index,val)
					if index == 'Value' then
						local value = {}
						if type(val) ~= 'table' then
							val = {val}
						end
						for i,v in pairs(val)do
							if type(i) == 'string' and Properties[i] then
								value[i] = Properties[i]
							elseif type(v) == 'function' then
								if #val == 1 then
									value[v] = args
								else
									value[v] = {}
								end
							elseif type(v) == 'table' or type(i) == 'number' then
								value[i] = v
							end
							Theme.Sync(name)
							rawset(self,'Value',value)
						end
					end
				end
			})
			gm(Theme).Themes[name] = theme
			return theme
		end;
		getTheme = function(name)
			return gm(Theme).Themes[name]
		end;
		addObjects = function(name,...)
			local theme = gm(Theme).Themes[name]
			local objects = theme.Objects
			local args = {...}
			for i,v in pairs(args) do
				if type(v) == 'userdata'  then
					objects[v] = Theme.getTheme(name).Value
				elseif type(v) == 'table' then
					objects[v[1]] = {}
					for z,x in pairs(v)do
						if z ~= 1 then
							if type(z) == 'number' then
								if Properties[x] then x = Properties[x] end
								objects[v[1]][x] = true
							elseif type(z) == 'string' then
								objects[v[1]][z] = x
							end
						end
					end
				end
			end				
			Theme.Sync(name)
		end;
		Sync = function(name)
			local theme = gm(Theme).Themes[name]
			local value = theme.Value
			local objects = theme.Objects
			local toObj = function(obj,prop,typ)
				if  Properties.hasProperty(obj,prop) then
					for i,val in pairs(value)do
						--warn(obj,'	|',prop,i,typ,'|	',val)
						if typ and type(val) == 'table' and type(val[1]) == 'function' and i == prop then
							val[1](obj,unpack(val[2]))
						elseif Properties[i] and i == Properties[prop] and typeof(val) == typeof(obj[Properties[prop]])  then
							obj[Properties[prop]] = val
						elseif typ and i == typ then
							obj[Properties[prop]] = val
						elseif type(i) == 'function' then
							i(obj,unpack(val))
						elseif type(i) == 'number' then
							if typeof(obj[Properties[prop]]) == typeof(val) then
								obj[Properties[prop]] = val
							end
						end
					end
				end
			end
			for obj,v in pairs(objects)do
				for prop,typ in pairs(v)do
					toObj(obj,prop,typ)
				end
			end
		end
	},{Themes = {}});
	Instance = sm({
		new = function(class,parent,...)
			local new
			local prop = ...
			if gm(Create).Classes[class] then
				local class = gm(Create).Classes[class]
				local args = {...}
				if type(args[#args]) == 'table' then
					prop = args[#args]
					args[#args] = nil
				else
					prop = nil
				end
				new = class.onCreate(unpack(args))
				table.insert(class.Objects,new)
			else 
				new = Instance.new(class)
			end
			if type(parent) == 'table' and #parent == 0 then
				prop = parent
				parent = nil	
			end
			new.Parent = (typeof(parent)=='Instance' and parent) or  (type(parent)=='table' and typeof(parent[1])=='Instance' and parent[1]) or nil 
			if prop then
				Properties.setProperties(new,prop)
			end
			return new
		end;
		newInstance = function(class,parent,prop)
			local new = Instance.new(class,(typeof(parent)=='Instance' and parent) or nil)
			for i,v in pairs((typeof(parent)~='Instance' and parent) or prop or {})do
				new[Properties[i]] = v
			end
			return new
		end;
		newClass = function(name,funct)
			local class = {onCreate = funct,Objects = sm({},{__index = function(self,ind) for i,v in pairs(self)do if i==ind or v == ind then return v end end end})}
			gm(Create).Classes[name] = class
		end;
		newObject =  function(what,parent,obj,prop)
			local new = Create.newInstance(what)
			local instance = {new}
			new.Parent = (typeof(parent) == 'Instance' and parent) or nil
			local meta = {
				Instance = new;
				Properties = {
					Index = {};
					NewIndex = {};
				};
				Object = (typeof(parent) ~= 'Instance' and parent) or obj or {};
				__index = function(self,ind)
					if gm(self).Object[ind] then
						return gm(self).Object[ind]
					elseif ind == 'index' then
						return gm(self).Properties.Index
					elseif ind == 'newindex' then
						return gm(self).Properties.NewIndex
					elseif ind == 'newProperty' then
						return true
					else
						for i,v in pairs(gm(self).Properties.Index)do
							if i == ind then
								return (type(v) == 'function' and v(self)) or v
							end
						end
						return self[1][(type(ind) == 'string' and Properties[ind]) or ind]
					end
				end;
				__newindex = function(self,ind,new)
					if gm(self).Object[ind] then
						gm(self).Object[ind] = new
					elseif ind == 'index' then
						gm(self).Properties.Index[new[1]] = new[2]
					elseif ind == 'newindex' then
						if not gm(self).Properties.Index[new[1]] then 
						gm(self).Properties.Index[new[1]] = function() return true end end
						gm(self).Properties.NewIndex[new[1]] = new[2]
					elseif ind == 'newProperty' then
						gm(self).Properties.Index[new[1]] = new[2]
						gm(self).Properties.NewIndex[new[1]] = new[3]
					else
						for i,v in pairs(gm(self).Properties.NewIndex)do
							if i == ind then
								return v(self,new)
							end
						end
						self[1][(type(ind) == 'string' and Properties[ind]) or ind] = new
					end
				end;
				__call = function(self,properties)
					Properties.setProperties(self[1],properties)
					return self
				end;
			}
			function instance:Clone(par)
				local clone = self[1]:Clone()
				clone.Parent = par or nil
				local objclone = tableClone(gm(self))
				objclone = sm({clone,Clone = self.Clone},objclone)
				gm(Create).Objects[clone] = objclone
				return objclone
			end
			sm(instance,meta)
			if prop then
				instance(prop)
			end
			gm(Create).Objects[new] = instance
			return instance
		end
	},{Effects = sm({},{__index = function(self,ind)
		for i,v in pairs(self)do
			if i:lower() == ind:lower() or v == ind then
				return v
			end
		end
	end});
	Objects = sm({},{
		__index = function(self,o)
			for obj,v in pairs(self)do
				if obj == o or v == o then
					return v
				end
			end
		end;
	});
	  Classes = sm({},{
	__call = function(self,who,type)
		local found =  {__index = function(self,ind)
					for i,v in pairs(self)do
						if (i == ind and type(i) == 'string') or (v == ind) then
							return true
						end
					end
					return false
				end
			} 
		local switch = switch(sm((self[type] and self[type].Objects) or {},found)[who])
		switch.type = {type}
		switch.Default = function() 
			for i,v in pairs(self)do
				if sm(v.Objects,found)[who] then
					return i
				end
			end
			return false
		end
		return switch(type)
	end})
	});	
	Interpolation = {
		tween = function(obj,prop,to,time,...)
			local args = {...}
			local style,direction,rep,rev,dela
			for i,v in pairs(args)do			
				if type(v) == 'string' then
					if v == 'In' or v == 'Out' or v == "InOut" then
						direction = Enum.EasingDirection[v]
					elseif checkAll(v,'Linear','Sine','Back','Quad','Quart','Quint','Bounce','Elastic') then
						style = Enum.EasingStyle[v]		
					end
				elseif type(v) == 'number' then
					if not rep then
						rep = v
					else
						dela = v
					end
				elseif type(v) == 'boolean' then
					rev = v
				end
			end
			return game:GetService('TweenService'):Create(obj,TweenInfo.new(time,style or Enum.EasingStyle.Linear,direction or Enum.EasingDirection.In,rep or 0,rev or false,dela or 0),{[Properties[prop]] = to}):Play()
		end;
		lerp = function(obj,prop,to,time)
			return Tweening.tween(obj,prop,to,time)
		end;
		tweenGuiObject = function(who,typ,where,...)
			local where2,what,what2,why,howfast
			local args = {...}
			if typ == 'both' then
				where2,howfast,what,what2,why = args[1],args[2],args[3],args[4],args[5]
			else
				howfast,what,what2,why = args[1],args[2],args[3],args[4]
			end
			for i,v in pairs(args)do
				if type(v) == 'function' then
					why = v
				end
			end
			if type(what) == 'function' then what = nil end
			if type(what2) == 'function' then what2 = nil end
			if not what then what = 'Out' end
			if not what2 then what2 = 'Sine' end
			if not howfast then howfast = .3 end
			if typ == 'both' then
				who:TweenSizeAndPosition(where2,where,what,what2,howfast,true,why)
			elseif typ:sub(1,3):lower() == 'pos' then
				who:TweenPosition(where,what,what2,howfast,true,why)
			elseif typ:sub(1,3):lower() == 'siz' then
				who:TweenSize(where,what,what2,howfast,true,why)
			end
		end;		
		Rotate = function(who,to,time)
			return Tweening.lerp(who,"Rotation",to,time)
		end;
	};
 	Placement = {
		new = function(a,b,c,d) --straight from lush
			if d then
				return UDim2.new(a,b,c,d)
			elseif type(a) == 'userdata' then
				return UDim2.new(0,a.X,0,a.Y)
			elseif c == 4 or c == 'so' then
				return UDim2.new(a,0,0,b)
			elseif c == 5 or c == 'os' then
				return UDim2.new(0,a,b,0)
			elseif c == 1 or (type(c) == 'string' and c:sub(1,1) == 's') then
				return UDim2.new(a,0,b,0)
			elseif c == 2 or (type(c) == 'string' and c:sub(1,1) == 'o') then
				return UDim2.new(0,a,0,b)
			elseif c == 3 or (type(c) == 'string' and c:sub(1,1) == 'b') then
				return UDim2.new(a,b,a,b)
			elseif b:sub(1,1) == 'o' then
				return UDim2.new(0,a,0,a)
			elseif b:sub(1,1) == 's' then
				return UDim2.new(a,0,a,0)
			elseif b:sub(1,1) == 'b' then
				return UDim2.new(a,a,a,a)
			end
		end;
		newVector = function(a,b)
			if not b then
				return Vector2.new(a,a)
			else
				return Vector2.new(a,b)
			end
		end;
		fromPosition = function(a,b,c,d) --also from lush
			local x,y,xo,yo
			xo,yo = c or 0,d or 0
			if not b and (a:sub(1,1):lower() == 'c' or a:sub(1,1):lower() == 'm') then
				return UDim2.new(.5,xo,.5,yo)
			end
			if a:sub(1,1):lower() == 't' or b:sub(1,1):lower() == 't' then
				y = 0
			elseif a:sub(1,1):lower() == 'c' or a:sub(1,1):lower() == 'm' then
				y = .5
			elseif a:sub(1,1):lower() == 'b' or b:sub(1,1):lower() == 'b' then
				y = 1
			end
			if a:sub(1,1):lower() == 'l' or b:sub(1,1):lower() == 'l' then
				x = 0
			elseif b:sub(1,1):lower() == 'c' or b:sub(1,1):lower() == 'm' then
				x = .5
			elseif a:sub(1,1):lower() == 'r' or b:sub(1,1):lower() == 'r' then
				x = 1
			end
			return UDim2.new(x,xo,y,yo)
		end
	};
	Icon = sm({
        new = function(id,x,y,xs,ys,names)
            if not names then
                names = ys
                ys = xs
            end
            local new = {}
            local ind = 0
            for xi = 0,(y-1)*ys,xs do
                for yi = 0,(x-1)*xs,ys do
                    ind = ind + 1
			  if names[ind]:find('%p') then
				local start, en,p = names[ind]:sub(1,names[ind]:find('%p')-1),names[ind]:sub(names[ind]:find('%p')+1),names[ind]:match('%p')
				names[ind] = start:sub(1,1):upper()..start:sub(2)..p..en:sub(1,1):upper()..en:sub(2)
			end
                    local icon = Create.new('ImageLabel',{trans = 1,image = id,nam = names[ind],iro = Vector2.new(yi,xi), irs = Vector2.new(xs,ys)})
			  rawset(new,names[ind],icon)
                end
            end
		for i,v in pairs(new)do
			rawset(gm(Icon).Icons,i,v)
		end
            --tableMerge(new,gm(Icon).Icons)
		return new
        end;
        get = function(name)
            return gm(Icon).Icons[name]
        end;
    },{Icons = sm({},{
        	__index = function(self,ind)
			for i,v in pairs(self)do
				if i:lower() == ind:lower() then
					return v
				else
					local caps = ''
					for a in i:gmatch('%u') do
						caps = caps..a
					end
					if ind:lower() == caps:lower() then
						return v
					elseif i:sub(1,#ind):lower() == ind:lower() then
						return v
					end
				end
			end
	end})
    })
}
table.sort(gm(Liquid.Properties).Properties,function(a,b) return #a < #b end);
Properties, Color, Theme, Create, Lerp, Placement, Icon = Liquid.Properties, Liquid.Color, Liquid.Theming, Liquid.Instance, Liquid.Interpolation, Liquid.Placement, Liquid.Icon