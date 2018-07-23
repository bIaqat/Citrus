Table = {
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
	mergeClone = function(a,b) --bypasses no call back rule
		local a,b = Spice.Table.clone(a), Spice.Table.clone(b)
		return Spice.Table.mergeTo(b,a)
	end;
	clone = function(tab)
		local cloned, clone = {}
		clone = function(x)
			for i,v in next,x do
				if type(v) == 'table' then
					cloned[i] = clone(v)
					if getmetatable(v) then
						local metaclone = clone(getmetatable(v))
						setmetatable(cloned[i],metaclone)
					end
				else
					cloned[i] = v
				end
			end	
			if getmetatable(x) then
				local metaclone = getmetatable(x)
				setmetatable(cloned,metaclone)
			end		
		end
		clone(tab)
		return cloned
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
		for i,v in next, tab do
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
<<<<<<< HEAD
	find = function(tabl,this, keepFound,...) --... function(this, index, value)
=======
	find = function(tabl,this, keepFound,...) --...compareFunction function(this, index, value)
>>>>>>> 3c933e55aacb9f3e847ccbb4c2de9c03a17a537d
		local found = {}
		for i,v in next, tabl do
			if i == this or v == this or 
				(type(this) == 'string' and (
					 type(i) == 'string'  and i:sub(1,#this):lower() == this:lower() or 
					 type(v) == 'string' and v:sub(1,#this):lower() == this:lower() or
					 typeof(v) == 'Instance' and v.Name:sub(1,#this):lower() == this:lower()
				)) or 
<<<<<<< HEAD
				if ... then for _,comp in next, {...} do
					comp(this,i,v)
				end end
=======
				for _,compareFunction in next, {...} do
					compareFunction(this, i, v)
				end
>>>>>>> 3c933e55aacb9f3e847ccbb4c2de9c03a17a537d
			then
				if not keepFound then
					return v, i
				else
					table.insert(found,{v,i})
				end
			end
		end
		if keepFound then return 
			found
		end
	end;
	search = function(tabl, this, skipStored, keepSimilar, returnFirst, capSearch, ...) --relies on Table.find; bypasses no call back rule
		local index, value, capAlg	
		--Saved Results means less elapsed time if searched again
		if not getmetatable(tabl) then setmetatable(tabl,{}) end
		local meta = getmetatable(tabl) 
		if not meta['SpiceSearchResultsStorage'] then
			meta['SpiceSearchResultsStorage'] = {}
		end
		local usedStorage = meta['SpiceSearchResultsStorage']		
		--Stops the search or continues
		local function stopSearch()
			if value and index then
				usedStorage[this] = {value, index}
				return value, index
			end
		end		
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
					if strin == comparative then
						return true
					end
				end
				return false
			end
		end	
		function subAlg(comparative, ind, val)
			local subject = type(ind) == 'string' and ind or type(val) == 'string' and val
				if subject then
					if subject:find(comparative, 1, true) then
						return true
					end
				end
			return false
		end
		--Checks the Used Storage for 'this' and returns if exists
		if not skipStored then
			local stored = usedStorage[this]
			if stored then
				value, index = stored[1], stored[2]
			end
			stopSearch()
		end	
		--Checks if 'this' is found with chosen specified means
<<<<<<< HEAD
		value, index = Spice.Table.find(tabl, this, keepSimilar or false,
			subAlg, capSearch and capAlg or nil, ...
=======
		value, index = Spice.Table.find(tabl, this, keepSimilar
			capSearch and capAlg or Alg or nil, ...
>>>>>>> 3c933e55aacb9f3e847ccbb4c2de9c03a17a537d
		)
		stopSearch()		
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
};
