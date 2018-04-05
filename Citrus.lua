local Citrus;
Citrus = setmetatable({
	Instance = setmetatable({
			newClass = function(name,funct)
				local self = Citrus.Instance
				local pt = Citrus.Table
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
				local self = Citrus.Instance
				if self.isAClass(is) then
					is = Instance.new(is)
					return is:IsA(a)
				end
				return false
			end;
			isAClass = function(is,custom)
				if pcall(function() return Instance.new(is) end) or custom and getmetatable(Citrus.Instance).Classes[is] then
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
				return Citrus.Instance.new(class,unpack(args))
			end;
			new = function(class,...)
				local self = Citrus.Instance
				local pt = Citrus.Table
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
					Citrus.Properties.setPropertiesToDefault(new)
				else
					table.remove(properties,a)
				end		
				Citrus.Properties.setProperties(new,properties or {})
				return new
			end;
			newInstance = function(class,parent,props)
				local new = Instance.new(class)
				local parent = Citrus.Instance.getInstanceOf(parent)
				props = props or type(parent) == 'table' and parent
				parent = type(parent) ~= 'table' and parent or nil
				local a = next(props or {})
				return Citrus.Properties.setProperties(Instance.new(class,parent),props or {})
			end;
			newObject = function(...)
				local function insert(who)
					rawset(getmetatable(Citrus.Instance).Objects,who.Instance,who)
				end
				local args,obj,class,parent,props = {...},{}
				for i,v in next,args do
					class = type(v) == 'string' and Citrus.Instance.isAClass(v) and v or class
					parent = typeof(v) == 'Instance' and v or parent
					props = type(v) == 'table' and Citrus.Table.length(obj) > 0 and v or props
					obj = type(v) == 'table' and Citrus.Table.length(obj) == 0 and v or obj
				end
				local ins = Citrus.Instance.newInstance(class,parent,props)
				local new = {Instance = ins,Object = obj}
				local newmeta = {
					Properties = {Index = {}, NewIndex = {}};
					__index = function(self,ind)
						local pro = getmetatable(self).Properties
						if Citrus.Table.contains(pro.Index,ind) then
							local ret = Citrus.Table.find(pro.Index,ind)
							return type(ret) ~= 'function' and ret or ret(self)
						elseif Citrus.Table.contains(self.Object,ind) or not Citrus.Properties.hasProperty(self.Instance,ind) then
							return Citrus.Table.find(self.Object,ind)
						elseif Citrus.Properties.hasProperty(self.Instance,ind) then
							return self.Instance[Citrus.Properties[ind]]
						end
					end;
					__newindex = function(self,ind,new)
						local pro = getmetatable(self).Properties
						if Citrus.Table.contains(pro.NewIndex,ind) then
							Citrus.Table.find(pro.NewIndex,ind)(self,new)
						elseif Citrus.Table.contains(self.Object,ind) or not Citrus.Properties.hasProperty(self.Instance,ind) then
							rawset(self.Object,ind,new)
						elseif Citrus.Properties.hasProperty(self.Instance,ind) then
							self.Instance[Citrus.Properties[ind]] = new
						end
					end;
					__call = function(self,prop)
						Citrus.Properties.setProperties(self.Instance,prop)
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
					local ins = self.Instance:Clone()
					ins.Parent = parent
					local clone = Citrus.Table.clone(self)
					clone.Instance = ins
					insert(clone)
					return clone
				end;
				setmetatable(new,newmeta)
				insert(new)
				return new
			end;
			getInstanceOf = function(who)
				local self = getmetatable(Citrus.Instance).Objects
				return Citrus.Table.indexOf(self,who) or who
			end;
			getObjectOf = function(who)
				local self = getmetatable(Citrus.Instance).Objects
				return Citrus.Table.find(self,who) or nil
			end;
			isAnObject = function(who)
				return Citrus.Instance.getObjectOf(who) and true or false
			end;
			getAncestors = function(who)
				local anc = {game}
				who = Citrus.Instance.getInstanceOf(who)
				local chain = Citrus.Misc.stringFilterOut(who:GetFullName(),'%.','game',nil,true)
				local ind = game
				for i,v in next,chain do
					ind = ind[v]
					table.insert(anc,ind)
				end
				return Citrus.Table.pack(Citrus.Table.reverse(anc),2)
			end;
		},{
			Classes = {};
			Objects = {};
		}
	);
	Properties = setmetatable({
			getDefault = function(classname)
				local def = {}
				for i,v in next, getmetatable(Citrus.Properties).Default do
					if Citrus.Instance.isA(classname,i) or classname == i or i == 'GuiText' and classname:find'Text' then
						table.insert(def,v)
					end
				end
				for i = 2,#def do
					Citrus.Table.merge(def[i],def[1])
				end
				return def[1]
			end;
			setDefault = function(classname,properties)
				getmetatable(Citrus.Properties).Default[classname] = properties;
			end;
			setPropertiesToDefault = function(who)
				Citrus.Properties.setProperties(who,Citrus.Properties.getDefault(who.ClassName) or {})
			end;
			new = function(name,func,...)
				local storage = getmetatable(Citrus.Properties).Custom
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
				who = Citrus.Instance.getInstanceOf(who)
				if pcall(function() return who[Citrus.Properties[prop]] end) then
					return true
				else
					return false
				end
			end;
			getProperties = function(who)
				who = Citrus.Instance.getInstanceOf(who)
				local p = getmetatable(Citrus.Properties).RobloxAPI
				local new = {}
				for i,v in next,p do
					if Citrus.Properties.hasProperty(who,v) then
						rawset(new,v,who[v])
					end
				end
				return new
			end;
			setProperties = function(who,props)
				who = Citrus.Instance.getInstanceOf(who)
				local c = getmetatable(Citrus.Properties).Custom
				for i,v in next,props do
					if c[i] and c[i][who] then
						if type(v) ~= 'table' then v = {v} end
						--custom object check
						c[i](who,unpack(v))
					elseif Citrus.Properties[i]:find'Color3' and type(v) == 'string' or type(v) == 'table' then
						v = type(v) == 'table' and v or {v}
						Citrus.Theming.insertObject(v[1],who,i,unpack(Citrus.Table.pack(v,2) or {}))
					elseif Citrus.Properties.hasProperty(who,i)  then
						pcall(function() who[Citrus.Properties[i]] = v end)
					end
				end
				return who
			end;
			getObjectOfProperty = function(property,directory)
				directory = Citrus.Instance.getInstanceOf(directory)
				local objects = {}
				for _,object in next,type(directory) == 'table' and directory or directory:GetDescendants() do
					if Citrus.Properties.hasProperty(object,property) then
						table.insert(objects,object)
					end
				end
				return objects
			end;
						
		},{
			__index = function(self,ind)
				return Citrus.Table.search(getmetatable(self).RobloxAPI,ind) or ind
			end;
			Default = {};
			Custom = setmetatable({},{
					__index = function(self,ind)
						for i,v in next,self do
							if i:sub(1,#ind):lower() == ind then
								return v
							end
						end
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
		}
	);
	Positioning = {
		new = function(...)
			local args = {...}
			if #args == 4 then
				return UDim2.new(unpack(args))
			else
				local a,b  = args[1], args[3] == nil and args[1] or args[2]
				return Citrus.Misc.switch(UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)):Filter('s','o','b','so','os')(args[3] or args[2] or 1)
			end
		end;
		toUDim = function(a,b)
			return Citrus.Misc.switch(UDim.new(a,b), UDim.new(a,a))(b and 1 or 2)
		end;
		toVector2 = function(a,b)
			return Citrus.Misc.switch(Vector2.new(a,b), Vector2.new(a,a))(b and 1 or 2)
		end;
		fromPosition = function(a,b)
			local x,y
			local pos = Citrus.Misc.switch(UDim.new(0,0),UDim.new(.5,0),UDim.new(1,0),UDim2.new(.5,0)):Filter('top','mid','bottom','center')
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
	Color = setmetatable({
			fromRGB = function(r,g,b)
				return Color3.fromRGB(r,g,b)
			end;
			toRGB = function(color)
				if not color then return nil end
				local r = Citrus.Misc.round
				return r(color.r*255),r(color.g*255),r(color.b*255)
			end;
			editRGB = function(color,...)
				local round,op = Citrus.Misc.round,Citrus.Misc.operation
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
				local r,g,b = Citrus.Color.toRGB(color)
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
				local r,g,b = Citrus.Color.toRGB(color)
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
				local r = Citrus.Misc.round
				local h,s,v = Color3.toHSV(color)
				return r(h*360),r(s*100),r(v*100)
			end;
			editHSV = function(color,...)
				local round,op = Citrus.Misc.round,Citrus.Misc.operation
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
				local r,g,b = Citrus.Color.toHSV(color)
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
				return Citrus.Color.fromHSV(unpack(nc))
			end;
			setHSV = function(color,...)
				local args = {...}
				local nr,ng,nb,nc
				local r,g,b = Citrus.Color.toHSV(color)
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
				return Citrus.Color.fromHSV(unpack(nc))
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
				local r,g,b = Citrus.Color.toRGB(color)
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
				local h,s,v = Citrus.Color.toHSV(color)
				return Citrus.Color.fromHSV(h,v,s)
			end;
			getInverse = function(color)
				local h,s,v = Citrus.Color.toHSV(color)
				return Citrus.Color.fromHSV((h + 180) % 360, v, s)
			end;
			getObjectsOfColor = function(color,directory)
				local objs = {}
				for i,obj in pairs(Citrus.Instance:getInstanceOf(directory):GetDescendants())do
					for prop, val in pairs(Citrus.Properties.getProperties(obj))do
						if val == color then
							table.insert(objs,obj)
						end
					end
				end
				return objs
			end;
			
			insertColor = function(name,col,...)
				local index = getmetatable(Citrus.Color).Colors
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
					Citrus.Table.insert(index[name],col)
				else
					index[name] = type(col) == 'table' and col or {col}
				end		
				for i,v in next,subs do
					Citrus.Color.insertColor(name,v,unpack({...}),i)
				end	
			end;
			getColor = function(name,id,...)
				local index = getmetatable(Citrus.Color).Colors
				for i,v in next,{type(id) == 'string' and id or nil,...} do
					index = Citrus.Table.search(index,v)
				end
				local col = index[name]
				return col and col[type(id) == 'number' and id or next(col)]
			end;
			removeColor = function(name,...)
				local index = getmetatable(Citrus.Color).Colors
				for i,v in next,{...} or {} do
					index = index[v]
				end
				index[name] = nil
			end;
			
			new = function(...)
				local args = {...}
				if type(args[1]) == 'string' then
					if args[1]:sub(1,1) == '#' then
						return Citrus.Color.fromHex(args[1])
					else
						return Citrus.Color.getColor(...)
					end
				elseif args[4] and args[4] == true then
					return Citrus.Color.fromHSV(args[1],args[2],args[3])
				elseif #args == 3 then
					return Citrus.Color.fromRGB(args[1],args[2],args[3])
				end
			end;
	},{
			Colors = {};
	});
	Theming = setmetatable({
			new = function(name,...)
				local vals = {...}
				local th = getmetatable(Citrus.Theming).Themes
				th[name] = { Values = vals, Objects = {} }
			end;
			getTheme = function(name)
				return getmetatable(Citrus.Theming).Themes[name]
			end;
			getObjects = function(name,obj)
				return obj and Citrus.Theming.getTheme(name).Objects[obj] or Citrus.Theming.getTheme(name).Objects
			end;
			getValues = function(name,index)
				return not index and Citrus.Theming.getTheme(name).Values or Citrus.Theming.getTheme(name).Values[index]
			end;
			setTheme = function(name,...)
				Citrus.Theming.getTheme(name).Values = {...}
				Citrus.Theming.syncTheme(name)
			end;
			setValue = function(name,to,index)
				Citrus.Theming.getValues(name)[index or 1] = to
				Citrus.Theming.syncTheme(name)
			end;
			setObjects = function(name,...)
				Citrus.Theming.getTheme(name).Objects = {}
				Citrus.Theming.insertObjects(...)
			end;
			insertObject = function(name,obj,...)
				obj = Citrus.Instance.getInstanceOf(obj)
				Citrus.Theming.getObjects(name)[obj] = {}
				local ob = Citrus.Theming.getObjects(name)[obj]
				local args = {...}
				local count = 1
				for i,val in next,args do
					if type(val) == 'string' and i == count and Citrus.Properties.hasProperty(obj,Citrus.Properties[val]) then
						count = count + 1
						val = Citrus.Properties[val]
						Citrus.Theming.insertProperty(name,obj,val,type(args[count]) == 'number' and args[count] or nil)
						if type(args[count]) == 'number' then
							count = count + 1
						end
					end				
				end
			end;
			insertProperty = function(name,obj,prop,index)
				obj = Citrus.Instance.getInstanceOf(obj)
				local objs = Citrus.Theming.getObjects(name,obj)
				objs[prop] = index or 1
				obj[prop] = Citrus.Theming.getValues(name,index or 1)
			end;
			insertObjects = function(name,...)
				for i,v in next,{...} do
					Citrus.Theme.insertObject(name,unpack(type(v) == 'table' and v and v or {v}))
				end
			end;
			syncTheme = function(name)
				for i,theme in next, name and {Citrus.Theming.getTheme(name)} or getmetatable(Citrus.Theming).Themes do
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
		}
	);
	Effects = setmetatable({
		--TweenInfo: Time EasingStyle EasingDirection RepeatCount Reverses DelayTime
		--TweenCreate: Instance TweenInfo dictionary
			new = function(name,func)
				getmetatable(Citrus.Effects).Effects[name] = func
			end;
			getEffect = function(name)
				return Citrus.Table.search(getmetatable(Citrus.Effects).Effects,name)
			end;
			affect = function(who,name,...)
				who = Citrus.Instance.getInstanceOf(who)
				name = type(name) == 'function' and name or Citrus.Effects.getEffect(name)
				return name(who,...)
			end;
			affectChildren = function(who,name,...)
				who = Citrus.Instance.getInstanceOf(who)
				for i,v in next,who:GetChildren() do
					Citrus.Effects.affect(v,name,...)
				end
			end;
			affectDescendants = function(who,name,...)
				who = Citrus.Instance.getInstanceOf(who)
				for i,v in next,who:GetDescendants() do
					Citrus.Effects.affect(v,name,...)
				end
			end;
			massAffect = function(who,name,...)
				who = Citrus.Instance.getInstanceOf(who)
				local args = {...}
				who.ChildAdded:connect(function(c)
						Citrus.Effects.affect(c,name,args)
					end)
			end;
	},
		{
			Effects  = {};
		}
	);
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
					local namefil = Citrus.Misc.stringFilterOut(names[count] or 'Icon','_',nil,true)
					local name = namefil[#namefil]
					table.remove(namefil,#namefil)
					Citrus.Iconography.insertIcon(name,icon,unpack(namefil))
					count = count + 1
				end
			end
		end;			
		insertIcon = function(name,icon,...)
			local index = getmetatable(Citrus.Iconography).Icons
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
			local index = getmetatable(Citrus.Iconography).Icons
			for i,v in next,{...} or {} do
				v = v:sub(1,1):upper()..v:sub(2)
				index = index[v]
			end
			local icon = Citrus.Table.search(index,name,true)
			return icon:Clone()
		end;		
		getIconData = function(...)
			local i = Citrus.Iconography.new(...)
			return {Image = i.Image, ImageRectSize = i.ImageRectSize, ImageRectOffset = i.ImageRectOffset}
		end;
	},{
		Icons = {}
		}
	);
	Settings = setmetatable({
		getDefault = function(classname)
			for i,v in next, getmetatable(Citrus.Settings).Default do
				if Citrus.Instance.isA(classname,i) or classname == i then
					return v
				end
			end
		end;
		setDefault = function(classname,properties)
			getmetatable(Citrus.Settings).Default[classname] = properties;
		end;
		newList = function(name)
			getmetatable(Citrus.Settings).Settings[name] = {};
		end;
		getList = function(name)
			local settings = getmetatable(Citrus.Settings).Settings
			return not name and settings.MAIN or settings[name]
		end;
		new = function(list,name,object,index,defaultval,...)
			local list = Citrus.Settings.getList(list)
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
			if list then return Citrus.Table.find(Citrus.Settings.getList(list),name) end
			for i,v in next, getmetatable(Citrus.Settings).Settings.MAIN do
				if i == name then
					return v
				end
			end
		end;
		setSetting = function(name,newval,list)
			Citrus.Settings.getSetting(name,list and list or nil):Set(newval)
		end;
		Sync = function(self)
			for _,list in next, getmetatable(self).Settings do
				for name, setting in next, list do
					print(setting,123)
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
	Table = {
		insert = function(tabl,...)
			for i,v in pairs(...) do 
				if type(v) == 'table' then
					Citrus.Table.insert(tabl,v)
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
					clone[i] = Citrus.Table.clone(v)
					if getmetatable(v) then
						local metaclone = Citrus.Table.clone(getmetatable(v))
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
		contains = function(tabl,contains,typ)
			for i,v in next,tabl do
				if v == contains or (typeof(i) == typeof(contains) and v == contains) or i == contains then
					if typ then
						return ({true,v,i})[typ]
					else
						return true,v,i
					end
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
			return #Citrus.Table.toNumeralIndex(tab)
		end;
		reverse = function(tab)
			local new ={}
			for i,v in next,tab do
				table.insert(new,tab[#tab-i+1])
			end
			return new
		end;
		indexOf = function(tabl,val)
			return Citrus.Table.contains(tabl,val,3)
		end;
		valueOfNext = function(tab,nex)
			local i,v = next(tab,nex)
			return v
		end;
		find = function(tabl,this)
			return Citrus.Table.contains(tabl,this,2)
		end;
		search = function(tabl,this,extra)
			if not getmetatable(tabl) then setmetatable(tabl,{}) end
			local meta = getmetatable(tabl)
			if not meta['0US3D'] then
				meta['0US3D'] = {}
			end
			local used = meta['0US3D']
			local likely = {}
			if Citrus.Table.find(used,this) then
				return unpack(Citrus.Table.find(used,this))
			end		
			if Citrus.Table.find(tabl,this) then
				used[this] = {Citrus.Table.find(tabl,this)}
				return Citrus.Table.find(tabl,this)
			end
			for i,v in next,tabl do
				if type(i) == 'string' or type(v) == 'string' then
					local subject = type(i) == 'string' and i or type(v) == 'string' and v
					local caps = Citrus.Misc.stringFilterOut(subject,'%u',nil,false,true)
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
			local resin = Citrus.Table.indexOf(tabl,likely[1])
			local firstresult = tabl[resin]
			used[this] = {firstresult and firstresult or false, firstresult and Citrus.Table.indexOf(tabl,firstresult), likely}
			return firstresult and firstresult or false, firstresult and Citrus.Table.indexOf(tabl,firstresult), likely
		end;
		anonSetMetatable = function(tabl,set)
			local old = getmetatable(tabl)
			local new = Citrus.Table.clone(setmetatable(tabl,set))
			setmetatable(tabl,old)
			return new
		end;
	};
	Misc = {
		destroyIn = function(who,seconds)
			game:GetService("Debris"):AddItem(who,seconds)
		end;
		exists = function(yes)
			return yes ~= nil and true or false
		end;
		tweenService = function(what,prop,to,...)
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
				props[Citrus.Properties[v]] = type(to) ~= 'table' and to or to[i]
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
				if not Citrus.Misc.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
					local filtered = string:sub(string:find(starting),ending and ({string:find(ending)})[2] or ({string:find(starting)})[2])
					local o = string:sub(1,(ending and string:find(ending) or string:find(starting))-1)
					table.insert(filter,filtered~=disregard and filtered or nil)
					table.insert(out,o~=disregard and o or nil)
				else
					table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
				end
				string = string:sub((ending and ({string:find(ending)})[2] or ({string:find(starting)})[2]) + 1)
			end
			table.insert(out,string)
			filter = tostr and table.concat(filter) or filter
			out = tostr and table.concat(out) or out
			return flip and out or filter, flip and filter or out
		end;
		dynamicType = function(obj)
			obj = Citrus.Instance.getInstanceOf(obj)
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
					local yes = Citrus.Misc.exists	
					local i = what
					if yes(Citrus.Table.find(self.data,what)) then
						i = Citrus.Table.indexOf(self.data,what)
					end
					if yes(Citrus.Table.find(self.filter,what)) then
						i = Citrus.Table.indexOf(self.filter,what)
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
			return Citrus.Misc.switch(a+b,a-b,a*b,a/b,a%b,a^b,a^(1/b),a*b,a^b,a^(1/b)):Filter('+','-','*','/','%','^','^/','x','pow','rt')(opa)
		end;
	};
},{
	__index = function(self,nam)
		for i,v in next, self do
			if self.Table.contains(v,nam) then
				return self.Table.find(v,nam)
			end
		end
	end
})
table.sort(getmetatable(Citrus.Properties).RobloxAPI,function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end);


--Variables
local Create, Properties, Position, Color, Theming, Effects, Icon, Settings, Table, Misc = Citrus.Instance, Citrus.Properties, Citrus.Positioning, Citrus.Color, Citrus.Theming, Citrus.Effects, Citrus.Iconography, Citrus.Settings, Citrus.Table, Citrus.Misc
local newClass = Create.newCustomClass
local create,create2,create3,newObject,newInstance, new = Create.new, Create.newObject, Create.newInstance, Create.newObject, Create.newInstance, Create.newInstance
local cPure = Create.newPure
local obj,ins,getInstance,getObject,isObject,getParents = Create.getObjectOf,Create.getInstanceOf,Create.getInstanceOf, Create.getObjectOf, Create.isObject, Create.getAncestors
local newProperty = Properties.new
local has, get, set = Properties.hasProperty, Properties.getProperties, Properties.setProperties
local setdef, getdef, todef = Properties.setDefault, Properties.getDefault, Properties.setPropertiesToDefault
local ud, udim, v2, frompos, tweenObj = Position.new, Position.toUDim, Position.toVector2, Position.fromPosition, Position.tweenObject
local newColor, getColor = Color.insertColor, Color.getColor
local col, rgb, hsv, hex = Color.new, Color.fromRGB, Color.fromHSV, Color.fromHex
local affect, affectch, affectdesc, massEffect = Effects.affect, Effects.affectChildren, Effects.affectDescendants, Effects.massAffect
local icons, getIcon = getmetatable(Icon).Icons, Icon.getIcon
local Set, newSet, getSet, newList, getList = Settings.setSetting, Settings.new, Settings.getSetting, Settings.newList, Settings.getList
local switch, round, op, yes, tween, filter = Misc.switch, Misc.round, Misc.operation, Misc.exists, Misc.tweenService, Misc.stringFilterOut
local Theme = {
	set = Theming.setTheme;
	get = Theming.getValues;
	new = Theming.new;
	to = Theming.insertObject;
}

--Colours
fromMaterial = function(name,i,ac)
	local id = Citrus.Misc.switch(1,2,3,4,5,6,7,8,9,10):Filter(unpack(Citrus.Misc.switch({50,100,200,300,400,500,600,700,800,900},{100,200,400,700}):Filter(false,true)(Citrus.Misc.exists(ac))))
	id = id(i or 500)
	return id and Citrus.Color.getColor(name,id,'Material',ac and 'Accent')
end;
