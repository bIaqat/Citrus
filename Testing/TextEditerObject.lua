--[[
local text = "vbnh$asd(q,w,eert,werp,zxcg){zxcv}tyu$yes(){lol}"
local got = {};
local t2 = text;
for c in text:gmatch('$%w+%([%w,]*%)') do
  local args = {}
  local t = text:sub(text:find'%(', text:find')')

  local c = 1
  local m1 = text:match('$%w+%([%w,]*%){%w+}')
  local m = ""
 for i in t:gmatch("[%w,]*") do
    m = t:match('%w+',c)
    table.insert(args,m)
    c = c + (m and #m or 0) + 1
  end


  got[text:match('$%w+')] = {text = ('{.+}'):sub(2,#text - 1), ['args'] = args};

  text= text:sub(1,text:find("$%w+%([%w,]*%)")-1)..text:sub(text:find("$%w+%([%w,]*%)")+#m1-1)

end

print(t2)
for i, v in next, got do
  print(i,v)
  print("\tARGS:")
  for a,s in next,v.args do
    print("\t\t"..s)
  end
end

 ]]
local TextEditor  = setmetatable({
	text = "";
	filteredText = {};
	filteredDels = {};
	instance = Instance.new("TextLabel");
	commands = setmetatable({},{
		__call = function(self, command, ...)
			local properties = self.commands[command](...)
			for i,v in next, properties do
				self.instance[i] = v
			end
		end;
	});
	startDel = "$";
	stopDel = ")";

},{
	__index = function(self, index)
		return self.instance[index];
	end;
}

function TextEdtior:new(parent, defaultProperties)
	local new = setmetatable({},{__index = self})
	new.instance = Instance.new("TextLabel", parent);

	for i,v in next, defaultProperties do
		new.instance[i] = v;
	end

	return new;
end

function TextEditor:getDelimiters(text)
	local text = text or self.text;
	local fil = {};
	local dels = {};

	

function TextEditor.getTextSize(text,prop)
	local textl
	if type(text) == 'string' then
		textl = Instance.new('TextLabel')
		textl.Text = text
		for i,v in next, prop or {} do
			textl[i] = v
		end
	end
	return game:GetService('TextService'):GetTextSize(text, textl.TextSize, textl.Font, textl.AbsoluteSize)
end;
