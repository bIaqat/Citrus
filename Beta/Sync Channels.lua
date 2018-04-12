Sync = setmetatable({
	getChannel = function(name)
		return getmetatable(Spice.Sync).Channels[name]
	end;
	getObject = function(name)
		return Spice.Sync.getChannel(name).Object
	end;
	getValue = function(name,ind)
		return Spice.Sync.getChannel(name).Values[ind or 0]
	end;
	insertObject = function(name,obj,prop)
		local ch = Spice.Sync.getChannel(name)
		local prop = Spice.Properties[prop]
		if not ch.Objects[obj] then
			ch.Objects[obj] = {}
		end
		if prop and not Spice.Table.find(ch.Objects[obj],prop) then
			table.insert(ch.Objects[obj],prop)
		end
		if ch.Sync then
			ch:Sync()
		end
		return ch
	end;
	removeObject = function(name,obj,prop)
		local ch = Spice.Sync.getChannel(name)
		if not prop then
			ch.Object[obj] = nil
		else
			local ob = ch.Object[obj]
			ob[Spice.Table.indexOf(ob,prop) or 0] = nil
		end
		return ch
	end;
	insertValue = function(name,val,ind)
		local ch = Spice.Sync.getChannel(name)
		ch.Values[ind or #ch.Values + 1] = val
		return ch
	end;	
	setValue = function(name,ind)
		local ch = Spice.Sync.getChannel(name)
		ch.ActiveVal = Spice.Sync.getValue(name,ind)
		return ch
	end;
	insertValue = function(name,val,ind)
		local ch = Spice.Sync.getChannel(name)
		ch.Values[ind or 0] = val
		return ch
	end;
	sync = function(self,nam)
		local t = nam and true or false
		local ch = nam and Spice.Sync.getChannel(nam)
		for i,v in next, ch and ch.Objects or getmetatable(self).Channels do
			if not nam then
				Spice.Sync:sync(i.Name)
			else
				for z,x in next, v do
					i[x] = ch.ActiveVal
				end
			end
		end
		return ch
	end;
	lerpSync = function(name,time,...)
		local ch = Spice.Sync.getChannel(name)
		for obj, props in next, ch.Objects do
			for index, prop in next, props do
				Spice.Misc.tweenService(obj,prop,ch.ActiveVal,time,...)
			end
		end
		return ch
	end;
	call = function(name,...)
		local ch = Spice.Sync.getChannel(name)
		if ch.Type == 'Function' then
			local args = ... and {...} or ch.Args
			for i,v in next, ch.Objects do
				ch.Function(i,unpack(args))
			end
		end
	end;
	insertKeyFrame = function(name, val, id, index)
		local ch = Spice.Sync.getChannel(name)
		if ch.Type == 'Array' then
			ch.Values[index or 0][id or #ch.Values[index or 0] + 1] = val
		end
	end;
	removeKeyFrame = function(name,id,index)
		local ch = Spice.Sync.getChannel(name)
		if ch.Type == 'Array' then
			local bas = ch.Values[index or 0]
			bas[id] = nil
			for i = id + 1, #bas do
				bas[i-1] = bas[i]
				bas[i] = nil
			end
		end
	end;
	playFrames = function(name,delay,index,lerp,...)
		local ch = Spice.Sync.getChannel(name)
		if ch.Type == 'Array' then
			ch.playingState = 'playing'
			ch.isPlaying = true
			local bas = ch:Get(index)
			local ind = Spice.Table.indexOf(ch.ActiveVal) or 1
			for i = ind or 1, #bas do
				if ch.isPlaying then
					ch.ActiveVal = bas[i]
					if lerp then
						Spice.Sync.lerpSync(name,delay or 1,...)
					else
						Spice.Sync:sync(name)
					end
					wait(delay or 1)
				end
			end
			ch.ActiveVal = nil
			if ch.Looping then
				if ch.isPlaying then
					ch:Play(ind,delay,ind,index,lerp,...)
				end
			end
		end
	end;
	pauseFrames = function(name)
		local ch = Spice.Sync.getChannel(name)
		if ch.Type == 'Array' then
			ch.playingState = 'paused'
			ch.isPlaying = false
		end
	end;
	stopFrames = function(name)
		local ch = Spice.Sync.getChannel(name)
		if ch.Type == 'Array' then
			ch:Pause()
			ch.ActiveVal = nil
		end
	end;	

	run = function(name,...)	
		local ch = Spice.Sync.getChannel(name)
		if ch.Type == 'Function' then
			local args = #({...}) > 0 and {...} or ch.Args
			for i,v in next, ch.Objects do
				ch.Function(i,unpack(args))
			end
		end
	end;
	new = function(name, base, ...)
		local typ = Spice.Misc.switch("Single","Array","Function"):Filter(0, 'table', 'function')((type(base) == 'table' or type(base) == 'function') and type(base) or 1)
		local sync = setmetatable({
			ActiveVal = 0;
			Name = name or '#'..Spice.Table.length(getmetatable(Spice.Sync).Channels);
			Values = {[0]=base,...};
			Objects = {};
			Type = typ;
			Insert = function(self,...)
				return Spice.Sync.insertObject(self.Name,...)
			end;
			Remove = function(self,...)
				return Spice.Sync.removeObject(self.Name,...)
			end;
			Set = function(self,to,ind)
				self:SetVal(to,ind)
				self:SetActive(ind)
				if self.Sync then
					self:Sync()
				end
			end;
			SetVal = function(self,...)
				return Spice.Sync.insertValue(self.Name,...)
			end;
			SetActive = function(self,...)
				return Spice.Sync.setValue(self.Name,...)
			end;
			Get = function(self,...)
				return Spice.Sync.getValue(self.Name,...)
			end;
		},{
			__tostring = function(self)
				return 'Sync '..self.Type..': '..tostring(self.Value)
			end;
			__index = function(self,ind)
				if ind == 'Value' then
					return self.ActiveVal
				end
			end
		})
		getmetatable(Spice.Sync).Channels[name] = sync;
		if typ == 'Array' then
			sync.Looping = false
			sync.Active = 0
			sync.isPlaying = false
			sync.playingState = 'stopped'
			sync.Play = function(self,...)
				return Spice.Sync.playFrames(self.Name,...)
			end
			sync.Pause = function(self,...)
				return Spice.Sync.pauseFrames(self.Name,...)
			end
			sync.Stop = function(self,...)
				return Spice.Sync.stopFrames(self.Name,...)
			end
			sync.AddFrame = function(self,...)
				return Spice.Sync.insertKeyFrame(self.Name,...)
			end;
			sync.RemoveFrame = function(self,...)
				return Spice.Sync.removeKeyFrame(self.Name,...)
			end;
		elseif typ == 'Function' then
			sync.Function = base
			sync.Args = {...}
			sync.Call = function(self,...)
				return Spice.Sync.call(self.Name,...)
			end;
			sync.setArgs = function(self,...)
				self.Args = {...}
			end;
			sync.setFunction = function(self,fun,...)
				self.Function = fun
				self:setArgs(...)
			end;
		else
			sync.Toggle = function(self)
				if #self.Values ==  2 then
					if self.ActiveVal == self.Values[0] then
						self:SetVal(1)
					else
						set:SetVal(0)
					end
				end
			end;
			sync:SetActive(0);
			sync.Sync = function(self,...)
				return Spice.Sync:sync(self.Name,...)
			end;
			sync.Lerp = function(self,...)
				return Spice.lerpSync(self.Name,...)
			end;
		end		
		return sync
	end
	},{
	Channels = {}; 
})