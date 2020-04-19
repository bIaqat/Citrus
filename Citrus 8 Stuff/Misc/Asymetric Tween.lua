function Citrus.motion:asymetricTween(Object, Property, duration, UDimX, UDimY, d1, e1, d2, e2)
	local gelf = getmetatable(self).__index;
	local lerpUDim = gelf.Lerps.UDim
	local heart = game:GetService('RunService').Heartbeat
	local startPos = Object[Property];
	local startX, startY = startPos.X, startPos.Y
	local connection, x, y
	local elapsed = 0;

	connection = heart:connect(function(step)
		elapsed = elapsed + step;
		if elapsed >= duration and connection then
			connection:disconnect()
			Object[Property] = UDim2.new(UDimX, UDimY);
		else
			x = lerpUDim(startX, UDimX, d1 and self:getEasing(d1,e1)(elapsed, 0, 1, duration) or elapsed/duration)
			y = lerpUDim(startY, UDimY, d2 and self:getEasing(d2,e2)(elapsed, 0, 1, duration) or elapsed/duration)

			Object[Property] = UDim2.new(x, y);
		end
	end)

	return connection;
end

function Citrus.motion:fullAsymetricTween(Object, Property, duration, UDimX, UDimY, d1, e1, d2, e2)
	local gelf = getmetatable(self).__index;
	local lerpUDim = gelf.Lerps.UDim
	local heart = game:GetService('RunService').Heartbeat
	local startPos = Object[Property];
	local startX, startY = startPos.X, startPos.Y
	local connection, x, y
	local elapsed = 0;
	local duration2 = duration
	if type(duration) == 'table' then
		duration2 = duration[2]
		duration = duration[1]
	end
	
connection = heart:connect(function(step)
	elapsed = elapsed + step;
	if elapsed >= (duration > duration2 and duration or duration2) and connection then
		connection:disconnect()
		Object[Property] = UDim2.new(UDimX, UDimY);
	else
		x = elapsed < duration  and lerpUDim(startX, UDimX, d1 and self:getEasing(d1,e1)(elapsed, 0, 1, duration) or elapsed/duration) or nil
		y = elapsed < duration2 and lerpUDim(startY, UDimY, d2 and self:getEasing(d2,e2)(elapsed, 0, 1, duration2) or elapsed/duration2) or nil
		
		Object[Property] = UDim2.new(x, y);
	end
end)

	return connection;
end
--c = Citrus.motion:asymetricTween(frame, 'Size', .5, UDim.new(0,math.random(50,500)), UDim.new(0,math.random(50,500)), 'Out', 'Quad', 'In', 'Sine')
	
	
function Citrus.Beta.motion:asymetricTween(Object, Property, duration, endValues, ...)
	local gelf = getmetatable(self).__index;	
	local _, first = next(endValues)
	local lerp = gelf.Lerps[typeof(first)]
	local dataTypes = {["BrickColor"] = BrickColor, ["Color3"] = Color3,["UDim"] = UDim, ["UDim2"] = UDim2, ["Vector2"] = Vector2, ["Vector3"] = Vector3};
	local dataTypeArgs = {BrickColor = {'r', 'g', 'b'}, Color3 = {'r', 'g', 'b'}, UDim = {'Scale', 'Offset'}, UDim2 = {'X', 'Y'}, Vector2 = {'X', 'Y'}, Vector3 = {'X', 'Y', 'Z'}};	
	local heart = game:GetService('RunService').Heartbeat
	local startValue = Object[Property];
	local dataType = dataTypes[typeof(startValue)];
	local values, connection = {}
	local ev = {}	
	local args = dataTypeArgs[typeof(startValue)]
	for i,v in next, args do
		ev[i] = endValues[v]
	end
	local elapsed = 0;
	local easings = {...}
	
	
	connection = heart:connect(function(step)
		elapsed = elapsed + step;
		if elapsed >= duration and connection then
			connection:disconnect()
			Object[Property] = dataType.new(unpack(ev));
		else
			for i,v in next, args do
				values[i] = lerp(startValue[v], endValues[v], easings[i] and self:getEasing(easings[i][1],easings[i][2])(elapsed, 0, 1, duration) or elapsed/duration)
			end

			Object[Property] = dataType.new(unpack(values));
		end
	end)
	return connection;
end
--c = Citrus.Beta.motion:asymetricTween(frame, 'Size', .5, {X = UDim.new(0,math.random(50,500)), Y = UDim.new(0,math.random(50,500))}, {'Out', 'Quad'}, {'In', 'Sine'})