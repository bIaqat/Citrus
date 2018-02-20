Misc = {
	Functions = {
		tweenService = function(what,prop,to,...)
			local args = {...}
			local props = {}
			local tim,style,direction,rep,reverse,delay
			for i,v in next,args do
				if type(v) == 'string' or typeof(v) == 'EnumItem' then
					if style == nil then
						style = v and type(v) ~= 'string' or Enum.EasingStyle[v]
					else
						direction = v and type(v) ~= 'string' or Enum.EasingDirection[v]
					end
				elseif type(v) == 'number' then
					if tim == nil then
						tim = v
					elseif rep == nil then
						rep = v
					else
						delay = v
					end
				elseif type(v) == 'boolean' then
					reverse = v
				end
			end
			for i,v in next,prop and type(prop) == 'table' or {prop} do
				props[Pineapple.Properties[v]] = to and type(to) ~= 'table' or to[i]
			end
			return game:GetService('TweenService'):Create(what,TweenInfo.new(tim,style or Enum.EasingStyle.Linear,direction or Enum.EasingDirection.In,rep or 0,reverse or false,delay = 0),props):Play()
		end;
		stringFilterOut = function(string,starting,ending,...)
			local args,disregard,tostr,flip = {...}
			for i,v in pairs(args)do
				if type(v) == 'boolean' then
					if flip == nil then flip = v else tostr = v end
				elseif type(v) == 'string' then
					disregar = v
				end
			end
			local filter,out = {},{}
			for i in string:gmatch(starting) do
				if not Pineapple.Misc.Functions.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
					local filtered = string:sub(string:find(starting),ending and ({string:find(ending)})[2] or ({string:find(starting)})[2])
					local o = string:sub(1,(ending and string:find(ending) or string:find(starting))-1)
					table.insert(filter,filtered~=disregard and filtered or nil)
					table.insert(out,o~=disregard and o or nil)
				else
					table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
				end
				string = string:sub((ending and ({string:find(ending)})[2] or ({string:find(starting)})[2]) + 1)
			end
			table.insert(out,string)
			filter = tostr and table.concat(filter) or filter
			out = tostr and table.concat(out) or out
			return flip and out or filter, flip and filter or out
		end;
		switch = function(...)
		    return sm({type = {},D4 = false,Get = function(self,number)
			if type(number) ~= 'number' then
			    for i,v in pairs(self.type)do
				if v == number then
				    number = i
				end
			    end
			    if type(number)~= 'number' then
				number = nil
			    end
			end
			if number == nil then
			    return self.D4
			else
			    return self[number]
			end
		    end,...},{
			__index = function(self,index)
			    return self:Get(index)
			end;
			__newindex = function(self,index,new)
			    if index == 'Default' then
				self['D4'] = new
			    end
			end;
			__call = function(self,type,...)
			    if typeof(self[type]) == 'function' then
				return self:Get(type)(...)
			    else
				return self[type]
			    end
			end;
		    })
		end;
		round = function(num)
			return math.floor(num+.5)
		end;
		contains = function(containing,...)
			for _,content in next,{...} do
				if content == containing then
					return true
				end
			end
			return false
		end;
		operation = function(a,b,opa)
			local op = Pineapple.Misc.Functions.switch(a+b,a-b,a*b,a/b,a%b,a^b,a^(1/b),a*b,a^b,a^(1/b))
			op.type = {'+','-','*','/','%','^','^/','x','pow','rt'}
			return op(opa)
		end;
	};
	
	Table = {
		pack = function(table,start)
			local new = {}
			for i = start or 1, #table do
				table.insert(new,table[i])
			end
			return new
		end;
		merge = function(who,what)
			for i,v in next,who do
				if what[i] then
					for a,z in next,v do
						what[i][a] = z
					end
				else
					what[i] = v
				end
			end
			return what
		end;
		clone = function(tab)
			local clone = {}
			for i,v in next,tab do
				if type(v) == 'table' then
					clone[i] = Pineapple.Misc.Table.clone(v)
					if getmetatable(v) then
						local metaclone = Pineapple.Misc.Table.clone(getametatable(v))
						setmetatable(clone[i],metaclone)
					end
				else
					clone[i] = v
				end
			end
			return clone
		end;
		contains = function(tabl,contains,typ)
			for i,v in next,tabl do
				if v == contains or (typeof(i) == typeof(contains) and  == contains) then
					if typ then
						return ({true,v,i})[typ]
					else
						return true,v,i
					end
				end
			end
			return false
		end;
		toNumberalIndex = function(tabl)
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
			return #Pineapple.Misc.Table.toNumeralIndex(tab)
		end;
		reverse = function(tab)
			local new ={}
			for i,v in next,tab do
				new[#tab+1-1] = v
			end
			return new
		end;
		indexOf = function(tabl,val)
			return Pineapple.Misc.Table.contains(tabl,val,3)
		end;
		find = function(tabl,this)
			return Pineapple.Misc.Table.contains(tabl,this,2)
		end;
		search = function(tabl,this)
			local misc = Pineapple.Misc
			if misc.Table.find(tabl,this) then
				return misc.Table.find(tabl,this)
			end
			for i,v in next,tabl do
				if type(i) == 'string' or type(v) == 'string' then
					local subject = type(i) == 'string' and i or type(v) == 'string' and v
					local caps = misc.Functions.stringFilterOut(subject,'%u',false,true)
					if subject:lower():sub(1,#this) == this:lower() or caps:lower() == this:lower() then
						return v,i
					end
				end
			end
			return false
		end;
		anonSetMetatable = function(tabl,set)
			local old = getmetatable(tabl)
			local new = Pineapple.Misc.Table.clone(setmetatable(tabl,set))
			setmetatable(tabl,old)
			return new
		end;
	};
==
}
				
				
				
				
