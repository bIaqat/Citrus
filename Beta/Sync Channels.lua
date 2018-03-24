--Sync Table Remake

Sync = setmetatable({
	getChannel = function(name)
		return getmetatable(Citrus.Sync).Channel[name]
	end;
	getObject = function(name)
		return Citrus.Sync.getChannel(name).Object
	end;
	getValue = function(name,ind)
		return Citrus.Sync.getChannel(name).Value[ind or 0]
	end;
	insertObject = function(name,obj,prop)
		local ch = Citrus.Sync.getChannel(name)
		if not ch.Objects[obj] then
			ch.Objects[obj] = {}
		end
		if prop and not Citrus.Table.find(ch.Objects[obj],prop) then
			table.insert(ch.Objects[obj],prop)
		end
		return ch
	end;
	removeObject = function(name,obj,prop)
		local ch = Citrus.Sync.getChannel(name)
		if not prop then
			ch.Object[obj] = nil
		else
			local ob = ch.Object[obj]
			ob[Citrus.Table.indexOf(ob,prop) or 0] = nil
		end
		return ch
	end;
	insertValue = function(name,val,ind)
		local ch = Citrus.Sync.getChannel(name)
		ch.Values[ind or #ch.Values + 1] = val
		return ch
	end;	
	setValue = function(name,val,ind)
		local ch = Citrus.Sync.getChannel(name)
		ch.Values[ind or 0] = val
		return ch
	end;
	sync = function(self,nam)
		local t = nam and true or false
		local ch = nam and Citrus.Sync.getChannel(nam)
		for i,v in next, ch.Objects or getmetatable(self).Channels do
			if not nam then
				Citrus.Sync:sync(i)
			else
				for z,x in next, v do
					i[x] = ch.ActiveVal
				end
			end
		end
		return ch
	end
	lerpSync = function(name,time,...)
		local ch = Citrus.Sync.getChannel(name)
		for obj, props in next, ch.Objects do
			for index, prop in next, props do
				Misc.tweenService(obj,prop,ch.ActiveVal,time,...)
			end
		end
		return ch
	end
	new = function(name, base, ...)
		local typ = Citrus.Misc.switch("Value","Array","Function"):Filter(0, 'table', 'function')((type(base) == 'table' or type(base) == 'function') and type(base) or 1)
		local sync = {
			ActiveVal = 0;
			Name = name or '#'..Citrus.Table.length(getmetatable(Citrus.Sync).Channels)
			Values = {[0]=base,...};
			Objects = {};
			Type = typ;

			Insert = function(self,...)
				return Citrus.Sync.insertObject(self.Name,...)
			end;
			Remove = function(self,...)
				return Citrus.Sync.removeObject(self.Name,...)
			end;
			Set = function(self,...)
				return Citrus.Sync.setValue(self.Name,...)
			end;
			Get = function(self,...)
				return Citrus.Sync.getValue(self.Name,...)
			end;
		}
		if typ == 'Array' then
			sync.Active = 0
			sync.isPlaying = false
			sync.playingState = 'stopped'
			sync.Play = function(self,...)
				return Citrus.Sync.playFrames(self.Name,...)
			end
			sync.Pause = function(self,...)
				return Citrus.Sync.pause(self.Name,...)
			end
			sync.Stop = function(self,...)
				return Citrus.Sync.stop(self.Name,...)
			end
			sync.AddFrame = function(self,...)
				return Citrus.Sync.insertKeyFrame(self.Name,...)
			end;
			sync.RemoveFrame = function(self,...)
				return Citrus.Sync.removeKeyFrame(self.Name,...)
			end;
		elseif typ == 'Function' then
			sync.Function = base
			sync.Args = {...}
			sync.Call = function(self,...)
				return Citrus.Sync.run(self.Name,...)
			end;
			sync.setArgs = function(self,...)
				self.Args = {...}
			end;
			sync.setFunction = function(self,fun,...)
				self.Function = fun
				if ... then
					self:setArgs(...)
				end
			end;
		else
			sync.Toggle = function(self)
				if self
			sync.Sync = function(self,...)
				return Citrus:sync(self.Name,...)
			end;
			sync.Lerp = function(self,...)
				return Citrus.lerpSync(self.Name,...)
			end;
		end
		getmetatable(Citrus.Sync).Channels[name] = sync;
		return sync
	end
	},{
	Channels = {}; 
})