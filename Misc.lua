Misc = {
	getAssetId = function(id)
		id = game:GetService('InsertService'):LoadAsset(tonumber(id)):GetChildren()[1]
		local idn = id.ClassName
		id = id[idn == 'ShirtGraphic' and 'Graphic' or idn == 'Shirt' and 'ShirtTemplate' or 'Pants' and 'PantsTemplate' or 'Decal' and 'Texture']
		return id:sub(id:find'='+1)
	end;
	getTextSize = function(text)
		local textl
		if type(text) == 'string' then
			textl = Instance.new('TextLabel')
			textl.Text = text
		end
		return game:GetService('TextService'):GetTextService(text, textl.TextSize, textl.Font, textl.AbsoluteSize)
	end;
	getPlayer = function(speaker, ...)
		local players = {}
		local has = {}
		local function insert(a)
			if not has[a] then
				table.insert(players,a)
				has[a] = true;
			end
		end
		local players = game:GetService'Players'
		for _,v in next, {...} do
			if v == 'all' then 
				for _, player in next, players:GetPlayers() do
					insert(player)
				end
			elseif v == 'others' then
				for _, player in next, players:GetPlayers() do
					if player ~= speaker then
						insert(player)
					end
				end
			elseif v == 'me' then
				insert(speaker)
			else
				for _, player in next, players:GetPlayers() do
					if player.Name:sub(1,#v):lower() == v:lower() then
						insert(player)
					end
				end
			end
		end
		return setmetatable(players,{__call = function(self, func) for i,v in next,self do func(v) end end})
	end;
	runTimer = function()
		return setmetatable({startTime = 0,running = false},{
			__call = function(self,start)
				local gettime
				if start or not self.running then
					self.running = true
					self.startTime = tick()
					return true, tick()
				else
					self.running = false
					gettime = tick() - self.startTime
					self.startTime = 0
				end
				return gettime or self.startTime
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
		game:GetService("Debris"):AddItem(who,seconds)
	end;
	exists = function(yes)
		return yes ~= nil and true or false
	end;
	--Redo StringFilterOut Later and Switch
	dynamicProperty = function(Object, Typ)
		local cn = Object.ClassName
		return (cn:find'Text' and 'Text' or cn:find'Image' and 'Image' or 'Background')..(Typ or '')
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
	operation = function(a,b,op)
		return 
		op == '+' and a + b or
		op == '-' and a - b or
		(op == '*' or op == 'x') and a * b or
		op == '/' and a / b or
		op == '%' and a % b or
		(op == 'pow' or op == '^') and a ^ b or
		(op == 'rt' or op == '^/') and a ^ (1/b)
	end;
};