Motion = setmetatable({
	Easings = setmetatable({},{
		__index = function(self, index)
			for i,v in next, {
				newStyle = function(Name, Types,...) --creates a section for new easings under a keyname such as Quad
					if ... then Types = self.fromBezier(Types,...) end
					self[Name] = Types and (type(Types) == 'table' and Types or type(Types) == 'function' and {Out = Types}) or {}
				end;
				newStyleType = function(Style, Name, Function,...) --creates a type (typically a direction) for a easing style such as InOut
					if ... then Function = self.fromBezier(Function,...) end
					if not self[Style] then self[Style] = {} end
					self[Style][Name] = Function
				end;
				getStyle = function(Name)
					return self[Name]
				end;
				getStyleType = function(Style, Type)
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
				local self = getmetatable(self)
				self.__index = {}
				self.__index[i] = v
				if i == index then
					return v
				end
			end
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
	tweenedObjects = {}
	__index = function(self,index)
		for i,v in next, {
			customTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat)
				if cancel then self.cancelTween(Object) end
				for i,v in next, type(Property) == 'table' and Property or {Property} do
					Property[v] = {Object[v],type(EndValue) == 'table' and EndValue[i] or EndValue}
					Property[v][3] = self.Lerps[typeof(Property[v])]
					Property[i] = nil
				end
				local easingFunction = EasingStyle and type(EasingStyle) == 'function' and EasingStyle or self.Easings.getType(EasingStyle or 'Quad', EasingDirection or 'Out')
				local time, rep, elapsed
				local heart = game:GetService('RunService').Heartbeat
				local function reset()
					time, rep = Duration or 0, Repeat or 0
					elapsed = 0
				end
				reset()	
				local function tween(en)
					for i,v in next, Property do
						if not en then
							Object[i] = v[3](v[1],v[2], easingFunction(elapsed))
						else
							Object[i] = v[2]
						end
					end
				end	
				local playing, connection = false
				local function stepped(step)
					local function go()
						elapsed = elapsed + step
						if time > elapsed then
							tween()
						else
							connection:Disconnect()
							tween(true)
						end	
					end
					if playing then
						go()
					elseif rep > 0 or rep < 0 then
						rep = rep - 1
						go()
					else
						connection:Disconnect()
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
				table.insert(getmetatable(self).tweenedObjects,tween)
				return tween
			end;
			tweenServiceTween = function(Object, Property, EndValue, Duration, cancel, EasingStyle, EasingDirection, Repeat, Reverse, Delay)
				if cancel then self.cancelTween(Object) end
				for i,v in next, type(Property) == 'table' and Property or {Property} do
					Property[v] = type(EndValue) == 'table' and EndValue[i] or EndValue
					Property[i] = nil
				end
				local tween = game:GetService('TweenService'):Create(Object,
					TweenInfo.new(Duration,
						EasingStyle and (type(EasingStyle) == 'string' and Enum.EasingStyle[EasingStyle] or EasingStyle) or Enum.EasingStyle.Quad,
						EasingDirection and (type(EasingDirection) == 'string' and Enum.EasingDirection[EasingDirection] or EasingDirection) or Enum.EasingDirection.Out,
						Repeat or 0, Reverse or false, Delay or 0
					),
					Property
				)
				tween:Play()
				table.insert(getmetatable(self).tweenedObjects,tween)
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
			cancelTween = function(Object)
				pcall(function() --im lazy lol
					if Object then
						getmetatable(self).tweenedObjects[Object]:Cancel()
					else
						for i,v in next, getmetatable(self).tweenedObjects do
							v:Cancel()
						end
					end
				end)
			end;
			asymmetricTween = function(Object, Property, End, tim, cancel, easing)--function from RoStrap
				if cancel then self.cancelTween(Object) end
				local easing = easing or self.Easings.fromBezier(0.4, 0.0, 0.2, 1)
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
			rotate = function(Object, Angle, Custom, ...)
				local EndValue = Object.Rotation + Angle
				return Custom and self.customTween(Object,'Rotation',EndValue,...) or self.tweenServiceTween(Object,'Rotation',EndValue,...)
			end;
		} do
			local self = getmetatable(self)
			self.__index = {}
			self.__index[i] = v
			if i == index then
				return v
			end
		end
	end
});