Citrus.misc.newTimeline = function(duration, step)
	return setmetatable({
		add = function(self, o, p, s, d, pos, endpos)	
			if p == true then
				pos, endpos = pos or s, endpos or d
				o,p,s,d = opsd(o);
			end
			local self = getmetatable(self).__index
			self:check(pos)
			self:check(endpos)
			local entry = {self.duration, Object = o, Properties = {}, Style = s, Direction = d}
			for i,v in next, p do
				entry.Properties[i] = o[i];
			end
			table.insert(self.timeline[pos], entry)
			self.timeline[self.duration][o] = p;
		end;
		remove = function(self, o, pos)
			local self = getmetatable(self).__index
			local c = 0;
			for i,v in next, self.timeline do
				for z,x in next, v do
					if x.Object == o then
						c = c + 1;
						if pos and c == pos then
							self.timeline[i][z] = nil
						end
					end
				end
			end
		end;
		new = function(self, duration, step)
			local gelf = getmetatable(self).__index
			gelf:check(0)
			gelf:check(duration)
			gelf.duration = duration;
			if step then
				for i = 1, step, 1 do
					gelf:check(i*duration/step);
				end
				gelf.step = true
			end
			return self
		end;
		start = function(alf)
			local self = getmetatable(alf).__index
			if self.elapsed == 0 then
				self.timeline2 = Citrus.table:clone(self.timeline)
			end
			local t = self.timeline2
			self.heartbeat = game:GetService('RunService').Heartbeat:connect(function(step)
				self.elapsed = self.elapsed + step;
				if self.elapsed < self.duration + step then
					for i,v in next, t do
						if self:check(i) then
							for q,x in next, v do
								if type(x) == 'table' then
									if x[1] and self.elapsed-i <= x[1]-i then
										for prop,val in next, x.Properties do
											x.Object[prop] = getmetatable(Citrus.motion).__index.Lerps[typeof(val)](val, t[x[1]][x.Object][prop], Citrus.motion:getEasing(x.Direction, x.Style)(self.elapsed - i, 0, 1, x[1] - i))
										end
									elseif x[1] then
										for prop,val in next, x.Properties do
											x.Object[prop] = t[x[1]][x.Object][prop]
										end						
									end
								end
							end
						end			
					end
				else
					alf:stop()
				end
			end)
		end;
		stop = function(self)
			local self = getmetatable(self).__index
			self.heartbeat:disconnect()
			for i,v in next, self.timeline do
				v.Passed = false;
			end
			self.elapsed = 0;
		end;
		pause = function(self)
			self.heartbeat:disconnect();
		end
	},{
		__tostring = function(self)
			local str = ""
			for i,v in next, getmetatable(self).__index.timeline do
				str = str..i.."\n";
				for i,x in next, v do
					str = str..("\t"..(type(x) == 'table' and (x.Object and x.Object.ClassName or x[1]) or i ~= 'Passed' and (type(i) == 'userdata' and i.ClassName or i) or "")).."\n";
				end
			end
			return str
		end;
		timeline = {};
		__index = {
			check = function(self, i)
				if self.timeline[i] then
					if i < self.elapsed and self.timeline2[i].Passed == false then
						self.timeline2[i].Passed = true
						return true
					end
					return i < self.elapsed;
				elseif i then
					if i > self.duration then
						self.duration = i;
					end
					self.timeline[i] = {Passed = false};
				end
			end;
			elapsed = 0;
			step = false;
			timeline = {};
			heartbeat = false;
			duration = 0;
		}
	}):new(duration, step)
end 

--[[
local frames = {}

for i = 0, 5 do
	local frame = Instance.new("Frame", Instance.new("ScreenGui", script.Parent))
	frame.Position = UDim2.new(0,0,0,110*i+50)
	frame.AnchorPoint = Vector2.new(0,.5)
	frame.Name = i+1;
	frame.Size = UDim2.new(0,100,0,100)	
	local a = .5+(1-.5)/5*i
	opsd(frame, {BackgroundColor3 = Color3.new(math.random(0,1) == 1 and a or 0,math.random(0,1) == 1 and a or 0,math.random(0,1) == 1 and a or 0),Position = UDim2.new(.5,0,0,110*i+75), AnchorPoint = Vector2.new(.5,.5)}, "Elastic", "Out")
	table.insert(frames,frame)
end


function delayTween(objects, props, duration, del, style, direction)

	local timeline = Citrus.misc.newTimeline(duration)

	local counter = 0
	for _,obj in next, objects do
		local cd = counter * del
		timeline:add(obj, props, style, direction, cd, duration + cd)
		counter = counter + 1
	end
	print(timeline.duration)
	timeline:start()
	
	return timeline;		
end

wait(1)
delayTween(frames, true, 3, .2) 
]]