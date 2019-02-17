hsv = function(h,s,v)
	return Color3.fromHSV(h/360,s/100,v/100)
end
rgb = Color3.fromRGB
Booge = {
	Shortcuts = {
		Name = {};Parent = {'Parent'}; AnchorPoint = {'AP'}; BackgroundColor3 = {'Bg3','BC','BG'}; BackgroundTransparency = {'BT','Trans'}; BorderColor3 = {'BC3'}; BorderSizePixel = {'BSP'}; Position = {'P'}; Rotation = {'R'}; Size = {'S'}; Visible = {'V'}; ZIndex = {'Z'}; AutoButtonColor = {'ABC'}; Text = {'T'}; Font = {'F','font'}; TextColor3 = {'TC3','TC'}; TextScaled = {'TSC'}; TextSize = {'TS'}; TextTransparency = {'TT','TTrans'}; TextWrapped = {'TW'}; TextXAlignment = {'TX','TXA'}; TextYAlignment = {'TY','TYA'}; Image = {'Pic','Image'}; ImageColor3 = {'IC3','IC'}; ImageRectOffset = {'IRO'}; ImageRectSize = {'IRS'}; ImageTransparency = {'IT'}; ClipsDescendants = {'cd'}; Draggable = {'Drag','d'};
	};
	Create = {
		Custom = {};
		newCustom = function(what,name,oncreate)
			local c = Booge.find'custom'
			c[name] = {what:Clone(),onCreate = oncreate}
		end;
		Create = function(a,b,c,...)
			local adsd = Booge.find'custom'
			local created,bool
			 for i,v in pairs(adsd)do if i == a then created = v[1]:Clone() if adsd[a].onCreate then bool = true end end end
			if not created then
				created = Instance.new(a)
			end
			if b then
				created.Parent = b
			end
			if c then
				for i,v in pairs(c)do
					 for q,w in pairs(Booge.Shortcuts)do if i:lower() ~= q:lower() then if q:sub(1,#i):lower() == i then i = q else for e,r in pairs(w)do if i:lower() == r:lower() then i = q end end end end end
					if i == 'Rounded' and v == true then
						Booge.Items.Round:Clone().Parent = created
						created.BackgroundTransparency = 1
						created.ZIndex = created.ZIndex + 1
					elseif i == 'Draggable' and v == true then
						created.Active = true
						created.Draggable = true
					elseif i == 'Rounded' and v == 'rounder' then local round = Booge.find('create')('Folder',created,{n = 'Round'}) local right = Booge.find('create')('ImageLabel',round,{r = .001,pic = 'rbxassetid://974669661', ap = Vector2.new(1,1),trans = 1,pos = UDim2.new(1,0,1,0),Size = UDim2.new(0,25,1,0),z = created.ZIndex,iro = Vector2.new(400,0),irs = Vector2.new(400,800)}) local left = Booge.find('set')(right:Clone(),{p = round,ap = Vector2.new(0,0),pos = UDim2.new(0,0,0,0),iro = Vector2.new(0,0)}) local rest = Booge.find('crea')('ImageLabel',round,{r = .001,ap = Vector2.new(.5,0),bt = 1,pos = UDim2.new(.5,0,0,0),s = UDim2.new(1,-50,1,0),pic = 'rbxassetid://974669661',iro = Vector2.new(400,0),irs = Vector2.new(5,800)}) created.BackgroundTransparency = 1 created.ZIndex = created.ZIndex + 1
					elseif i == 'Ripple' and v == true and a:sub(#a-5,#a) == 'Button' then  created.AutoButtonColor = false created.MouseButton1Click:connect(function() local m = game.Players.LocalPlayer:GetMouse() Booge.find('tween').tween(Booge.find('set')(Booge.Items.Circle:Clone(),{z = created.ZIndex + 1,par = created,pos = UDim2.new(0,m.X-created.AbsolutePosition.X,0,m.Y-created.AbsolutePosition.Y)}),'size',UDim2.new(0,900,0,900),.9) coroutine.wrap(function() for i = .7,1,.05 do created.Circle.ImageTransparency = i wait(.001) end created.Circle:Destroy() end)() end) created.ClipsDescendants = true
					elseif i == 'Shadow' and v == 'hover' then created.MouseEnter:connect(function() if not created:FindFirstChild('Shadow') then local s = Booge.Items.Shadow:Clone() s.ZIndex = created.ZIndex - 1 Booge.find('tween').tween(Booge.find('set')(s,{n = 'Shadow',p = created}),'size',UDim2.new(1,0,0,7),.1) else local s = created.Shadow Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,7),.1) end end) created.MouseLeave:connect(function() local s = created:FindFirstChild('Shadow') Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,1),.1) end)
					elseif i == 'Shadow' and type(v) == 'table' then  local s = Booge.find('create')('Folder',created,{n = 'Shadow'}) for i = 0,v[2],1 do Booge.find('set')(Booge.Items.Shadow:Clone(),{p = s,s = UDim2.new(1,0,0,1)}) end if v[1] == 'hover' then if not v[3] then v[3] = 7 end created.MouseEnter:connect(function() for i,q in pairs(created:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(q,'size',UDim2.new(1,0,0,v[3]),.1) end end) created.MouseLeave:connect(function() for i,v in pairs(created:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(v,'size',UDim2.new(1,0,0,1),.1) end end) end
					elseif i == 'Shadow' and v == true then
						Booge.find('set')(Booge.Items.Shadow:Clone(),{p = created,s = UDim2.new(1,0,0,7)})
					elseif i == 'Shadow' and v == 'double' then
						Booge.find('set')(Booge.Items.Shadow:Clone(),{p = created,s = UDim2.new(1,0,0,7)}):Clone().Parent = created
					elseif i:sub(#i-5,#i) == 'Color3' and type(v) ~= 'userdata' then
						local number,theme
						local t = Booge.find'tothem'
						if type(v) == 'table' then
							theme,number = v[1],v[2]
						elseif type(v) == 'string' then
							theme,number = v,1
						end
						if i:sub(1,4) == 'Text' then
							t(created,theme,number,'t')
						else
							t(created,theme,number)
						end
					else
						created[i] = v
					end
				end
			end
			 if created:FindFirstChild('Round') then for i,v in pairs(created.Round:GetChildren())do if v.ClassName == 'Frame' then v.BackgroundColor3 = created.BackgroundColor3 else v.ImageColor3 = created.BackgroundColor3 end end end
			if bool then
				adsd[a].onCreate(created,...)
			end
			return created
		end;
		Set = function(a,b)
			for i,v in pairs(b)do
					for i,v in pairs(b)do
					 for q,w in pairs(Booge.Shortcuts)do if i:lower() ~= q:lower() then if q:sub(1,#i):lower() == i then i = q else for e,r in pairs(w)do if i:lower() == r:lower() then i = q end end end end end
					if i == 'Rounded' and v == true then
						Booge.Items.Round:Clone().Parent = a
						a.BackgroundTransparency = 1
						a.ZIndex = a.ZIndex + 1
					elseif i == 'Draggable' and v == true then
						a.Active = true
						a.Draggable = true
					elseif i == 'Rounded' and v == 'rounder' then local round = Booge.find('create')('Folder',a,{n = 'Round'}) local right = Booge.find('create')('ImageLabel',round,{r = .001,pic = 'rbxassetid://974669661', ap = Vector2.new(1,1),trans = 1,pos = UDim2.new(1,0,1,0),Size = UDim2.new(0,25,1,0),z = a.ZIndex,iro = Vector2.new(400,0),irs = Vector2.new(400,800)}) local left = Booge.find('set')(right:Clone(),{p = round,ap = Vector2.new(0,0),pos = UDim2.new(0,0,0,0),iro = Vector2.new(0,0)}) local rest = Booge.find('crea')('ImageLabel',round,{r = .001,ap = Vector2.new(.5,0),bt = 1,pos = UDim2.new(.5,0,0,0),s = UDim2.new(1,-50,1,0),pic = 'rbxassetid://974669661',iro = Vector2.new(400,0),irs = Vector2.new(5,800)}) a.BackgroundTransparency = 1 a.ZIndex = a.ZIndex + 1 elseif i == 'Ripple' and v == true and a:sub(#a-5,#a) == 'Button' then a.AutoButtonColor = false a.MouseButton1Click:connect(function() local m = game.Players.LocalPlayer:GetMouse() Booge.find('tween').tween(Booge.find('set')(Booge.Items.Circle:Clone(),{z = a.ZIndex + 1,par = a,pos = UDim2.new(0,m.X-a.AbsolutePosition.X,0,m.Y-a.AbsolutePosition.Y)}),'size',UDim2.new(0,900,0,900),.9) coroutine.wrap(function() for i = .7,1,.05 do a.Circle.ImageTransparency = i wait(.001) end a.Circle:Destroy() end)() end) a.ClipsDescendants = true elseif i == 'Shadow' and v == 'hover' then a.MouseEnter:connect(function() if not a:FindFirstChild('Shadow') then local s = Booge.Items.Shadow:Clone() Booge.find('tween').tween(Booge.find('set')(s,{n = 'Shadow',p = a}),'size',UDim2.new(1,0,0,7),.1) else local s = a.Shadow Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,7),.1) end end) a.MouseLeave:connect(function() local s = a:FindFirstChild('Shadow') Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,1),.1) end) elseif i == 'Shadow' and type(v) == 'table' then local s = Booge.find('create')('Folder',a,{n = 'Shadow'}) for i = 0,v[2],1 do Booge.find('set')(Booge.Items.Shadow:Clone(),{p = s,s = UDim2.new(1,0,0,1)}) end if v[1] == 'hover' then if not v[3] then v[3] = 7 end a.MouseEnter:connect(function() for i,q in pairs(a:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(q,'size',UDim2.new(1,0,0,v[3]),.1) end end) a.MouseLeave:connect(function() for i,v in pairs(a:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(v,'size',UDim2.new(1,0,0,1),.1) end end) end elseif i == 'Shadow' and v == true then Booge.find('set')(Booge.Items.Shadow:Clone(),{p = a,s = UDim2.new(1,0,0,7)}) elseif i == 'Shadow' and v == 'double' then Booge.find('set')(Booge.Items.Shadow:Clone(),{p = a,s = UDim2.new(1,0,0,7)}):Clone().Parent = a
					elseif i:sub(#i-5,#i) == 'Color3' and type(v) ~= 'userdata' then
						local number,theme
						local t = Booge.find'tothem'
						if type(v) == 'table' then
							theme,number = v[1],v[2]
						elseif type(v) == 'string' then
							theme,number = v,1
						end
						if i:sub(1,4) == 'Text' then
							t(a,theme,number,'t')
						else
							t(a,theme,number)
						end
					else
						a[i] = v
					end
				end
			end
			 if a:FindFirstChild('Round') then for i,v in pairs(a.Round:GetChildren())do if v.ClassName == 'Frame' then v.BackgroundColor3 = a.BackgroundColor3 else v.ImageColor3 = a.BackgroundColor3 end end end
			return a
		end
	};
	Position = {
		Tween = {
			tween = function(who,what,where,when,how,ex) if what ~= 'both' then if not how then how = {'Out','Sine'} end if what == 'size' then who:TweenSize(where,how[1],how[2],when,true) elseif what == 'pos' then who:TweenPosition(where,how[1],how[2],when,true) end else if not ex then ex = {'Out','Sine'} end who:TweenSizeAndPosition(where,when,ex[1],ex[2],how,true) end end;
			Enter = function(who,from,tox,toy,tim,offset,more) who.Position = from if not offset then offset = {0,0} end local x,y if tox == 'left' or toy == 'left' then x = 0 elseif tox == 'center' or toy == 'center' and y == nil then x = .5 elseif tox == 'right' or toy == 'right' then x = 1 end if tox == 'top' or toy == 'top' then y = 0 elseif tox == 'center' or toy == 'center' and x then y = .5 elseif tox == 'bottom' or toy == 'bottom' then y = 1 end Booge.find('twee').tween(who,'pos',UDim2.new(x,offset[1],y,offset[2]),tim,more) end;
			Leave = function(who,from,tox,toy,tim,offset,more) who.Position = from if not offset then offset = {0,0} end local x,y if tox == 'left' or toy == 'left' then x = -1 elseif tox == 'center' or toy == 'center' and y == nil then x = .5 elseif tox == 'right' or toy == 'right' then x = 2 end if tox == 'top' or toy == 'top' then y = -1 elseif tox == 'center' or toy == 'center' and x then y = .5 elseif tox == 'bottom' or toy == 'bottom' then y = 2 end Booge.find('twee').tween(who,'pos',UDim2.new(x,offset[1],y,offset[2]),tim,more) end;
			Rotate = function(who,where,when)
				local positive = 1/when
				if where < who.Rotation then
					positive = -1/when
				end
				for i = who.Rotation,where,positive do
					who.Rotation = i
					wait()
				end
			end;
			Pop = function(who,where,speed,when,color)
				local typ
				if not when then when = 1 end
				local self = who:Clone()
				self.Rotation = .001
				for i,v in pairs(self:GetChildren())do
					v:Destroy()
				end
				if self.ClassName:sub(1,5) ~= 'Image' then
					typ = 'Background'
				else
					typ = 'Image'
				end
				if not color then color = who[typ..'Color3'] end
				self.AnchorPoint = Vector2.new(.5,.5)
				self.Position= UDim2.new(.5,0,.5,0)
				coroutine.wrap(function()
				for i = 1,when,1 do
					local asd = self:Clone()
					if type(color) == table then
						color = color[i]
					end
					asd[typ..'Color3'] = color
					Booge.find('tween').tween(Booge.find('set')(asd,{par = who}),'size',where,speed)
					for i = who[typ..'Transparency'],1,.1 do
						asd[typ..'Transparency'] = i
						wait(speed/10)
					end
					asd:Destroy()
					wait(speed)
				end end)()
				return self
			end;
		};		
		UD = {
			new = function(a,b,c,d) if d then return UDim2.new(a,b,c,d) elseif c == 1 then return UDim2.new(a,0,b,0) elseif c == 2 then return UDim2.new(0,a,0,b) elseif c == 3 then return UDim2.new(a,b,a,b) elseif b == 'o' then return UDim2.new(0,a,0,a) elseif b == 's' then return UDim2.new(a,0,a,0) end end; Offset = function(a,b) return UDim2.new(0,a,0,b) end; Scale = function(a,b) return UDim2.new(a,0,b,0) end;
			fromPosition = function(a,b,c,d) local y,x if not b then b = '' end if a:lower()== 'top' or b:lower() == 'top' then y = 0 elseif a:lower() == 'center' or b:lower() == 'center' and x == nil or x == 0 then y = .5 elseif a:lower() == 'bottom' or b:lower() == 'bottom' then y = 1 elseif a:lower() == 'center' and not b then y,x = .5,1/2 else y = 0 end if a:lower()== 'left' or b:lower() == 'left' then x = 0 elseif a:lower()== 'center' or b:lower() == 'center' and y~= nil then x = .5 elseif a:lower() == 'right' or b:lower() == 'right' then x = 1 else x = 0 end if not c then c = 0 end if not d then d = 0 end return UDim2.new(x,c,y,d) end
		};
	};
	Color = {
		Theme = {
			Themes = {};
			New = function(...)
				local t = Booge.find('theme').Themes
				local c = Booge.Color.new
				for i,v in pairs({...})do
					if not t[v[1]] then
						if v[2] == 'light' then
							v[2] = {c('Grey',-1,'l'),c('Grey',0,'l'),c('Grey',1,'l'),c('Grey',2,'l')}
						elseif v[2] == 'dark' then
							v[2] = {c('Grey',-1),c('Grey',0),c('Grey',1),c('Grey',2)}
						elseif type(v[2]) == 'string' then
							v[2] = {c(v[2],-1),c(v[2],0),c(v[2],1),c(v[2],2)}
						elseif type(v[2]) == 'userdata' then
							v[2] = {v[2]}
						end
						t[v[1]] = {v[2]}
						if v[3] then
							t[v[1]].Items = {v[3]}
						else
							t[v[1]].Items = {}
						end
					end
				end
			end;
			Set = function(theme,towhat)
				local c = Booge.Color.new
				if towhat == 'light' then
					towhat = {c('Grey',-1,'l'),c('Grey',0,'l'),c('Grey',1,'l'),c('Grey',2,'l')}
				elseif towhat == 'dark' then
					towhat = {c('Grey',-1),c('Grey',0),c('Grey',1),c('Grey',2)}
				elseif type(towhat) == 'string' then
					towhat = {c(towhat,-1),c(towhat,0),c(towhat,1),c(towhat,2)}
				elseif type(towhat) == 'userdata' then
					towhat = {towhat}
				end
				for i,v in pairs(Booge.find('theme').Themes)do
					if i:sub(1,#theme):lower() == theme:lower() then
						v[1] = towhat
						for who,z in pairs(v.Items)do
							for typ,num in pairs(z)do
								who[typ] = v[1][num]	
							end
						end
					end
				end
			end;
			Get = function(who,num)
				for i,v in pairs(Booge.find'theme'.Themes)do
					if i:sub(1,#who):lower() == who:lower() then
						if num then
							return v[1][num]
						else
							return v[1]
						end
					end
				end
			end
		};
		toTheme = function(who,theme,number,alt2)
			if not number then number = 1 end
			local t = Booge.find('theme').Themes
			local typ
			
			if who.ClassName:sub(1,5) == 'Image' then
				typ = 'ImageColor3'
			elseif who.ClassName:sub(1,4) == 'Text' and alt2 == 't' then
				typ = 'TextColor3'
			else
				typ = 'BackgroundColor3'
			end
			for i,v in pairs(t)do
				if i:sub(1,#theme):lower() == theme:lower() then
					if v.Items and not v.Items[who] then
						v.Items[who] = {}
					end
					v.Items[who][typ] = number
					who[typ] = v[1][number]
				else
					if v.Items and v.Items[who] and v.Items[who][typ] then
						local IHATEROBLOX = {}
						for z,x in pairs(v.Items[who])do
							if z ~= typ then
								IHATEROBLOX[z] = x
							end
						end
						v.Items[who] = IHATEROBLOX
					end
				end
			end
		end;
		fromHex = function(hex)
			if hex:sub(1) == '#' then
				hex = hex:sub(2,#hex)
			end
			local r,g,b
			r = tonumber(hex:sub(2, 3), 16)
			g = tonumber(hex:sub(4, 5), 16)
			b = tonumber(hex:sub(6, 7), 16)
			return rgb(r,g,b)
		end;
		toHex = function(color,asd,els,dsa)
			local r,g,b,hex,ro
			local round,ts = Booge.round,tostring
			if els then
				color = Color3.fromRGB(color,asd,els)
			end
			r =("%02X"):format(round(color.r*255))
			g =("%02X"):format(round(color.g*255))
			b =("%02X"):format(round(color.b*255))
			hex = ts(r)..ts(g)..ts(b)
			if not els and asd then
				hex = '#'..hex
			elseif dsa then
				hex = '#'..hex
			end
			return hex
		end;
		toRGB = function(color)
			return color.r*255,color.g*255,color.b*255
		end;
		toHSV = function(color)
			local h,s,v = Color3.toHSV(color)
			return h*360,s*100,v*100
		end;
		new = function(colour,number,alt) if not number then number = 0 end for i,v in pairs(Booge.find'colo')do if i:sub(1,#colour):lower() == colour:lower() then if alt then return v['Light'][number] else return v[number] end end end end;
		get = function(colour,number,section,subsection) local c = Booge.find'colou' for i,v in pairs(c)do if i:sub(1,#colour):lower() == colour:lower() then if section then if section:find' ' then section = section:sub(1,section:find' '-1) end for x,c in pairs(v)do if type(c) == 'table' then if x:sub(1,#section):lower() == section:lower() then if subsection then for a,s in pairs(c)do if type(s) == 'table' and a:sub(1,#subsection):lower() == subsection:lower() then return s[number] end end end return c[number] end end end else return v[number] end end end end;
		fromMaterial = function(name,number) if not number then number = 500 end local c = Booge.find('Colou') local colorname = name if colorname:find' ' then colorname = name:sub(name:find' '+1,#name) end for i,v in pairs(c)do if i:sub(1,#name):lower() == colorname:lower() then local m = v.Material if name:find' ' then return m[name:sub(1,name:find' '-1)][number] else return m[number] end end end end;
		Colours = {
			Red = {
				Light = {
					[-1] = hsv(359,30,100);
					[0] = hsv(359,47,100);
					[1] = hsv(358,59,100);
					[2] = hsv(358,50,91)
				};
				Flat = {
					Vibrant = {
						[0] = 'F32133';
						[1] = 'AA1726';
						[2] = '79101B';
					};
					[0] = 'C23A34';
					[1] = '882925';
					[2] = '691E1C';
				};
				Material = {
					[50] = rgb(255,235,238);
					[100] = rgb(255,205,210);
					[200] = rgb(239,154,154);
					[300] = rgb(229,115,115);
					[400] = rgb(239,83,80);
					[500] = rgb(244,67,54);
					[600] = rgb(229,57,53);
					[700] = rgb(211,47,47);
					[800] = rgb(198,40,40);
					[900] = rgb(183,28,28);
					['A100'] = rgb(255,138,128);
					['A200'] = rgb(255,82,82);
					['A400'] = rgb(255,23,68);
					['A700'] = rgb(213,0,0);			
				};
				[-1] = hsv(358,65,100);
				[0] = hsv(358,71,100);
				[1] = hsv(358,76,93);
				[2] = hsv(357,83,82);
			};
			Peach = {
				Light = {
					[-1] = hsv(3,30,100);
					[0] = hsv(4,47,100);
					[1] = hsv(3,59,100);
					[2] = hsv(4,50,91)
				};
				Flat = {
					Vibrant = {
						[0] = 'F33221';
						[1] = 'AA2017';
						[2] = '791710';
					};
					[0] = 'C24334';
					[1] = '883025';
					[2] = '69241C';
				};
				[-1] = hsv(3,65,100);
				[0] = hsv(3,71,100);
				[1] = hsv(2,76,93);
				[2] = hsv(3,83,82);
			};
			Orange = {
				Light = {
					[-1] = hsv(14,30,100);
					[0] = hsv(13,47,100);
					[1] = hsv(13,59,100);
					[2] = hsv(14,50,91)
				};
				Flat = {
					Vibrant = {
						[0] = 'F35521';
						[1] = 'AA3917';
						[2] = '792810';
					};
					[0] = 'C26B34';
					[1] = '884C25';
					[2] = '693A1C';
				};
				Material = {
					Deep = {
						[50] = rgb(251,233,231);
						[100] = rgb(255,204,188);
						[200] = rgb(255,171,145);
						[300] = rgb(255,138,101);
						[400] = rgb(255,112,67);
						[500] = rgb(255,87,34);
						[600] = rgb(244,81,30);
						[700] = rgb(230,74,25);
						[800] = rgb(216,67,21);
						[900] = rgb(191,54,12);
						['A100'] = rgb(255,158,128);
						['A200'] = rgb(255,110,64);
						['A400'] = rgb(255,61,0);
						['A700'] = rgb(221,44,0);			
					};
					[50] = rgb(255,243,224);
					[100] = rgb(255,224,178);
					[200] = rgb(255,204,128);
					[300] = rgb(255,183,77);
					[400] = rgb(255,167,38);
					[500] = rgb(255,152,0);
					[600] = rgb(251,140,0);
					[700] = rgb(245,124,0);
					[800] = rgb(239,108,0);
					[900] = rgb(230,81,0);
					['A100'] = rgb(255,209,128);
					['A200'] = rgb(255,171,64);
					['A400'] = rgb(255,145,0);
					['A700'] = rgb(255,109,0);		
				};
				[-1] = hsv(13,65,100);
				[0] = hsv(13,71,100);
				[1] = hsv(13,76,93);
				[2] = hsv(12,83,82);
			};
			Yellow = {
				Light = {
					[-1] = hsv(42,30,100);
					[0] = hsv(41,47,100);
					[1] = hsv(40,59,100);
					[2] = hsv(42,50,91)
				};
				Flat = {
					Vibrant = {
						Gold = {
							[0] = 'F3A621';
							[1] = 'AA7117';
							[2] = '795010';
						};
						[0] = 'F3DB21';
						[1] = 'AA9617';
						[2] = '796A10';
					};
					[0] = 'CAC400';
					[1] = '8E8A00';
					[2] = '6E6A00';
				};
				Material = {
					Amber = {
						[50] = rgb(255,248,225);
						[100] = rgb(255,236,179);
						[200] = rgb(255,224,130);
						[300] = rgb(255,213,79);
						[400] = rgb(255,202,40);
						[500] = rgb(255,193,7);
						[600] = rgb(255,179,0);
						[700] = rgb(255,160,0);
						[800] = rgb(255,143,0);
						[900] = rgb(255,111,0);
						['A100'] = rgb(255,229,127);
						['A200'] = rgb(255,215,64);
						['A400'] = rgb(255,196,0);
						['A700'] = rgb(255,171,0);			
					};
					[50] = rgb(255,253,231);
					[100] = rgb(255,249,196);
					[200] = rgb(255,245,157);
					[300] = rgb(255,241,118);
					[400] = rgb(255,238,88);
					[500] = rgb(255,235,59);
					[600] = rgb(253,216,53);
					[700] = rgb(251,192,45);
					[800] = rgb(249,168,37);
					[900] = rgb(245,127,23);
					['A100'] = rgb(255,255,141);
					['A200'] = rgb(255,255,0);
					['A400'] = rgb(255,234,0);
					['A700'] = rgb(255,214,0);			
				};
				[-1] = hsv(41,65,100);
				[0] = hsv(41,71,100);
				[1] = hsv(41,76,93);
				[2] = hsv(40,83,82);
			};
			Lime = {
				Light = {
					[-1] = 'DEFFB2';
					[0] = 'CDFF87';
					[1] = 'BFF76C';
					[2] = 'B7EA75';
				};
				Flat = {
					Vibrant = {
						[0] = 'D7F321';
						[1] = '99AA17';
						[2] = '6E7910';					
					};
					[0] = '89AE02';
					[1] = '607A01';
					[2] = '4B5F01';				
				};
				Material = {
					[50] = rgb(249,251,231);
					[100] = rgb(240,244,195);
					[200] = rgb(230,238,156);
					[300] = rgb(220,231,117);
					[400] = rgb(212,225,87);
					[500] = rgb(205,220,57);
					[600] = rgb(192,202,51);
					[700] = rgb(175,180,43);
					[800] = rgb(158,157,36);
					[900] = rgb(130,119,23);
					['A100'] = rgb(244,255,129);
					['A200'] = rgb(238,255,65);
					['A400'] = rgb(198,255,0);
					['A700'] = rgb(174,234,0);								
				};
				[-1] = 'AFEF51';
				[0] = 'A4E542';
				[1] = '94D82F';
				[2] = '80C41B';
				
			};
			Green = {
				Light = {
					[-1] = hsv(122,30,100);
					[0] = hsv(122,47,100);
					[1] = hsv(121,56,96);
					[2] = hsv(123,50,91)
				};
				Flat = {
					Vibrant = {
						[0] = 'F35521';
						[1] = 'AA3917';
						[2] = '792810';
					};
					[0] = 'C26B34';
					[1] = '884C25';
					[2] = '693A1C';
				};				
				Material = {
					Light = {
						[50] = rgb(241,248,233);
						[100] = rgb(220,237,200);
						[200] = rgb(197,225,165);
						[300] = rgb(174,213,129);
						[400] = rgb(156,204,101);
						[500] = rgb(139,195,74);
						[600] = rgb(124,179,66);
						[700] = rgb(104,159,56);
						[800] = rgb(85,139,47);
						[900] = rgb(51,105,30);
						['A100'] = rgb(204,255,144);
						['A200'] = rgb(178,255,89);
						['A400'] = rgb(118,255,3);
						['A700'] = rgb(100,221,23);			
					};
					[50] = rgb(232,245,233);
					[100] = rgb(200,230,201);
					[200] = rgb(165,214,167);
					[300] = rgb(129,199,132);
					[400] = rgb(102,187,106);
					[500] = rgb(76,175,80);
					[600] = rgb(67,160,71);
					[700] = rgb(56,142,60);
					[800] = rgb(46,125,50);
					[900] = rgb(27,94,32);
					['A100'] = rgb(185,246,202);
					['A200'] = rgb(105,240,174);
					['A400'] = rgb(0,230,118);
					['A700'] = rgb(0,200,83);			
				};
				[-1] = hsv(121,66,93);
				[0] = hsv(121,71,89);
				[1] = hsv(121,78,84);
				[2] = hsv(121,86,76);
			};				
			Teal = {
				Light = {
					[-1] = 'B8FEF6';
					[0] = '90FEF1';
					[1] = '78F6E7';
					[2] = '75EADF';
				};	
				Flat = {
					Vibrant = {
						[0] = '21F38E';
						[1] = '17AA60';
						[2] = '107943';
					};
					[0] = '02AEAA';
					[1] = '017A77';
					[2] = '015F5D';
				};				
				Material = {
					[50] = rgb(224,242,241);
					[100] = rgb(178,223,219);
					[200] = rgb(128,203,196);
					[300] = rgb(77,182,172);
					[400] = rgb(38,166,154);
					[500] = rgb(0,150,136);
					[600] = rgb(0,137,123);
					[700] = rgb(0,121,107);
					[800] = rgb(0,105,92);
					[900] = rgb(0,77,64);
					['A100'] = rgb(167,255,235);
					['A200'] = rgb(100,255,218);
					['A400'] = rgb(29,233,182);
					['A700'] = rgb(0,191,165);			
				};		
				[-1] = '5EEFDC';
				[0] = '51E6D2';
				[1] = '3ED8C4';
				[2] = '2CC6B1';			
			};
			Cyan = {
				Light = {
					[-1] = 'B8FAFE';
					[0] = '90F9FE';
					[1] = '78F0F6';
					[2] = '75E2EA'
				};
				Material = {
					[50] = rgb(224,247,250);
					[100] = rgb(178,235,242);
					[200] = rgb(128,222,234);
					[300] = rgb(77,208,225);
					[400] = rgb(38,198,218);
					[500] = rgb(0,188,212);
					[600] = rgb(0,172,193);
					[700] = rgb(0,151,167);
					[800] = rgb(0,131,143);
					[900] = rgb(0,96,100);
					['A100'] = rgb(132,255,255);
					['A200'] = rgb(24,255,255);
					['A400'] = rgb(0,229,255);
					['A700'] = rgb(0,184,212);			
				};
				[-1] = '5EEAEF';
				[0] = '51E1E6';
				[1] = '3ED2D8';
				[2] = '2CC1C6';
			};	
			Blue = {
				Light = {
					[2] = hsv(210,50,92);
					[-1] = hsv(209,30,100);
					[0] = hsv(209,47,100);
					[1] = hsv(207,59,100);
				};
				Material = {
					Light = {
						[50] = rgb(225,245,254);
						[100] = rgb(179,229,252);
						[200] = rgb(129,212,250);
						[300] = rgb(79,195,247);
						[400] = rgb(41,182,246);
						[500] = rgb(3,169,244);
						[600] = rgb(3,155,229);
						[700] = rgb(2,136,209);
						[800] = rgb(2,119,189);
						[900] = rgb(1,87,155);
						['A100'] = rgb(128,216,255);
						['A200'] = rgb(64,196,255);
						['A400'] = rgb(0,176,255);
						['A700'] = rgb(0,145,234);			
					};
					[50] = rgb(227,242,253);
					[100] = rgb(187,222,251);
					[200] = rgb(144,202,249);
					[300] = rgb(100,181,246);
					[400] = rgb(66,165,245);
					[500] = rgb(33,150,243);
					[600] = rgb(30,136,229);
					[700] = rgb(25,118,210);
					[800] = rgb(21,101,192);
					[900] = rgb(13,71,161);
					['A100'] = rgb(130,177,255);
					['A200'] = rgb(68,138,255);
					['A400'] = rgb(41,121,255);
					['A700'] = rgb(41,98,255);			
				};
				['Naval coacoa'] = {
					Light = {
						[-1] = hsv(230,19,90);
						[0] = hsv(230,32,86);
						[1] = hsv(229,41,83);
						[2] = hsv(231,37,83)
					};
					[-1] = hsv(230,47,81);
					[0] = hsv(230,53,79);
					[1] = hsv(230,58,72);
					[2] = hsv(230,64,62);
				};
				[-1] = hsv(208,65,100);
				[0] = hsv(208,71,100);
				[1] = hsv(207,76,93);
				[2] = hsv(208,83,82);
			};
			Indigo = {
				Light = {
					[-1] = hsv(244,30,100);
					[0] = hsv(244,47,100);
					[1] = hsv(242,59,100);
					[2] = hsv(245,50,91)
				};
				Material = {
					[50] = rgb(232,234,246);
					[100] = rgb(197,202,233);
					[200] = rgb(159,168,218);
					[300] = rgb(121,134,203);
					[400] = rgb(92,107,192);
					[500] = rgb(63,81,181);
					[600] = rgb(57,73,171);
					[700] = rgb(48,63,159);
					[800] = rgb(40,53,147);
					[900] = rgb(26,35,126);
					['A100'] = rgb(140,158,255);
					['A200'] = rgb(83,109,254);
					['A400'] = rgb(61,90,254);
					['A700'] = rgb(48,79,254);			
				};
				[-1] = hsv(243,65,100);
				[0] = hsv(243,71,100);
				[1] = hsv(242,76,93);
				[2] = hsv(243,83,82);
			};
			Purple = {
				Light = {
					[-1] = hsv(261,30,100);
					[0] = hsv(261,47,100);
					[1] = hsv(259,59,100);
					[2] = hsv(261,50,91)
				};
				Material = {
					Deep = {
						[50] = rgb(237,231,246);
						[100] = rgb(209,196,233);
						[200] = rgb(179,157,219);
						[300] = rgb(149,117,205);
						[400] = rgb(126,87,194);
						[500] = rgb(103,58,183);
						[600] = rgb(94,53,177);
						[700] = rgb(81,45,168);
						[800] = rgb(69,39,160);
						[900] = rgb(49,27,146);
						['A100'] = rgb(179,136,255);
						['A200'] = rgb(124,77,255);
						['A400'] = rgb(101,31,255);
						['A700'] = rgb(98,0,234);			
					};
					[50] = rgb(243,229,245);
					[100] = rgb(225,190,231);
					[200] = rgb(206,147,216);
					[300] = rgb(186,104,200);
					[400] = rgb(171,71,188);
					[500] = rgb(156,39,176);
					[600] = rgb(142,36,170);
					[700] = rgb(123,31,162);
					[800] = rgb(106,27,154);
					[900] = rgb(74,20,140);
					['A100'] = rgb(234,128,252);
					['A200'] = rgb(224,64,251);
					['A400'] = rgb(213,0,249);
					['A700'] = rgb(170,0,255);			
				};
				[-1] = hsv(260,65,100);
				[0] = hsv(260,71,100);
				[1] = hsv(259,76,93);
				[2] = hsv(260,83,82);
			};
			Pink = {
				Light = {
					[-1] = hsv(326,24,100);
					[0] = hsv(326,38,100);
					[1] = hsv(324,48,100);
					[2] = hsv(329,40,93)
				};
				Material = {
					[50] = rgb(252,228,236);
					[100] = rgb(248,187,208);
					[200] = rgb(244,143,177);
					[300] = rgb(240,98,146);
					[400] = rgb(236,64,122);
					[500] = rgb(233,30,99);
					[600] = rgb(216,27,96);
					[700] = rgb(194,24,91);
					[800] = rgb(173,20,87);
					[900] = rgb(136,14,79);
					['A100'] = rgb(255,128,171);
					['A200'] = rgb(255,64,129);
					['A400'] = rgb(245,0,87);
					['A700'] = rgb(197,17,98);			
				};
				[-1] = hsv(324,52,100);
				[0] = hsv(325,58,100);
				[1] = hsv(324,61,94);
				[2] = hsv(325,65,85);
			};
			Amaranth = {
				Light = {
					[-1] = hsv(345,28,100);
					[0] = hsv(345,44,100);
					[1] = hsv(343,55,100);
					[2] = hsv(346,45,92)
				};
				[-1] = hsv(344,61,100);
				[0] = hsv(344,67,100);
				[1] = hsv(344,72,94);
				[2] = hsv(344,77,83);
			};
			Grey = {
				Light = {
					[-1] = hsv(0,0,98);
					[0] = hsv(0,0,96);
					[1] = hsv(0,0,87);
					[2] = hsv(0,0,80)			
				};
				Material = {
					Blue = {
						[50] = rgb(236,239,241);
						[100] = rgb(207,216,220);
						[200] = rgb(176,190,197);
						[300] = rgb(144,164,174);
						[400] = rgb(120,144,156);
						[500] = rgb(96,125,139);
						[600] = rgb(84,110,122);
						[700] = rgb(69,90,100);
						[800] = rgb(55,71,79);
						[900] = rgb(38,50,56);
						['A100'] = rgb(179,136,255);
						['A200'] = rgb(124,77,255);
						['A400'] = rgb(101,31,255);
						['A700'] = rgb(98,0,234);			
					};
					[50] = rgb(250,250,250);
					[100] = rgb(245,245,245);
					[200] = rgb(238,238,238);
					[300] = rgb(224,224,224);
					[400] = rgb(189,189,189);
					[500] = rgb(158,158,158);
					[600] = rgb(117,117,117);
					[700] = rgb(97,97,97);
					[800] = rgb(66,66,66);
					[900] = rgb(33,33,33);
					['A100'] = rgb(234,128,252);
					['A200'] = rgb(224,64,251);
					['A400'] = rgb(213,0,249);
					['A700'] = rgb(170,0,255);			
				};
				Blue = {
					[-1] = hsv(219,21,36);
					[0] = hsv(219,25,34);
					[1] = hsv(220,25,27);
					[2] = hsv(218,25,21)				
				};
				Dark = {
					[-1] = hsv(0,0,25);
					[0] = hsv(0,0,21);
					[1] = hsv(0,0,12);
					[2] = hsv(0,0,2);			
				};
				[-1] = hsv(220,10,32);
				[0] = hsv(213,12,27);
				[1] = hsv(217,12,24);
				[2] = hsv(220,12,18);
			};
			Brown = {
				Light = {
					[-1] = '7B6C67';
					[0] = '745D56';
					[1] = '6F5149';
					[2] = '6A534C'			
				};
				Material = {
					[50] = rgb(239,235,233);
					[100] = rgb(215,204,200);
					[200] = rgb(188,170,164);
					[300] = rgb(161,136,127);
					[400] = rgb(141,110,99);
					[500] = rgb(121,85,72);
					[600] = rgb(109,76,65);
					[700] = rgb(93,64,55);
					[800] = rgb(78,52,46);
					[900] = rgb(62,39,35);			
				};
				[-1] = '6D4C43';
				[0] = '6B463C';
				[1] = '623D33';
				[2] = '543127'	
			};
	};
	Fade = {
			lerp = function(who,to) local typ,trans if type(who) == 'table' then who = who[1] typ = 'Text' elseif who.ClassName:sub(1,5) == 'Image' then typ = 'Image' else typ = 'Background' end typ = typ..'Color3' coroutine.wrap(function() for i = 0,1,.01 do who[typ] = who[typ]:lerp(to,i) wait() end end)() end;
			fade = function(who,from,to) local typ,trans if type(who) == 'table' then who = who[1] typ = 'Text' elseif who.ClassName:sub(1,5) == 'Image' then typ = 'Image' else typ = 'Background' end typ = typ..'Color3' coroutine.wrap(function() repeat for i = 0,1,.005 do who[typ] = from:lerp(to,i) wait(.01) end for i = 0,1,.005 do who[typ] = to:lerp(from,i) wait(.01) end until nil end)() end;
			gradient = function(who,from,to) if from == 'end' then who.COLORHUE.Go.Value = false return end local typ,trans if type(who) == 'table' then who = who[1] typ = 'Text' elseif who.ClassName:sub(1,5) == 'Image' then typ = 'Image' else typ = 'Background' end local create,tween = Booge.find('create'),Booge.find('tween').tween who.ZIndex = who.ZIndex + 1 trans = who.BackgroundTransparency for i,v in pairs(who:GetChildren())do if v.ClassName ~= 'Folder' then v.ZIndex = v.ZIndex+1 end end local main = create('Folder',who,{n = 'COLORHUE'}) local go = create('BoolValue',main,{Name = 'Go',Value = true}) who.ClipsDescendants = true coroutine.wrap(function() repeat for i = 0,1,.005 do if go.Value == true then local color = from:lerp(to,i) who[typ..'Color3'] = color local h,s,v = Color3.toHSV(color) local c = create('Frame',main,{s = UDim2.new(0,5,1,0),n = 'color',pos = UDim2.new(0,-5,0,0),bsp = 0,bg = color,trans = trans,z = who.ZIndex-1}) for i,v in pairs(main:GetChildren())do if v.ClassName == 'Frame' then tween(v,'pos',v.Position + UDim2.new(0,5,0,0),.005) if v.Position.X.Offset > who.AbsoluteSize.X then v:Destroy() end end end game:GetService'RunService'.RenderStepped:wait() end end who.BackgroundTransparency = 1 for i = 0,1,.005 do if go.Value == true then local color = to:lerp(from,i) who[typ..'Color3'] = color local h,s,v = Color3.toHSV(color) local c = create('Frame',main,{s = UDim2.new(0,5,1,0),n = 'color',pos = UDim2.new(0,-5,0,0),bsp = 0,bg = color,trans = trans,z = who.ZIndex-1}) for i,v in pairs(main:GetChildren())do if v.ClassName == 'Frame' then tween(v,'pos',v.Position + UDim2.new(0,5,0,0),.005) if v.Position.X.Offset > who.AbsoluteSize.X then v:Destroy() end end end game:GetService'RunService'.RenderStepped:wait() end end until main.Go.Value == false main:Destroy() who.BackgroundTransparency,who.ZIndex = trans,who.ZIndex - 1 for i,v in pairs(who:GetChildren())do if v.ClassName ~= 'Folder' then v.ZIndex = v.ZIndex-1 end end end)() end;
		};
	};	
	Items = {
		
	};
	find = function(a,b) if not b then b = Booge end for i,v in pairs(b)do if type(v) == 'table' then for z,x in pairs(v)do if z:sub(1,#a):lower() == a:lower() then return x end end end end end;
	round = function(num)
		return math.floor(num+.5)
	end
}
Booge.Items = {Shadow = Booge.Create.Create('ImageLabel',nil,{n = 'Shadow',Rotation = 0.0001,Position = UDim2.new(0,0,1,0),Size = UDim2.new(1,0,0,1),Image = 'rbxasset://textures/ui/TopBar/dropshadow@2x.png',BackgroundTransparency = 1}); Circle = Booge.Create.Create('ImageLabel',nil,{n = 'Circle',ImageTransparency = .7,AnchorPoint = Vector2.new(.5,.5),BackgroundTransparency = 1,Image = 'rbxassetid://631172870',ImageColor3 = Color3.new(0,0,0)}); Round = Booge.Create.Create('Folder',nil,{n = 'Round'}); }; tl = Booge.find('create')('ImageLabel',Booge.find('round'),{BackgroundTransparency = 1,Size = UDim2.new(0,5,0,5),Image = 'rbxassetid://962539105',ImageRectOffset = Vector2.new(54,57),ImageRectSize = Vector2.new(100,100)}); tr = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(1,0),Position = UDim2.new(1,0,0,0),Rotation = 90}); bl = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(0,1),Position = UDim2.new(0,0,1,0),Rotation = 270}); br = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(1,1),Position = UDim2.new(1,0,1,0),Rotation = 180}); top = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,0),Size = UDim2.new(1,-10,0,5),ImageRectOffset = Vector2.new(154,57),ImageRectSize = Vector2.new(289,100)}); bottom = Booge.find('Set')(top:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(.5,1),Rotation = 180,Position = UDim2.new(.5,0,1,0)}); rest = Booge.find('create')('Frame',Booge.find('round'),{BorderSizePixel = 0,Parent = tl.Parent, AnchorPoint = Vector2.new(0,.5),Position = UDim2.new(0,0,.5,0),Size = UDim2.new(1,0,1,-10)}); 


	
