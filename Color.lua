Color = setmetatable({
		fromRGB = function(r,g,b)
			return Color3.fromRGB(r,g,b)
		end;
		toRGB = function(color)
			local r = Pineapple.Misc.Functions.round
			return r(color.r*255),r(color.g*255),r(color.b*255)
		end;
		editRGB = function(color,...)
			local round,op = Pineapple.Misc.Functions.round,Pineapple.Misc.Functions.operation
			local sign,nr,ng,nb,nc
			local args = {...}
			if type(args[1]) ~= 'string' then
				sign = '+'
				nr,bg,nb = args[1],args[2],args[3]
			else
				sign = args[1]
				nr,ng,nb = args[2],args[3],args[4]
				args[1],args[2],args[3] = nr,ng,nb
			end
			local r,g,b = Pineapple.Color.toRGB(color)
			nc = {r,g,b}
			if not b then
				if not g then
					g = 1
				end
				nc[g] = ope(nc[g],r,sign)
			else
				for i,v in pairs(nc)do
					nc[i] = op(v,args[i],sign)
				end
			end
			return Color3.fromRGB(unpack(nc))
		end;
		setRGB = function(color,...)
			local args = {...}
			local nr,ng,nb,nc
			local r,g,b = Pineapple.Color.toRGB(color)
			nc = {r,g,b}
			if #args < 3 then
				if not args[2] then
					args[2] = 1
				end
				nc[args[2]] = args[1]
			else
				for i,v in pairs(nc)do
					nc[i] = args[i]
				end
			end
			return Color3.fromRGB(unpack(nc))
		end;
		fromHSV = function(h,s,v)
			return Color3.fromHSV(h/360,s/100,v/100)
		end;
		toHSV = function(color)
			local r = Pineapple.Misc.Functions.round
			local h,s,v = Color3.toHSV(color)
			return r(h*360),r(s*360),r(v*360)
		end;
		editHSV = function(color,...)
			local round,op = Pineapple.Misc.Functions.round,Pineapple.Misc.Functions.operation
			local sign,nr,ng,nb,nc
			local args = {...}
			if type(args[1]) ~= 'string' then
				sign = '+'
				nr,bg,nb = args[1],args[2],args[3]
			else
				sign = args[1]
				nr,ng,nb = args[2],args[3],args[4]
				args[1],args[2],args[3] = nr,ng,nb
			end
			local r,g,b = Pineapple.Color.toHSV(color)
			nc = {r,g,b}
			if not b then
				if not g then
					g = 1
				end
				nc[g] = ope(nc[g],r,sign)
			else
				for i,v in pairs(nc)do
					nc[i] = op(v,args[i],sign)
				end
			end
			return Pineapple.Color.fromHSV(unpack(nc))
		end;
		setHSV = function(color,...)
			local args = {...}
			local nr,ng,nb,nc
			local r,g,b = Pineapple.Color.toHSV(color)
			nc = {r,g,b}
			if #args < 3 then
				if not args[2] then
					args[2] = 1
				end
				nc[args[2]] = args[1]
			else
				for i,v in pairs(nc)do
					nc[i] = args[i]
				end
			end
			return Pineapple.Color.fromHSV(unpack(nc))
		end;		
		fromHex = function(hex)
			if hex:sub(1,1) == '#' then
				hex = hex:sub(2)
			end
			local r,g,b
			if #hex >= 6 then
				r = tonumber(hex:sub(1,2),16)
				g = tonumber(hex:sub(3,4),16)
				g = tonumber(hex:sub(5,6),16)
			elseif #hex >= 3 then
				r = tonumber(hex:sub(1,1)
