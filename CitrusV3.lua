--[[
                                      d8,                      
                                     `8P                       
                                                               
  88bd88b d8888b ?88   d8P d888b8b    88b .d888b,  88bd8b,d88b 
  88P'  `d8P' ?88d88   88 d8P' ?88    88P ?8b,     88P'`?8P'?8b
 d88     88b  d88?8(  d88 88b  ,88b  d88    `?8b  d88  d88  88P
d88'     `?8888P'`?88P'?8b`?88P'`88bd88' `?888P' d88' d88'  88b
                                 )88                           
                                ,88P                           
                            `?8888P  

      
]]
local Citrus
Citrus = setmetatable({
	Shortcuts = setmetatable({
		'Active','AnchorPoint','AutoButtonColor','BackgroundColor3','BorderColor3','BorderSizePixel';
		'Name','Position','Size','SizeConstraint','Visible','ZIndex','ClipsDescendants';
		'Draggable','BackgroundTransparency','Font','Text','TextColor3','TextSize';
		'TextScaled','TextStrokeColor3','TextStrokeTransparency','TextTransparency','TextWrapped';
		'TextXAlignment','TextYAlignment','Image','ImageColor3','ImageRectOffset','ImageRectSize';
		'ImageTransparency','Parent','CanvasPosition','BottomImage','CanvasSize','HorizontalScrollBarInsert','MidImage','ScrollBarThickness';
		'ScrollingEnabled','TopImage','VerticalScrollBarInsert','VerticalScrollBarPosition';
		'AspectRatio','AspectType','DominantAxis','CellPadding','CellSize','FillDirection','FillDirectionMaxCells','HorizontalAlignment','SortOrder';
		'StartCorner','VerticalAlignment','Padding','PaddingBottom','PaddingLeft','PaddingRight','PaddingTop','EasingDirection','EasyingStyle','TweenTime';
		'Scale','Value'
	},getmetatable(Citrus).Metatables.Find);
	Instances = {
		Functions = {
			newCustomProperty = function(self,who,where,what,...)
				if type(where) ~= 'table' then where = {where} end
				for i,where in pairs(where)do
					if not self[where] then
						self[where] = {}
						sm(self[where],metaFind)
					end
					if self[where][who] and self[where][who] ~= who then
						return error(who..' has already been established in '..where)
					else
						self[where][who] = what
					end
				end
				if ... and ... == true then
					table.insert(Shortcuts,who)
				elseif ... and type(...) == 'string' then
					table.insert(Shortcuts,...)
				end
			end;
		};
		Classes = setmetatable({},getmetatable(Citrus).Metatables.Find2);
		toTheme = function(who,typ,where,what)
			Theme.insertGuiObject(who,typ,where,what)
			if not what then what = 1 end
			who[Shortcuts[typ]] = Theme.getTheme(where,what)
		end;
		newClass = function(who,what)
			local class = {onCreate = what}
			if Create.Classes[who] and Create.Classes[who] == who then
				return error(who..' is an already established class.')
			else
				Create.Classes[who] = class
			end
		end;
		newInstance = function(who,where,how)
			local new = Instance.new(who)
			if where then
				new.Parent = where
			end
			if how then
				for i,v in pairs(how)do
					i = Lusch.Shortcuts[i]
					if Create.Functions[new.ClassName] and Create.Functions[new.ClassName][i] and Create.Functions[new.ClassName][i] ~= i then
						local f = Create.Functions[new.ClassName][i]
						if type(v) == 'table' then
							f(new,unpack(v))
						else
							f(new,v)
						end
					elseif Create.Functions['All'] and Create.Functions.All[i] and Create.Functions.All[i] ~= i then
						local f = Create.Functions['All'][i]
						if type(v) == 'table' then
							f(new,unpack(v))
						else
							f(new,v)
						end				
					else
						new[i] = v
					end
				end
			end
			return new
		end;
		setProperties = function(who,how)
			if type(who) == 'table' then
				local ret = {}
				for i,v in pairs(who)do
					table.insert(who,Create.setProperties(v,how))
				end
				return ret
			end
			local new = who
			if how then
				for i,v in pairs(how)do
					i = Lusch.Shortcuts[i]
					if Create.Functions[new.ClassName] and Create.Functions[new.ClassName][i] and Create.Functions[new.ClassName][i] ~= i then
						local f = Create.Functions[new.ClassName][i]
						if type(v) == 'table' then
							f(new,unpack(v))
						else
							f(new,v)
						end
					elseif Create.Functions['All'] and Create.Functions.All[i] and Create.Functions.All[i] ~= i then
						local f = Create.Functions['All'][i]
						if type(v) == 'table' then
							f(new,unpack(v))
						else
							f(new,v)
						end				
					else
						new[i] = v
					end
				end
			end
			return new
		end;
		createObject = function(who,where,obj,prop)
			local new = Create.newInstance(who)
			local Obj = {new}
			if not obj then obj = {} end
			if where then
				new.Parent = where
			end
			local metaObj = {
				Object = obj;
				__index = function(who,other)
					local s
					if type(other) == 'string' then 
						s = Shortcuts[other] 
					else 
						s = other 
					end
					if getmetatable(who).Object[other] then
						return getmetatable(who).Object[other]
					else
						return who[1][s]
					end
				end;
				__newindex = function(who,other,to)
					local s
					if type(other) == 'string' then s = Shortcuts[other] else s = other end
					if (getmetatable(who).Object and getmetatable(who).Object[other]) or not Shortcuts(other) then
						getmetatable(who).Object[other] = to
					else
						who[1][s] = to
					end			
				end;
				__call = function(who,tab)
					Create.setProperties(who[1],tab)
					return who
				end;
			}
			function Obj:Clone(parent)
				local clone = self[1]:Clone()
				clone.Parent = parent
				clone = {clone,Clone = self.Clone}
				local meta = gm(self)
				local ob = meta.Object
				local newob = {}
				for i,v in pairs(ob)do
					if typeof(v) == 'Instance' then
						newob[i] = v:Clone()
					else
						newob[i] = v
					end
				end
				meta.Object = newob
				
				sm(clone,meta)
				return clone
			end
			sm(Obj,metaObj)
			if prop then
				Obj(prop)
			end
			return Obj
		end;
	};
	Position = {
		Tweening = {
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
				return who
			end;
			Rotate = function(who,where,when)
				Tweening.tween(who,'Rotation',where,when)
			end;
			tween = function(who,typ,how,howfast)
				if type(who) == 'table' and type(who[1]) == 'userdata' then who = who[1] end
				local typt = {}
				if type(typ) ~= 'table' then
					typ = {typ}
				end
				for i,v in pairs(typ)do
					typt[Shortcuts[v]] = how
				end
				local t = TweenInfo.new(howfast)
				if type(who) == 'userdata' then
					game:GetService('TweenService'):Create(who,t,typt):Play()
				else
					who:Lerp(how,howfast)
				end
			end;
		};
		['UDim'] = {
			new = function(a,b,c,d)
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
			pos = function(a,b,c,d)
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
			end;
			Offset = function(a,b)
				a,b = a or 0,b or 0
				return UDim2.new(0,a,0,b)
			end;
			Scale = function(a,b)
				a,b = a or 0,b or 0
				return UDim2.new(a,0,b,0)
			end;
			X = function(a,b)
				if type(a) == 'table' then
					return UD.X(a[1],a[2])
				end
				return UDim2.new(a,b,0,0)
			end;
			Y = function(a,b)
				if type(a) == 'table' then
					return UD.Y(a[1],a[2])
				end
				return UDim2.new(0,0,a,b)
			end;
		};
	};
	Color = {
		Colours = {
			insertNewColor = function(self,who,set)
				if type(who) == 'table' then
					local tab = {}
					for i,v in pairs(who) do
						table.insert(tab,Colors:insertNewColor(v,set[i]))
					end
					return tab
				end
				Colors[who] = {};
				if set then
					Colors[who] = set
					for i,v in pairs(set)do
						if type(i) == 'string' and type(v) == 'table' then
							Colors[who][i] = Colors:insertColorSet(i,set,v)
						else
							Colors[who][i] = v
						end
					end
				end
				return Colors[who]
			end;
			insertColorSet = function(self,who,where,set)
				if type(where) == 'string' then
					return error(where.." doesn't exist.")
				end
				where[who] = {}
				for i,v in pairs(set)do
					if type(i) == 'string' and type(v) == 'table' then
						where[who][i] = Colors:insertColorSet(i,set,v)
					else
						where[who][i] = v
					end
				end
				return where[who]
			end;
			getColorSet = function(self,who,typ,...)
				local subs,get = {...}
				if type(Colors[who]) == 'string' then
					return error('Color: '..who..' doesnt exist.')
				end
				if Colors[who][typ] == typ then
					return error('Type: '..typ..' doesnt exist.')
				end
				get = Colors[who][typ]
				for i,v in pairs(subs)do
					get = get[v]
				end
				return get
			end;
		};
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
			return Color.fromRGB(r,g,b)
		end;
		toHex = function(a,b,c,d)
			local r,g,b,hex,ro
			local round,ts = round,tostring
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
		fromHSV = function(h,s,v)
			return Color3.fromHSV(h/360,s*.01,v/100)
		end;
		toHSV = function(color)
			local h,s,v = Color3.toHSV(color)
			return {h*360,s*100,v*100}
		end;
		fromRGB = function(r,g,b)
			return Color3.new(r/255,g/255,b/255)
		end;
		toRGB = function(color)
			return { round(color.r*255),round(color.g*255),round(color.b*255) }
		end;
		new = function(who,typ,...)
			if not typ then typ = 1 end
			local set = Colors:getColorSet(who,'Default',...)
			return set[typ]
		end;
		getColor = function(who,typ,...)
			if not typ then typ = 1 end
			local set = Colors:getColorSet(who,...)
			return set[typ]
		end;
		newKeyframes = function(...)
			local keys = {}
			keys.Keys = {}
			local kmeta = {
				__call = function(self,i)
					if type(self[i]) == 'string' then
						return Color.fromHex(self[i])
					else
						return self[i]
					end
				end
			}
			sm(keys.Keys,kmeta)
			keys.Playing = false
			keys.Looped = false
			keys.Reverse = false
			keys.PausedOn = 1
			keys.Objects = {}
			keys.Data = {}
			keys.insertKeyframes = function(self,...)
				local frames = {...}
				if type(frames[1]) == 'number' then
					for i,v in pairs(frames)do
						if type(v) ~= 'number' then
							self:insertKeyframe(v,frames[1])
						end
					end
				else
					for i,v in pairs(frames)do
						self:insertKeyframe(v)
					end
				end
			end
			keys.insertKeyframe = function(self,who,where)
				if where then
					table.insert(self.Keys,where,who)
				else
					table.insert(self.Keys,who)
				end
			end
			keys.insertObject = function(self,who,prop)
				if not prop and who.ClassName:sub(-5) == 'Frame' then
					prop = 'bc'
				end
				if not self.Objects[who] then
					self.Objects[who] = {}
				end
				if prop then
					self:toggleProperty(who,prop)
				end
			end
			keys.toggleProperty = function(self,who,prop)
				if not self.Objects[who] then
					self:insertObject(who)
				end
				prop = Shortcuts[prop]
				if not self.Objects[who][prop] then
					self.Objects[who][prop] = false
				end
				if self.Objects[who][prop] == false then
					self.Objects[who][prop] = true
					who[prop] = self.Keys(self.PausedOn)
				else
					self.Objects[who][prop] = false
				end
			end
			keys.setData = function(self,dur,lerp)
				if type(dur) == 'table' then
					self.Data = dur
				end
				if dur then
					self.Data[1] = dur
				end
				if lerp~= nil then
					self.Data[2] = lerp
				end
			end
			keys.setKeyframes = function(self,...)
				self.Keys = {}
				sm(self.Keys,kmeta)
				self:insertKeyframes(...)
			end
			keys.editKeyframe = function(self,who,to)
				for i,v in pairs(self.Keys)do
					if v == who then
						self.Keys[i] = to
					end
				end
			end
			keys.Sync = function(self,to,lerp,speed)
				for who,v in pairs(self.Objects)do
					for prop,bool in pairs(v)do
						if bool == true then
							if lerp and lerp == true then
								if not speed then speed = keys.Data[1] end
								Tweening.tween(who,prop,self.Keys(to),speed)
							else
								who[prop] = self.Keys(to)
							end
						end
					end
				end
			end
			keys.Play = function(self,duration,lerp)
				if not duration then duration = self.Data[1] end
				if not lerp then lerp = self.Data[2] end
				
				self.Data[1] = duration
				self.Data[2] = lerp
				self.Playing = true
				spawn(function()
					if self.Playing == true then
						for i = 1,#self.Keys,1 do
							if self.Playing == true then
								self:Sync(i,self.Data[2],self.Data[1])
								self.PausedOn = i
								wait(self.Data[1])
							else
								break
							end
						end
						if self.Reverse == true then
							for i = #self.Keys-1,2,-1 do
								if self.Playing == true then
									self:Sync(i,self.Data[2],self.Data[1])
									self.PausedOn = i
									wait(self.Data[1])
								else
									break
								end
							end					
						end
					end
					if self.Looped == true then
						self:Play(self.Data[1],self.Data[2])
					else
						self:Stop()
					end
				end)
				return self.PausedOn
			end
			keys.Pause = function(self)
				self.Playing = false
				if self.Looped == true then
					self.Looped = 'Paused'
				end
				return self.PausedOn
			end
			keys.Resume = function(self,from,duration,lerp)
				if not duration then duration = self.Data[1] end
				if not lerp then lerp = self.Data[2] end
				
				self.Data[1] = duration
				self.Data[2] = lerp
				self.Playing = true
				if self.Looped == 'Paused' then
					self.Looped = true
				end
				spawn(function()
					if not from then from = self.PausedOn end
					for i = from,#self.Keys,1 do
						if self.Playing == true then
							self:Sync(i,self.Data[2],self.Data[1])
							self.PausedOn = i
							wait(duration)
						else
							break
						end		
					end
					if self.Reverse == true then
						for i = #self.Keys,1,-1 do
							if self.Playing == true then
								self:Sync(i,self.Data[2],self.Data[1])
								self.PausedOn = i
								wait(duration)
							else
								break
							end
						end					
					end
					if self.Playing == true then
						self:Play(self.Data[1],self.Data[2])
					end
				end)
			end
			keys.Stop = function(self)
				self.Playing = false
				self.Looped = false
				self.PausedOn = 1
				wait(self.Data[1])
				self:Sync(1,self.Data[2],self.Data[1])
			end
			keys:insertKeyframes(...)
			local default = {
				Keys = keys.Keys, Data = keys.Data, Objects = keys.Objects
			}
			sm(keys,default)
			keys.getDefault = function(self,typ)
				if typ then
					return gm(keys)[typ]
				else
					return gm(keys)
				end
			end
			keys.Reset = function(self,typ)
				local df = keys:getDefault(typ)
				if typ then
					df = {df}
				end
				for i,v in pairs(df)do
					keys[i] = v
				end
			end
			keys.setDefault = function(self,typ)
				local df = keys:getDefault()
				if typ then
					df[typ] = keys[typ]
				else
					for i,v in pairs(df)do
						df[i] = keys[i]
					end
				end
			end
		
			return keys
		end;
	};
	Synchronous = setmetatable({
		Theming = {
			Theme = setmetatable({},getmetatable(Citrus).Metatables.Find);
			insertThemeSet = function(self,who,where,set)
				if type(where) == 'string' then
					return error(where.." doesn't exist.")
				end
				if type(set) == 'string' then
					local sett = {}
					local t,t2 = set
					t = t:sub(1,1):upper()..t:sub(2)
					if set:find'-' then
						local t2 = t
							t = t..'-'
							for check in t:gmatch('-') do
								t2 = t:sub(1,t:find'-'-1)
								table.insert(sett,t2)
								t = t:sub(t:find'-'+1)
							end
					end
					if set:sub(1,5) == 'light' or set:sub(1,4) == 'dark' then
						set = Colors:getColorSet('Themes',t,unpack(sett))
					else
						set = Colors:getColorSet(t,unpack(sett))
					end
				elseif type(set) == 'userdata' then
					set = {set}
				end		
				where[who] = set
			end;
			insertNewTheme = function(self,who,typ,...)
				if type(typ) == 'string' then
					local typt = {}
					local t,t2 = typ
					t = t:sub(1,1):upper()..t:sub(2)
					if typ:find'-' then
						local t2 = t
							t = t..'-'
							for check in t:gmatch('-') do
								t2 = t:sub(1,t:find'-'-1)
								t2 = t2:sub(1,1):upper()..t2:sub(2)
								table.insert(typt,t2)
								t = t:sub(t:find'-'+1)
							end
					end
					if typ:sub(1,5) == 'light' or typ:sub(1,4) == 'dark' then
						if #typt < 1 then
							typt[1] = t
						end
						typ = Colors:getColorSet('Themes','Default',unpack(typt))
					else
						typ = Colors:getColorSet(unpack(typt))
					end
				elseif type(typ) == 'userdata' then 
					typ = {typ}
				end
				Theme.Theme[who] = {Colors = typ,Items = {}}
				if ... then
					Theme:insertThemeSet((...)[1],Theme.Theme[who],(...)[2])
				end
			end;
			getThemeSet = function(self,who,...)
				if Theme.Theme[who] == who and type(who) == 'string' then
					return error('Theme: '..who.." doesn't exist.")
				end
				local args,get = {...},Theme.Theme[who]
				if not args[1] then args[1] = 'Colors' end
				for i,v in pairs(args)do
					get = get[v]
				end
				return get
			end;
			insertThemes = function(...)
				for _,v in pairs({...})do
					local args = {}
					for i = 3,#(v),1 do
						table.insert(args,(v)[i])
					end
					Theme:insertNewTheme((v)[1],(v)[2],unpack(args))
				end
			end;
			setTheme = function(who,what)
				if Theme[who] == who then
					return error('Theme: '..who.." doesn't exist.")
				end
				local args,set = {}
				local t,t2 = who,who
				t = t..'-'
				for check in t:gmatch('-') do
					t2 = t:sub(1,t:find'-'-1)
					table.insert(args,t2)
					t = t:sub(t:find'-'+1)
				end
				set = Theme.Theme
				for i,v in pairs(args)do
					if i ~= #args then
						set = set[v]
					end
				end
				if #args == 1 then
					set = set[args[1]]
					args[1] = 'Colors'
				end
				Theme:insertThemeSet(args[#args],set,what)
				Theme:SYNC()
			end;
			insertGuiObject = function(who,typ,what,typ2)
				local ghat = what
				if ghat:find'-' then ghat = ghat:sub(1,ghat:find'-'-1) end
				for i,v in pairs(Theme.Theme)do
					if v.Items[who] and v.Items[who][Shortcuts[typ]] then
						v.Items[who][Shortcuts[typ]] = nil
					end
				end
				local i = Theme.Theme[ghat].Items
				if not i[who] then
					i[who] = {}
				end
				i[who][Shortcuts[typ]] = {what,typ2}
			end;
			SYNC = function(self,typ)
				if not typ then
					for i,v in pairs(Theme.Theme)do
						local it = v.Items
						for who,x in pairs(it)do
							for typ,val in pairs(x)do
								Create.toTheme(who,typ,unpack(val))
							end
						end
					end
				end
			end;
			getTheme = function(who,typ)
				if Theme[who] == who then
					return error('Theme: '..who.." doesn't exist.")
				end
				local args,fir = {},who:sub(1,1):upper()..who:sub(2)
				if fir:find'-' then
					fir = fir:sub(1,fir:find'-'-1)
				end
				local t,t2 = who,who
				for check in who:gmatch('-')do
					t2 = t2:sub(t:find'-'+1,1):upper()..t2:sub(t:find'-'+1)
					table.insert(args,t2:sub(1,t:find'-'-1))
					t2 = t:sub(t:find'-'-1)		
				end
				local get = Theme:getThemeSet(fir,unpack(args))
				if not typ then return get end
				return get[typ]
			end;
		};
		Channels = {};
		insertNewChannel = function(self,who,towhat,...)
			if type(who) == 'number' then return error'ChannelID can only contain string values.' end
			Channels[#Channels+1] = {}
			local ch = Channels[#Channels]
			ch.ID = who
			ch.Value = towhat
			ch[1] = {}
			ch.Sync = function(self)
				for object,v in pairs(self[1])do
					for property,z in pairs(v)do
						object[property] = self.Value
					end
				end
			end
			ch.Lerp = function(self,to,speed)
				for who,v in pairs(self[1])do
					for prop,x in pairs(v)do
						Tweening.tween(who,prop,to,speed)
					end
				end
				self.Value = to
			end
			ch.Insert = function(self,who,...)
				Sync.channelAddObject(who,self.ID,...)
			end
			ch.Set = function(self,towhat)
				Sync.editChannelValue(self.ID,towhat)
			end
			ch.Remove = function(self,who,...)
				Sync.channelRemoveObject(who,self.ID,...)
			end
			ch.Delete = function(self)
				Sync:deleteChannel(self.ID)
			end
			ch.Reset = function(self)
				Sync:resetChannel(self.ID)
			end
			if ... then
				for i,v in pairs(...)do
					Sync.channelInsertObject(v[1],who,#Channels)
				end
			end
			sm(ch,{ID = #Channels,Name = ch.ID, DefaultValue = towhat, DefaultObjects = ch[1],
				__newindex = function(self,i,v)
					self:Edit(v)
				end
				})
			return ch
		end;
		deleteChannel = function(self,who)
			local who = gm(Sync:findChannel(who)).ID
			Channels[who] = nil
		end;
		resetChannel = function(self,who)
			local who = Sync:findChannel(who)
			local dwho = gm(who)
			who.ID = dwho.ID
			who.Value = dwho.DefaultValue
			who[1] = dwho.DefaultObjects
		end;
		removeChannelObject = function(who,where,...)
			local where = Sync:findChannel(where)[1]
			if ... then
				where[who][...] = nil
			else
				where[who] = nil
			end
		end;
		editChannelValue = function(who,towhat)
			local who = Sync:findChannel(who)
			if type(towhat) == type(who.Value) then
				who.Value = towhat
				who:Sync()
			else
				return error('This error is for ',type(who.Value),' values ONLY!')
			end
		end;
		findChannel = function(self,who)
			for i,v in pairs(Channels)do
				if v.ID == who and type(who) == 'string' then
					return v
				elseif i == who then
					return v
				end
			end
			return error'No channel with the ID or Name of '..who..' was found.'
		end;
		channelAddObject = function(who,where,...)
			local to = Sync:findChannel(where)
			local obj,val = to[1],to.Value
			if not obj[who] then obj[who] = {} end
			if who[Shortcuts[...]] then
				obj[who][Shortcuts[...]] = val
				who[Shortcuts[...]] = val
			end
			return to
		end;
		insertAnonChannel = function(self,...)
			return self:insertNewChannel(tostring(round((#Channels*math.exp(#Channels)^#Channels)*1000)),...)
		end;
	},{
		__call = function(self,	...)
			for i,v in pairs(Channels)do
				if ... then
					if v.ID == ... then
						v:Sync()
					elseif i == ... then
						v:Sync()
					end
				else
					v:Sync()
				end
			end
		end
	});
	Iconography = {
		Icons = {};
		insertIcons = function(who,image,getx,gety,how,beta) 
			local name,sub,sefl 
			if not how then how = 144 end 
			image = Create.newInstance('ImageLabel',nil,{imag = image}) 
			local iro,irs,new,spare = image.ImageRectOffset,Vector2.new(how,how),Create.newInstance('ImageLabel'),who 
			who = {} 
			local id = 1 
			for y = 0,gety-1,1 do 
				for x = 0,getx-1,1 do 
					sub,name = nil,nil
					if spare[id] then 
						name,sefl = spare[id],Create.setProperties(image,{iro = Vector2.new(x*how,y*how),irs = Vector2.new(how,how)}) 
						if name:find'_' then 
							sub = name:sub(name:find'_'+1) 
							name = name:sub(1,name:find'_'-1) 
						end 
						name = name:sub(1,1):upper()..name:sub(2) 
						if not who[name] then 
							if not sub then 
								who[name] = Create.setProperties(sefl:Clone(),{Name = name}) 
							else 
								who[name] = {} 
								who[name][sub] = Create.setProperties(sefl:Clone(),{Name = sub:sub(1,1):upper()..sub:sub(2)}) 
							end 
						else 
							if sub then 
								who[name][sub] = Create.setProperties(sefl:Clone(),{Name = sub:sub(1,1):upper()..sub:sub(2)})
							end 
						end 
					end
					id = id + 1		
					
				end 
			end 
			if not beta then
				Misc.tableMerge(who,Icon.Icons)
			end
			return who 
		end ;
		getIconInfo = function(who,typ)
			if not typ then 
				return {who.Image,who.ImageRectOffset,who.ImageRectSize}
			elseif typ == 'pic' or typ == 1 then 
				return who.Image 
			elseif typ == 'iro' or typ == 2 then 
				return who.ImageRectOffset 
			elseif typ == 'irs' or typ == 3 then 
				return who.ImageRectSize 
			elseif who[typ] then
				return who[typ] 
			else error'error; no info' 
			end 
		end ;
		isIcon = function(self,who,what)
			who = Icon.getIconInfo(who)
			what = Icon.getIconInfo(what)
			for i = 1,3,1 do
				if who[i] ~= what[i] then
					return false
				end
			end
			return true
		end	;
		};
	Miscellaneous = {
		CatalogAPI = {
			fromLink = function(who,typ)
				local link = who
				local tab = {}
				link = game.HttpService:UrlEncode(link:sub(link:find'catalog/json?'+13,#link))
				local proxy = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?'
				if typ then
					link = game:GetService'HttpService':JSONDecode(game:GetService'HttpService':GetAsync(proxy..link))
				else
					link = game:GetService'HttpService':JSONDecode(game:HttpGetAsync(proxy..link))
				end
				for i,v in pairs(link)do
					tab[v.Name] = v
				end
				return tab
			end;
		};
		round = function(num)
			return math.floor(num+.5)
		end;
		tableReverse = function(tab)
			local ret = {}
			for i,v in pairs(tab)do
				ret[#tab+1-i] = v
			end
			return ret
		end;
		tableClone = function(tab)
			local clone = {}
			for i,v in pairs(tab)do
				if type(v) ~= 'table' then
					clone[i] = v
				else
					clone[i] = Misc.tableClone(v)
				end
			end
			return clone
		end;
		tableFind = function(tab,fo)
			for i,v in pairs(tab)do
				if v == fo or i == fo then
					return v
				end
			end
			return nil
		end;
		tableSearch = function(tab,fo)
			table.insert(tab,1,Misc.tableMerge(tab,{}))
			tab = sm(tab,metaFind)
			return tab(fo)
		end;
		tableMerge = function(who,what)
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
		end;
		getPlayer = function(speaker,...)
			local player = {}
			local ET = et
			local Metas = gm(Lusch).Metatables
			for i,v in pairs({...})do
				if v == 'all' then
					for z,x in pairs(game.Players:GetPlayers())do
						if not ET.Find(player,x) then
							table.insert(player,x)
						end
					end
				elseif v == 'others' then
					for z,x in pairs(game.Players:GetPlayers())do
						if x ~= speaker then
							if not ET.Find(player,x) then
								table.insert(player,x)
							end
						end
					end
				elseif v == 'me' then
					if not ET.Find(player,speaker) then
						table.insert(player,speaker)
					end
				else
					local plrs = sm(game.Players:GetPlayers(),Metas.ClassFind)
					if not ET.Find(player,plrs[v]) then
						table.insert(player,plrs[v])
					end
				end
			end
			return player
		end;
		tableToID = function(who)
			local new = {}
			local id = 1
			for i,v in pairs(who)do
				new[id] = v
				id = id + 1
			end
			return new
		end;
		stringColor = function(pName)
			local colors = {
			  Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
			  Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
			  Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
			  BrickColor.new("Bright violet").Color,
			  BrickColor.new("Bright orange").Color,
			  BrickColor.new("Bright yellow").Color,
			  BrickColor.new("Light reddish violet").Color,
			  BrickColor.new("Brick yellow").Color,
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
		getDropbox = function(link,par)
			local function UrlDecode(Text) --leeched urldecode xD #lazyandtired
				Text = string.gsub(Text, "%%(%d+)", function(Code)
					return string.char(tonumber("0x" .. Code))
				end)
				return Text
			end
			local used = {}
			local main = Instance.new'Folder'
			setmetatable(used,{
				__index=function(self,id)
					for i,v in pairs(self)do
						if v == id then
							return false
						end
					end
					return true
				end;
			})
			local folder = {}
			local function getFolder(lin,p)
				local title,items,async = nil,{}
				local f = Instance.new'Folder'
				if p then f.Parent = p else f = main end
				local s = Instance.new'StringValue'
				async = game.HttpService:GetAsync(lin)
				title = async:sub(async:find'name="filename" value="'+23)
				title = title:sub(1,title:find'" /> <div class="credentials'-1)
				f.Name = title
				coroutine.wrap(function()
					for i in async:gmatch('https://www.dropbox.com/sh/')do
						local l
						async = async:sub(async:find'https://www.dropbox.com/sh/',#async)
						local l2 = async:sub(1,async:find'"')
						if l2:find'dl=0' then
							l = l2:sub(1,l2:find'dl=0'+3)
							if used[l] then
								if l:sub(-9):sub(1,1) == '.' then
									table.insert(used,l)
									local data = s:Clone()
									data.Parent = f
									data.Value = l:sub(1,#l-1)..'1'
									local n = l:reverse():sub(10,l:reverse():find'/'-1):reverse()
									data.Name = UrlDecode(n)
								else
									if not l:find(lin) and not l:find'/file?' and l ~= lin then
										table.insert(used,l)
										if not l:sub(-11):find'rbxl' then
											getFolder(l,f)
										end
									end
								end
							end
						end
						async = async:sub(3)
					end
				end)()
				return f
				end
			getFolder(link)
			if par then main.Parent = par end
			return main
		end;
		tableCount = function(tab)
			local tab = Misc.tableToID(tab)
			return #tab
		end;
		};
	get = {};
	req = function()
		wait()
		for i,v in pairs(script:GetChildren())do
			if v.ClassName == 'ModuleScript' then
				require(v)	
			end
			v:Destroy()
		end
		return Lusch
	end;
},{
	Sync = {
		Channels = {};
		insertNewChannel = function(ID,Value,Type)
			if type(ID) == 'number' then
				return error'Channel IDs can only be a string value'
			end
			BCh[#BCh+1] = {}
			local newChannel = BCh[#BCh]
			newChannel.ID = ID
			newChannel.Value = Value
			newChannel[1] = {}
			if not Type then
				if type(Value) == 'table' then
					if #Value == 3 and typeof(Value[1]) == 'number' and type(Value[3]) == 'string' then
						Type = 'UD_'..Value[3]
					else
						Type = 'Set'
					end
				elseif type(Value) == 'function' then
					Type = 'Function'
				else
					Type = 'Value'
				end
			end
			newChannel.Type = Type
			newChannel.Insert = function(self,who,...)
				if self.Type ~= 'Function' then
					return BSync.channelAddObject(self,who,...)
				else
					return BSync.channelAddObject(self,who,nil,...)
				end
			end
			newChannel.SetObject = function(self,who,...)
				self:Delete(who)
				self:Insert(who,...)
			end
			newChannel.SetProperty = function(self,who,prop,...)
				self:Remove(who,prop)
		
				self:Insert(who,prop,...)
			end
			newChannel.Delete = function(self,...)
				BSync.channelRemoveObject(self,...)
			end
			newChannel.Remove = function(self,...)
				BSync.channelRemoveObjectProperty(self,...)
			end
			newChannel.Edit = function(self,...)
				BSync.channelEditValue(self,...)
				if self.Type ~= 'Function' then
					self:Sync()
				end
			end
			newChannel.exeCall = function(self,...)
				if self.Type == 'Function' then
					self.Value(...)
				end
			end
			newChannel.Call = function(self)
				if self.Type == 'Function' then
					for i,v in pairs(self[1])do
						self.Value(i,unpack(v))
					end
				end
			end
			newChannel.Lerp = function(self,...)
				local order = Misc.tableCount(self[1])
				--Tweening.tween(who,prop,to,speed)
				local dela
				local typ = self.Type
				local args = {...}
				if args[1] == 'Get' and #args == 2 then
					local newargs = {}
					if type(self.Value) == 'table' then
						for i,v in pairs(self.Value)do
							newargs[i] = v
						end
					else
						newargs[1] = self.Value
					end
					newargs[#newargs+1] = args[#args]
					args = newargs
				end
				if args[1] == 'Default' and #args == 2 then
					local newargs = {}
					if type(self:getDefault('Value')) == 'table' then
						for i,v in pairs(self:getDefault('Value'))do
							newargs[i] = v
						end
					else
						newargs[1] = self:getDefault('Value')
					end
					newargs[#newargs+1] = args[#args]
					args = newargs
				end
				for i,v in pairs(args)do
					if v == 'Default' or v == 'dt' then
						args[i] = self:getDefault('Value')[i]
					elseif v == 'Get' or v == 'gt' then
						args[i] = self.Value[i]
					end
				end
				if type(args[#args]) == 'table' then
					dela = args[#args][2]
					args[#args] = args[#args][1]
				end
				if typ == 'Set' then
					for i = 1,order,1 do
						for obj,v in pairs(self[1])do
							if gm(self[1][obj]).ID == i then
								for prop,z in pairs(v)do
									Tweening.tween(obj,prop,args[z],args[#args])
									if dela then
										wait(dela)
									end
								end
							end
						end
					end
				elseif typ:sub(1,2):lower() == 'ud' then
					for i = 1,order,1 do
						for obj,v in pairs(self[1])do
							if gm(self[1][obj]).ID == i then
								for prop,z in pairs(v)do
									if typ:sub(-1):lower() == 'x' then
										Tweening.tween(obj,prop,UD.new(args[1],args[2],obj[prop].Y.Scale,obj[prop].Y.Offset),args[#args])
									elseif typ:sub(-1):lower() == 'y' then
										Tweening.tween(obj,prop,UD.new(obj[prop].X.Scale,obj[prop].X.Offset,args[1],args[2]),args[#args])
									end
									if dela then
										wait(dela)
									end
								end
							end
						end
					end
				else
					for i = 1,order,1 do
						for obj,v in pairs(self[1])do
							if gm(self[1][obj]).ID == i then
								for prop,z in pairs(v)do
									Tweening.tween(obj,prop,args[1],args[2])
									if dela then
										wait(dela)
									end
								end
							end
						end
					end
				end
				args[#args] = nil
				BSync.channelEditValue(self,unpack(args))
			end
			newChannel.Sync = function(self)
				local typ = self.Type
				if typ == 'Function' then
					for i,v in pairs(self[1])do
						--self.Value(i,unpack(v)) IGNORES THIS
					end
				elseif typ == 'Set' then
					for obj,v in pairs(self[1])do
						for prop,z in pairs(v)do
							obj[prop] = self.Value[z]
						end
					end
				elseif typ:sub(1,2):lower() == 'ud' then
					for obj,v in pairs(self[1])do
						for prop,z in pairs(v)do
							if typ:sub(-1):lower() == 'x' then
								obj[prop] = UD.new(self.Value[1],self.Value[2],obj[prop].Y.Scale,obj[prop].Y.Offset)
							elseif typ:sub(-1):lower() == 'y' then
								obj[prop] = UD.new(obj[prop].X.Scale,obj[prop].X.Offset,self.Value[1],self.Value[2])
							end
						end
					end
				else
					for obj,v in pairs(self[1])do
						for prop,z in pairs(v)do
							obj[prop] = self.Value
						end
					end
				end
			end
			newChannel.getDefault = function(self,typ)
				local d = gm(self)
				if typ then
					d = d[typ]
				end
				return d
			end
			newChannel.setDefault = function(self,typ)
				local d = gm(self)
				if typ then
					d[typ] = self.Value
				end
				return d
			end
			sm(newChannel,{ID = newChannel.ID, Value = newChannel.Value, Type = newChannel.Type, Objects = newChannel[1]})
			return newChannel
		end;
		getChannel = function(ID)
			for i,v in pairs(BCh)do
				if i == ID then
					return v
				elseif v.ID == ID then
					return v
				end
			end
			return error'No channel with the ID: '..ID..' found.'
		end;
		getChannelType = function(ID)
			return BSync.getChannel(ID).Type
		end;
		channelAddObject = function(ch,obj,prop,...)
			local typ = BSync.getChannelType(ch.ID)
			if type(ch) == 'string' then ch = BSync.getChannel(ch) end
			if type(obj) == 'table' then
				for i,v in pairs(obj)do
					BSync.channelAddObject(ch,v,prop,...)
				end
				return ch
			end
			if not ch[1][obj] then
				ch[1][obj] = {}
			end
			local val = {...}
			if #val == 1 then
				val = val[1]
			end
			if typ ~= 'Function' then
				prop = Shortcuts[prop]
				if type(prop) == 'table' then
					for i,v in pairs(prop)do
						BSync.channelAddObject(ch,obj,v,val)
					end
					return ch
				end
				ch[1][obj][prop] = val
			else
				ch[1][obj] = val
			end
			ch:Sync()
			sm(ch[1][obj],{ID = Misc.tableCount(ch[1])})
			return ch[1][obj]
		end;
		channelRemoveObject = function(ch,obj)
			if type(ch) == 'string' then ch = BSync.getChannel(ch) end
			if type(obj) == 'table' then
				for i,v in pairs(obj)do
					BSync.channelRemoveObject(ch,v)
				end
				return ch
			end
			ch[1][obj] = nil
		end;
		SyncAll = function()
			for i,v in pairs(BCh)do
				v:Sync()
			end
		end;
		channelRemoveObjectProperty = function(ch,obj,prop)
			if type(ch) == 'string' then ch = BSync.getChannel(ch) end
			if type(obj) == 'table' then
				for i,v in pairs(obj)do
					BSync.channelRemoveObjectProperty(ch,v,prop)
				end
				return ch
			end
			if type(prop) == 'table' then
				for i,v in pairs(prop)do
					BSync.channelRemoveObjectProperty(ch,obj,v)
				end
				return ch
			end
			if ch[1][obj] and ch[1][obj][prop] then
				ch[1][obj][prop] = nil
			end
		end;
		channelEditValue = function(ch,...)
			local val
			local args = {...}
			if args[1] == 'Default' and #args == 1 then
				args = ch:getDefault('Value')
			end
			if args[1] == 'Get' and #args == 1 then
				args = ch.Value
			end
			if type(args) == 'table' then
				for i,v in pairs(args)do
					if v == 'Default' or v == 'dt' then
						args[i] = ch:getDefault('Value')[i]
					elseif v == 'Get' or v == 'gt' then
						args[i] = ch.Value[i]
					end
				end
			end
			ch.Value = args
		end;
	};
	Customs = {
		newCustomInstance = function(self,who,what,...)
			local new = {who}
			new.functions = {...}
			Create.Customs[what] = new
			return new
		end;
	};
	Icon = {
		Icons = {};
		insertIcons = function(who,image,sx,sy,how)
			for i,v in pairs(who)do
				if type(v) == 'table' and type(v[1]) == 'number' then
					who = bIcon.newIconFilter(who,i,v[1])
				end
			end
			for i,v in pairs(who)do
				if type(v) == 'table' then
					who[i] = nil
				end
			end
			who = Icon.insertIcons(who,image,sx,sy,how,'true')
			--who = bIcon.filterIconNames(who)
			return who
		end;
		newIconFilter = function(who,index,id)
			if not id then id = #who else id = id - 2 end
			local tab = who
			local ind = ''
			local int = {}
			if index and type(index) == 'table' then
				for i,v in pairs(index)do
					who = who[v]
					ind = ind..v..'_'
				end
				int = index
			elseif index then
				who = who[index]
				ind = index..'_'
				int = {index}
			end
			for i,v in pairs(who)do
				if type(v) == 'table' then
					table.insert(int,i)
					bIcon.newIconFilter(tab,int,v[1])
				elseif type(v) == 'string' then
					table.insert(tab,id+i,ind..v)
				end
			end
			return tab
		end;
		filterIconNames = function(who)
			local insert = {}
			local insertFull = {}
			filter = function(str,par,index)
				local s,sub
				if type(str) == 'table' and not par then par = str end
				if type(str) == 'table' then
					for i,v in pairs(str)do
						if type(v) == 'table' then
							if index ~= i then
								i = index..'_'..i
							end
							filter(v,str,i)
						else
							local st = index:lower()..'_'..v
							str[i] = nil
							filter(st)
						end
					end
					return str
				end
				if str:find'_' then
					s = str:sub(1,str:find'_'-1)
					sub = str:sub(str:find'_'+1)
					if not sub:find'_' then
						if #s <= 1 then
							s = ''
						else
							s = s:sub(1,1):upper()..s:sub(2)..'_'
						end
						table.insert(insertFull,s..sub:lower())
					end
					if par then
						if not par[s:sub(1,1):upper()..s:sub(2)] then
							par[s:sub(1,1):upper()..s:sub(2)] = {}
						end
						if sub:find'_' then
							filter(sub,par[s:sub(1,1):upper()..s:sub(2)])
						else
							table.insert(par[s:sub(1,1):upper()..s:sub(2)],sub:lower())
						end			
					else
						if not insert[s:sub(1,1):upper()..s:sub(2)] then
							insert[s:sub(1,1):upper()..s:sub(2)] = {}
						end
						if sub:find'_' then
							filter(sub,insert[s:sub(1,1):upper()..s:sub(2)])
						else
							table.insert(insert[s:sub(1,1):upper()..s:sub(2)],sub:lower())
						end			
					end
				else
					s = str
					sub = s
					if par then
						table.insert(par,sub:lower())
					else
						table.insert(insert,sub:lower())
					end
				end
			end
			who = {i = {who}}
			for i,v in pairs(who)do
				filter(v,nil,i)
			end
			return {list = insert,full = insertFull}
		end;
		};
	EditTable = {
		Count = function(tab)
			local tab = Misc.tableToID(tab)
			return #tab
		end;
		toInt = function(who)
			local new = {}
			local id = 1
			for i,v in pairs(who)do
				new[id] = v
				id = id + 1
			end
			return new
		end;
		Reverse = function(tab)
			local ret = {}
			for i,v in pairs(tab)do
				ret[#tab+1-i] = v
			end
			return ret
		end;
		Clone = function(tab)
			local clone = {}
			for i,v in pairs(tab)do
				if type(v) ~= 'table' then
					clone[i] = v
				else
					clone[i] = Misc.tableClone(v)
				end
			end
			return clone
		end;
		Find = function(tab,fo)
			for i,v in pairs(tab)do
				if v == fo or i == fo then
					return v
				end
			end
			return nil
		end;
		Search = function(tab,fo)
			table.insert(tab,1,Misc.tableMerge(tab,{}))
			tab = sm(tab,metaFind)
			return tab(fo)
		end;
		Merge = function(who,what)
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
		end;
	};
	Metatables = {
		Find = {
			__call = function(self,i)
				if type(i) == 'string' then
					for _,v in pairs(self[1])do
						if v == self[i] then
							return true
						end
					end
					return false
				else
					return false
				end
				
			end;
			__index = function(self,i)
				local tab,tex = {},''
					for z,v in pairs(self)do
						if type(v) == 'string' then
							if i == v then
								return v
							end
						end
					end
					for z,v in pairs(self)do
						if type(v) == 'string' then
							if v:sub(1,1):lower() == i:sub(1,1):lower()then
								for w in v:gmatch('%u')do
									table.insert(tab,w)
								end
								for _,e in pairs(tab)do
									tex = tex..e
								end
								if i:lower() == tex:lower() then
									return v
								elseif v:sub(1,#i):lower() == i:lower() then
									return v
								else
									tex = ''
									tab = {}
								end
							end
						end
					end
				return i
			end;
		};
		Find2 = {
			__call = function(self,i)
				if self[i] then
					return true
				end
				return false
			end;
			__index = function(self,ind)
				for i,v in pairs(self)do
					if i:sub(1,#ind):lower() == ind then
						return v
					elseif i == ind and type(i) ~= 'number' then
						return v
					end
				end
				return false
			end
		};
		ClassFind = {
			__index = function(self,is)
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
			end
		};
	};
	newEvent = function(who,fire)
		local create = Lusch.Instances.newInstance
		local typ
		if not fire then fire = function() print("") end end
		if type(who) == 'boolean' then
			typ = 'Bool'
		elseif type(who) == 'string' then
			typ = 'String'
		elseif typeof(who) == 'Color3' then
			typ = 'Color3'
		elseif type(who) == 'number' then
			typ = 'Number'
		elseif type(who)=='table' or typeof(who) == 'Instance' then
			typ = 'Object'
		end
		if type(who)=='table' then who = who[1] end
		local val = create(typ..'Value',nil,{val = who})
		local event = sm({Fire = fire},{
			__index = function(self,i)
				if i:lower() == ("Value"):sub(1,#i):lower() then
					return val.Value
				elseif i:lower() == ("Event"):sub(1,#i):lower() or  i:lower() == ("Fired"):sub(1,#i):lower() then
					return self.Fire
				end
			end;
			__newindex = function(self,i,v)
				if self[i] == self.Fire then
					val.Changed:connect(v)
					rawset(self,'Fire',v)
				else
					val.Value = v
				end
				
			end
		})
		val.Changed:connect(event.Fire)
		return event
	end;
	ExternalRipple = function(who,how,howfast,color,...)
		local typ
		if not howfast then howfast = .3 end
		who = Create.setProperties(who:Clone(),{par = who,ap = Vector2.new(.5,.5),pos = UD.pos('Center'),bypass = true})
		who.ZIndex = who.ZIndex - 1
		if who.ClassName:sub(1,5) == 'Image' then
			typ = 'it'
			if not color then color = who.ImageColor3 end
			Create.setProperties(who,{ic = color})
		elseif who.ClassName:sub(1,4) == 'Text' then
			typ = {'bt','tt'}
			if not color then color = who.TextColor3 end
			Create.setProperties(who,{tc = color})
		else
			typ = 'bt'
			if not color then color = who.BackgroundColor3 end
			Create.setProperties(who,{bc = color})
		end
		how = UD.new(how*who.AbsoluteSize.X,how*who.AbsoluteSize.Y,'o')
		Tweening.tweenGuiObject(who,'siz',how,howfast,...)
		Tweening.tween(who,typ,1,howfast)
		coroutine.wrap(function()
			wait(howfast)
			who:Destroy()
		end)()
	end;
	Create = function(who,parent,...)
		local new
		if Create.Classes(who) then
			local class = Create.Classes[who]
			local args = {...}
			local prop = {}
			if type(args[#args]) == 'table' then
				prop = args[#args]
				args[#args] = nil
			end
			new = class.onCreate(unpack(args))
			for i,v in pairs(prop)do
				i = Lusch.Shortcuts[i]
				if Create.Functions[new.ClassName] and Create.Functions[new.ClassName][i] and Create.Functions[new.ClassName][i] ~= i then
					local f = Create.Functions[new.ClassName][i]
					if type(v) == 'table' then
						f(new,unpack(v))
					else
						f(new,v)
					end
				elseif Create.Functions['All'] and Create.Functions.All[i] and Create.Functions.All[i] ~= i then
					local f = Create.Functions['All'][i]
					if type(v) == 'table' then
						f(new,unpack(v))
					else
						f(new,v)
					end				
				else
					new[i] = v
				end
			end
			new.Parent = parent
		else
			new = Create.newInstance(who,parent,...)
		end
		return new
	end;
})
table.insert(Shortcuts,1,Misc.tableMerge(Shortcuts,{}))
--															  					 вy:v4rx
