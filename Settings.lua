Settings = setmetatable({
		getDefault = function(classname)
			return classname and getmetatable(Pineapple.Settings).Default[classname] or getmetatable(Pineapple.Settings).Default
		end;
		setDefault = function(classname,properties)
			Pineapple.Settings.getDefault()[classname] = properties
		end;
		
		new = function(obj,name,defaultvalue)
			
		},{
		Default = {};
		Settings = {};
	}
)
  
