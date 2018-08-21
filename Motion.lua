Motion = setmetatable({
	Easings = setmetatable({
		},{
		__index = function(self, index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				newStyle = function(Name, Types,...) --creates a section for new easings under a keyname such as Quad
					if ... then Types = self.fromBezier(Types,...) end
					self[Name] = Types and (type(Types) == 'table' and Types or type(Types) == 'function' and {Out = Types}) or {}
				end;
				newDirection = function(Style, Name, Function,...) --creates a type (typically a direction) for a easing style such as InOut
					if ... then Function = self.fromBezier(Function,...) end
					if not self[Style] then self[Style] = {} end
					self[Style][Name] = Function
				end;
				getStyle = function(Name)
					return self[Name]
				end;
				getDirection = function(Style, Type)
					return self[Style][Type]
				end;
				fromBezier = function(x1, y1, x2, y2)--function from RoStrap
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
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end;
	});
 	Lerps = {
		['Color3'] = Color3.new().Lerp;
		['Vector2'] = Vector2.new().Lerp;
		['UDim2'] = UDim2.new().Lerp;
		['CFrame'] = CFrame.new().Lerp;
		['Vector3'] = Vector3.new().Lerp;
		['UDim'] = function(a, b, c)
			local function x(y)
				return a[y] + c * (b[y] - a[y])
			end
			return UDim.new(x'Scale',x'Offset')
		end;
		number = function(a,b,c)
			return a + c * (b - a)
		end
	};
},{
	tweenedObjects = {};
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			customTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat)
				Property = type(Property) == 'table' and Property or {Property}
				if cancel then self.cancelTween(Object,table.concat(Property)) end
				for i = 1,#Property do
					local v = Property[i]
					Property[v] = {Object[v],type(EndValue) == 'table' and EndValue[i] or EndValue,self.Lerps[typeof(EndValue)]}
					Property[i] = nil
				end
				local easingFunction = EasingStyle and (type(EasingStyle) == 'function' and EasingStyle or self.Easings.getDirection(EasingStyle, EasingDirection or 'Out'))
				local time, rep, elapsed
				local heart = game:GetService('RunService').Heartbeat
				local function reset()
					time, rep = Duration or 0, Repeat or 0
					elapsed = 0
				end
				reset()	
				local function tween(en,rep)
					for i,v in next, Property do
						if rep then
							Object[i] = v[1]
						elseif not en then
							Object[i] = v[3](v[1],v[2], easingFunction and easingFunction(elapsed/Duration) or elapsed/Duration)
						else
							Object[i] = v[2]
						end
					end
				end	
				local playing, connection = false
				local function stepped(step)
					if not (elapsed == 0 and step > 1) then
						local function go()
							elapsed = elapsed + step
							if time > elapsed then
								tween()
							else
								tween(true)
								playing = 'check'
							end	
						end
						
						if playing == true then
							go()
						elseif playing == 'check' and (rep == true or rep > 0 or rep < 0) then
							rep = rep == true or rep - 1
							elapsed = 0
							tween(false,true)
							playing = true
						else
							playing = false
							connection:Disconnect()
						end		
					end
				end	
				local tween = setmetatable({},{
					__index = {
						Play = function(self)
							playing = true
							connection = heart:connect(stepped)
						end;
						Pause = function(self)
							playing = false
						end;
						Cancel = function(self)
							playing = false
							reset()
						end;
					}
				})
				tween:Play()
				local to = getmetatable(self).tweenedObjects
				if not to[Object] then to[Object] = {} end
				for i,v in next, Property do
					to[Object][i] = tween
				end
				return tween
			end;
			tweenServiceTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat, Reverse, Delay)
				local Property = type(Property) == 'table' and Property or {Property}
				if cancel then self.cancelTween(Object,table.concat(Property)) end
				for i = 1,#Property do
					local v = Property[i]
					Property[v] = type(EndValue) == 'table' and EndValue[i] or EndValue
					Property[i] = nil
				end
				local tween = game:GetService('TweenService'):Create(Object,
					TweenInfo.new(Duration,
						EasingStyle and (type(EasingStyle) == 'string' and Enum.EasingStyle[EasingStyle] or EasingStyle) or Enum.EasingStyle.Quad,
						EasingDirection and (type(EasingDirection) == 'string' and Enum.EasingDirection[EasingDirection] or EasingDirection) or Enum.EasingDirection.Out,
						Repeat and (Repeat == true and -1 or Repeat) or 0, Reverse or false, Delay or 0
					),
					Property
				)
				tween:Play()
				local to = getmetatable(self).tweenedObjects
				if not to[Object] then to[Object] = {} end
				local str = ''
				for i,v in next, Property do
					to[Object][i] = tween
				end
				return tween
			end;
			lerp = function(BeginingValue, EndValue, Alpha, EasingStyle, EasingDirection)
				local Lerps = self.Lerps
				return Lerps[typeof(BeginingValue)](BeginingValue, EndValue, 
					EasingStyle and ((type(EasingStyle) == 'string' and self.Easings[EasingStyle][EasingDirection or 'Out'](Alpha) ) or
						type(EasingStyle) == 'function' and EasingStyle(Alpha) 
					) or
					Alpha
				)
			end;
			cancelTween = function(Object,Property)
				pcall(function() --im lazy lol
					if Object and Property then
						for i,v in next, getmetatable(self).tweenedObjects[Object] do
							if i:find(Property) then
								v:Cancel()
							end
						end
					elseif Object then
						for i,v in next, Object do
							v:Cancel()
						end
					else
						for i,Object in next, getmetatable(self).tweenedObjects do
							for i,v in next, Object do
								v:Cancel()
							end
						end
					end
				end)
			end;
			rotate = function(Object, Angle, Speed,Custom, ...)
				local EndValue = Object.Rotation + Angle
				return Custom and self.customTween(Object,'Rotation',EndValue,Speed,...) or self.tweenServiceTween(Object,'Rotation',EndValue,Speed,...)
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
