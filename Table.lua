Table = setmetatable({
	insert = function(tabl, ...)--... inserting
		local insert
		insert = function(x)
			for i,v in next, x do
				if type(v) == 'table' then
					insert(v)
				else
					rawset(tabl,i,v)
				end
			end
		end;
		insert({...})
		return tabl
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
	clone = function(tab)
		local clone
		clone = function(x)
			local cloned = {}
			for i,v in next,x do
				if type(v) == 'table' then
					rawset(cloned,i,clone(v))
				else
					if typeof(i) == 'Instance' then i = i:Clone() end
					if typeof(v) == 'Instance' then v = v:Clone() end
					rawset(cloned,i,v)
				end
			end	
			if getmetatable(x) then
				local metaclone = getmetatable(x)
				setmetatable(cloned,metaclone)
			end		
			return cloned
		end
		return clone(tab)
	end;
	contains = function(tabl,contains)
		for i,v in next,tabl do
			if v == contains or i == contains then
				return true
			end
		end
		return nil
	end;
	toNumeralIndex = function(tabl)
		for i,v in next, tabl do
			if type(i) ~= 'number' then
				table.insert(tabl,v)
				tabl[i] = nil
			end
		end
		return tabl
	end;
	length = function(tabl)
		local count = 0
		for i,v in next, tabl do
			count = count + 1
		end
		return count
	end;
	reverse = function(tabl)
		local new = {}
		for i,v in next, tabl do
			if type(i) == 'number' then
				new[#tabl-i+1] = v
			else
				new[i] = v
			end
			tabl[i] = nil
		end
		for i,v in next, new do
			tabl[i] = v
		end
		return tabl
	end;
	indexOf = function(tabl,val)
		for i,v in next, tabl do
			if v == val then
				return i
			end
		end
	end;
	find = function(tabl,this, keepFound,...) --...compareFunction function(this, index, value)
		local found = {}
		local compareFunctions = {...}
		if #compareFunctions == 0 then compareFunctions = nil end
		for i,v in next, tabl do
			if i == this or v == this or 
				(type(this) == 'string' and (
					 type(i) == 'string'  and i:sub(1,#this):lower() == this:lower() or 
					 type(v) == 'string' and v:sub(1,#this):lower() == this:lower() or
					 typeof(v) == 'Instance' and v.Name:sub(1,#this):lower() == this:lower()
				)) or compareFunctions and ({pcall(function()	
						for _,compareFunction in next, compareFunctions do
							if compareFunction(this,i,v) then
								return true
							end
						end 
					return false
				end)})[2] == true
			then
				if not keepFound then
					return v, i
				else
					table.insert(found,{v,i})
				end
			end
		end
		if keepFound then return found end
	end;
},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			mergeClone = function(a,b) --bypasses no call back rule
				local a,b = self.clone(a), self.clone(b)
				return self.mergeTo(b,a)
			end;
			search = function(tabl, this, skipStored, keepSimilar, returnFirst, subStringSearch, capSearch, ...) --relies on Table.find; bypasses no call back rule
				local index, value, capAlg, subAlg
				--Saved Results means less elapsed time if searched again
				if not getmetatable(tabl) then setmetatable(tabl,{}) end
				local meta = getmetatable(tabl) 
				if not meta['SpiceSearchResultsStorage'] then
					meta['SpiceSearchResultsStorage'] = {}
				end
				local usedStorage = meta['SpiceSearchResultsStorage']		
				--Search functions
				if capSearch then
					function capAlg(comparative, ind, val)
						local subject = type(ind) == 'string' and ind or type(val) == 'string' and val
						if subject then
							local strin = ''
							for cap in subject:gmatch('%u') do
								strin = strin..cap
							end
							strin = strin..(subject:match('%d+$') or '')
							if strin:lower() == comparative:lower() then
								return true
							end
						end
						return false
					end
				end	
				if subStringSearch then
					function subAlg(comparative, ind, val)
						local subject = (type(ind) == 'string' and ind or type(val) == 'string' and val):lower()
						return subject and subject:find(comparative:lower(), 1, true) and true or false
					end
				end
				--Checks the Used Storage for 'this' and returns if exists
				if not skipStored then
					local stored = usedStorage[this]
					if stored then
						value, index = stored[1], stored[2]
					end
					if value and index then
						usedStorage[this] = {value, index}
						return value, index
					end
				end	
				--Checks if 'this' is found with chosen specified means
				value, index = self.find(tabl, this, keepSimilar or false,
					subAlg, capAlg, ...
				)
				if value and index then
					usedStorage[this] = {value, index}
					return value, index
				end	
				--Returns the results if keepSimilar
				if keepSimilar and value then
					table.sort(value,function(a,b)
						a, b = a[1], b[1]
						local function get(x) 
							return type(x) == 'table' and #x or type(x) == 'string' and #x:lower() or type(x) == 'number' and x or typeof(x) == 'Instance' and #x.Name or type(x) == 'boolean' and (x == true and 4 or x == false and 5) 
						end
						local lena, lenb = get(a), get(b)
						if type(a) == 'string' and type(b) == 'string' then if lena == lenb then return a:lower() < b:lower() else  return lena < lenb end end 
						return lena < lenb
					end);
					return returnFirst and value[1][1] or value, returnFirst and value[1][2] or nil
				end
				return false
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
