Misc = {
	String = {
		filterOut = function(string,starting,ending,...)
			local args,disregard,tostr,flip = {...}
			for i,v in pairs(args)do
				if type(v) == 'boolean' then
					if not flip then flip = v else tostr = v end
				elseif type(v) == 'string' then
					disregar = v
				end
			end
			local filter,out = {},{}
			for i in string:gmatch(starting) do
				if not Pineapple.Misc.Functions.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
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
		--Magic is adding more later hopefully or else this will be moved into Misc.Functions as "stringFilterOut"
	};
	Functions = {
		switch = function(...)
			return setmetatable({type = {},D4 = f
					
