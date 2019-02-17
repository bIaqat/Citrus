function newStopWatch(startOnCreation)
	local watch = {
		elapsedTime = 0;
		isRunning = false;
		reset = function(self)
			getmetatable(self).timer = 0
		end;
		start = function(self)
			self(true)
		end;
		stop = function(self)
			self(false)
		end;
		toggle = function(self)
			self()
		end;
	}
	local watchMeta = {
		last = 0;
		startTime = 0;
		timer = nil;
		run = function(self)
			local s = getmetatable(self)
			local tm
			tm = game:GetService('RunService').Heartbeat:connect(function()
				self.elapsedTime = tick() - s.startTime - s.last
				if self.isRunning == false or s.timer == 0 then
					tm:disconnect()
					s.timer = nil
					s.last = tick() - s.startTime - s.last
				end
				if s.timer == 0 then
					tm:disconnect()
					s.timer = nil
					s.startTime = 0
					s.last = 0
					self.elapsedTime = 0
					self.isRunning = false
				end
			end)
			s.timer = tm
		end;
		__index = function(self, id)
			if id == "life" then
				return tick() - getmetatable(self).startTime
			end
		end;
		__call = function(self, setTo)
			local s = getmetatable(self)
			if setTo then
				self.isRunning = setTo
			else
				self.isRunning = not self.isRunning
			end
			if self.isRunning and s.timer == nil then
				if s.startTime == 0 then
					s.startTime = tick()
				end
				s.run(self)
			end
		end;
		__tostring = function(self)
			local s = getmetatable(self)
			return "𝓒stopWatch: Elapsed: "..math.ceil(self.elapsedTime*100-.5)/100
		end;
	}	
	watch = setmetatable(watch,watchMeta)
	if startOnCreation then
		watch:start()
	end
	return watch
end

function newTimer(duration, startOnCreation, functionOnEnd, functionOnTick)
	local watch = newStopWatch()
	local timer
	timer = {
		start = function(self)
			self(true)
		end;
		stop = function(self)
			self(false)
		end;
		reset = function(self)
			local s = getmetatable(self)
			s.watch:reset()
			s.timer:disconnect()
			s.timer = nil
			s.last = 0
			s.timeLeft = self.duration
		end;
		onFinished = functionOnEnd or function(self)
			warn(self)
		end;
		onEachTick = functionOnTick or function(self,tim)
			print(self,tim)
		end;
		timeLeft = duration or 0;
		duration = duration or 0;
	}
	local timerMeta = {
		watch = watch;
		timer = nil;
		last = 0;
		__index = function(self, ind)
			local s = getmetatable(self)
			if ind == 'isRunning' then
				return s.watch.isRunning
			elseif ind == 'watch' then
				return s.watch
			end
		end;
		__call = function(self,setTo)
			local s = getmetatable(self)
			s.watch(setTo)
			if self.isRunning and s.timer == nil then
				if s.last == 0 then
					s.last = self.duration
				end
				s.run(self)
			end			
		end;
		run = function(self)
			local s = getmetatable(self)
			local tm
			tm = game:GetService('RunService').Heartbeat:connect(function()
				self.timeLeft = self.duration - s.watch.elapsedTime
				local wt = math.ceil(self.timeLeft - .5)
				if wt < s.last then
					self:onEachTick(self.timeLeft)
					s.last = wt
				end
				if self.timeLeft <= 0 then
					self:onFinished()
					s.timer:disconnect()
					s.timer = nil
					s.watch:reset()
					s.last = 0
					self.timeLeft = self.duration
					
				end
			end)
			s.timer = tm
		end;
		__tostring = function(self)
			return "𝓒timer: Time Left: " .. math.ceil(self.timeLeft-.5) .. " / " .. self.duration 
		end
	}
	timer = setmetatable(timer,timerMeta)
	if startOnCreation then
		timer:start()
	end
	return timer
end
--[[
		--[[
		stopWatch:reset()
		stopWatch:start()
		stopWatch:toggle()
		stopWatch:stop()
		stopWatch.isRunning
		stopWatch.elapsedTime
		stopWatch.life
	--]]
local a = newStopWatch() --newStopWatch(StartOnCreation)

print(a) -- print time
a:start() -- start
wait(3)
print(a) -- print time
a:stop() -- stop, warn time
wait(3)
a:start() -- start
wait(3)
print(a) -- print time
a:stop() --stop, warn time
--]]

--[[
		--[[
		timer:start()
		timer:stop()
		timer:reset()
		timer.onFinished(timer)
		timer.onEachTick(timer, timeLeft)
		timer.timerLeft
		timer.duration
		timer.watch
		timer.isRunning
		--]]
local a = newTimer(5, false,  --newTimer(Duration, StartOnCreation, EndFunction, OnEachTickFunction)
	function(timer)
		warn'\nGOBBLE GOBBLE GOBBLE!!!!'
		print(timer.watch)
		print(timer)
	end,
	function(timer, timeLeft)
		print(math.ceil(timeLeft).. " seconds remaining...")
	end
)
a:start()
--]]