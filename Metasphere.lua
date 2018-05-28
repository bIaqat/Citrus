Metasphere = setmetatable({},{
	__index = function(self,index)
		return getmetatable(Spice[index])
	end;
	__newindex = function(self,index,newindex)
		setmetatable(Spice[index],newindex)
	end;
})