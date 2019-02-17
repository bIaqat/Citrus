--Basic Theming
Theming = setmetatable({
	new = function(name,valtab,...)
		local theme = {
			Values = setmetatable({},{
					vals = type(valtab) == 'table' and valtab or {valtab};
					__index = getmetatable(theme.Values).vals;
					__newindex = function(self,ind,new)
						for object,v in next, theme.Objects do
							for prop, index in next, v do
								if index == ind then
									object[prop] = new
								end
							end
						end
						rawset(self.vals,ind,new)
					end
				})
			Objects = {};
		}
		Spice.Theming.insertObjects(name,...)
		getmetatable(Spice.Theming).Themes[name] = theme
	end;
	insertObjects = function(theme, ...)
		local theme = getmetatable(Spice.Theming).Themes[theme]
		for i,tab in next, {...} do
			if not theme.Objects[tab[1]] then theme.Objects[tab[1]] = {} end
			theme.Objects[tab[1]][tab[2]] = tab[3] or 1
			tab[1][tab[2]] = theme.Values[tab[3] or 1]
		end
	end;
	setValue = function(theme,ind,new)
		getmetatable(Spice.Theming).Themes[theme].Values[ind] = new;
	end;
	getValue = function(theme,ind)
		return getmetatable(Spice.Theming).Themes[theme].Values[ind]
	end; 
},{
	Themes = {}
}