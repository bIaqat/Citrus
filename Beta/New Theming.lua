Theming = setmetatable({
	new = function(name,...)
		local self = getmetatable(Spice.Theming)
		local theme = self:newThemeTable({...})
		self.Themes[name] = theme
	end;
	getTheme = function(name)
		return getmetatable(Spice.Theming).Themes[name]
	end;
	setTheme = function(name,...)
		local self = getmetatable(Spice.Theming)
		local theme = Spice.Theming.getTheme(name)
		theme.Filter = self:filter({...},theme.Filter)
		Spice.Theming.sync(name)
	end;
	insertObject = function(obj,...)
		local theme = Spice.Theming.getTheme(name)
		theme.Objects[obj] = {...}
	end;
	sync = function(name)
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
	end;
},{
	fromFilter = function(self,obj,filter,objfilter)
		local self = getmetatable(self)
		if objfilter then
			local newf = self:filter(objfilter)
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
					rawset(props,prop, filter[class][prop][i[1] or 1])
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
		local self = getmetatable(self)
		if pcall(function() return Spice.Instance.isA('Instance',v)) then
			return 'Class'
		elseif pcall(function() return Spice.Properties(v)) then
			return 'Property'
		elseif type(v) == 'function' then
			return 'Function'
		else
			return 'Value'
		end
	end;
	filter = function(self,stuff,filter)
		local self = getmetatable(self)
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
					if storedValue then table.insert(filter.All[0], storedValue) end
					storedValue = v
				elseif check == 'Property' then
					if storingProperty then 
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
					else
						table.insert(filter[v][0],storedValue)
					end
					storedProperty = nil
					storedValue = nil
				elseif check == 'Function' then
					if self:valueCheck(nextIndex) == 'Value' then
						pushIndex = pushIndex + 1
						storedValue = {v, nextIndex}
					end
				end
			end
		end
		if storedValue then table.insert(filter.All[0], storedValue) end
		if storingProperty then 
			if not filter.All[storedProperty[1]] then
				filter.All[storedProperty[1]] = {}
			end
			table.insert(filter.All[storedProperty[1]],storedProperty[2]) 
		end
		return filter
	end;
	newThemeTable = function(self,...)
		local self = getmetatable(self)
		local stuff = {...}
		local theme
		theme = {
			Active = theme;
			Objects = {
				All = {[0] = {}}
			}
			Filter = self.filter(stuff)
			Alts = {};
		}
		return theme
	end
	Themes = {};
}

local f = Instance.new("Frame")
local f2 = Instance.new("TextButton")
local a = Theming.new("Primary", Color3.new(1,0,0), 'BackgroundColor3',5, Color3.new(0,0,1), 'GuiButton', Color3.new(0,1,0), Color3.new(1,1,0), Color3.new(1,0,1),{Color3.new(0,0,0),Color3.new(1,1,1)},'BorderColor3','GuiButton',function(obj,prop,...),{args}) 

local Primary = {
	Objects = {
		All = {
			[0] = {
				f = {'BoderColor3', 1}
				f2 = {'BackgroundColor3', 2}
			};
			BackgroundColor3 = {
				f = {'BackgroundColor3', 1}
			}

		};
		GuiButton = {
			[0] = {};
			BorderColor3 = {
				f = {BorderColor3, 1}
			}
		}
	};
	Filter = {
		All = {
			[0] = {5, Color3.new(0,1,0), Color3.new(1,1,0), Color3.new(1,0,1), {function(), {args}}};
			BackgroundColor3 = {
				Color3.new(1,0,0)
			}
		};
		GuiButton = {
			[0] = {Color3.new(0,0,1)};
			BorderColor3 = {
				Color3.new(0,0,0);
				Color3.new(1,1,1);
			}
		}
	}

	Alts = {
		[1] = ThemeTable;
	}
	}
}

a:InsertObject(f, 'BorderColor3') -- frame will have Background as 1,0,0 and BorderColor3 as 0,1,0
Theming.insertObject("Primary", f2) --button will have Background as 1, 0, 0; bordercolor3 as 0,0,0

Theming.insertObject(f) --background as 1,0,0
Theming.insertObject(f,'BackgroundColor3') --background as 1,0,0; background as 0,1,0

Theming.insertObject(f2,'BackgroundColor3',2) --background as 1,0,0; background as 0,1,0; bordercolor3 as 0,0,0

Theming.insertObject(f,f2,'BorderSize',nil,2) --background to both as 1,0,0; BorderSize as 5; f2 bordercolor3 as 1,1,1
Theming.insertObject(f,f2,'BorderSize') --background to both as 1,0,0; BorderSize as 5
Theming.insertObject(TextLabel,'GuiButton','TextColor3') -- background as 1,0,0

Theming.newAlt('Primary',1,...)


Theming.set("Primary", 1, Color3.new(0,1,1))
Theming.set("Primary", 'GuiButton', Color3.new(0,1,1))