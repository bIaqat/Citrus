Table = {
	insert = function(tabl,...)
		for i,v in pairs(...) do 
			if type(v) == 'table' then
				Spice.Table.insert(tabl,v)
			else
				rawset(tabl,i,v)
			end
		end
	end;
	pack = function(tabl,start,en)
		local new = {}
		for i = start or 1, en or #tabl do
			table.insert(new,tabl[i])
		end
		return new
	end;
	mergeTo = function(from,to)
		for i,v in next, from do
			to[i] = v
		end
		return to
	end;
	merge = function(a,b)
		local a,b = Spice.Table.clone(a), Spice.Table.clone(b)
		return Spice.Table.mergeTo(b,a)
	end;
	clone = function(tab)
		local clone = {}
		for i,v in next,tab do
			if type(v) == 'table' then
				clone[i] = Spice.Table.clone(v)
				if getmetatable(v) then
					local metaclone = Spice.Table.clone(getmetatable(v))
					setmetatable(clone[i],metaclone)
				end
			else
				clone[i] = Spice.Instance.getObjectOf(v) or v
			end
		end
		if getmetatable(tab) then
			local metaclone = getmetatable(tab)
			setmetatable(clone,metaclone)
		end
		return clone
	end;
	contains = function(tabl,contains)
		for i,v in next,tabl do
			if v == contains or (typeof(i) == typeof(contains) and v == contains) or i == contains then
				return true,v,i
			end
		end
		return nil
	end;
	toNumeralIndex = function(tabl)
		local new = {}
		for index,v in next,tabl do
			if type(index) ~= 'number' then
				table.insert(new,{index,v})
			else
				table.insert(new,index,v)
			end
		end
		setmetatable(new,{
				__index = function(self,index)
					for i,v in next,self do
						if type(v) == 'table' and v[1] == index then
							return v[2]
						end
					end
				end
				})
		return new
	end;
	length = function(tab)
		return #Spice.Table.toNumeralIndex(tab)
	end;
	reverse = function(tab)
		local new ={}
		for i,v in next,tab do
			table.insert(new,tab[#tab-i+1])
		end
		return new
	end;
	indexOf = function(tabl,val)
		return Spice.getArgument(3,Spice.Table.contains(tabl,val))
	end;
	valueOfNext = function(tab,nex)
		local i,v = next(tab,nex)
		return v
	end;
	find = function(tabl,this)
		return Spice.getArgument(2,Spice.Table.contains(tabl,this))
	end;
	search = function(tabl,this,extra,keep)
		if not getmetatable(tabl) then setmetatable(tabl,{}) end
		local meta = getmetatable(tabl)
		if not meta['0US3D'] then
			meta['0US3D'] = {}
		end
		local used = meta['0US3D']
		local likely = {}
		if used[this] then
			return unpack(used[this])
		end
		if Spice.Table.contains(tabl,this) then
			local found = Spice.Table.find(tabl,this)
			if not extra then used[this] = {found} return found end
			table.insert(likely, found)
		end
		for i,v in next,tabl do
			if typeof(v) == 'Instance' then
				i = v.Name
			end
			if type(i) == 'string' or type(v) == 'string' then
				local subject = type(i) == 'string' and i or type(v) == 'string' and v
				local caps = Spice.Misc.stringFilterOut(subject,'%u',nil,false,true)
				local numc = caps..(subject:match('%d+$') or '')
				if subject:lower():sub(1,#this) == this:lower() or caps:lower() == this:lower() or numc:lower() == this:lower() then
					if not extra then
						used[this] = {v, i}
						return v, i
					end
					table.insert(likely,v)
				end
			end
		end
		table.sort(likely,function(a,b) if #a == #b then return a:lower() < b:lower() end return #a < #b end);
		local resin = Spice.Table.indexOf(tabl,likely[1])
		local firstresult = tabl[resin]
		used[this] = {keep and #likely > 0 and likely or firstresult and firstresult or false, firstresult and Spice.Table.indexOf(tabl,firstresult), likely}
		return keep and #likely > 0 and likely or firstresult and firstresult or false, firstresult and Spice.Table.indexOf(tabl,firstresult), likely
	end;
	anonSetMetatable = function(tabl,set)
		local old = getmetatable(tabl)
		local new = Spice.Table.clone(setmetatable(tabl,set))
		setmetatable(tabl,old)
		return new
	end;
};