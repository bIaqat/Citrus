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
sm = setmetatable
gm = getmetatable
metaFind2 = {
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
}
metaFind = {
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
}
--Hey what's up guys, MineCarter27 here! Today wer are going to be playing some more minecraft!!!1!1...
--Maybe Module arguement order  (who,what,when,where,why,how,howfast,...)
Lusch = {};
BETA = {};

sm(Lusch,BETA)
Lusch.Shortcuts = {
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
}

--SHORTCUTS
local Shortcuts = Lusch.Shortcuts

sm(Lusch.Shortcuts,metaFind)


--INSTANCES
Lusch.Instances = {}
local Create = Lusch.Instances
Create.Functions = {}
BETA.Customs = {}

--[[
{
	Frame = {
		Shadow = function(who,...)
		Drag = function(who,...)
	}
}
]]
--Module arguement order  (who,type,where,how/,/howfast,what,why,...)
function Create.Functions:newCustomProperty(who,where,what,...)
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
end

--Create.Customs:newCustomInstance
function BETA.Customs:newCustomInstance(who,what,...)
	local new = {who}
	new.functions = {...}
	Create.Customs[what] = new
	return new
end
function Create.toTheme(who,typ,where,what)
	Theme.insertGuiObject(who,typ,where,what)
	if not what then what = 1 end
	who[Shortcuts[typ]] = Theme.getTheme(where,what)
end
Create.Classes = {}
sm(Create.Classes,metaFind2)
function Create.newClass(who,what)
	local class = {onCreate = what}
	if Create.Classes[who] and Create.Classes[who] == who then
		return error(who..' is an already established class.')
	else
		Create.Classes[who] = class
	end
end

function BETA.Create(who,parent,...)
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
end

function Create.newInstance(who,where,how)
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
end
function Create.setProperties(who,how)
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
end
function Create.createObject(who,where,obj,prop)
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
end



--POSITION
Lusch.Position = {}
Position = Lusch.Position

--TWEENING
Position.Tweening = {}
Tweening = Position.Tweening
function Tweening.tweenGuiObject(who,typ,where,...)
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
end
--Module arguement order  (who,type,where,how/,/howfast,what,why,...)
function Tweening.Rotate(who,where,when)
	Tweening.tween(who,'Rotation',where,when)
end;
function Tweening.tween(who,typ,how,howfast)
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
end
--Tweening.ExternalRipple(
function BETA.ExternalRipple(who,how,howfast,color,...)
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
end
--MISSING ENTER, LEAVE, POP

--UDIM FUNCTIONS
Position.UDim = {}
UD = Position.UDim
function UD.new(a,b,c,d)
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
end
function UD.pos(a,b,c,d)
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
function UD.Offset(a,b)
	a,b = a or 0,b or 0
	return UDim2.new(0,a,0,b)
end
function UD.Scale(a,b)
	a,b = a or 0,b or 0
	return UDim2.new(a,0,b,0)
end
function UD.X(a,b)
	if type(a) == 'table' then
		return UD.X(a[1],a[2])
	end
	return UDim2.new(a,b,0,0)
end
function UD.Y(a,b)
	if type(a) == 'table' then
		return UD.Y(a[1],a[2])
	end
	return UDim2.new(0,0,a,b)
end
--MISSING OFFSET, SCALE, UDPOS


--COLOR
Lusch.Color = {}
Color = Lusch.Color

function Color.fromHex(hex)
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
end
function Color.toHex(a,b,c,d)
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
end
function Color.fromHSV(h,s,v)
	return Color3.fromHSV(h/360,s*.01,v/100)
end
function Color.toHSV(color)
	local h,s,v = Color3.toHSV(color)
	return {h*360,s*100,v*100}
end
function Color.fromRGB(r,g,b)
	return Color3.fromRGB(r,g,b)
end
function Color.toRGB(color)
	return {round(color.r*255),round(color.g*255),round(color.b*255)}
end
function Color.new(who,typ,...)
	if not typ then typ = 1 end
	local set = Colors:getColorSet(who,'Default',...)
	return set[typ]
end
function Color.getColor(who,typ,...)
	if not typ then typ = 1 end
	local set = Colors:getColorSet(who,...)
	return set[typ]
end

function Color.newKeyframes(...)
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
end


--[[
{
	COLORNAME = {
		THEME = {
			SUBNAME = {
				COLOR;
				{COLOR,ALT};
			}
			COLOR;
			{COLOR,ALT};
		}
	}
}
]]
--COLORS
Color.Colours = {};
Colors = Color.Colours
sm(Colors,metaFind)
--Module arguement order  (who,type,towhat,where,how/,/howfast,what,why,...)
function Colors:insertNewColor(who,set)
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
end

function Colors:insertColorSet(who,where,set)
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
end

function Colors:getColorSet(who,typ,...)
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
end

--MISSING COLOURS

--SYNCHRONOUS
Lusch.Synchronous = {}
Sync = Lusch.Synchronous


--{ 1{ID = 'Example', Val = 1, {OBJECTS}}, 2ETC}
Sync.Channels = {}
Channels = Sync.Channels
sm(Sync,{
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
})
function Sync:insertNewChannel(who,towhat,...)
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
end
function Sync:deleteChannel(who)
	local who = gm(Sync:findChannel(who)).ID
	Channels[who] = nil
end
function Sync:resetChannel(who)
	local who = Sync:findChannel(who)
	local dwho = gm(who)
	who.ID = dwho.ID
	who.Value = dwho.DefaultValue
	who[1] = dwho.DefaultObjects
end
function Sync.removeChannelObject(who,where,...)
	local where = Sync:findChannel(where)[1]
	if ... then
		where[who][...] = nil
	else
		where[who] = nil
	end
end
function Sync.editChannelValue(who,towhat)
	local who = Sync:findChannel(who)
	if type(towhat) == type(who.Value) then
		who.Value = towhat
		who:Sync()
	else
		return error('This error is for ',type(who.Value),' values ONLY!')
	end
end
function Sync:findChannel(who)
	for i,v in pairs(Channels)do
		if v.ID == who and type(who) == 'string' then
			return v
		elseif i == who then
			return v
		end
	end
	return error'No channel with the ID or Name of '..who..' was found.'
end
function Sync.channelAddObject(who,where,...)
	local to = Sync:findChannel(where)
	local obj,val = to[1],to.Value
	if not obj[who] then obj[who] = {} end
	if who[Shortcuts[...]] then
		obj[who][Shortcuts[...]] = val
		who[Shortcuts[...]] = val
	end
	return to
end
function Sync:insertAnonChannel(...)
	return self:insertNewChannel(tostring(round((#Channels*math.exp(#Channels)^#Channels)*1000)),...)
end

BETA.Sync = {}
BSync = BETA.Sync
BSync.Channels = {}
BCh = BSync.Channels
--[[
Channel = {
	ID = 'String'
	Type = 'Value'
	Value = Val
	{
		GuiObject = {
			Property = Val
		};
	}
}

]]
function BSync.insertNewChannel(ID,Value,Type)
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
end
function BSync.getChannel(ID)
	for i,v in pairs(BCh)do
		if i == ID then
			return v
		elseif v.ID == ID then
			return v
		end
	end
	return error'No channel with the ID: '..ID..' found.'
end
function BSync.getChannelType(ID)
	return BSync.getChannel(ID).Type
end
function BSync.channelAddObject(ch,obj,prop,...)
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
end
function BSync.channelRemoveObject(ch,obj)
	if type(ch) == 'string' then ch = BSync.getChannel(ch) end
	if type(obj) == 'table' then
		for i,v in pairs(obj)do
			BSync.channelRemoveObject(ch,v)
		end
		return ch
	end
	ch[1][obj] = nil
end
function BSync.SyncAll()
	for i,v in pairs(BCh)do
		v:Sync()
	end
end
function BSync.channelRemoveObjectProperty(ch,obj,prop)
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
end
function BSync.channelEditValue(ch,...)
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
end

--THEMING
Sync.Theming = {}
Theme = Sync.Theming
Theme.Theme = {};
sm(Theme.Theme,metaFind)
-- {Primary = {Colors = {set},Alt = {Alt = {set},set}}}
--Module arguement order  (who,type,where,how/,/howfast,what,why,...)
function Theme:insertThemeSet(who,where,set)
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
end
function Theme:insertNewTheme(who,typ,...)
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
end
function Theme:getThemeSet(who,...)
	if Theme.Theme[who] == who and type(who) == 'string' then
		return error('Theme: '..who.." doesn't exist.")
	end
	local args,get = {...},Theme.Theme[who]
	if not args[1] then args[1] = 'Colors' end
	for i,v in pairs(args)do
		get = get[v]
	end
	return get
end
function Theme.insertThemes(...)
	for _,v in pairs({...})do
		local args = {}
		for i = 3,#(v),1 do
			table.insert(args,(v)[i])
		end
		Theme:insertNewTheme((v)[1],(v)[2],unpack(args))
	end
end
function Theme.setTheme(who,what)
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
end
function Theme.insertGuiObject(who,typ,what,typ2)
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
end
function Theme:SYNC(typ)
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
end
function Theme.getTheme(who,typ)
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
end


--ICONOGRAPHY
BETA.Icon = {}
bIcon = BETA.Icon
bIcon.Icons = {}
--[[
{
	Action = {
		'3d rotation','account_balance wallet','account_box','add shopping cart','alarm_off','all out';
		'accessibility','account_balance','alarm_add','alarm_on','alarm_alarm','andriod';
		'accessible','announcement','aspect ratio','assessment','assignment_ind','assignment_late';
		'account_circle','assignment_return','assignment_returned','assignment_turned in','assignment_assignment','autorenew';
	};
};
--]]
function bIcon.insertIcons(who,image,sx,sy,how)
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
end
function bIcon.newIconFilter(who,index,id)
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
end
function bIcon.filterIconNames(who)
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
end


Lusch.Iconography = {}
Icon = Lusch.Iconography
Icon.Icons = {}
function Icon.insertIcons(who,image,getx,gety,how,beta) 
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
end 
function Icon.getIconInfo(who,typ)
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
end 
function Icon:isIcon(who,what)
	who = Icon.getIconInfo(who)
	what = Icon.getIconInfo(what)
	for i = 1,3,1 do
		if who[i] ~= what[i] then
			return false
		end
	end
	return true
end	

--MISC
Lusch.Miscellaneous = {}
Misc = Lusch.Miscellaneous
function Misc.round(num)
	return math.floor(num+.5)
end
round = Misc.round
BETA.EditTable = {}
local et = BETA.EditTable
function Misc.tableReverse(tab)
	local ret = {}
	for i,v in pairs(tab)do
		ret[#tab+1-i] = v
	end
	return ret
end
et.Reverse = Misc.tableReverse
function Misc.tableClone(tab)
	local clone = {}
	for i,v in pairs(tab)do
		if type(v) ~= 'table' then
			clone[i] = v
		else
			clone[i] = Misc.tableClone(v)
		end
	end
	return clone
end
et.Clone = Misc.tableClone
function Misc.tableFind(tab,fo)
	for i,v in pairs(tab)do
		if v == fo or i == fo then
			return v
		end
	end
	return nil
end
et.Find = Misc.tableFind
function Misc.tableSearch(tab,fo)
	table.insert(tab,1,Misc.tableMerge(tab,{}))
	tab = sm(tab,metaFind)
	return tab(fo)
end
et.Search = Misc.tableSearch
function Misc.tableMerge(who,what)
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
et.Merge = Misc.tableMerge
Misc.CatalogApi = {}
function Misc.CatalogApi.fromLink(who,typ)
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
end
--Search API?
function Misc.getPlayer(speaker,...)
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
end
function Misc.tableToID(who)
	local new = {}
	local id = 1
	for i,v in pairs(who)do
		new[id] = v
		id = id + 1
	end
	return new
end	
et.toInt = Misc.tableToID
function Misc.stringColor(pName)
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
end
function Misc.getDropbox(link,par)
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
end
table.insert(Shortcuts,1,Misc.tableMerge(Shortcuts,{}))
Lusch.req = function()
	wait()
	for i,v in pairs(script:GetChildren())do
		if v.ClassName == 'ModuleScript' then
			require(v)	
		end
		v:Destroy()
	end
	return Lusch
end

function Misc.tableCount(tab)
	local tab = Misc.tableToID(tab)
	return #tab
end
et.Count = Misc.tableCount
metaClassFind = {__index = function(self,is)
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
	end}
Lusch.get = {}
BETA.newEvent = function(who,fire)
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
end
BETA.Metatables = {}
local bm = BETA.Metatables
bm.Find = metaFind
bm.ClassFind = metaClassFind
bm.Find2 = metaFind2
local lush = Lusch

sm = setmetatable
gm = getmetatable
Shortcuts = lush.Shortcuts
Instances = lush.Instances
Tweening = lush.Position.Tweening
UD = lush.Position.UDim
Color = lush.Color
Colours = Color.Colours
Sync = lush.Synchronous
bSync = gm(lush).Sync
Icon = lush.Iconography
bIcon = gm(lush).Icon
Misc = lush.Miscellaneous
Metas = gm(lush).Metatables
tableEdit = gm(lush).EditTable
local create = Instances.newInstance
local set = Instances.setProperties
local create2 = Instances.createObject
	createObj = create2
local tween = Tweening.tweenGuiObject
local rotate = Tweening.Rotate
local lerp = Tweening.tween
local pop = gm(lush).ExternalRipple
local toPos = UD.pos
local ud = UD.new
local v2 = Vector2.new
local hsv = Color.fromHSV
local rgb = Color.fromRGB
local hex = Color.fromHex
local newKey = Color.newKeyframes
local Theme = {}
Theme.New = Sync.Theming.insertThemes
Theme.Set = Sync.Theming.setTheme
Theme.Get = Sync.Theming.getTheme
local toTheme = Instances.toTheme
local icons = Icon.icons
local round = Misc.round
local ET = tableEdit
local create3 = gm(lush).Create
local newClass = Instances.newClass
local newEvent = gm(lush).newEvent

newClass("Circle",function(siz,typ)
	local circle
	if typ then
		circle = create("ImageButton")
	else
		circle = create("ImageLabel")
	end
	set(circle,{im = 'rbxassetid://550829430',bt = 1,siz = ud(siz,'o')})
	return circle
end)

f = lush.Color.Colours
c = lush.Color.new
h = lush.Color.fromHex
hsv = lush.Color.fromHSV
f:insertNewColor('Red',{
	Material = {
		[0] = h'#ffebee';
		{h'#ffcdd2',h'#ff8a80'};
		{h'#ef9a9a',h'#ff5252'};
		h'#e57373';
		{h'#ef5350',h'#ff1744'};
		h'#f44336';
		h'#e53935';
		{h'#d32f2f',h'#d50000'};
		h'#c62828';
		h'#b71c1c';
	}
}
)
f:insertNewColor('Pink',{
	Material = {
		[0] = h'#FCE4EC';
		{h'#F8BBD0',h'#FF80AB'};
		{h'#F48FB1',h'#FF4081'};
		h'#F06292';
		{h'#E91E63',h'#F50057'};
		h'#EC407A';
		h'#D81B60';
		{h'#C2185B',h'#C51162'};
		h'#AD1457';
		h'#880E4F';
	}
}
)
f:insertNewColor('Purple',{
	Material = {
		[0] = h'#F3E5F5';
		{h'#E1BEE7',h'#EA80FC'};
		{h'#CE93D8',h'#E040FB'};
		h'#BA68C8';
		{h'#AB47BC',h'#D500F9'};
		h'#9C27B0';
		h'#8E24AA';
		{h'#7B1FA2',h'#AA00FF'};
		h'#6A1B9A';
		h'#4A148C';
		Deep = {
			[0] = h'#EDE7F6';
			{h'#D1C4E9',h'#B388FF'};
			{h'#B39DDB',h'#7C4DFF'};
			h'#9575CD';
			{h'#7E57C2',h'#651FFF'};
			h'#673AB7';
			h'#5E35B1';
			{h'#512DA8',h'#6200EA'};
			h'#4527A0';
			h'#311B92';			
		}
	}
}
)

f:insertNewColor('Grey',{
	Default = {
		Light = {
			[0] = hsv(0,0,98);
			[1] = hsv(0,0,96);
			[2] = hsv(0,0,87);
			[3] = hsv(0,0,80)			
		};
		Blue = {
			[0] = hsv(219,21,36);
			[1] = hsv(219,25,34);
			[2] = hsv(220,25,27);
			[3] = hsv(218,25,21)		
		};
		Dark = {
			[0] = hsv(0,0,25);
			[1] = hsv(0,0,21);
			[2] = hsv(0,0,12);
			[3] = hsv(0,0,2);	
		};
		[0] = hsv(220,10,32);
		[1] = hsv(213,12,27);
		[2] = hsv(217,12,24);
		[3] = hsv(220,12,18);		
	};
})

f:insertNewColor('Themes',{
	Default = {
		Dark = {
			c('Grey',3),c('Grey',2),c('Grey',1),c('Grey',0);
			Grey = {c('Grey',3,'Dark'),c('Grey',2,'Dark'),c('Grey',1,'Dark'),c('Grey',0,'Dark')};
			Blue = {c('Grey',3,'Blue'),c('Grey',2,'Blue'),c('Grey',1,'Blue'),c('Grey',0,'Blue')};
		};
		Light = {
			c('Grey',0,'Light'),c('Grey',1,'Light'),c('Grey',2,'Light'),c('Grey',3,'Light')
		};
	};
})
f = lush.Instances.Functions
--Theming
f:newCustomProperty("DynamicColor3",'All',function(who,new,typ)
	local tipe
	if who.ClassName:find'Image' then
		tipe = 'Image'
	elseif typ then
		tipe = lush.Shortcuts[typ]:sub(1,lush.Shortcuts[typ]:find'Color3'-1)
	else
		tipe = 'Background'
	end
	if type(new) == 'string' then
		lush.Instances.toTheme(who,tipe..'Color3',new)
	else
		who[tipe..'Color3'] = new
	end
end,true)
f:newCustomProperty("DynamicTransparency",'All',function(who,new,typ)
	local tipe
	if who.ClassName:find'Image' then
		tipe = 'Image'
	elseif typ then
		tipe = lush.Shortcuts[typ]:sub(1,lush.Shortcuts[typ]:find'Transparency'-1)
	else
		tipe = 'Background'
	end
	who[tipe..'Transparency'] = new
end,true)
f:newCustomProperty('BackgroundColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'bc',typ,what)
	else
		who.BackgroundColor3 = typ
	end
end)
f:newCustomProperty('BorderColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'borderc',typ,what)
	else
		who.BorderColor3 = typ
	end
end)
f:newCustomProperty('TextColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'tc',typ,what)
	else
		who.TextColor3 = typ
	end
end)
f:newCustomProperty('ImageColor3','All',function(who,typ,what)
	if type(typ) == 'string' then
		lush.Instances.toTheme(who,'ic',typ,what)
	else
		who.ImageColor3 = typ
	end
end)
f:newCustomProperty('Image',{'ImageLabel','ImageButton'},function(who,typ)
	if type(typ) == 'userdata' then
		local icon = lush.Iconography.getIconInfo(typ)
		lush.Instances.setProperties(who,{image = icon[1],iro = icon[2],irs = icon[3]})	
	elseif not typ:find('rbxassetid') or type(typ) == 'number' then
		who.Image = "rbxassetid://"..typ
	else
		who.Image = typ	
	end		
end)
f:newCustomProperty('Image','ScrollingFrame',function(who,image)
	image = 'rbxassetid://'..image
	lush.Instances.setProperties(who,{ti = image,bi = image,mi = image})
end)
f:newCustomProperty('Ripple',{'TextButton','ImageButton'},function(who,trans,typ)
	if trans and type(trans) == 'string' or type(trans) == 'userdata' then 
		local ty = trans 
		trans = typ 
		typ = ty 
	end
	local Button = who	
	Button.ClipsDescendants = true
	Button.AutoButtonColor = false
	
	Button.MouseButton1Click:connect(function()
		coroutine.resume(coroutine.create(function()
			if trans and trans == true then trans = .9 end
			local Circle = lush.Instances.newInstance('ImageLabel',Button,{name = 'Circle',ic = Color3.new(0,0,0),bt = 1,z = 10,ima = 'rbxassetid://550829430',it = .9})	
			if trans then Circle.ImageTransparency = trans end
			if typ then 
				lush.Instances.setProperties(Circle,{ic = typ})
			elseif lush.Color.toHSV(who.BackgroundColor3)[3] < 25 then
				 Circle.ImageColor3 = Color3.new(1,1,1)
			else
				Circle.ImageColor3 = Color3.new(0,0,0)
			end
			local m = game.Players.LocalPlayer:GetMouse()
			--rbxassetid://550829430 'rbxassetid://266543268'
			local NewX = m.X - Circle.AbsolutePosition.X
			local NewY = m.Y - Circle.AbsolutePosition.Y
			Circle.Position = UDim2.new(0,NewX,0,NewY)
			local Size = 0
			if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.X*1.5
			elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.Y*1.5
			elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																																																																														
				Size = Button.AbsoluteSize.X*1.5
			end							
			local Time = Circle.ImageTransparency/1.8
			lush.Position.Tweening.tweenGuiObject(Circle,'both',UDim2.new(.5,-Size/2,.5,-Size/2),UDim2.new(0,Size,0,Size),Time,'Out','Quad')
			repeat
				Circle.ImageTransparency = Circle.ImageTransparency + Time/(Time*10)^2
				wait(Time/10)
			until Circle.ImageTransparency >= 1
			Circle:Destroy()
		end))
	end)
end)

f:newCustomProperty('Shadow','All',function(who,typ,typ2)
	local many,siz = 1,7
	if typ then 
		if type(typ) == 'number' then many = typ
		elseif type(typ) == 'table' then many,siz = typ[1],typ[2]
		elseif typ == 'hover' then typ2 = true
		end 
	end
	local shadow = lush.Instances.newInstance('ImageLabel',nil,{n = 'Shadow',Rotation = 0.0001,Position = UDim2.new(0,0,1,0),Size = UDim2.new(1,0,0,siz),Image = 'rbxasset://textures/ui/TopBar/dropshadow@2x.png',BackgroundTransparency = 1})
	local fol = Instance.new'Folder'
	for i = 1,many,1 do
		lush.Instances.setProperties(shadow:Clone(),{parent = fol})
	end
	fol.Parent = who
	if typ2 and typ2 == true then
		for i,v in pairs(fol:GetChildren())do
			v.Size = UDim2.new(1,0,0,1)
		end	
		who.MouseEnter:connect(function()
			for i,v in pairs(fol:GetChildren())do
				lush.Position.Tweening.tweenGuiObject(v,'size',UDim2.new(1,0,0,7),.1)
			end
		end)
		who.MouseLeave:connect(function()
			for i,v in pairs(fol:GetChildren())do
				lush.Position.Tweening.tweenGuiObject(v,'size',UDim2.new(1,0,0,1),.1)
			end
		end)			
	end
end)
f:newCustomProperty('TableLayout','All',function(who,...)
	lush.Instances.newInstance('UITableLayout',who,...)
end)
f:newCustomProperty('TextConstraint','All',function(who,...)
	lush.Instances.newInstance('UITextSizeConstraint',who,...)
end)
f:newCustomProperty('SizeConstraint','All',function(who,...)
	lush.Instances.newInstance('UISizeConstraint',who,...)
end)
f:newCustomProperty('AspectRatio','All',function(who,...)
	lush.Instances.newInstance('UIAspectRatioConstraint',who,...)
end)
f:newCustomProperty('Draggable','All',function(who)
	who.Active = true
	who.Draggable = true
end)
f:newCustomProperty('List','All',function(who,...)
	lush.Instances.newInstance('UIListLayout',who,...)
end)
f:newCustomProperty('Grid','All',function(who,...)
	lush.Instances.newInstance('UIGridLayout',who,...)
end)
f:newCustomProperty('Page','All',function(who,...)
	lush.Instances.newInstance('UIPageLayout',who,...)
end)
f:newCustomProperty('Spacing','All',function(who,...)
	lush.Instances.newInstance('UIPadding',who,...)
end)
f:newCustomProperty('Pop','All',function(who,siz,...)
	local args = {...}
	return error('Sorry Pop has been removed from lush temporarily')
	--spawn(function()
		--lush.Position.Tweening.ExternalRipple(who,siz,unpack(args))
	--end)
end)
f:newCustomProperty('BypassClip','All',function(who)
	who.Rotation = .0001
end,true)











local version = 1.5
local beta = getmetatable(lush)
--															  			                		 вy:v4rx Rouge
local gm = getmetatable
local sm = setmetatable
--Basic functions
local create = beta.Create -- Citrus version of Instance.new | create(Class,Parent,Properties) or create(Class,Parent,args...,Properties)
local set = lush.Instances.setProperties -- edit the properties of a Class | set(who,Properties)
local rotate = lush.Position.Tweening.Rotate -- self explanitory | rotate(who,ToWhat,Speed)
local tween = lush.Position.Tweening.tweenGuiObject -- Citrus version of Tween gui functions | tween(who,"pos" "size" or "both",UDims...,Speed) 
local pop = beta.ExternalRipple -- does the ripple effect outside of a GuiObject | pop(who,Size (integer),Speed,Color)
local ud = lush.Position.UDim.new --[[ Citrus version of UDim2 functions | ud(XScale,XOffset,YScale,YOffset)
																	| ud(a,"s")				-- [same as] UDim2.new(a,0,a,0)
																	| ud(a,"o") 				-- [same as] UDim2.new(0,a,0,a)
																	| ud(a,b,1) or ud(a,b,"s") 	-- [same as] UDim2.new(a,0,b,0)
																	| ud(a,b,2) or ud(a,b,"o") 	-- [same as] UDim2.new(0,a,0,#2)
																	| ud(a,b,3) 				-- [same as] UDim2.new(a,b,a,#2)
																	| ud(a,b,4) 				-- [same as] UDim2.new(a,0,0,#2)
																	| ud(a,b,5) 				-- [same as] UDim2.new(0,a,b,0)
																	| ud(a,b,c,d)				 -- [same as] UDim2.new(a,b,c,d)																
--]]
local Color = lush.Color 
	local rgb = Color.fromRGB --same as Color3.fromRGB
	local hsv = Color.fromHSV --Citrus version of Color3.fromHSV | hsv(1-360,1-100,1-100)
	local hex = Color.fromHex --gets a color from a hexadecimal | hex'hexadecimal' [EXAMPLE: hex'#FF0000' or hex'FF0000' or hex'#F00' or hex'F00']
local round = lush.Miscellaneous.round --rounds a number to the nearest integer | round(1.6) >> 2

--Semi advanced functions  
local lerp = lush.Position.Tweening.tween -- Citrus version of TweenService functions | lerp(who,Property,ToWhat,Speed)
local fromPos = lush.Position.UDim.pos -- gets a UDim2 from a string position | fromPos(stringPositions...) [EXAMPLE: fromPos("Center") fromPos("Top","Left") fromPos("Middle","Right") fromPos("Top","Middle")]
local Theme = {
	New = lush.Synchronous.Theming.insertThemes; --creates new Themes | Theming.New({ThemeName,ColorSet}) [EXAMPLE: Theming.New({"Primary",rgb(255,0,0)},{"Secondary",{rgb(0,0,0),rgb(255,255,255)})]
	Set = lush.Synchronous.Theming.setTheme; --sets an existing Theming to a new ColorSet | Theming.Set(ThemeName,Color,ColorSetNumber) [Example: Theming.Set("Primary",rgb(0,255,0)) Theming.Set("Secondary",hsv(0,0,12),2) [the 2 would set the 2nd color in the Secondary ColorSet to 2]]
	Get = lush.Synchronous.Theming.getTheme; --gets an existing Theme's ColorSet | Theming.Get(ThemeName,ColorSetNumber) [Exmaple: Theming.Get("Primary",1) [the 1 would return the 1st color in the ColorSet instead of the ColorSet (table)] Theming.Get("Secondary")
	Sync = function() lush.Synchronous.Theming:Sync() end; --Syncs all Themes (useless unless something goes wrong) } Theming.Sync()
	toTheme = lush.Instances.toTheme; --Sets an Object to a Theme | Theming.toTheme(who,Property,ThemeName,ColorSetNumber) [Exmaple: Theming.toTheme(Frame,"BackgroundColor3","Primary",1) or Theming.toTheme(Frame,"bc","Primary") [the default ColorSetNumber is 1] [Properties have shortcuts]
}
local EditTable = beta.EditTable --[[ a table of functions for editing tables 
									Includes:
										tableReverse | Reverses a table | tab = {1,2,3} tableReverse(tab) >> {3,2,1}
										tableClone | Clones a table
										tableFind | Finds something specific in a table | tab2 = {"apples","oranges","eat"} tableFind(tab,"oranges") or tableFind(tab,2) >> "oranges"
										tableSearch | Searches through a table for something similar to a string | tableSearch(tab,"ora") >> "oranges"
										tableMerge | Merges 2 tables together | tableMerge(tab,tab2) >> {3,2,1,"apples",'oranges',"eat"}
--]]

--advancedish?
local newClass = lush.Instances.newClass --creates a new Class that can be used with the create function | newClass(ClassName,function)
local newKeyframes = Color.newKeyframes --Citrus version of Emitter color keyframes for GuiObjects | newKeyframes(colors...) !!! for more info contant me if u need it
local EditColor = { --table of functions to help organize a color pallete
	New = function(...) return Color.Colors:insertNewColor(...) end; --creates a new Color with or without a ColorSet | New(ColorName) new(ColorName,ColorSet)
	Add = function(...) return Color.Colors:insertNewColorSet(...) end; --adds a ColorSet to na existing color | Add(ColorSetName,ColorName,ColorSet)
	Get = function(...) return Color.Colors:getColorSet(...) end; --gets a ColorSet from an existing Color | Get(ColorName,ColorSetName...)
}
local Sync = { --you know how much i love sync functions
	New = function(...) return lush.Synchronous:insertNewChannel(...) end; --creates a Sync Channel | New(ChannelName,ChannelValue,{Object,Properties...}...) [Example: primary = Sync.New("PrimaryColor",rgb(255,0,0)) primary:Insert(Frame,"BackgroundColor3","BorderColor3") or Sync.New("PrimaryColor",rgb(255,0,0),{Frame,"BackgroundColor3","BorderColor3"})
	newAnon = function(...)return  lush.Synchronous:insertAnonChannel(...) end; --creates an anonymous Sync channel so the channel name can not repeat | newAnon(ChannelValue,{Object,Properties...}...)
	Get = function(...) return lush.Synchronous:findChannel(...) end; --gets an existing Channel from the Channel name | Get(ChannelName) [Example: Sync.New("PrimaryColor",rgb(255,0,0)) pimary = Sync.Get("Primary")
	Set = lush.Synchronous.editChannelValue; --sets the value of an existing Channel to a new value | Set(ChannelName,newChannelValue)
	Reset = function(...) return lush.Synchronous:resetChannel(...) end; --Resets every part of a  channel to its initial value (first values and objects you had in it) | Reset(ChannelName)
	Delete = function(...)return  lush.Synchronous:deleteChannel(...) end; --Deletes the channel | Delete(ChannelName)
}
local Icon = { --Iconography is fundamental so why not organize it !!! for more info contant me if u need it
	Icons = lush.Iconography.Icons;
	New = lush.Iconography.insertIcons; --inserts a set of icons from a grid of icons into the Icons table | New(IconNamesSet,ImageId,GridX,GridY,ImageSize)
	Get = lush.Iconography.getIconInfo; --gets an icon's info {OriginalImage, ImageRectOffset, ImageRectSize, otherProperty} | Get(icon) >> {icon.Image,icon.ImageRectOffset,icon.ImageRectSize}
	Equals = function(...) return lush.Iconography:isIcon(...) end; --checks if an icon is the same icon as another | Equals(Icon,Icon2)
}
local Misc = lush.Miscellaneous --Includes things like Dropbox and CatalogApi
 
--kinda hard >:O but not relly
local newProperty = function(...) lush.Instances.Functions:newCustomProperty(...) end --creates a new Property that can be used with the create and set functions | newProperty(Name,ClassesAllowed,function(who) {first argument is always who is effected},AbleToHaveAShortcut (boolean)) [Example: newProperty("toColor","TextButton",function(who,color) who.BackgoundColor3 = color end,true) set(TextButton,{toc = rgb(255,0,0)}) >> TextButton.BackgroundColor3 = Red
local createObject = lush.Instances.createObject --you've heard me rant on create2 :) -- the supiror edit to Instance.new that is made for Object Oriented Programming | create2(Class,Parent,ObjectProperties,Properties) [Example: Frame = createObject("Frame",ScreenGui,{Apples = 'cool'}) print(Frame.Apples) >> "cool"
	local create2 = createObject
local betaSync = { -- new form of SyncChannels (doesnt have anon channels however) with the abilities to have more than one type of value
	New = beta.Sync.insertNewChannel; 
	Get = beta.Sync.getChannel;
	getType = beta.Sync.getChannelType; --gets the ChannelValueType in a Channel | getType(ChannelName or ChannelId)
	Edit = beta.Sync.channelEditValue; -- same as Sync.Set
	Sync = beta.Sync.SyncAll; --syncs all channels | Sync()
}
local betaIcon = { --alternate to Icon still in testing better at organizing and can read different types of organization !!! for more info contant me if u need it
	Icons = beta.Icon.Icons;
	New = beta.Icon.insertIcons;  --inserts a set of icons from a grid of icons into the Icons table | New(IconNamesSet,ImageId,GridX,GridY,ImageSize)
}
local newEvent = beta.newEvent

local v2 = function(a,b)
	if not b then
		return Vector2.new(a,a)
	else
		return Vector2.new(a,b)
	end
end

