Theming = setmetatable({
		new = function(name,...)
			local vals = {...}
			local th = getmetatable(Spice.Theming).Themes
			th[name] = { Values = vals, Objects = {} }
		end;
		getTheme = function(name)
			return getmetatable(Spice.Theming).Themes[name]
		end;
		getObjects = function(name,obj)
			return obj and Spice.Theming.getTheme(name).Objects[obj] or Spice.Theming.getTheme(name).Objects
		end;
		getValues = function(name)
			return Spice.Theming.getTheme(name).Values
		end;
		setTheme = function(name,...)
			Spice.Theming.getTheme(name).Values = {...}
		end;
		setValue = function(name,to,index)
			Spice.Theming.getValues(name)[index or 1] = to
		end;
		setObjects = function(name,...)
			Spice.Theming.getTheme(name).Objects = {}
			Spice.Theming.insertObjects(...)
		end;
		insertObject = function(name,obj,...)
			Spice.getObjects(name)[obj] = {}
			local ob = Spice.getObjects(name)[obj]
			local args = {...}
			local count = 1
			for i,val in next,args do
				if type(val) == 'string' and i == count then
					count = count + 1
					if on[val] = args[count] and type(args[count]) == type(obj[val]) and not Spice.Properties.hasProperty(obj,args[count]) then
						Spice.Theming.insertProperty(name,obj,val,args[count])
						count = count + 1
					end
				end
			end
		end;
		insertProperty = function(name,obj,prop,index)
			local objs = Spice.Theming.getObjects(name,obj)
			objs[prop] = index or 1
			obj[prop] = Spice.Theming.getValues(name)[index or 1]
		end;
		insertObjects = function(name,...)
			for i,v in next,{...} do
				Spice.Theme.insertObject(name,unpack(type(v) == 'table' and v and v or {v}))
			end
		end;
		syncTheme = function(name)
			for i,theme in next, name and {1} or getmetatable(Spice.Theming).Themes do
				theme = name and Spice.getTheme(name) or theme
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
)
