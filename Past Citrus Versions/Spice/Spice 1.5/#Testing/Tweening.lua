Tweening = setmetatable({
	new =(obj,prop,en,dur,style,dir)
		local func
		if type(style) ~= 'function' and ((type(style) == 'string' and pcall(function() return Enum.EasingStyle[style] and true or false end)) or typeof(style) == 'EnumItem') then
			return Spice.Tweening.lerp(obj,prop,en,dur,style,dir)
		elseif type(style) ~= 'function' then
			func = Spice.Tweening.getEasingType(style,dir)
		else
			func = style
		end
		local types = {
			['Color3'] = {Lerp = function(a,b,c)
				local x = function(a,b,c)
					return a +b * (c - a)
				end
				return Color3.new(x(a.r,b.r,c),x(a.g,b.g,c),x(a.b,b.b,c))
			end};
			['Vector2'] = Vector2.new();
			['UDim2'] = UDim2.new();
			['CFrame'] = CFrame.new();
			['Vector3'] = Vector3.new();
			number = {Lerp = {function(self,b,c)
				return self + b * (c - self)
			end}};
		}
		local hb = game:GetService("RunService").Heartbeat
		local start,last = obj[prop],0
		local con
		con = hb:connect(function(step)
			last = last + step
			if dur > last then
				obj[prop] = types[typeof(obj[prop])].Lerp(start,en,func(last))
			else
				con:Disconnect()
				obj[prop] = en
			end
		end)
	end;
	lerp = function(what,prop,to,...)
		if type(what) == 'table' and type(what[1]) == 'userdata' then
			local data = {}
			for i,what in next,what do
				data[i] = Spice.Tweening.new(what,prop,to,...)
			end
			return data
		end
		what = Spice.getInstanceOf(what)
		local args = {...}
		local props = {}
		local tim,style,direction,rep,reverse,delay
		for i,v in next,args do
			if type(v) == 'string' or typeof(v) == 'EnumItem' then
				if style == nil then
					style = v and type(v) ~= 'string' or Enum.EasingStyle[v]
				else
					direction = v and type(v) ~= 'string' or Enum.EasingDirection[v]
				end
			elseif type(v) == 'number' then
				if tim == nil then
					tim = v
				elseif rep == nil then
					rep = v
				else
					delay = v
				end
			elseif type(v) == 'boolean' then
				reverse = v
			end
		end
		for i,v in next,type(prop) == 'table' and prop or {prop} do
			props[Spice.Properties[v]] = type(to) ~= 'table' and to or to[i]
		end
		return game:GetService('TweenService'):Create(what,TweenInfo.new(tim,style or Enum.EasingStyle.Linear,direction or Enum.EasingDirection.In,rep or 0,reverse or false,delay or 0),props):Play()
	end;	
	getEasingStyle = function(name)
		return getmetatable(Spice.Tweening).Styles[name]
	end;
	getEasingType = function(style,dir)
		return getmetatable(Spice.Tweening).Styles[style][dir]
	end;
	newEasingType = function(style, dir, func)
		getmetatable(Spice.Tweening).Styles[style][dir] = func
	end;
	newEasingStyle = function(name,content)
		getmetatable(Spice.Tweening).Styles[name] = nil
		for i,v in next, content do
			if type(v) == 'table' then
				content[i] = Spice.Tweening.newEasing(unpack(v))
			end
		end
		getmetatable(Spice.Tweening).Styles[name] = content or {}
	end;
	typeFromBezier = function(x1, y1, x2, y2)--function from RoStrap
		if not (x1 and y1 and x2 and y2) then error("Need 4 numbers to construct a Bezier curve") end
		if not (0 <= x1 and x1 <= 1 and 0 <= x2 and x2 <= 1) then error("The x values must be within range [0, 1]") end
		if x1 == y1 and x2 == y2 then
			return function(x) return x end
		end
		local e, f = 3*x1, 3*x2
		local g, h, i = 1 - f + e, f - 2*e, 3*(1 - f + e)
		local j, k = 2*h, 3*y1
		local l, m = 1 - 3*y2 + k, 3*y2 - 2*k
		local SampleValues = {}
		for a = 0, 10 do
			local z = a*0.1
			SampleValues[a] = ((g*z + h)*z + e)*z -- CalcBezier
		end
		return function(t)
			if t == 0 or t == 1 then
				return t
			end
			local CurrentSample = 9
			for a = 1, CurrentSample do
				if SampleValues[a] > t then
					CurrentSample = a - 1
					break
				end
			end
			local IntervalStart = CurrentSample*0.1
			local GuessForT = IntervalStart + 0.1*(t - SampleValues[CurrentSample]) / (SampleValues[CurrentSample + 1] - SampleValues[CurrentSample])
			local InitialSlope = (i*GuessForT + j)*GuessForT + e
			if InitialSlope >= 0.001 then
				for NewtonRaphsonIterate = 1, 4 do
					local CurrentSlope = (i*GuessForT + j)*GuessForT + e
					if CurrentSlope == 0 then break end
					GuessForT = GuessForT - (((g*GuessForT + h)*GuessForT + e)*GuessForT - t) / CurrentSlope
				end
			elseif InitialSlope ~= 0 then
				local IntervalStep = IntervalStart + 0.1

				for BinarySubdivide = 1, 10 do
					GuessForT = IntervalStart + 0.5*(IntervalStep - IntervalStart)
					local BezierCalculation = ((g*GuessForT + h)*GuessForT + e)*GuessForT - t

					if BezierCalculation > 0 then
						IntervalStep = GuessForT
					else
						IntervalStart = GuessForT
						BezierCalculation = -BezierCalculation
					end

					if BezierCalculation <= 0.0000001 then break end
				end
			end
			return ((l*GuessForT + m)*GuessForT + k)*GuessForT
		end
	end;
	newEasing = function(...)
		local args = {...}
		local index = {}
		local func
		if #args > 4 or args[2] and type(args[2]) == 'string' then
			for i,v in next, args do
				if type(v) == 'string' then
					table.insert(index,v)
					table.remove(args,v)
				end
			end
		end
		if #args > 1 then
			func = Spice.Tweening.typeFromBezier(unpack(args))
		else
			func = args[1]
		end
		local style, direction = index[1] or 0, index[2] or 'Out'
		if style then
			if not getmetatable(Spice.Tweening).Styles[style] then Spice.Tweening.newEasingStyle(style,{direction = func}) else Spice.Tweening.newEasingType(style,direction,func) end
		else
			return func,warn'No style inserted'
		end
	end;
	asymmetricTween = function(Object, Property, End, tim, easing)--function from RoStrap
		local easing = easing or Bezier.new(0.4, 0.0, 0.2, 1)
		local Heartbeat = game.GetService('RunService').Heartbeat
		local StartX = Object[Property].X
		local StartY = Object[Property].Y
		local EndX = End.X
		local EndY = End.Y	
		local XStartScale = StartX.Scale
		local XStartOffset = StartX.Offset
		local YStartScale = StartY.Scale
		local YStartOffset = StartY.Offset	
		local XScaleChange = EndX.Scale - XStartScale
		local XOffsetChange = EndX.Offset - XStartOffset
		local YScaleChange = EndY.Scale - YStartScale
		local YOffsetChange = EndY.Offset - YStartOffset
		local ElapsedTime, Connection = 0
		local Clone = Object:Clone()
		Clone.Name = ""
		Clone[Property] = End
		Clone.Visible = false
		Clone.Parent = Object.Parent
		if Object.AbsoluteSize.X * Object.AbsoluteSize.Y < Clone.AbsoluteSize.X * Clone.AbsoluteSize.Y then
			Clone:Destroy()
			local Duration = tim or 0.375
			local HeightStart = Duration*0.1
			local WidthDuration = Duration*0.75
			Connection = Heartbeat:Connect(function(Step)
				ElapsedTime = ElapsedTime + Step
				if Duration > ElapsedTime then
					local XScale, XOffset, YScale, YOffset

					if WidthDuration > ElapsedTime then
						local WidthAlpha = easing(ElapsedTime, 0, 1, WidthDuration)
						XScale = XStartScale + WidthAlpha*XScaleChange
						XOffset = StartX.Offset + WidthAlpha*XOffsetChange
					else
						XScale = Object[Property].X.Scale
						XOffset = Object[Property].X.Offset
					end

					if ElapsedTime > HeightStart then
						local HeightAlpha = easing(ElapsedTime - HeightStart, 0, 1, Duration)
						YScale = YStartScale + HeightAlpha*YScaleChange
						YOffset = YStartOffset + HeightAlpha*YOffsetChange
					else
						YScale = YStartScale
						YOffset = YStartOffset
					end

					Object[Property] = UDim2.new(math.ceil(XScale), math.ceil(XOffset), math.ceil(YScale), math.ceil(YOffset))
				else
					Connection:Disconnect()
					Object[Property] = End
				end
			end)
		else
			Clone:Destroy()
			local Duration = tim or .375
			local WidthStart = Duration*0.15
			local HeightDuration = Duration*0.95
			Connection = Heartbeat:Connect(function(Step)
				ElapsedTime = ElapsedTime + Step
				if Duration > ElapsedTime then
					local XScale, XOffset, YScale, YOffset
		
					if HeightDuration > ElapsedTime then
						local HeightAlpha = easing(ElapsedTime, 0, 1, HeightDuration)
						YScale = YStartScale + HeightAlpha*YScaleChange
						YOffset = YStartOffset + HeightAlpha*YOffsetChange
					else
						YScale = Object[Property].Y.Scale
						YOffset = Object[Property].Y.Offset
					end
		
					if ElapsedTime > WidthStart then
						local WidthAlpha = easing(ElapsedTime - WidthStart, 0, 1, Duration)
						XScale = XStartScale + WidthAlpha*XScaleChange
						XOffset = XStartOffset + WidthAlpha*XOffsetChange
					else
						XScale = XStartScale
						XOffset = XStartOffset
					end
		
					Object[Property] = UDim2.new(math.ceil(XScale), math.ceil(XOffset), math.ceil(YScale), math.ceil(YOffset))
				else
					Connection:Disconnect()
					Object[Property] = End
				end
			end)
		end
		return Connection
	end;
	tweenGuiObject = function(object,typ,...)
		typ = typ:lower()
		object = Spice.Instance.getInstanceOf(object)
		local interupt,udim,udim2,time,style,direction,after = true
		for i,v in pairs({...})do
			if typeof(v) == 'UDim2' then
				udim2 = udim and v or nil
				udim = udim and udim or v
			elseif type(v) == 'function' then
				after = v
			elseif type(v) == 'boolean' then
				interupt = v
			elseif type(v) == 'number' then
				time = v
			elseif type(v) == 'string' then
				style = style and style or v
				direction = style and nil or v
			end
		end
		if udim2 then
			object:TweenSizeAndPosition(udim2,udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		elseif typ:find'p' then
			object:TweenPosition(udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		else
			object:TweenSize(udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		end
	end;	
	rotate = function(object, to, timer)
		object = Spice.Instance.getInstanceOf(object)
		Spice.Tweening.lerp(object, 'Rotation', to, timer)
	end
},{
	Styles = {};
}