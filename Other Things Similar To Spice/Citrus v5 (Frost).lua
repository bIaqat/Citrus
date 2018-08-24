local gm,sm = getmetatable, setmetatable
local Citrus = {}
local Color, Effect, Icon, Create, Misc, Theme, Position, Properties, Settings

--COLOR
Citrus.Color = setmetatable({
		fromRGB = function(r,g,b)
			return Color3.fromRGB(r,g,b)
		end;
		toRGB = function(color)
			local r = Citrus.Misc.Functions.round
			return r(color.r*255),r(color.g*255),r(color.b*255)
		end;
		editRGB = function(color,...)
			local round,op = Citrus.Misc.Functions.round,Citrus.Misc.Functions.operation
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
			local r = Citrus.Misc.Functions.round
			local h,s,v = Color3.toHSV(color)
			return r(h*360),r(s*360),r(v*360)
		end;
		editHSV = function(color,...)
			local round,op = Citrus.Misc.Functions.round,Citrus.Misc.Functions.operation
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
			local r,g,b = Citrus.Color.fromRGB(color)
			r = string.format('%02X',r)
			g = string.format('%02X',g)
			b = string.format('%02X',b)
			return (hash and '#' or '')..tostring(r)..tostring(g)..tostring(b)
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
			local h,s,v = Color.toHSV(color)
			return Color.fromHSV(h,v,s)
		end;
		getInverse = function(color)
			local h,s,v = Color.toHSV(color)
			return Color.fromHSV((h + 180) % 360, v, s)
		end;
		getObjectsOfColor = function(color,directory)
			local objs = {}
			for i,obj in pairs(Citrus.Instance:instanceOf(directory):GetDescendants())do
				for prop, val in pairs(Properties.getProperties(obj))do
					if val == color then
						table.insert(objs,obj)
					end
				end
			end
			return objs
		end;
		
		insertColor = function(name,col,...)
			local index = getmetatable(Citrus.Color).Colors
			for i,v in next,{...} or {} do
				index = index[v]
			end
			if index[name] and type(index[name]) ~= 'table' then
				index[name] = {index[name]}
			end
			if index[name] then
				table.insert(index[name],col)
			else
				index[name] = col
			end			
		end;
		getColor = function(name,id,...)
			local index = getmetatable(Citrus.Color).Colors
			for i,v in next,{...} or {} do
				index = index[v]
			end
			return index[id or next(index)]
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
})
Color = Citrus.Color
local rgb,hsv,hex = Color.fromRGB, Color.fromHSV, Color.fromHex


--EFFECTS
Citrus.Effects = setmetatable({
	--TweenInfo: Time EasingStyle EasingDirection RepeatCount Reverses DelayTime
	--TweenCreate: Instance TweenInfo dictionary
		new = function(name,func)
			getmetatable(Citrus.Effects).Effects[name] = func
		end;
		getEffect = function(name)
			return Citrus.Misc.Table.search(getmetatable(Citrus.Effects).Effects,name)
		end;
		affect = function(who,name,...)
			name = type(name) == 'function' and name or Citrus.Effects.getEffect(name)
			return name(who,...)
		end;
		affectChildren = function(who,name,...)
			for i,v in next,who:GetChildren() do
				Citrus.Effects.affect(v,name,...)
			end
		end;
		affectDescendants = function(who,name,...)
			for i,v in next,who:GetDescendants() do
				Citrus.Effects.affect(v,name,...)
			end
		end;
		massAffect = function(who,name,...)
			local args = {...}
			who.ChildAdded:connect(function(c)
					Citrus.Effects.affect(c,name,args)
				end)
		end;
},
	{
		Effects  = {
			Ripple = function(who,speed,to,ex,prop)
				Citrus.Properties.setProperties(who,prop or {})
				if ex and who.Rotation == 0 then who.Rotation = .001 end
				local typ,size
				if who.ClassName:find'Image' then
					typ = 'Image'
				elseif who.ClassName:find'Text' then
					typ = 'Text'
				else
					typ = 'Background'
				end
				typ = (typ or '')..'Transparency'
				speed = speed or who[typ]/1.8
				local ud = Citrus.Positioning.new
				if Citrus.Properties.hasProperty(who.Parent,'AbsoluteSize') and not to then
					size = Citrus.Misc.Functions.switch(who.Parent.AbsoluteSize.X * 1.5,who.Parent.AbsoluteSize.Y * 1.5)
					size.type = {true,false}
					size = size(who.Parent.AbsoluteSize.X >= who.Parent.AbsoluteSize.Y)
				end
				size = to or size	
				--Citrus.Positioning.tweenObject(who,'size',ud(size,'o'),speed,'Quad','Out')	
				Citrus.Positioning.tweenObject(who,'both',ud(.5,0,3),ud(size,'o'),speed)
				Citrus.Misc.Functions.tweenService(who,typ,1,speed)
				coroutine.wrap(function()
						repeat wait() until who[typ] >= 1
						who:Destroy()
					end)()
			end;
		};
	}
)
Effect = Citrus.Effects
local affect, mass = Effect.affect, Effect.massAffect


--ICONOGRAPHY
Citrus.Iconography = setmetatable({
		new = function(img,xlen,ylen,xgrid,ygrid,names)
			if not names then names = ygrid ygrid = xgrid end
			local count = 1
			for y = 0, ylen-1,1 do
				for x = 0,xlen-1,1 do
					local icon = Instance.new("ImageLabel")
					icon.Image = img
					icon.ImageRectOffset = Vector2.new(x*xgrid,y*ygrid)
					icon.ImageRectSize = Vector2.new(xgrid,ygrid)
					local namefil = Citrus.Misc.Functions.stringFilterOut(names[count] or 'Icon','_',nil,true)
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
		getIcon = function(...)
			local index = getmetatable(Citrus.Iconography).Icons
			for i,v in next,{...} or {} do
				v = v:sub(1,1):upper()..v:sub(2)
				index = index[v]
			end
			return index
		end;		
		
		},{
		Icons = {}
		}
	)
Icon = Citrus.Iconography
local icons, newIcon = getmetatable(Icon), Icon.insertIcon


--INSTANCE
Citrus.Instance = setmetatable({
		newCustomClass = function(name,funct)
			local self = Citrus.Instance
			local pt = Citrus.Misc.Table
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
			if pcall(function() return Instance.new(is):IsA(a) end) then
				return true
			else 
				return false
			end
		end;
		isAClass = function(is)
			if pcall(function() return Instance.new(is) end) then
				return true
			else
				return false
			end
		end;
				
		new = function(class,...)
			local self = Citrus.Instance
			local pt = Citrus.Misc.Table
			local args,storage,new,parent,properties = {...},getmetatable(self).Classes
			if typeof(args[1]) == 'Instance' or self.isObject(args[1]) then
				parent = self.getInstanceOf(args[1])
				table.remove(args,1)
			end
			if type(args[#args]) == 'table' then
				properties = args[#args]
				table.remove(args,#args)
			end
			new = pt.find(storage,class) and pt.find(storage,class)(unpack(args)) or Instance.new(class)
			new.Parent = parent
			Citrus.Properties.setProperties(new,Citrus.Settings.getDefault(class) or {})
			Citrus.Properties.setProperties(new,properties or {})
			return new
		end;
		newInstance = function(class,parent,props)
			local new = Instance.new(class)
			props = props or type(parent) == 'table' and parent
			parent = type(parent) == 'table' and nil or parent
			Citrus.Properties.setProperties(new,Citrus.Settings.getDefault(class) or {})
			return Citrus.Properties.setProperties(Instance.new(class,parent),props or {})
		end;
		newObject = function(class,...)
			local ins = Citrus.Instance
			local pt = Citrus.Misc.Table
			local args,parent,object,properties = {...}
			if typeof(ins.getInstanceOf(args[1])) == 'Instance' then
				parent = ins.getInstanceOf(args[1])
				table.remove(args,1)
			end
			if type(args[#args]) == 'table' then
				if #args == 1 then
					object = args[#args]
					table.remove(args,#args)
				else
					properties = args[#args]
					table.remove(args,#args)
					object = args
				end
			end
			local new = {Instance.new(class)}
			setmetatable(new,{
					Object = object or {};
					Properties = { Index = {}, NewIndex = {} };
					__index = function(self,ind)
						local obj = getmetatable(self).Object
						local prop = getmetatable(self).Properties
						if pt.contains(prop.Index,ind) then
							return pt.find(prop.Index,ind)()
						elseif pt.contains(obj,ind) then
							return pt.find(obj,ind)
						elseif Citrus.Properties.hasProperty(self[1],ind) then
							return self[1][Citrus.Properties[ind]]
						end
					end;
					__newindex = function(self,ind,new)
						local obj = getmetatable(self).Object
						local prop = getmetatable(self).Properties
						if pt.contains(prop.Index,ind) then
							pt.find(prop.Index,ind)(new)
						elseif pt.contains(obj,ind) then
							rawset(obj,ind,new)
						elseif Citrus.Properties.hasProperty(self[1],ind) then
							self[1][Citrus.Properties[ind]] = new
						end
					end;
				})
			function new:Index(name,what)
				local prop = getmetatable(self).Properties
				rawset(prop.Index,name,what)
			end
			function new:NewIndex(name,what)
				local prop = getmetatable(self).Properties
				rawset(prop.NewIndex,name,what)
			end
			function new:Clone(parent)
				local clone = Citrus.Misc.Table.clone(self)
				clone[1] = self[1]:Clone()
				clone[1].Parent = parent
				getmetatable(ins).Objects[clone] = clone[1]
				return clone
			end
			getmetatable(ins).Objects[new] = new[1]
			return new
		end;
		getInstanceOf = function(who)
			local self = getmetatable(Citrus.Instance).Objects
			return Citrus.Misc.Table.find(self,who) or typeof(who) == 'Instance' and who
		end;
		getObjectOf = function(who)
			local self = getmetatable(Citrus.Instance).Objects
			return Citrus.Misc.Table.indexOf(self,who) or typeof(who) == 'Instance' and who
		end;
		isObject = function(who)
			return Citrus.Instance.getObjectOf(who) and true or false
		end;
		getAncestors = function(who)
			local misc = Citrus.Misc
			who = Citrus.Instance.getInstaceOf(who)
			local chain = {game,unpack(misc.Functions.stringFilterOut(who:GetFullName(),'%.',nil,'game',true))}
			chain = misc.Table.reverse(chain)
			table.remove(chain,1)
			return misc.Table.reverse(chain)
		end;
	},{
		Classes = {};
		Objects = {};
	}
)
Create = Citrus.Instance
local isa, newClass = Create.isAClass, Create.newCustomClass
local create, create2, createObj, create3, createNew = Create.new, Create.newObject, Create.newObject, Create.newInstance, Create.newInstance
local objectOf, instanceOf, getAncestors = Create.getObjectOf, Create.getInstanceOf, Create.getAncestors


--THEMING (OLD)
Citrus.Theming = setmetatable({ --almost 100% positive this is 100% BROKEN
		new = function(name,...)
			local args, filter, funct, vals = {}
			local vals = {...}
			if type(vals[1]) == 'table' then
				filter = vals[1]
				table.remove(vals,1)
			end
			for i,v in next,vals do
				if type(v) == 'function' then
					funct = v
					for x = i+1,#vals do
						table.insert(args,vals[x])
						table.remove(vals,x)
					end
					table.remove(vals,i)
					break
				end
			end
			local newTheme
			newTheme = setmetatable({
					Sync = function(self,...)
						Citrus.Theming.syncTheme(name,...)
					end;
					Set = function(self,...)
						Citrus.Theming.setTheme(name,...)
					end;
					Call = function(self,...)
						Citrus.Theming.callTheme(name,...)
					end;
					Insert = function(self,...)
						Citrus.Theming.insertObjects(name,...)
					end;
					Values = vals or {};
					Funct = setmetatable({funct or nil,unpack(args)},{
								__call = function(self,...)
									coroutine.wrap(function(...)
										for i,v in pairs(newTheme.Objects)do
											if ... then
												self[1](v,...)
											else
												self[1](v,unpack(Citrus.Misc.Table.pack(self,2)))
											end
										end
									end)(...)
								end});
					Filter = filter or {};
					Objects = {};
			},{
					__call = function(self,obj,filv)
						local hasClass
						local checks
						local used = {}
						--first checks to make sure its eligible to be used
						for i,v in pairs(self.Filter)do
							if Citrus.Instance.isAClass(v) or Citrus.Instance.isAClass(i) then
								if obj:IsA(v) or obj:IsA(i) then
									checks = true
								end
								hasClass = true
							end	
							if Citrus.Instance.isAClass(i) and type(v) ~= 'boolean' then
								for _,val in pairs(filv or self.Values)do
									if Citrus.Properties.hasProperty(obj,v) and type(val) == type(obj[Citrus.Properties[v]]) and not Citrus.Misc.Table.find(used,v) then
										obj[Citrus.Properties[v]] = val
									end
									table.insert(used,val)
								end
							end
						end
						if not hasClass or checks then
							for _,prop in next,self.Filter do
								for _,val in next,filv or self.Values do
									if Citrus.Properties.hasProperty(obj,prop) and type(val) == type(obj[Citrus.Properties[prop]]) and not Citrus.Misc.Table.find(used,val) then
										obj[Citrus.Properties[prop]] = val
										table.insert(used,val)
									end
								end
							end
						end
						if Citrus.Misc.Table.length(self.Filter) == 0 then
							for _,val in next,filv or self.Values do
								for prop,_ in next,Citrus.Properties.getProperties(obj)do
									if Citrus.Properties.hasProperty(obj,prop) and typeof(obj[prop]) == typeof(val) then
										pcall(function()
											obj[prop] = val
										end)
									end
								end
							end
						end
					end;
				}
			)	
			getmetatable(Citrus.Theming).Themes[name] = newTheme
			return newTheme
		end;
		getTheme = function(name)
			return Citrus.Misc.Table.find(getmetatable(Citrus.Theming).Themes,name)
		end;
		insertObjects = function(name,...)
			local theme = Citrus.Theming.getTheme(name)
			for ins,ob in next,{...} or {} do
				if Citrus.Instance.isAClass(ins) then
					theme.Objects[ins] = ob
					theme(ins,ob)
				else
					table.insert(theme.Objects,ob)
					theme(ob)
				end
			end
			Citrus.Theming.syncTheme(name)
		end;
		syncTheme = function(name)
			local theme = Citrus.Theming.getTheme(name)
			pcall(function() theme:Call() end)
			for ins,ob in next,theme.Objects or {} do
				if Citrus.Instance.isAClass(ins) then
					theme.Objects[ins] = ob
					theme(ins,ob)
				else
					theme(ob)
				end
			end
		end;
		callTheme = function(name,...)
			return Citrus.Theming.getTheme(name).Funct(...)
		end;
		setTheme = function(name,...)
			local used = {}
			local theme = Citrus.Theming.getTheme(name)
			local vals = theme.Values
			for index,val in next, vals do
				for _,new in next,{...} do
					if typeof(val) == typeof(new) and not Citrus.Misc.Table.find(used,new) then
						vals[index] = new
						table.insert(used,new)
					end
				end
			end
			theme:Sync()
		end;
	},{
		Themes = {};
	}
)			
Theme = Citrus.Theming


--POSITIONING
Citrus.Positioning = {
	new = function(...)
		local args = {...}
		if #args == 4 then
			return UDim2.new(unpack(args))
		else
			local a,b  = args[1], args[3] == nil and args[1] or args[2]
			local uds = Citrus.Misc.Functions.switch(UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0))
			uds.type = {'s','o','b','so','os'}
			return uds(args[3] or args[2] or 1)
		end
	end;
	toUDim = function(a,b)
		local uds = Citrus.Misc.Functions.switch(UDim.new(a,b), UDim.new(a,a))
		return uds(b and 1 or 2)
	end;
	toVector2 = function(a,b)
		local uds = Citrus.Misc.Functions.switch(Vector2.new(a,b), Vector2.new(a,a))
		return uds(b and 1 or 2)
	end;
	fromPosition = function(a,b)
		local x,y
		local pos = Citrus.Misc.Functions.switch(UDim.new(0,0),UDim.new(.5,0),UDim.new(1,0),UDim2.new(.5,0))
		pos.type = {'top','mid','bottom','center'}
		y = pos(a) or (pos(b) and b~='mid' and b~='center')
		pos.type = {'left','mid','right','center'}
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
					
}
Position = Citrus.Positioning
local ud, udim, v2, fromPos, tweenObj = Position.new, Position.toUDim, Position.toVector2, Position.fromPosition, Position.tweenObject


--PROPERTIES
Citrus.Properties = setmetatable({
		new = function(name,func,...)
			local storage = getmetatable(Citrus.Properties).Custom
			storage[name] = setmetatable({func,...},{
					__call = function(self,...)
						return self[1](...)
					end;
					__index = function(self,indexed)
						for i = 2,#self do
							if self[i]:lower() == 'all' or indexed:IsA(self[i]) then
								return true
							end
						end
						return false
					end;
			})
		end;
		hasProperty = function(who,prop) --EDIT LATER FOR CUSTOM OBJECTS
			if pcall(function() return who[Citrus.Properties[prop]] end) then
				return true
			else
				return false
			end
		end;
		getProperties = function(who)
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
			local c = getmetatable(Citrus.Properties).Custom
			for i,v in next,props do
				if c[i] then
					if type(v) ~= 'table' then v = {v} end
					--custom object check
					c[i](who,unpack(v))
				elseif Citrus.Properties.hasProperty(who,i) then
					pcall(function() who[Citrus.Properties[i]] = v end)
				end
			end
			return who
		end;
		getObjectOfProperty = function(property,directory)
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
			return Citrus.Misc.Table.search(getmetatable(self).RobloxAPI,ind)
		end;
		Custom = setmetatable({},{
				__index = function(self,ind)
					for i,v in next,self do
						if i:sub(1,#ind):lower() == ind then
							return v
						end
					end
				end});
		RobloxAPI = {
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
)
Properties = Citrus.Properties
local newProperty, has, set, get = Properties.new, Properties.hasProperty, Properties.setProperties, Properties.getProperties
table.sort(gm(Properties).RobloxAPI,function(a,b) return #a < #b end);


--SETTINGS
Citrus.Settings = setmetatable({
		getDefault = function(classname)
			return classname and getmetatable(Citrus.Settings).Default[classname] or getmetatable(Citrus.Settings).Default
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
					Value = object[index];
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
			object.GetPropertyChangedSignal(index):connect(function()
					setting:Set(object[index])
			end)	
			return list
		end;
		getSetting = function(name,list)
			if list then return Citrus.Misc.Table.find(list,name) end
			for i,v in next, getmetatable(Citrus.Settings).Settings do
				for n, ret in next, v do
					if n == name then 
						return ret
					end
				end
			end
		end;
		setSetting = function(name,newval,list)
			Citrus.Settings.get(name,list):Set(newval)
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
	}
)
Settings = Citrus.Settings  
local newDefault = Settings.setDefault


--MISCELLANEOUS
Citrus.Misc = {
	Functions = {
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
				if not Citrus.Misc.Functions.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
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
		switch = function(...)
		    return setmetatable({type = {},D4 = false,Get = function(self,number)
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
			local op = Citrus.Misc.Functions.switch(a+b,a-b,a*b,a/b,a%b,a^b,a^(1/b),a*b,a^b,a^(1/b))
			op.type = {'+','-','*','/','%','^','^/','x','pow','rt'}
			return op(opa)
		end;
	};
	Table = {
		pack = function(tabl,start)
			local new = {}
			for i = start or 1, #tabl do
				table.insert(new,tabl[i])
			end
			return new
		end;
		merge = function(who,what)
			for i,v in next,who do
				if what[i] then
					for a,z in next,v do
						what[i][a] = z
					end
				else
					what[i] = v
				end
			end
			return what
		end;
		clone = function(tab)
			local clone = {}
			for i,v in next,tab do
				if type(v) == 'table' then
					clone[i] = Citrus.Misc.Table.clone(v)
					if getmetatable(v) then
						local metaclone = Citrus.Misc.Table.clone(getmetatable(v))
						setmetatable(clone[i],metaclone)
					end
				else
					clone[i] = v
				end
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
			return false
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
			return #Citrus.Misc.Table.toNumeralIndex(tab)
		end;
		reverse = function(tab)
			local new ={}
			for i,v in next,tab do
				new[#tab+1-1] = v
			end
			return new
		end;
		indexOf = function(tabl,val)
			return Citrus.Misc.Table.contains(tabl,val,3)
		end;
		find = function(tabl,this)
			return Citrus.Misc.Table.contains(tabl,this,2)
		end;
		search = function(tabl,this)
			local misc = Citrus.Misc
			if misc.Table.find(tabl,this) then
				return misc.Table.find(tabl,this)
			end
			for i,v in next,tabl do
				if type(i) == 'string' or type(v) == 'string' then
					local subject = type(i) == 'string' and i or type(v) == 'string' and v
					local caps = misc.Functions.stringFilterOut(subject,'%u',nil,false,true)
					local numc = caps..(subject:match('%d+$') or '')
					if subject:lower():sub(1,#this) == this:lower() or caps:lower() == this:lower() or numc:lower() == this:lower() then
						return v,i
					end
				end
			end
			return false
		end;
		anonSetMetatable = function(tabl,set)
			local old = getmetatable(tabl)
			local new = Citrus.Misc.Table.clone(setmetatable(tabl,set))
			setmetatable(tabl,old)
			return new
		end;
	};
}

