Util = {
	AutoUpdate = function(name,typ)
		local ret = false
		local file
		pcall( function()
			if not name then
				file = Spice.Util.gitFile(typ,'Spice')
			elseif name:lower() == 'all' then
				for i,v in next, Spice do
					if type(i) == 'string' and type(v) == 'table' then
						Spice.Util.AutoUpdate(i,typ)
					end
				end
			else
				file = Spice.Util.gitFile(typ,name)
			end
			
			file = file + ('\n return '..(name and name or 'Spice'))
			ret = file()
			if name then
				Spice[name] = ret
			end
		end)
		return ret
	end;
	gitFile = function(typ,...)
		local http
		local htt = not typ and game:GetService('HttpService').GetAsync or game.HttpGet
		function http(link)
			return htt(typ and htt or game:GetService('HttpService'),link)
		end	
		local directory = table.concat({...},'/')
		return setmetatable({Data = http('https://raw.githubusercontent.com/Karmaid/Spice/master/'..directory..'.lua')},{
			__call = function(self,...)
				return loadstring(self.Data)(...)
			end;
			__concat = function(a,b)
				return tostring(a)..tostring(b)
			end;
			__add = function(a,b)
				local val = type(a) == 'string' and a or type(b) == 'string' and b or ''
				local tab = type(a) ~= 'string' and a or type(b) ~= 'string' and b
				tab.Data = tab.Data..val
				return tab
			end;
			__tostring = function(self)
				return tostring(self.Data)
			end
		})
	end;
	getSpiceCompressed = function(upd,typ)
		local main = not upd and Spice or Spice.Util.AutoUpdate()
		local citrus = [[local Spice
Spice = setmetatable({
	]]
		
	local rest = [[
	},{
	__index = function(self,nam)
		if rawget(self,nam) then
			return rawget(self,nam)
		end
		for i,v in next, self do
			if rawget(v,nam) then
				return rawget(v,nam)
			end
		end
	end
})
table.sort(getmetatable(Spice.Properties).RobloxAPI,function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end);
	]]
		for i,v in next,main do
			if type(i) == 'string' and type(v) == 'table' then
				citrus = citrus..string.gsub(''..Spice.Util.gitFile(typ,i),'\n','\n\t')
			end
		end
		return citrus..rest
	end;
};
