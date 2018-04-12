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
	getValues = function(name,index)
		return not index and Spice.Theming.getTheme(name).Values or Spice.Theming.getTheme(name).Values[index]
	end;
	setTheme = function(name,...)
		Spice.Theming.getTheme(name).Values = {...}
		Spice.Theming.syncTheme(name)
	end;
	setValue = function(name,to,index)
		Spice.Theming.getValues(name)[index or 1] = to
		Spice.Theming.syncTheme(name)
	end;
	setObjects = function(name,...)
		Spice.Theming.getTheme(name).Objects = {}
		Spice.Theming.insertObjects(...)
	end;
	insertObject = function(name,obj,...)
		obj = Spice.Instance.getInstanceOf(obj)
		Spice.Theming.getObjects(name)[obj] = {}
		local ob = Spice.Theming.getObjects(name)[obj]
		local args = {...}
		local count = 1
		for i,val in next,args do
			if type(val) == 'string' and i == count and Spice.Properties.hasProperty(obj,Spice.Properties[val]) then
				count = count + 1
				val = Spice.Properties[val]
				Spice.Theming.insertProperty(name,obj,val,type(args[count]) == 'number' and args[count] or nil)
				if type(args[count]) == 'number' then
					count = count + 1
				end
			end				
		end
	end;
	insertProperty = function(name,obj,prop,index)
		obj = Spice.Instance.getInstanceOf(obj)
		local objs = Spice.Theming.getObjects(name,obj)
		objs[prop] = index or 1
		obj[prop] = Spice.Theming.getValues(name,index or 1)
	end;
	insertObjects = function(name,...)
		for i,v in next,{...} do
			Spice.Theme.insertObject(name,unpack(type(v) == 'table' and v and v or {v}))
		end
	end;
	syncTheme = function(name)
		for i,theme in next, name and {Spice.Theming.getTheme(name)} or getmetatable(Spice.Theming).Themes do
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
});
