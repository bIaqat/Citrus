Color = setmetatable({
	fromRGB = function(r,g,b)
		return Color3.fromRGB(r,g,b)
	end;
	toRGB = function(Color)
		return math.floor(Color.r*255),math.floor(Color.g*255),math.floor(Color.b*255)
	end;
	editRGB = function(Color, operation, r, g, b)
		local operation, cr,cg, cb = operation or '+', Color.r, Color.g, Color.b
		cr, cg, cb = cr * 255, cg * 255, cb * 255
		return 
		operation == '+' and Color3.fromRGB(cr + r, cg + g, cb + b) or
		operation == '-' and Color3.fromRGB(cr - r, cg - g, cb - b) or
		operation == '/' and Color3.fromRGB(cr / r, cg / g, cb / b) or		
		(operation == '*' or operation == 'x') and Color3.fromRGB(cr * r, cg * g, cb * b) or
		operation == '^' and Color3.fromRGB(cr ^ r, cg ^ g, cb ^ b) or
		(operation == 'rt' or operation == '^/') and Color3.fromRGB(cr ^ (1/r), cg ^ (1/g), cb ^ (1/b)) or
		operation == '%' and Color3.fromRGB(cr % r, cg % g, cb % b)
	end;
	setRGB = function(Color, newR, newG, newB)
		return Color3.fromRGB(newR or Color.r*255, newG or Color.g*255, newB or Color.b*255)
	end;	
	fromHSV = function(h,s,v)
		return Color3.fromHSV(h/360,s/100,v/100)
	end;
	toHSV = function(Color,i)
		local h,s,v = Color3.toHSV(Color)
		return math.floor(h*360),math.floor(s*100),math.floor(v*100)
	end;
	editHSV = function(Color, operation, h, s, v)
		local operation ,ch,cs,cv = operation or '+', Color3.toHSV(Color)
		h,s,v = h/360, s/100, v/100
		return 
		operation == '+' and Color3.fromHSV(ch + h, cs + s, cv + v) or
		operation == '-' and Color3.fromHSV(ch - h, cs - s, cv - v) or
		operation == '/' and Color3.fromHSV(ch / h, cs / s, cv / v) or		
		(operation == '*' or operation == 'x') and Color3.fromHSV(ch * h, cs * s, cv * v) or
		operation == '^' and Color3.fromHSV(ch ^ h, cs ^ s, cv ^ v) or
		(operation == 'rt' or operation == '^/') and Color3.fromHSV(ch ^ (1/h), cs ^ (1/s), cv ^ (1/v)) or
		operation == '%' and Color3.fromHSV(ch % h, cs % s, cv % v)
	end;
	setHSV = function(Color, newH, newS, newV)
		local h,s,v = Color3.toHSV(Color)
		return Color3.fromHSV(newH and newH / 360 or h,newS and newS / 100 or s,newV and newV / 100 or v)
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
		return (includeHash and '#' or '')..string.format('%02X',Color.r*255)..string.format('%02X',Color.g*255)..string.format('%02X',Color.b*255)
	end;
	fromString = function(String, replace, ...)
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
			if replace then colors = {} end
			for i,v in next, {...} do
				table.insert(colors,v)
			end
		end
		return colors[value % #colors + 1]
	end;
	toInverse = function(Color)
		local r,g,b = Color.r,Color.g,Color.b
		return Color3.new(1-r,1-g,1-b)
	end;
	Colors = setmetatable({},{
		__index = function(self,ind)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = function(Name, Color, ...) --... Index
					local index = self
					for i,v in next, {...} do
						if not index[v] then
							index[v] = {}
						end
						index = index[v]
					end
					if not index[Name] then index[Name] = Color
					else
						if type(index[Name]) ~= 'table' then index[Name] = {index[Name]} end
						for i,v in next, type(Color) == 'table' and Color or {Color}  do
							if type(i) == 'string' then
								index[Name][i] = v
							else
								table.insert(index[Name],v)
							end
						end
					end
				end;
				get = function(...) --... Index
					local index = self
					for i,v in next, {...} do
						index = index[v]
					end
					return index
				end;
				remove = function(Name, ...) --... Index
					local index = self
					for i,v in next, {...} do
						index = index[v]
					end		
					index[Name] = nil
				end;
			} do
				gelf.__index[i] = v
				if i == ind then
					return v
				end
			end
		end
	});
},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			fromStored = function(Name, Key, ...) --... Index
				local index = self.Colors
				for i,v in next, {...} do
					index = index[v]
				end
				local colors = index[Name]
				return colors and colors[type(Key) == 'number' and Key or next(colors)]
			end;
			new = function(...)
				local args = {...}
				return
					type(args[1]) == 'string' and (args[1]:sub(1,1) == '#' and self.fromHex(args[1]) or self.fromStored(...)) or
					type(args[1]) ~= 'string' and (args[4] and Color3.fromHSV(args[1]/360,args[2]/100,args[3]/100)) or
					type(args[1]) ~= 'string' and Color3.fromRGB(args[1],args[2],args[3]) or
					nil
			end;
			storeColor = self.Colors.new;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
