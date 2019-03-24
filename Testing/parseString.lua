stringFilterOut = function(string,starting,ending,...)
	local args,disregard,tostr,flip = {...}
	for i,v in pairs(args)do
		if type(v) == 'boolean' then
			if flip == nil then flip = v else tostr = v end
		elseif type(v) == 'string' then
			disregard = v
		end
	end
	local filter,out = {},{}
	for i in string:gmatch(starting) do
		if not Spice.Misc.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
			local filtered = string:sub(string:find(starting),ending and Spice.getArgument(2,string:find(ending)) or Spice.getArgument(2,string:find(starting)))
			local o = string:sub(1,(ending and string:find(ending) or string:find(starting))-1)
			table.insert(filter,filtered~=disregard and filtered or nil)
			table.insert(out,o~=disregard and o or nil)
		else
			table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
		end
		string = string:sub((ending and Spice.getArgument(2,string:find(ending)) or Spice.getArgument(2,string:find(starting))) + 1)
	end
	table.insert(out,string)
	filter = tostr and table.concat(filter) or filter
	out = tostr and table.concat(out) or out
	return flip and out or filter, flip and filter or out
end;

function parseString(String, startOfPattern, endOfPattern, inclusiveBefore, inclusiveAfter) --Does not work yet
	local filteredOut = {};
	local rawMatches = {};
	endOfPattern = endOfPattern or startOfPattern
	local tempString = String;
	
	for match in String:gmatch(startOfPattern) do
		
		local start = tempString:find(startOfPattern)
		local endp = tempString:find(endOfPattern, start + 1) or 0
		
		table.insert(filteredOut, tempString:sub(start + (inclusiveBefore and 0 or #startOfPattern) ,endp + (endOfPattern and 0 or #match-1) + (inclusiveAfter and #match or -1)))
		table.insert(rawMatches,match)
		
		tempString = tempString:sub(1, start - 1) .. tempString:sub(endp + (endOfPattern and 1 or #match - 1))
		
	end

	return setmetatable(filteredOut,{__index = {raw = rawMatches},__tostring = function(self) return table.concat(self," | ") end}), tempString
end

--[[CASE USE parseString(string,a,b) gets things inbetween a and b
local string = "{{123}},{{453}},223"

parseString(string,"{","}")
>> {123, {453
.raw >> {, {
.leftOverString >> "},},223"


parseString(string,"{{","}}")
>> 123, 453
.raw >> {{, {{
.leftOverString >> ",,223"


parseString(string,"%p+")
>> 123, 453
.raw >> {{, }},{{, }},
.leftOverString >>"223"

parseString(string,"%d+")
>> }},{{, }},
.raw >> 123, 453, 223
.leftOverString >> "{{"

parseString(string,"{{%d+}}")
>> ,
.raw >> {{123}}, {{453}}
.leftOverString >> ",223"
]]