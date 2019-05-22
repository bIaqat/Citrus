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
