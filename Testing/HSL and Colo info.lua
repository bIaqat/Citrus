local Color = {};
local function op(a,b,op)
	return op == '+' and a + b or
		op == '-' and a - b or
		(op == '*' or op == 'x') and a * b or
		op == '/' and a / b or
		op == '%' and a % b or
		(op == 'pow' or op == '^') and a ^ b or
		(op == 'rt' or op == '^/') and a ^ (1/b);
end;


function Color.fromHSL(h, s, l)
	s = s * (l < .5 and l or 1 - l);

	return Color3.fromHSV(h, 2*s/(l+s), l+s);
end;

function Color.toHSL(Color, returnTable)
	local h,s,v = Color3.toHSV(Color);
	local h2 = (2-s) * v
	local tab = {h%1, s*v / (h2 < 1 and h2 or 2 - h2), h2/2};

	return unpack(returnTable and {tab} or tab);
end;

function Color.toHex(Color, includeHash)
	return (includeHash and '#' or '') .. string.format('%02X',Color.r*255)..string.format('%02X',Color.g*255)..string.format('%02X',Color.b*255);
end;

function Color.setHSL(Color, newH, newS, newL)
	local h,s,v = Color3.toHSV(Color);
	local h2 = (2-s) * v
	local h,s,l = newH or h%1, newS or (h2 < 1 and h2 or 2 - h2), newL or h2/2;
	
	s = s * (l < .5 and l or 1 - l);
	
	return Color3.fromHSV(h, 2*s/(l+s), l+s);
end;

function Color.editHSL(Color, operation, editH, editS, editL)
	local h,s,v = Color3.toHSV(Color);
	local h2 = (2-s) * v
	local h,s,l = op(h%1,editH,operation), (h2 < 1 and h2 or 2 - h2), editL or h2/2;
	s,l = op(s,editS,operation), op(l,editL,operation);
	
	s = s * (l < .5 and l or 1 - l);
	
	return Color3.fromHSV(h, 2*s/(l+s), l+s);
end;
function Color:getMonochromatic(Color, intervals, limit)
	limit = 1 - ((limit or 0)/100)
	intervals = intervals or 5
	local h,s,l = self.toHSL(Color)
	local max, min = l + limit, l - limit
	max,min = max <= 1 and max or 1, min >= 0 and min or 0
	local afr, afl = (max - l) / intervals, (l - min) / intervals
	local l1, l2 = l, l
	local tab = {Color}
	
	for i = 1, intervals do
		l1 = l1 + afr;
		l2 = l2 - afl;
		table.insert(tab,1,self.fromHSL(h,s,l2))
		tab[i+1] = Color;
		tab[intervals + 3 + i] = self.fromHSL(h,s,l1)
	end
	return tab
end;

function Color.getTriadic(Color)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + 120) %360))/360,s,v), fh(abs(((h0 + 240) %360))/360,s,v)};
end;

function Color.getTetradic(Color)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + 90) %360))/360,s,v), fh(abs(((h0 + 180) %360))/360,s,v), fh(abs(((h0 + 270) %360))/360,s,v)};
end;

function Color.getShades(Color, intervals)
	intervals = intervals or 10
	local h,s,v = Color3.toHSV(Color);
	local sp, sv = (1-s) / (intervals), v / intervals;
	local tab = {Color};
	local abs = math.abs
	
	for i = 1, intervals do
		s = s + sp;
		v = v - sv;
		table.insert(tab,Color3.fromHSV(h,s <= 1 and s or 1,v >= 0 and v or 0));
	end

	return tab;
end;

function Color.getTints(Color, intervals)
	intervals = intervals or 10
	local h,s,v = Color3.toHSV(Color);
	local sp, sv = s / (intervals), (1-v) / intervals;
	local tab = {Color};
	local abs = math.abs
	
	for i = 1, intervals do
		s = s - sp;
		v = v + sv;
		table.insert(tab,Color3.fromHSV(h,s >= 0 and s or 0,v <= 1 and v or 1));
	end

	return tab;
end;

function Color.getComplementary(Color, split)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + (split and 150 or 180)) %360))/360,s,v), split and fh(abs((((h0 + 210) %360)))/360,s,v) or nil};
end;

function Color.getAnalogous(Color, split)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + 30) %360))/360,s,v), fh(abs(((h0 + (split and 60 or 330)) %360))/360,s,v), split and fh(abs(((h0 + 90) %360))/360,s,v) or nil};
end;

function Color.getInverse(Color)
	return Color3.new(1 - Color.r, 1 - Color.g, 1 - Color.b);
end;

wait(2)

local color = BrickColor.Random().Color
local base;
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,100,0,100)
frame.BorderSizePixel = 0
frame.BackgroundColor3 = color
local textBox = Instance.new("TextLabel",frame)
textBox.Size = UDim2.new(1,0,1,0)
textBox.BackgroundTransparency = 1
textBox.Font = Enum.Font.GothamSemibold
textBox.TextSize = 17


function newBase(colors, ti)
	local head = Instance.new("Frame", script.Parent)
	head.Draggable = true
	head.Active = true
	head.Position = UDim2.new(math.random(2,8)/10,math.random(0,100),math.random(2,8)/10,math.random(0,100))
	head.BackgroundColor3 = Color3.new(0,.01,0)
	head.BackgroundTransparency = .85
	head.BorderColor3 = Color3.new(1,1,1)
	local ghost = Instance.new("Frame",head)
	ghost.Size = UDim2.new(1,0,1,0)
	ghost.Transparency = 1;
	local b = Instance.new("UIListLayout",ghost)
	b.Padding = UDim.new(0,3)
	b.FillDirection = 'Horizontal'
	b.HorizontalAlignment = 'Center'
	b.VerticalAlignment = 'Center'
	b.SortOrder = 'LayoutOrder'
	local title = Instance.new("TextLabel", head)
	title.Position = UDim2.new(0,0,1,0)
	title.AnchorPoint = Vector2.new(0,1)
	title.Text = ti or "Untitled Base"
	title.Font = Enum.Font.Gotham
	title.TextScaled = true;
	title.Size = UDim2.new(1,0,0,12);
	title.TextColor3 = Color3.new(1,1,1);
	title.BackgroundTransparency = 1;
	
	head.MouseEnter:connect(function(child)
		head.BackgroundTransparency = .7
	end)
	head.MouseLeave:connect(function(child)
		head.BackgroundTransparency = .86
	end)
	ghost.ChildAdded:connect(function(child)
		local c = #ghost:GetChildren() - 1
		head.Size = UDim2.new(0,c * 100 + (c + 1) * 3 + 12, 0, 124)
	end)
	
	base = setmetatable({Base = head, Main = ghost, Layout = b, TitleField = title},{
		__newindex = function(self, ind, new)
			if ind == 'title' then
				self.TitleField.Text = new;
			end
		end;
		__index = function(self, ind)
			local tab = {}
			for i,v in next, self:getChildren() do
				if v.ClassName == 'Frame' then
					table.insert(tab, v)
				end
			end
			return tab[ind];
		end
	})
	
	if colors then
		if type(colors) == 'table' then
			insertFrames(colors)
		else
			newFrame(color);
		end
	end	
	
	return base;
end



textBox.Changed:connect(function(a)
	if a == 'Text' then
		
	end
end)

function newFrame(color, par)
	par = par or base.Main
	frame.BackgroundColor3 = color;
	local h,s,l = Color.toHSL(color)
	if (l + s) / 2 < .8 then
		frame.TextLabel.TextColor3 = Color3.new(1,1,1);
	else
		frame.TextLabel.TextColor3 = Color3.new(.2,.2,.2);
	end	
	frame.TextLabel.Text = Color.toHex(color,true);
	frame.LayoutOrder = #par:GetChildren()
	frame:Clone().Parent = par;
end;

function insertFrames(tabl)
	for i,v in next, tabl do
		newFrame(v);
	end
end


--[[
newBase(Color.getComplementary(color), "Complementary")
newBase(Color.getComplementary(color,true), "Complementary Split")
newBase(Color.getTriadic(color), "Triadic")
newBase(Color.getAnalogous(color), "Analogous")
newBase(Color.getAnalogous(color, true), "Analogous Split")
newBase(Color.getTetradic(color), "Tetradic")
]]
--[[
newBase(Color.getTints(color), "Tints")
newBase(Color.getShades(color), "Shades")
newBase(Color:getMonochromatic(color), "Monochromatic")
newBase(Color.getTints(color,4), "Intervals of 5 Tints")
newBase(Color.getShades(color,4), "Intervals of 5 Shades")
newBase(Color:getMonochromatic(color,3,75), "Intervals of 2 Monochromatic with 15% Limit")
]]

newBase(Color.getComplementary(color), "Complementary")
newBase(Color.getTriadic(color), "Triadic")
newBase(Color.getAnalogous(color), "Analogous")
newBase(Color.getTints(color), "Tints")
newBase(Color.getShades(color), "Shades")
newBase(Color:getMonochromatic(color,2,50), "Monochromatic 50%")
