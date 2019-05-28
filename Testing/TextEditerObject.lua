local advTextSeperator = {
  text = "";
  seperatedText = {};
};

function advTextSeperator:new(text)
  return setmetatable({seperatedText = {},text = text or ""},{
    __index = self;
    __tostring = function(self) 
      local text = self.seperatedText;
      local out = "𝓒seperator: ";
      for i,v in next, text do
        if v.command then
          out = out.."["..v.command.." "..table.concat(v.args,", ").."]";
        end
        out = out..v.text
      end
      return out;
  end}):seperate();
end;

function advTextSeperator:addText(text, command, args)
  table.insert(self.seperatedText, {
    text = text;
    command = command or false;
    args = args;
  })
  return #self.seperatedText;
end;

function advTextSeperator:seperate()
  local text = self.text;
  local sep = self.seperatedText;
  local commandArgDel = '%([%w,%s*]*%)';
  local textDel = '{.-}';
  local del = '$%w+'..commandArgDel..textDel;
  for _ in text:gmatch(del) do
    self:addText(text:sub(1, text:find(del) - 1));

    local matched = text:match(del);
    local argField = matched:match(commandArgDel);
    local args = {};
    local count = 0;
    for _ in argField:gmatch('%w+') do
      local arg = argField:match('%w+', count)
      table.insert(args, arg);
      count = count + #arg + 2;
    end
    self:addText(matched:match(textDel):sub(2,-2), matched:match('%w+'), args)

    local _, postMatched = text:find(del);
    text = text:sub(postMatched+1);
  end
  self:addText(text);
  return self;
end;

local TextEditor = setmetatable({
	text = {};
	instance = Instance.new("TextLabel");
	ghostInstances = {};
	properties = {};
	commands = setmetatable({},{
		__call = function(self, obj, command, ...)
			local properties = self[command](obj, ...)
			if type(properties) == 'table' then
				for i,v in next, properties do
					obj[i] = v
				end
			end
		end;
	});
},{
	__index = function(self, index)
		return self.instance[index];
	end;
})


function TextEditor:new(text, object, defaultProperties)
	local new = setmetatable({text = advTextSeperator:new(text)},{__index = self})
	new.instance = object or Instance.new("TextLabel");

	if defaultProperties then
		new.properties = defaultProperties;
	end
	new.instance.Text = text;
	
	return new;
end

function TextEditor:setText(text)
	self.text = advTextSeperator:new(text);
end;
	
function TextEditor:getRawText()
	return self.text.text;
end;

function TextEditor:insertCommand(name, funct)
	self.commands[name] = funct;
end;

function TextEditor:renderText()
	local obj = self.instance;
	local bounds = obj.TextBounds
	if obj:findFirstChild'Ghost' then
		obj.Ghost:Destroy()
	end
	local ghost = Instance.new("Frame",obj)
	ghost.Size = UDim2.new(1,0,1,0);
	ghost.Name = 'Ghost'
	ghost.Transparency = 1;
	local last = 0
	for _, sep in next, self.text.seperatedText do
		local t = Instance.new("TextLabel", ghost)
		t.Text = sep.text
		for i,v in next, self.properties do
			t[i] = v;
		end
		if sep.command and self.commands[sep.command] then
			self.commands(t, sep.command, unpack(sep.args))
		end
		t.Size = UDim2.new(0, t.TextBounds.X, 0, t.TextBounds.Y);
		t.Position = UDim2.new(0, last,0,0);
		last = last + t.TextBounds.X
	end
	obj.TextColor3 = Color3.new(1,1,1)
end;

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

local testObject = TextEditor:new("sample $red(){text} yo.", script.Parent.Frame.TextBox, {TextColor3 = Color3.new(0,0,0),BackgroundTransparency = 1, Font = 'Gotham', TextSize = 14});
testObject:insertCommand("red",function(obj)
	return {TextColor3 = Color3.new(1, 0, 0)};
end)

testObject:insertCommand("bold", function(obj)
	return {Font = "GothamBlack"};
end)
testObject:insertCommand("rgb", function(obj, r, g, b)
	return {TextColor3 = Color3.new(tonumber(r)/255, tonumber(g)/255, tonumber(b)/255)};
end)

testObject:insertCommand("flashingColors", function(obj)
	spawn(function()
		while wait(.1) do
			obj.TextColor3 = BrickColor.Random().Color
		end
	end)
	return false
end)

script.Parent.Frame.TextBox:GetPropertyChangedSignal('Text'):connect(function(a)
	
		testObject:setText(script.Parent.Frame.TextBox.Text)
		testObject:renderText()
	
end)
