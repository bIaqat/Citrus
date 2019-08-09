--[[
function Motion:createTween(Object, propertyTable, duration, directionName, easingName, ...)
	local tween = game:GetService('TweenService'):Create(Object, TweenInfo.new(
			duration or 1, 
			easingName and Enum.EasingStyle[easingName] or Enum.EasingStyle[1], 
			directionName and Enum.EasingDirection[directionName] or Enum.EasingDirection[1],
			...
		));

	return tween;
end;

function Motion:asymetricTween(Object, Property, duration, UDimX, UDimY, d1, e1, d2, e2)
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
]]


--[[
customTween
	:Cancel()
	:Pause()
	:Play()
	:onPlaybackChanged(function) playbackState
	:onCompletion(function) playbackState
	
	.Playbackstate
		(Unused
		Begin
		Delayed
		Playing
		Paused
		Completed
		Cancelled)
		
	.playbackState		
	
[READONLY]
	tweenInfo
	.startingValues (a propertyTable containig the values the properties were before the tween)
	.endingValues (the propertyTable entered by the user to tween to) 
	.duration (how long the tween will take)
	.direction (the Easing Direction chosen)
	.style (the Easing Style chosen)
	.repeating (how many times the tween will repeat)
	.reverse (if the tween will reverse)
	.delay (the delay before the tween starts)
	
	concurrentInfo
	.connection (the heartBeat connection currently used)
	.elapsed (how much time has currently elapsed since the tween started)
	.repeated (how many times the tween currently has repeated)
	.reversing (if the tween is currently reversing)
	.reversed (if the tween has reversed)
]]

function Citrus.Beta.motion:createTween(Object, propertyTable, duration, direction, easing, repeating, reverses, delayDuration)
	local bez = type(direction) == 'function' and '𝓒ustomEasingFunction'..math.random(999,99999)
	if bez then
		self:storeEasing(bez, bez, direction)
		direction = bez
		easing = bez
	end
	local gelf = getmetatable(self).__index;
	local lerps = gelf.Lerps;
	local heart = game:GetService('RunService').Heartbeat
	local elapsed = 0;
	
	local startingValues = {}
	for i,v in next, propertyTable do
		startingValues[i] = Object[i];
	end
	
	local tween = {
		Cancel = function(self)
			self.playbackState = 'cancelled';
		end;
		Pause = function(self)
			self.playbackState = 'paused';
		end;
		Play = function(self)
			if self.playbackState == 'paused' then
				self.playbackState = 'playing'
			else
				self.playbackState = 'delayed';
			end
		end;
		onPlaybackChanged = function(self, func)
			local e = getmetatable(self).playbackChanged
			local t = {id = #e, disconnect = function(self)
				e[self.id] = nil
			end, connect = function(self)
				table.insert(e, func)
			end
			}		
			return t;
		end;
		onCompletion = function(self, func)
			local e = getmetatable(self).completion
			local t = {id = #e, disconnect = function(self)
				e[self.id] = nil
			end, connect = function(self)
				table.insert(e, func)
			end
			}		
			return t;	
		end;	
	}
	
	local metaTween = {
		playbackChanged = {};
		completion = {};
		tweenInfo = {
			startingValues = startingValues;
			endingValues = propertyTable;
			duration = duration or 1;
			direction = direction or 'Out';
			style = easing or 'Linear';
			repeating = repeating or 0;
			reverse = reverses or false;
			['delay'] = delayDuration or 0;
		};
		liveInfo = {
			playbackState = 'unused';
			connection = false;
			elapsed = 0;
			repeated = 0;
			reversing = false;
			reversed = false;
		};
		__index = function(self, ind)
			local gelf = getmetatable(self)
			return gelf.tweenInfo[ind] or gelf.liveInfo[ind] or nil;
		end;
		__newindex = function(self, ind, new)
			local g = getmetatable(self)
			local l = g.liveInfo
			if g.tweenInfo[ind] then
				error(ind..' cannot be assigned to');
			elseif ind == 'playbackState' then
				local state = new
				if (l.playbackState == 'unused' or l.playbackState == 'cancelled' or l.playbackState == 'completed') and new == 'delayed' then
					state = 'begin'
					g.play(self);
				end
				for i,v in next, g.playbackChanged do
					coroutine.wrap(v)(state);
				end
				g.liveInfo.playbackState = new;	
			else
				error('readonly table')
			end
		end;
		play = function(tw)
			local g = getmetatable(tw)
			local info, live = g.tweenInfo, g.liveInfo
			live.connection = heart:connect(function(step)
				local state, reverse = live.playbackState, info.reverse
				if state == 'playing' then
					live.elapsed = live.elapsed + step;
					local elapsed = live.elapsed
					if elapsed >= duration then
						if reverse and not live.reversed then
							live.reversed = true;
							live.reversing = reverse and not live.reversing;
							live.elapsed = 0;
						else
							if info.repeating > live.repeated then
								live.repeated = live.repeated + 1;
								tw.playbackState = 'delayed'
							elseif live.connection then
								live.connection:disconnect()
								live.repeated = 0;
								tw.playbackState = 'completed'
							end			
							live.elapsed = 0;
							live.reversing = false;
							live.reversed = false;
							for i,v in next, g.completion do
								v('completed');
							end
							
							for i,v in next, reverse and startingValues or propertyTable do
								Object[i] = v
							end
						end
					else
						for i,v in next, propertyTable do
							if live.reversing then
								Object[i] = lerps[typeof(Object[i])](v, startingValues[i], self:getEasing(info.direction, info.style)(elapsed, 0, 1, duration))
							else
								Object[i] = lerps[typeof(Object[i])](startingValues[i], v, self:getEasing(info.direction, info.style)(elapsed, 0, 1, duration))
							end
						end
					end
				elseif state == 'delayed' then
					live.elapsed = live.elapsed + step;
					if live.elapsed >= info.delay then
						tw.playbackState = 'playing'
						live.elapsed = 0;
					end
				elseif state == 'cancelled'  then
					live.connection:disconnect()
					live.elapsed = 0;
					live.repeated = 0;
					live.reversing = false;
				end
				
			end)
		end
	}
	
	return setmetatable(tween, metaTween);
end