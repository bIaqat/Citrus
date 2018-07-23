Color = {
	fromRGB = function(r,g,b)
		return Color3.fromRGB(r,g,b)
	end;
	toRGB = function(Color)
		return math.ceil(Color.r*255),math.ceil(Color.g*255),math.ceil(Color.b*255)
	end;
	editRGB = function(Color, operation, r, g, b)
		operation = operation or '+'
		return 
		operation == '+' and Color3.fromRGB(Color.r + r, Color.g + g, Color.b + b) or
		operation == '-' and Color3.fromRGB(Color.r - r, Color.g - g, Color.b - b) or
		operation == '/' and Color3.fromRGB(Color.r / r, Color.g / g, Color.b / b) or		
		(operation == '*' or operation == 'x') and Color3.fromRGB(Color.r * r, Color.g * g, Color.b * b) or
		operation == '^' and Color3.fromRGB(Color.r ^ r, Color.g ^ g, Color.b ^ b) or
		(operation == 'rt' or operation == '^/') and Color3.fromRGB(Color.r ^ (1/r), Color.g ^ (1/g), Color.b ^ (1/b)) or
		operation == '%' and Color3.fromRGB(Color.r % r, Color.g % g, Color.b % b)
	end;
	setRGB = function(Color, newR, newG, newB)
		return Color3.fromRGB(newR or Color.r, newG or Color.g, newB or Color.b)
	end;	
	fromHSV = function(h,s,v)
		return Color3.fromHSV(h/360,s/100,v/100)
	end;
	toHSV = function(Color)
		local h,s,v = Color3.toHSV(Color)
		return math.ceil(h*360),math.ceil(s*100),math.ceil(v*100)
	end;
	editHSV = function(Color, operation, h, s, v)
		local operation ,ch,cs,cv = operation or '+', Color3.fromHSV(Color)
		return operation == '+' and Color3.fromHSV(ch + h, cs + s, cv + v) or
		operation == '-' and Color3.fromHSV(ch - h, cs - s, cv - v) or
		operation == '/' and Color3.fromHSV(ch / h, cs / s, cv / v) or		
		(operation == '*' or operation == 'x') and Color3.fromHSV(ch * h, cs * s, cv * v) or
		operation == '^' and Color3.fromHSV(ch ^ h, cs ^ s, cv ^ v) or
		(operation == 'rt' or operation == '^/') and Color3.fromHSV(ch ^ (1/h), cs ^ (1/s), cv ^ (1/v)) or
		operation == '%' and Color3.fromHSV(ch % h, cs % s, cv % v)
	end;
	setHSV = function(Color, newH, newS, newV)
		local h,s,v = Color3.toHSV(Color)
		return Color3.fromHSV((newH or h)/360,(newS or s)/100,(newV or v)/100)
	end;	
	fromHex = function(Hex)
		Hex = Hex:sub(1,1) == '#' and Hex:sub(2) or Hex
		local r,g,b =
			#Hex >= 6 and tonumber(Hex:sub(1,2),16) or #Hex >= 3 and tonumber(Hex:sub(1,1):rep(2),16),
			#Hex >= 6 and tonumber(Hex:sub(3,4),16) or #Hex >= 3 and tonumber(Hex:sub(2,2):rep(2),16),
			#Hex >= 6 and tonumber(Hex:sub(5,6),16) or #Hex >= 3 and tonumber(Hex:sub(3,3):rep(2),16)
		return Color3.fromRGB(r,g,b)
	end;
	toHex = function(Color, includeHash)
		return (includeHash and '#' or '')..string.format('%02X',Color.r)..string.format('%02X',Color.g)..string.format('%02X',Color.b)
	end;
	fromString = function(String, ...)
		local value = 0
		for i = 1,#String do
			local byteString = String:sub(i,i):byte()
			local inverse_i = #String - i + 1
			inverse_i = #String == 1 and inverse_i - 1 or inverse_i
			byteString = inverse_i % 4 >= 2 and -byteString or byteString
			value = value + byteString
		end
		local colors = {Color3.new(0.992157, 0.160784, 0.262745), Color3.new(0.00392157, 0.635294, 1), Color3.new(0.00784314, 0.721569, 0.341176), Color3.new(0.419608, 0.196078, 0.486275), Color3.new(0.854902, 0.521569, 0.254902), Color3.new(0.960784, 0.803922, 0.188235), Color3.new(0.909804, 0.729412, 0.784314), Color3.new(0.843137, 0.772549, 0.603922)}
		if ... then
			for i,v in next, {...} do
				table.insert(v)
			end
		end
		return colors[value % #colors + 1]
	end;
	toInverse = function(Color)
		local h,s,v = Color3.toHSV(Color)
		return Color3.fromHSV(1 - h, 1 - s, 1 - v)
	end;
	fromStored = function(Name, Key, ...) --... Index
		local index = Spice.Color.Colors
		for i,v in next, {...} do
			index = index[v]
		end
		local colors = index[Name]
		return colors[type(Key) == 'number' and Key or next(colors)]
	end;
	new = function(...)
		local args = {...}
		return
			type(args[1]) == 'string' and (args[1]:sub(1,1) == '#' and Spice.Color.fromHex(args[1]) or Spice.Color.fromStored(...)) or
			args[4] and Color3.fromHSV(args[1]/360,args[2]/100,args[3]/100) or
			Color3.fromRGB(args[1],args[2],args[3]) 
	end;
	Colors = setmetatable({},{
		__index = function(self,ind)
			for i,v in next, {
				new = function(Name, Color, ...) --Name, ColorSet,...   ... Index
					local index = self
					for i,v in next, {...} do
						if not index[v] then
							index[v] = {}
						end
						index = index[v]
					end
					if not index[Name] then index[Name] = type(Color) == 'table' and Color or {Color}
					else
						for i,v in next, type(Color) == 'table' and Color or {Color}  do
							index[Name][i] = v
						end
					end
				end;
				get = function(Name, ...) --... Index
					local index = self
					for i,v in next, {...} do
						index = index[v]
					end
					return index[Name]
				end;
				remove = function(Name, ...) --... Index
					local index = sself
					for i,v in next, {...} do
						index = index[v]
					end		
					index[Name] = nil
				end;
			} do
				local self = getmetatable(self)
				self.__index = {}
				self.__index[i] = v
				if i == ind then
					return v
				end
			end
		end
	});
	store = Spice.Color.Colors.new;
}