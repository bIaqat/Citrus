
local Spice = require(game.ReplicatedStorage["Spice v1.5"])
Tweening, Easing, Lerp = {}, {}, {}


Easing.Styles = {}
function Easing.getStyle(name)
	return Easing.Styles[name]
end
function Easing.getType(style,dir)
	return Easing.Styles[style][dir]
end
function Easing.insertType(style, dir, func)
	Easing.Styles[style][dir] = func
end
function Easing.newStyle(name,content)
	Easing.Styles[name] = nil
	for i,v in next, content do
		if type(v) == 'table' then
			content[i] = Easing.new(unpack(v))
		end
	end
	Easing.Styles[name] = content or {}
end
function Easing.fromBezier(x1, y1, x2, y2)					--function from RoStrap
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
end
function Easing.new(...)
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
		func = Easing.fromBezier(unpack(args))
	else
		func = args[1]
	end
	local style, direction = index[1] or 0, index[2] or 'Out'
	if style then
		if not Easing.Styles[style] then Easing.newStyle(style,{direction = func}) else Easing.insertType(style,direction,func) end
	else
		return func,warn'No style inserted'
	end
end

Easing.newStyle('Circular',{
	In = function(x)
		return 1 - math.sqrt(1-x*x)
	end;
	InOut = function(x)
		x = x * 2
		if x < 1 then
			return -.5 * (math.sqrt(1-x*x)-1)
		else
			x = x - 2
			return .5 * (math.sqrt(1-x*2)+1)
		end
	end;
	Out = function(x)
		x = x - 1
		return math.sqrt(1 - (x * x))
	end
})
Easing.newStyle('Cubic',{
	In = function(x)
		return x^3
	end;
	InOut = function(x)
		x = x * 2
		if x < 1 then
			return .5 * x^3
		else
			x = x - 2
			return .5 * (x^3 + 2)
		end
	end;
	Out = function(x)
		x = x - 1
		return x^3 + 1
	end
})
Easing.newStyle('Expo',{
	In = function(x)
		return math.pow(2,10*(x-1)) - .001;
	end;
	InOut = function(x)
		x = x * 2
		if x < 1 then
			return .5 * math.pow(2,10*(x-1))
		else
			return .5 * (2-math.pow(2,-10*(x-1)))
		end
	end;
	Out = function(x)
		return 1 -  math.pow(2,-10*x)
	end
})

function Tweening.new(obj,prop,en,dur,style,dir)
	local func
	if type(style) ~= 'function' and ((type(style) == 'string' and pcall(function() return Enum.EasingStyle[style] and true or false end)) or typeof(style) == 'EnumItem') then
		return Spice.Tweening.new(obj,prop,en,dur,style,dir)
	elseif type(style) ~= 'function' then
		func = Easing.getType(style,dir)
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
end


local frame = Instance.new("Frame", Instance.new("ScreenGui",script.Parent))
frame.AnchorPoint = Vector2.new(.5,.5)
frame.Position = UDim2.new(.5,0,.5,0)
frame.Size = UDim2.new(.1,0,.1,0)
wait(3)
Tweening.new(frame,'BackgroundColor3',Color3.new(1,0,0),1,Easing.fromBezier(0,0,0,0))