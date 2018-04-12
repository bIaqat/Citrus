--[[old switch
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
]]
--[[ workflow i want
local switch = Switch(100,400,300,'apple')
switch(2) --same as a table switch[2]
	-->> 400
switch(4)
	-->>'apple'

switch.set(400,200,300)
switch(400)
	-->> 100
switch(300)
	-->> 300


switch:Set('a',true,false,'b')
switch(false)
	-->>300
switch'b'
	-->>'apple'
]]

switch = function(...)
	local data = {filter = {},data = {...}}
	function data:Filter(...)
		self.filter = {...}
		return self
	end;
	function data:Set(...)
		data.data = {...}
	end;
	function data:Get(what)
		local i = what
		if Citrus.Misc.Table.find(self.data,what) then
			i = Citrus.Misc.Table.indexOf(self.data,what)
		end
		if Citrus.Misc.Table.find(self.filter,what) then
			i = Citrus.Misc.Table.indexOf(self.filter,what)
		end
		return self.data[i]
	end;
	setmetatable(data,{
		__call = function(self,what,...)
			local get = self:Get(what)
			return get and (type(get) ~= 'function' and get or get(...)) or self.Default
		end;
		})
	return data
end

-- "one line"
switch = function(...)
	return setmetatable({filter = {},Default = false,data = {...},
		Filter = function(self,...)
			self.filter = {...}
			return self
		end;	
		Get = function(self,what)
			local yes = Citrus.Misc.Functions.exists	
			local i = what
			if yes(Citrus.Misc.Table.find(self.data,what)) then
				i = Citrus.Misc.Table.indexOf(self.data,what)
			end
			if yes(Citrus.Misc.Table.find(self.filter,what)) then
				i = Citrus.Misc.Table.indexOf(self.filter,what)
			end
			return self.data[i]
		end},{
			__call = function(self,what,...)
				local get = self:Get(what)
				return get and (type(get) ~= 'function' and get or get(...)) or self.Default
			end;
		})
end;