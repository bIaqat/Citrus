Misc = {
	getPlayer = function(speaker, ...)
		local players = setmetatable({},{
			__call = function(self, plr)
				if not Spice.Table.contains(self,plr) then
					table.insert(self,plr)
				end
			end
		})
		local gp = game:GetService("Players")
		for _,v in next, {...} do
			if v == 'all' then
				for _,plr in next, gp:GetPlayers() do
					players(plr)
				end
			elseif v == 'others' then
				for _, plr in next, gp:Players() do
					if plr ~= speaker then
						players(plr)
					end
				end
			elseif v == 'me' then
				players(speaker)
			else
				local results = Spice.Table.search(gp:GetPlayers(), v, true, true)
				for i, plr in next, results do
					print(typeof(plr), plr, typeof(Spice.Table.search(gp:GetPlayers(), v)))
					players(plr)
				end
			end
		end
		return setmetatable(players,{})
	end;
	doAfter = function(wai,fun,...)
		local args = {...}
		spawn(function()
			wait(wai)
			do fun(unpack(args)) end
		end)
	end;
	runTimer = function()
		return setmetatable({time = 0,running = false},{
			__call = function(self,start)
				local gettime
				if start or not self.running then
					self.running = true
					coroutine.wrap(function()
						while self.running and wait(.01) do
							self.time = self.time + .01
						end
					end)()
					return true, self.time
				else
					self.running = false
					gettime = self.time
					self.time = 0
				end
				return gettime or self.time
			end
		})
	end;
	searchAPI = function(link,typ)
		local tab = {}
		link = game.HttpService:UrlEncode(link:sub(link:find'?'+1,#link))
		local proxy = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?'
		if not typ then
			link = game:GetService'HttpService':JSONDecode(game:GetService'HttpService':GetAsync(proxy..link))
		else
			link = game:GetService'HttpService':JSONDecode(game:HttpGetAsync(proxy..link))
		end
		for i,v in pairs(link)do
			tab[v.Name] = v
		end
		return tab
	end;
	getArgument = function(num,...)
		return ({...})[num]
	end;
	destroyIn = function(who,seconds)
		game:GetService("Debris"):AddItem(Spice.Instance.getInstanceOf(who),seconds)
	end;
	exists = function(yes)
		return yes ~= nil and true or false
	end;
	stringFilterOut = function(string,starting,ending,...)
		local args,disregard,tostr,flip = {...}
		for i,v in pairs(args)do
			if type(v) == 'boolean' then
				if flip == nil then flip = v else tostr = v end
			elseif type(v) == 'string' then
				disregard = v
			end
		end
		local filter,out = {},{}
		for i in string:gmatch(starting) do
			if not Spice.Misc.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
				local filtered = string:sub(string:find(starting),ending and Spice.getArgument(2,string:find(ending)) or Spice.getArgument(2,string:find(starting)))
				local o = string:sub(1,(ending and string:find(ending) or string:find(starting))-1)
				table.insert(filter,filtered~=disregard and filtered or nil)
				table.insert(out,o~=disregard and o or nil)
			else
				table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
			end
			string = string:sub((ending and Spice.getArgument(2,string:find(ending)) or Spice.getArgument(2,string:find(starting))) + 1)
		end
		table.insert(out,string)
		filter = tostr and table.concat(filter) or filter
		out = tostr and table.concat(out) or out
		return flip and out or filter, flip and filter or out
	end;
	dynamicProperty = function(obj,to)
		obj = Spice.Instance.getInstanceOf(obj)
		if obj.ClassName:find'Text' then
			return 'Text'
		elseif obj.ClassName:find'Image' then
			return 'Image'
		end
		return 'Background'..to or ''
	end;
	switch = function(...)
		return setmetatable({filter = {},Default = false,data = {...},
			Filter = function(self,...)
				self.filter = {...}
				return self
			end;	
			Get = function(self,what)
				local yes = Spice.Misc.exists	
				local i = what
				if yes(Spice.Table.find(self.data,what)) then
					i = Spice.Table.indexOf(self.data,what)
				end
				if yes(Spice.Table.find(self.filter,what)) then
					i = Spice.Table.indexOf(self.filter,what)
				end
				return self.data[i]
			end},{
				__call = function(self,what,...)
					local get = self:Get(what)
					return get and (type(get) ~= 'function' and get or get(...)) or self.Default
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
		return Spice.Misc.switch(a+b,a-b,a*b,a/b,a%b,a^b,a^(1/b),a*b,a^b,a^(1/b)):Filter('+','-','*','/','%','^','^/','x','pow','rt')(opa)
	end;
};
