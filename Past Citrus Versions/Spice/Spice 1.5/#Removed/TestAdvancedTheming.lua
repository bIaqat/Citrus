TestAdvancedTheming = setmetatable({
	new = function(name,...)
		local self = getmetatable(Spice.Theming)
		local theme = self:newThemeTable(...)
		self.Themes[name] = theme
	end;
	getTheme = function(name)
		return getmetatable(Spice.Theming).Themes[name]
	end;
	addValues = function(name,...)
		local stuff = {...}
		local index
		if type(stuff[#stuff]) == 'number' then
			index = stuff[#stuff]
			table.remove(stuff,#stuff)
		else
			index = 1
		end
		local self = getmetatable(Spice.Theming)
		local theme = Spice.Theming.getTheme(name)
		theme.Filter = self:filter(stuff,theme.Filter)
		Spice.Theming.sync(name)
	end;
	setTheme = function(name,...)
		local theme = Spice.Theming.getTheme(name)
		local self = getmetatable(Spice.Theming)
		theme.Filter = self:filter({...})
		Spice.Theming.sync(name)
	end;
	insertObject = function(name,obj,...)
		local theme = Spice.Theming.getTheme(name)
		theme.Objects[obj] = {...}
		Spice.Theming.sync(name)
	end;
	sync = function(name)
		pcall(function()
		local self = getmetatable(Spice.Theming)
		if not name then
			for i,v in next, self.Themes do
				Spice.Theming.sync(i)
			end
		else
			local theme = Spice.Theming.getTheme(name)
			for i,v in next, theme.Objects do
				local props = self:fromFilter(i,theme.Filter,v)
				for pro,val in next, props do
					if type(val) == 'table' then
						val[1](i,pro,unpack(val[2] or {}))
						table.remove(props,pro)
					end
				end
				Spice.Properties.setProperties(i,props)
			end
		end
		end)
	end;
},{
	fromFilter = function(self,obj,filter,objfilter)
		local newf
		if objfilter then
			newf = self:filter(objfilter)
			for i,v in next, newf do
				warn(i)
				for z,x in next,v do
					warn("\t"..z)
					for y,u in next, x do
						print(y,u)
					end
				end
			end
		end
		local props = {}
		for class, v in next, filter do
			if obj:isA(class) or class == 'All'  then
				for prop, i in next, v do
					if type(prop) == 'string' and Spice.Properties.hasProperty(obj,prop) then
						rawset(props,prop,i[1])
					end
				end
			end
		end
		if objfilter then
			for class, v in next, newf do
				for prop, i in next, v do
					if prop == 0 then
						print(i)
						for w, q in next, i do
							local pro, index = q[1], q[2]
							rawset(props,pro,filter[class][prop][index or 1])
						end
					end
				end
				if not obj:isA(class) and class ~= 'All' then
					for prop, i in next, filter[class] do
						if type(prop) == 'string' and Spice.Properties.hasProperty(obj,prop) then
							rawset(props,prop,i[1])
						end
					end
				end
			end
		end
		return props
	end;	
	valueCheck = function(self,v)
		if type(v) == 'string' and Spice.Instance.isA(v,'Instance') then
			return 'Class'
		elseif type(v) == 'string' and Spice.Properties(v) then
			return 'Property'
		elseif type(v) == 'function' then
			return 'Function'
		else
			return 'Value'
		end
	end;
	filter = function(self,stuff,filter)
		local filter = filter or {
			All = {[0] = {}}
		}
		local pushIndex = 1;
		local storedValue;
		local storedProperty;
		for i, v in next, stuff do
			if i == pushIndex then
				local nextIndex = stuff[i+1]
				local check = self:valueCheck(v)
				if check == 'Value' then
					if storedProperty then 
						if not filter.All[storedProperty[1]] then
							filter.All[storedProperty[1]] = {}
						end
						table.insert(filter.All[storedProperty[1]],storedProperty[2]) 
						storedProperty = nil
					end
					if storedValue then table.insert(filter.All[0], storedValue) end
					storedValue = v
				elseif check == 'Property' then
					if storedProperty then 
						if not filter.All[storedProperty[1]] then
							filter.All[storedProperty[1]] = {}
						end
						table.insert(filter.All[storedProperty[1]],storedProperty[2]) 
					end
					storedProperty = {v, storedValue}
					storedValue = nil
				elseif check == 'Class' then
					if not filter[v] then
						filter[v] = {[0] = {}};
					end
					if storedProperty then
						if not filter[v][storedProperty[1]] then
							filter[v][storedProperty[1]] = {}
						end
						table.insert(filter[v][storedProperty[1]],storedProperty[2])
						storedProperty = nil
					end
					if storedValue then
						table.insert(filter[v][0],storedValue)
						storedValue = nil
					end
				elseif check == 'Function' then
					if self:valueCheck(nextIndex) == 'Value' then
						pushIndex = pushIndex + 1
						storedValue = {v, nextIndex}
					end
				end
			end
			pushIndex = pushIndex + 1
		end
		if storedValue then table.insert(filter.All[0], storedValue) end
		if storedProperty then 
			if not filter.All[storedProperty[1]] then
				filter.All[storedProperty[1]] = {}
			end
			table.insert(filter.All[storedProperty[1]],storedProperty[2]) 
		end
		return filter
	end;
	newThemeTable = function(self,...)
		local stuff = {...}
		local theme
		theme = {
			Active = theme;
			Objects = {
			};
			Filter = self:filter(stuff);
			Alts = {};
		}
		return theme
	end;
	Themes = {};
})



local frame = Spice.Instance.new("Frame",sg,{Size = UDim2.new(0,200,0,200), Pos = UDim2.new(.5,0,.5,0)})
Spice.Theming.new("Primary", Color3.new(0,0,1),Color3.new(1,0,0)) 
Spice.Theming.insertObject("Primary", frame, {'BorderColor3',2},{'BackgroundColor3',1})
wait(1)
Spice.Theming.setTheme("Primary",Color3.new(1,0,1))
wait(2)
Spice.Theming.addValues('Primary',Color3.new(0,1,0))