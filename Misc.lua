Misc = {
	searchAPI = function(link,typ)
		local tab = {}
		link = game.HttpService:UrlEncode(link:sub(link:find'catalog/json?'+13,#link))
		local proxy = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?'
		if typ then
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
		game:GetService("Debris"):AddItem(Citrus.Instance.getInstanceOf(who),seconds)
	end;
	exists = function(yes)
		return yes ~= nil and true or false
	end;
	tweenService = function(what,prop,to,...)
		what = Citrus.getInstanceOf(what)
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
		for i,v in next,type(prop) == 'table' and prop or {prop} do
			props[Citrus.Properties[v]] = type(to) ~= 'table' and to or to[i]
		end
		return game:GetService('TweenService'):Create(what,TweenInfo.new(tim,style or Enum.EasingStyle.Linear,direction or Enum.EasingDirection.In,rep or 0,reverse or false,delay or 0),props):Play()
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
			if not Citrus.Misc.contains(string:match(starting),type(disregard)=='table' and unpack(disregard) or disregard) then
				local filtered = string:sub(string:find(starting),ending and Citrus.getArgument(2,string:find(ending)) or Citrus.getArgument(2,string:find(starting)))
				local o = string:sub(1,(ending and string:find(ending) or string:find(starting))-1)
				table.insert(filter,filtered~=disregard and filtered or nil)
				table.insert(out,o~=disregard and o or nil)
			else
				table.insert(out,string:sub(1,string:find(starting))~=disregard and string:sub(1,string:find(starting)) or nil)
			end
			string = string:sub((ending and Citrus.getArgument(2,string:find(ending)) or Citrus.getArgument(2,string:find(starting))) + 1)
		end
		table.insert(out,string)
		filter = tostr and table.concat(filter) or filter
		out = tostr and table.concat(out) or out
		return flip and out or filter, flip and filter or out
	end;
	dynamicType = function(obj)
		obj = Citrus.Instance.getInstanceOf(obj)
		if obj.ClassName:find'Text' then
			return 'Text'
		elseif obj.ClassName:find'Image' then
			return 'Image'
		end
		return 'Background'
	end;
	switch = function(...)
		return setmetatable({filter = {},Default = false,data = {...},
			Filter = function(self,...)
				self.filter = {...}
				return self
			end;	
			Get = function(self,what)
				local yes = Citrus.Misc.exists	
				local i = what
				if yes(Citrus.Table.find(self.data,what)) then
					i = Citrus.Table.indexOf(self.data,what)
				end
				if yes(Citrus.Table.find(self.filter,what)) then
					i = Citrus.Table.indexOf(self.filter,what)
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
		return Citrus.Misc.switch(a+b,a-b,a*b,a/b,a%b,a^b,a^(1/b),a*b,a^b,a^(1/b)):Filter('+','-','*','/','%','^','^/','x','pow','rt')(opa)
	end;
};
