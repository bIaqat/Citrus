local Table = {};
setmetatable(Table, {__index = {
	bySubstring = function(comparative, ind, val)
		local subject, subject2 = (type(ind) == 'string' and ind or type(val) == 'string' and val):lower(),(type(ind) == 'string' and type(val) == 'string' and val):lower()
		return subject and subject:find(comparative:lower(), 1, true) and true or subject2 and subject2:find(comparative:lower(), 1, true) and true or false
	end;
	byCapitals = function(comparative, ind, val)
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
	end;
}});

function Table.mergeTo(TableFrom, TableTo)
	for index, key in next, TableFrom do

		if type(index) == 'string' then
			rawset(TableTo,index,key);
		else
			table.insert(TableTo,key);
		end

	end

	return TableTo;
end;

function Table:clone(Table)
	local clone = {};
	local clonef = self.clone

	for index, key in next, Table do

		if type(index) == 'table' then
			index = clonef(self,index);
		elseif typeof(index) == 'Instance' then
			index = index:Clone();
		end

		if type(key) == 'table' then
			key = clonef(self,key);
		elseif typeof(key) == 'Instance' then
			key = key:Clone();
		end

		rawset(clone,index,key);
	end

	local metatable = getmetatable(Table);

	if metatable then
		setmetatable(clone,clonef(self,metatable));
	end

	return clone;
end;

function Table.contains(Table, contains)
	for index, key in next, Table do

		if (type(i) ~= 'string' and i == contains) or (v == contains) then
			return true;
		end

	end

	return false;
end;

function Table.length(Table)
	local count = 0

	for _,_ in next, Table do
		count = count + 1;
	end

	return count;
end;

function Table.firstIndexOf(Table, value)
	for index, key in next, Table do
		if key == value then
			return key;
		end
	end

	return nil;
end;

function Table.indexesOf(Table, value, returnNumber)
	local indexes = {};

	for index, key in next, Table do
		if key == value then
			table.insert(indexes);
		end
	end

	return returnNumber and indexes[returnNumber] or indexes;
end;

function Table.find(Table, value, returnNumber, ...) --...searchAlgorithms (function(Table, index, value))
	local found = {};

	for i,v in next, Table do
		if v == value then
			table.insert(found, {i, v})
		end

		for i,v in next, {...} do
			if type(v) == 'string' then
				v = self:getCompareAlgorithm(v)
			end

			if v and v(Table, i, v) then
				table.insert(found, {i, v})
			end
		end

	end

	return returnNumber and found[returnNumber] or found;
end;

function Table:search(Table, value, skipSaved, returnNumber, subStringSearch, capSearch, ...)
	if not getmetatable(Table) then
		setmetatable(Table,{})
	end

	local meta = getmetatable(Table)

	if not meta['𝓒table.search'] then
		meta['𝓒table.search'] = {};
	end
	local saved = meta['𝓒table.search'];

	if not skipSaved and saved[value] then
		return saved[value];
	end;

	local found = self.find(Table, value, nil, subStringSearch and 'bySubString', capSearch and 'byCapitals', ...);

	saved[value] = returnNumber and found[returnNumber] or found;

	return saved[value];
end;

function Table:setCompareAlgorithm(name, Function)
	rawset(getmetatable(self).index, name, Function);
end

function Table:getCompareAlgorithm(name)
	return rawget(getmetatable(self).index, name);
end
