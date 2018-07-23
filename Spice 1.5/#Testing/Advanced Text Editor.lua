TextEditor = setmetatable({
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
	newCommand = function(name, func)
		getmetatable(Spice.TextEditor).Commands[name] = func
	end;
	getTextSize = function(text)
		if type(text) == 'string' then
			text = Spice.Instance.new("TextLabel",{Text = text})
		end
		return game:GetService("TextService"):GetTextSize(text.Text,text.TextSize,text.Font,text.AbsoluteSize)
	end;
	render = function(self, obj, filter)
		filter = filter or obj.Text
},{
	Commands = setmetatable({
		Property = function(ind,val)
			return {[ind] = val}
		end;
		Italic = function()
			return {Font = Enum.Font.SourceSansItalic}
		end;
		Bold = function()
			return {Font = Enum.Font.SourceSansBold}
		end;
		SemiBold = function()
			return {Font = Enum.Font.SourceSansSemibold}
		end;
		Color = function(r,g,b)
			return {TextColor3 = Color3.fromRGB(r,g,b)}
		end;
		},{
		__call = function(self, obj, command, ...)
			return Spice.Properties.setProperties(obj,self[command](...))
		end;
	}
	getFilter = function(obj)
		local filter = {}
		text = '$b{Hello} $c(0,0,255){World}!' --obj.Text
	Filters = {};
})

TextEdtior.newCommand('Bold', function()
	return {Font = Enum.Font.SourceSansBold}
end



local TextBox = Instance.new('TextBox')
TextBox.Text = '$b{Hello} $c(0,0,255){World}!'
TextEditor:render(TextBox)

local syntaxc = TextEditor.newFilter("SyntaxColoring",
	'local', '$color(0,0,255)$italic',
	'end', '$color(0,0,255)$semibold'
)


syntaxc:connect(TextBox) --or TextEditor:connectFilter('SyntaxColoring', TextBox)


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
			if not contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
				local filtered = string:sub(string:find(starting),ending and getArgument(2,string:find(ending)) or getArgument(2,string:find(starting)))
				local o = string:sub(#filtered+1, (string:sub(#filtered+1):find(starting) or 1)-1+#filtered)
				table.insert(filter,filtered~=disregard and filtered or nil)
				table.insert(out,o~=disregard and #o > 0 and o or nil)
			else
				table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
			end
			string = string:sub((ending and getArgument(2,string:find(ending)) or getArgument(2,string:find(starting))) + 1)
		end
		table.insert(out,string)
		filter = tostr and table.concat(filter) or filter
		out = tostr and table.concat(out) or out
		return flip and out or filter, flip and filter or out
	end;
	
text = '<b, color = 0,0,255>Hello</b> a<color = 0,0,255>World Is Good</c>apple' --obj.Text
local a, b = stringFilterOut(text, '<%a+','</%a+>')
print(table.concat(b,'|'))
for i,v in next, a do
  local name = stringFilterOut(v, '<%a+','%s',false,true):sub(2)
  local text = stringFilterOut(v, '>','<',false,true):sub(2,-2)
  print(name,text)
end

