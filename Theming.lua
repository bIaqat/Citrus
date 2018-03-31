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
					print(prop,index,unpack(val))
					obj[prop] = val[index]
				end
			end
		end
	end;
},{
	Themes = {};
}
);