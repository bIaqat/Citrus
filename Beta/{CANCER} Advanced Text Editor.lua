TextEditor = {
--[[
	contains = function(containing,...)
		for _,content in next,{...} do
			if content == containing then
				return true
			end
		end
		return false
	end;
	filterOut = function(string,starting,ending,...)
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
			if not contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
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
	pack = function(tabl,start,en)
		local new = {}
		for i = start or 1, en or #tabl do
			table.insert(new,tabl[i])
		end
		return new
	end;
     
local a = '(<a>apples/) are (<asd cv><also this>good/) (<c 4 5 6><b><i>apple/) why (<a 123 567>not/) anymore'

local b = filterOut(a,'%(',')',false)

local commands = {}
for i,v in next,b do
  print("WORD",v)
  local word = v:sub()
  cmd, word = filterOut(v,'<','>',false,true),filterOut(v,'>','/',false,true)
  print(cmd,word)
  commands[#commands+1] = filterOut(v,'<','>',false)
end

for _,v in next, commands do
  for _,x in next,v do
    local x = x:sub(1,#x-1):sub(2)
    local args = filterOut(x,'%S+',nil,false)
    local name, rest
    for p, arg in next, args do
      rest = name and not rest and pack(args,p) or rest
      name = not name and arg or name
    end
    print(name,rest,rest and table.concat(rest,'/'))
  end
end


]]
	getTextSize = function(text)
		if type(text) == 'string' then
			text = Spice.Instance.new("TextLabel",{Text = text})
		end
		return game:GetService("TextService"):GetTextSize(text.Text,text.TextSize,text.Font,text.AbsoluteSize)
	end;

	newFilter = function(command,...)
		local fil = '<'
		if not Spice.Misc.switch('b','i','bold','italic','size','color','rgb','hsv')(command) then
			return error'Not a valid command'
		end
		fil = fil..command..' '..
		for i,v in next,{...} do
			fil = fil..v..' '
		end
		return fil..'>'
	end;

	applyFilter = function(object,...)
		local fil = '['
		for i,v in next,{...} do
			if type(v) == 'string' then
				fil = fil..v
			end
		end
		fil = fil..object.Text..']'
		return fil
	end;

	runCommand = function(name,...)
		if not Spice.Misc.switch('b','i','bold','italic','size','color','rgb','hsv')(command) then
			return error'Not a valid command'
		end
		name = name:lower():sub(1,1)
		if name == 'b' then


	unFilter = function(text)
		local fo = Spice.Misc.stringFilterOut
		local pack = Spice.Table.pack
		local ret = {}
		local filters = fo(text,'%(',')',false)

		local commands = {}
		for _, filt in next, filters do 

			ret = 
			commands[#commands+1] = fo(v,'<','>',false)
		end
		
		for _, a in next, commands do
			for _, command in next, a do
				local command = command:sub(1,#command-1):sub(2)
				local args = fo(x,'%S+',nil,false)
				local name,rest
				for pn, arg in next, args do
			      rest = name and not rest and pack(args,p) or rest
			      name = not name and arg or name
			    end

			end
		end




	applySyntax = function(object,filter)
		if not filter then filter = object.Text end

		local sections = Spice.Misc.stringFilterOut(filter,'[',']')



}