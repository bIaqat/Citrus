Misc = {
	getAssetId = function(id)
		id = game:GetService('InsertService'):LoadAsset(tonumber(id)):GetChildren()[1]
		local idn = id.ClassName
		id = id[idn == 'ShirtGraphic' and 'Graphic' or idn == 'Shirt' and 'ShirtTemplate' or 'Pants' and 'PantsTemplate' or 'Decal' and 'Texture']
		return id:sub(id:find'='+1)
	end;
	getTextSize = function(text,prop)
		local textl
		if type(text) == 'string' then
			textl = Instance.new('TextLabel')
			textl.Text = text
			for i,v in next, prop or {} do
				textl[i] = v
			end
		end
		return game:GetService('TextService'):GetTextSize(text, textl.TextSize, textl.Font, textl.AbsoluteSize)
	end;
	getPlayer = function(speaker, ...)
		local plrs = {}
		local has = {}
		local function insert(a)
			if not has[a] then
				table.insert(plrs,a)
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
		return setmetatable(plrs,{__call = function(self, func) for i,v in next,self do func(v) end end})
	end;
	--what have a "doAfter" function when there is already a delay(WaitTime, Function) already thonk
	timer = function()
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
			end;
			__concat = function(self,value)
				return ''..tick()-self.startTime..value
			end;
			__tostring = function(self)
				return ''..tick()-self.startTime
			end;
		})
	end;
	searchAPI = function(ApiLink)
		local exploiting = pcall(function() return game.HttpGet end) and true or false
		local httpget =  exploiting and game.HttpGet or game:GetService('HttpService').GetAsync
		local proxyLink = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?'
		local jsonData
		jsonData = game:GetService('HttpService'):JSONDecode(httpget(exploiting and httpget or game:GetService'HttpService',proxyLink..ApiLink:match('Category=%d+')))
		for i,v in next, jsonData do
			setmetatable(v,{
				__tostring = function(self)
					return 'Datatable:\t'..self.Name
				end
			})
		end
		return jsonData
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
	--Redo StringFilterOut  and Switch
	dynamicProperty = function(Object, Typ)
		local cn = Object.ClassName
		return (cn:find'Text' and 'Text' or cn:find'Image' and 'Image' or 'Background')..(Typ or 'Color3')
	end;
	round = function(number, placement)
		local mult = math.pow(10,placement or 0)
		return math.floor(number*mult + .5)/mult;
	end;
	contains = function(containing,...)
		for i,content in next,{...} do
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
