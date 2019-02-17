hsv = function(h,s,v)
	return Color3.fromHSV(h/360,s/100,v/100)
end
rgb = Color3.fromRGB
Booge = {
	Shortcuts = {
		[0] = {
			__index = function(self,i)
				local tab,tex = {},''
				for z,v in pairs(self)do
					if type(v) == 'string' then
					if v:sub(1,1):lower() == i:sub(1,1):lower()then
						for w in v:gmatch('%u')do
							table.insert(tab,w)
						end
						for _,e in pairs(tab)do
							tex = tex..e
						end
						if i:lower() == tex:lower() then
							return v
						elseif v:sub(1,#i):lower() == i:lower() then
							return v
						else
							tex = ''
							tab = {}
						end
					end
					end
				end
				return i
			end;
		};
		'Active','AnchorPoint','BackgroundColor3','BorderColor3','BorderSizePixel';
		'Name','Position','Size','SizeConstraint','Visible','ZIndex','ClipsDescendants';
		'Draggable','BackgroundTransparency','Font','Text','TextColor3','TextSize';
		'TextScaled','TextStrokeColor3','TextStrokeTransparency','TextTransparency','TextWrapped';
		'TextXAlignment','TextYAlignment','Image','ImageColor3','ImageRectOffset','ImageRectSize';
		'ImageTransparency','Parent','CanvasPosition','BottomImage','CanvasSize','HorizontalScrollBarInsert','MidImage','ScrollBarThickness';
		'ScrollingEnabled','TopImage','VerticalScrollBarInsert','VerticalScrollBarPosition'
	};	
	Create = {
		Create = function(a,b,c,...)
			local created,bool
			if not created then
				created = Instance.new(a)
			end
			if b then
				if type(b) == 'table' then
					b = b[1]
				end
				created.Parent = b
			end
			if c then
				for i,v in pairs(c)do
					i = Booge.Shortcuts[i]
					if i == 'Rounded' and v == true then
						Booge.Items.Round:Clone().Parent = created
						created.BackgroundTransparency = 1
						created.ZIndex = created.ZIndex + 1
					elseif i == 'Draggable' and v == true then
						created.Active = true
						created.Draggable = true
					elseif i == 'Image' and type(v) == 'userdata' then
						local icon = iconInfo(v)
						Booge.find'set'(created,{image = icon[1],iro = icon[2],irs = icon[3]})
					elseif i == 'Rounded' and v == 'rounder' then local round = Booge.find('create')('Folder',created,{n = 'Round'}) local right = Booge.find('create')('ImageLabel',round,{r = .001,image = 'rbxassetid://974669661', ap = Vector2.new(1,1),bt = 1,pos = UDim2.new(1,0,1,0),Size = UDim2.new(0,25,1,0),z = created.ZIndex,iro = Vector2.new(400,0),irs = Vector2.new(400,800)}) local left = Booge.find('set')(right:Clone(),{p = round,ap = Vector2.new(0,0),pos = UDim2.new(0,0,0,0),iro = Vector2.new(0,0)}) local rest = Booge.find('crea')('ImageLabel',round,{r = .001,ap = Vector2.new(.5,0),bt = 1,pos = UDim2.new(.5,0,0,0),s = UDim2.new(1,-50,1,0),image = 'rbxassetid://974669661',iro = Vector2.new(400,0),irs = Vector2.new(5,800)}) created.BackgroundTransparency = 1 created.ZIndex = created.ZIndex + 1
					elseif i == 'Ripple' and v == true and a:sub(#a-5,#a) == 'Button' then	
						local Button = created	
						Button.ClipsDescendants = true
						Button.AutoButtonColor = false
						Button.MouseButton1Click:connect(function()
						coroutine.resume(coroutine.create(function()
							local m = game.Players.LocalPlayer:GetMouse()
							local Circle = Booge.find'create'('ImageLabel',Button,{name = 'Circle',ic = Color3.new(0,0,0),bt = 1,z = 10,ima = 'rbxassetid://266543268',it = .9})
							local NewX = m.X - Circle.AbsolutePosition.X
							local NewY = m.Y - Circle.AbsolutePosition.Y
							Circle.Position = UDim2.new(0,NewX,0,NewY)
							local Size = 0
							if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
								 Size = Button.AbsoluteSize.X*1.5
							elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
								 Size = Button.AbsoluteSize.Y*1.5
							elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																																																																														
								Size = Button.AbsoluteSize.X*1.5
							end							
							local Time = .5
							Booge.find'tween'.tween(Circle,'both',UDim2.new(.5,-Size/2,.5,-Size/2),UDim2.new(0,Size,0,Size),Time,{'Out','Quad'})
							for i = 1,10,1 do
								Circle.ImageTransparency = Circle.ImageTransparency + .01
								wait(Time/10)
							end
							Circle:Destroy()
						end))
						end)
						--[[local circle = Booge.find('set')(Booge.Items.Circle:Clone(),{z = created.ZIndex + 1,par = created})
						circle.Position = UDim2.new(0,m.X-circle.AbsolutePosition.X,0,m.Y-circle.AbsolutePosition.Y)
						local Size = 0
						if created.AbsoluteSize.X > created.AbsoluteSize.Y then
							 Size = created.AbsoluteSize.X*1.5
						elseif created.AbsoluteSize.X < created.AbsoluteSize.Y then
							 Size = created.AbsoluteSize.Y*1.5
						elseif created.AbsoluteSize.X == created.AbsoluteSize.Y then																																																																														
							Size = created.AbsoluteSize.X*1.5
						end
						created.AutoButtonColor = false
						created.MouseButton1Click:connect(function()
							
							Booge.find('tween').tween(circle,'both',UDim2.new(0,Size,0,Size),UDim2.new(.5,-Size/2,.5,-Size/2),.5,{'Out','Quad'})
							coroutine.wrap(function()
								for i = .1,10 do
									circle.ImageTransparency = circle.ImageTransparency + .01
									wait(.05)
								end
								circle:Destroy()
							end)()
						end)
					created.ClipsDescendants = true]]			
					elseif i == 'Ripple' and type(v) == 'number' and a:sub(#a-5,#a) == 'Button' then
						local Button = created	
						Button.ClipsDescendants = true
						Button.AutoButtonColor = false
						Button.MouseButton1Click:connect(function()
						coroutine.resume(coroutine.create(function()
							local m = game.Players.LocalPlayer:GetMouse()
							local Circle = Booge.find'create'('ImageLabel',Button,{name = 'Circle',ic = Color3.new(0,0,0),bt = 1,z = v,ima = 'rbxassetid://266543268',it = .9})
							local NewX = m.X - Circle.AbsolutePosition.X
							local NewY = m.Y - Circle.AbsolutePosition.Y
							Circle.Position = UDim2.new(0,NewX,0,NewY)
							local Size = 0
							if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
								 Size = Button.AbsoluteSize.X*1.5
							elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
								 Size = Button.AbsoluteSize.Y*1.5
							elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																																																																														
								Size = Button.AbsoluteSize.X*1.5
							end							
							local Time = .5
							Booge.find'tween'.tween(Circle,'both',UDim2.new(.5,-Size/2,.5,-Size/2),UDim2.new(0,Size,0,Size),Time,{'Out','Quad'})
							for i = 1,10,1 do
								Circle.ImageTransparency = Circle.ImageTransparency + .01
								wait(Time/10)
							end
							Circle:Destroy()
						end))
						end)
					elseif i == 'Shadow' and v == 'hover' then
						created.MouseEnter:connect(function()
							if not created:FindFirstChild('Shadow') then
								local s = Booge.Items.Shadow:Clone()
								s.ZIndex = created.ZIndex - 1
								Booge.find('tween').tween(Booge.find('set')(s,{n = 'Shadow',par = created}),'size',UDim2.new(1,0,0,7),.1)
							else
								local s = created.Shadow
								Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,7),.1)
							end
						end)
						created.MouseLeave:connect(function()
							local s = created:FindFirstChild('Shadow')
							Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,1),.1)
						end)
					elseif i == 'Shadow' and type(v) == 'table' then  local s =  Booge.find'create'('Folder',created,{n = 'Shadow'}) for i = 0,v[2],1 do Booge.find('set')(Booge.Items.Shadow:Clone(),{p = s,s = UDim2.new(1,0,0,1)}) end if v[1] == 'hover' then if not v[3] then v[3] = 7 end created.MouseEnter:connect(function() for i,q in pairs(created:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(q,'size',UDim2.new(1,0,0,v[3]),.1) end end) created.MouseLeave:connect(function() for i,v in pairs(created:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(v,'size',UDim2.new(1,0,0,1),.1) end end) end
					elseif i == 'Shadow' and v == true then
						Booge.find('set')(Booge.Items.Shadow:Clone(),{p = created,s = UDim2.new(1,0,0,7)})
					elseif i == 'Shadow' and v == 'double' then
						local s = Booge.find'create'('Folder',created,{n = 'Shadow'})
						Booge.find('set')(Booge.Items.Shadow:Clone(),{p = s,s = UDim2.new(1,0,0,7)}):Clone().Parent = created
					elseif i:sub(#i-5,#i) == 'Color3' and type(v) ~= 'userdata' then
						local number,theme
						local t,tg = Booge.find'tothem',Booge.find'theme'.Get
						if type(v) == 'table' then
							theme,number = v[1],v[2]
						elseif type(v) == 'string' then
							theme,number = v,1
						end
						if i:sub(1,4) == 'Text' then
							t(created,theme,number,'t')
						elseif i:sub(1,6) == 'Border' then
							t(created,theme,number,'b')
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
			if a:sub(1,5) == 'Image' then
				created.BackgroundTransparency = 1
			end
			return created
			
		end;
		Set = function(a,b)
			if type(a) == 'table' then
				a = a[1]
			end
			for i,v in pairs(b)do
					for i,v in pairs(b)do
					 i = Booge.Shortcuts[i]
					 if i == 'Rounded' and v == true then
						Booge.Items.Round:Clone().Parent = a
						a.BackgroundTransparency = 1
						a.ZIndex = a.ZIndex + 1
					elseif i == 'Draggable' and v == true then
						a.Active = true
						a.Draggable = true
					elseif i == 'Image' and type(v) == 'userdata' then
						local icon = iconInfo(v)
						Booge.find'set'(a,{image = icon[1],iro = icon[2],irs = icon[3]})
					elseif i == 'Rounded' and v == 'rounder' then local round = Booge.find('create')('Folder',a,{n = 'Round'}) local right = Booge.find('create')('ImageLabel',round,{r = .001,image = 'rbxassetid://974669661', ap = Vector2.new(1,1),bt = 1,pos = UDim2.new(1,0,1,0),Size = UDim2.new(0,25,1,0),z = a.ZIndex,iro = Vector2.new(400,0),irs = Vector2.new(400,800)}) local left = Booge.find('set')(right:Clone(),{p = round,ap = Vector2.new(0,0),pos = UDim2.new(0,0,0,0),iro = Vector2.new(0,0)}) local rest = Booge.find('crea')('ImageLabel',round,{r = .001,ap = Vector2.new(.5,0),bt = 1,pos = UDim2.new(.5,0,0,0),s = UDim2.new(1,-50,1,0),image = 'rbxassetid://974669661',iro = Vector2.new(400,0),irs = Vector2.new(5,800)}) a.BackgroundTransparency = 1 a.ZIndex = a.ZIndex + 1 elseif i == 'Ripple' and v == true and a.ClassName:sub(#a.ClassName-5,#a.ClassName) == 'Button' then a.AutoButtonColor = false a.MouseButton1Click:connect(function() local m = game.Players.LocalPlayer:GetMouse() Booge.find('tween').tween(Booge.find('set')(Booge.Items.Circle:Clone(),{z = a.ZIndex + 1,par = a,pos = UDim2.new(0,m.X-a.AbsolutePosition.X,0,m.Y-a.AbsolutePosition.Y)}),'size',UDim2.new(0,900,0,900),.9) coroutine.wrap(function() for i = .7,1,.05 do a.Circle.ImageTransparency = i wait(.001) end a.Circle:Destroy() end)() end) a.ClipsDescendants = true elseif i == 'Shadow' and v == 'hover' then a.MouseEnter:connect(function() if not a:FindFirstChild('Shadow') then local s = Booge.Items.Shadow:Clone() Booge.find('tween').tween(Booge.find('set')(s,{n = 'Shadow',p = a}),'size',UDim2.new(1,0,0,7),.1) else local s = a.Shadow Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,7),.1) end end) a.MouseLeave:connect(function() local s = a:FindFirstChild('Shadow') Booge.find('tween').tween(s,'size',UDim2.new(1,0,0,1),.1) end) elseif i == 'Shadow' and type(v) == 'table' then local s = Booge.find'create'('Folder',a,{n = 'Shadow'}) for i = 0,v[2],1 do Booge.find('set')(Booge.Items.Shadow:Clone(),{p = s,s = UDim2.new(1,0,0,1)}) end if v[1] == 'hover' then if not v[3] then v[3] = 7 end a.MouseEnter:connect(function() for i,q in pairs(a:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(q,'size',UDim2.new(1,0,0,v[3]),.1) end end) a.MouseLeave:connect(function() for i,v in pairs(a:FindFirstChild('Shadow'):GetChildren())do Booge.find('tween').tween(v,'size',UDim2.new(1,0,0,1),.1) end end) end elseif i == 'Shadow' and v == true then Booge.find('set')(Booge.Items.Shadow:Clone(),{p = a,s = UDim2.new(1,0,0,7)}) elseif i == 'Shadow' and v == 'double' then Booge.find('set')(Booge.Items.Shadow:Clone(),{p = a,s = UDim2.new(1,0,0,7)}):Clone().Parent = a
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
						elseif i:sub(1,6) == 'Border' then
							t(a,theme,number,'b')
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
			tween = function(who,what,where,when,how,ex) if what ~= 'both' then if not how then how = {'Out','Sine'} end if what == 'size' then who:TweenSize(where,how[1],how[2],when,true) elseif what == 'pos' then who:TweenPosition(where,how[1],how[2],when,true) end else if not ex then ex = {'Out','Sine'} end who:TweenSizeAndPosition(when,where,ex[1],ex[2],how,true) end end;
			Enter = function(who,from,tox,toy,tim,offset,more) who.Position = from if not offset then offset = {0,0} end local x,y if tox == 'left' or toy == 'left' then x = 0 elseif tox == 'center' or toy == 'center' and y == nil then x = .5 elseif tox == 'right' or toy == 'right' then x = 1 end if tox == 'top' or toy == 'top' then y = 0 elseif tox == 'center' or toy == 'center' and x then y = .5 elseif tox == 'bottom' or toy == 'bottom' then y = 1 end Booge.find('twee').tween(who,'pos',UDim2.new(x,offset[1],y,offset[2]),tim,more) end;
			Leave = function(who,from,tox,toy,tim,offset,more) who.Position = from if not offset then offset = {0,0} end local x,y if tox == 'left' or toy == 'left' then x = -1 elseif tox == 'center' or toy == 'center' and y == nil then x = .5 elseif tox == 'right' or toy == 'right' then x = 2 end if tox == 'top' or toy == 'top' then y = -1 elseif tox == 'center' or toy == 'center' and x then y = .5 elseif tox == 'bottom' or toy == 'bottom' then y = 2 end Booge.find('twee').tween(who,'pos',UDim2.new(x,offset[1],y,offset[2]),tim,more) end;
			Rotate = function(who,where,when)
				local positive = 1/when
				if where < who.Rotation then
					positive = -1/when
				end
				coroutine.wrap(function()
				for i = who.Rotation,where,positive do
					who.Rotation = i
					wait()
				end
				end)()
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
			new = function(a,b,c,d) if d then return UDim2.new(a,b,c,d) elseif c == 1 then return UDim2.new(a,0,b,0) elseif c == 2 then return UDim2.new(0,a,0,b) elseif c == 3 then return UDim2.new(a,b,a,b) elseif b == 'o' then return UDim2.new(0,a,0,a) elseif b == 's' then return UDim2.new(a,0,a,0) elseif c == 'x' then return UDim2.new(a,b,0,0) elseif c == 'y' then return UDim2.new(0,0,a,b) elseif c == 4 then return UDim2.new(a,0,0,b) elseif c == 5 then return UDim2.new(0,a,b,0) end end; Offset = function(a,b) return UDim2.new(0,a,0,b) end; Scale = function(a,b) return UDim2.new(a,0,b,0) end;
			fromPosition = function(a,b,c,d) local y,x if not b then b = '' end if a:lower()== 'top' or b:lower() == 'top' then y = 0 elseif a:lower() == 'center' or b:lower() == 'center' and x == nil or x == 0 then y = .5 elseif a:lower() == 'bottom' or b:lower() == 'bottom' then y = 1 elseif a:lower() == 'center' and not b then y,x = .5,1/2 else y = 0 end if a:lower()== 'left' or b:lower() == 'left' then x = 0 elseif a:lower()== 'center' or b:lower() == 'center' and y~= nil then x = .5 elseif a:lower() == 'right' or b:lower() == 'right' then x = 1 else x = 0 end if not c then c = 0 end if not d then d = 0 end return UDim2.new(x,c,y,d) end
		};
	};
	Color = {
		new = function(colour,number,alt)
			local color
			if not number then
				number = 0
			end
			for i,v in pairs(Booge.find'colo')do
				if i:sub(1,#colour):lower() == colour:lower() then
					if alt then
						for z,x in pairs(v)do
							if type(z) == 'string' and z:sub(1,#alt):lower() == alt then
								color = x[number]
							end
						end
					else
						color = v[number] 
					end
					if color and type(color) == 'string' then
						color = Booge.find'fromhex'(color)
					end
					return color
				end
			end
		end;
		editRGB = function(color,r,g,b)
			local red,green,blue = color.r*255,color.g*255,color.b*255
			return rgb(red+r,green+g,blue+b)
		end;
		editHSV = function(color,h,s,v)
			local hue,saturation,variance = Booge.find'tohsv'(color)
			return hsv(hue+h,saturation+s,variance+v)
		end;
		Colours = {
			Red = {
				Light = {
					[-1] = hsv(359,30,100);
					[0] = hsv(359,47,100);
					[1] = hsv(358,59,100);
					[2] = hsv(358,50,91)
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
				[-1] = '6D4C43';
				[0] = '6B463C';
				[1] = '623D33';
				[2] = '543127'	
			};
			White = {
				[0] = rgb(255,255,255);
			};
			Black = {
				[0] = rgb(0,0,0);
			};
	};
		Fade = {
			lerp = function(who,to) 
				local typ,bt 
				if type(who) == 'table' then 
					who = who[1] typ = 'Text' 
				elseif who.ClassName:sub(1,5) == 'Image' then 
					typ = 'Image' 
				else typ = 'Background' end typ = typ..'Color3' 
					coroutine.wrap(function() for i = 0,1,.01 do who[typ] = who[typ]:lerp(to,i) wait() end end)() end;
			};
	};	
	Items = {
	};
	find = function(a,b) if not b then b = Booge end for i,v in pairs(b)do if type(v) == 'table' then for z,x in pairs(v)do if tostring(z):sub(1,#a):lower() == a:lower() then return x end end end end end;
	round = function(num)
		return math.floor(num+.5)
	end
}
create2,Booge.Create[0],GetShortcut,Booge.Shortcuts[0] = setmetatable(Booge.Create,Booge.Create[0]),nil,setmetatable(Booge.Shortcuts,Booge.Shortcuts[0]),nil
Booge.Items = {Shadow = Booge.Create.Create('ImageLabel',nil,{n = 'Shadow',Rotation = 0.0001,Position = UDim2.new(0,0,1,0),Size = UDim2.new(1,0,0,1),Image = 'rbxasset://textures/ui/TopBar/dropshadow@2x.png',BackgroundTransparency = 1}); Circle = Booge.Create.Create('ImageLabel',nil,{n = 'Circle',ImageTransparency = .7,AnchorPoint = Vector2.new(.5,.5),BackgroundTransparency = 1,Image = 'rbxassetid://620823795',ImageColor3 = Color3.new(0,0,0)}); Round = Booge.Create.Create('Folder',nil,{n = 'Round'}); }; tl = Booge.find('create')('ImageLabel',Booge.find('round'),{BackgroundTransparency = 1,Size = UDim2.new(0,5,0,5),Image = 'rbxassetid://962539105',ImageRectOffset = Vector2.new(54,57),ImageRectSize = Vector2.new(100,100)}); tr = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(1,0),Position = UDim2.new(1,0,0,0),Rotation = 90}); bl = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(0,1),Position = UDim2.new(0,0,1,0),Rotation = 270}); br = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(1,1),Position = UDim2.new(1,0,1,0),Rotation = 180}); top = Booge.find('Set')(tl:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,0),Size = UDim2.new(1,-10,0,5),ImageRectOffset = Vector2.new(154,57),ImageRectSize = Vector2.new(289,100)}); bottom = Booge.find('Set')(top:Clone(),{Parent = Booge.find('round'), AnchorPoint = Vector2.new(.5,1),Rotation = 180,Position = UDim2.new(.5,0,1,0)}); rest = Booge.find('create')('Frame',Booge.find('round'),{BorderSizePixel = 0,Parent = tl.Parent, AnchorPoint = Vector2.new(0,.5),Position = UDim2.new(0,0,.5,0),Size = UDim2.new(1,0,1,-10)}); 

--DIMS
find = Booge.find round = Booge.round create,set,new = find'create',find'set',find'newCus' Tween = find'tween' tween,rotate,pop = Tween.tween,Tween.Rotate,Tween.Pop ud,udpos,v2 = find'ud'.new,find'ud'.fromPosition,Vector2.new Color,Theme = Booge.Color,find'Theme' lerp,fade,gradient = find('lerp',Color),find('fade',Color),find('gradient',Color) fadein,fadeout = find'fade'.In,find'fade'.Out lp = game.Players.LocalPlayer hex = Color.fromHex multiset = function(tab,to) for i,seas in pairs(tab)do set(seas,to) end end multitheme = function(tab,to,num) if not num then num = 1 end for _,v in pairs(tab)do Color.toTheme(v,to,num) end end tablemerge = function(from,to) for i,v in pairs(from)do if to[i] then for a,z in pairs(v)do to[i][a] = z end else to[i] = v end end return to end themeSwitch = function(a,b) local at,bt = Theme.Get(a),Theme.Get(b) Theme.Set(a,bt) Theme.Set(b,at) end geticons = function(tabl,image,getx,gety,size) local name,sub,self if not size then size = 144 end image = create('ImageLabel',nil,{image = image}) local iro,irs,new,spare = image.ImageRectOffset,Vector2.new(size,size),create('ImageLabel'),tabl tabl = {} local id = 1 for y = 0,gety-1,1 do for x = 0,getx-1,1 do sub,name = nil,nil name,self = spare[id],set(image,{iro = Vector2.new(x*144,y*144),irs = Vector2.new(size,size)}) if name:find'_' then sub = name:sub(name:find'_'+1) name = name:sub(1,name:find'_'-1) end name = name:sub(1,1):upper()..name:sub(2) if not tabl[name] then if not sub then tabl[name] = set(self:Clone(),{Name = name}) else tabl[name] = {} tabl[name][sub] = set(self:Clone(),{Name = sub:sub(1,1):upper()..sub:sub(2)}) end else if sub then tabl[name][sub] = set(self:Clone(),{Name = sub:sub(1,1):upper()..sub:sub(2)}) end end id = id + 1 end end return tabl end iconInfo = function(icon,num) if not num then return {icon.Image,icon.ImageRectOffset,icon.ImageRectSize} elseif num == 'pic' or num == 1 then return icon.Image elseif num == 'iro' or num == 2 then return icon.ImageRectOffset elseif num == 'irs' or num == 3 then return icon.ImageRectSize elseif icon[num] then return icon[num] else warn'error; no info' end end get = function(link,typ) local tab = {} link = game.HttpService:UrlEncode(link:sub(link:find'catalog/json?'+13,#link)) local proxy = 'https://www.classy-studios.com/APIs/Proxy.php?Subdomain=search&Dir=catalog/json?' if typ then link = game:GetService'HttpService':JSONDecode(game:GetService'HttpService':GetAsync(proxy..link)) else link = game:GetService'HttpService':JSONDecode(game:HttpGetAsync(proxy..link)) end for i,v in pairs(link)do tab[v.Name] = v end return tab end numTable = function(tab) local new = {} local id = 1 for i,v in pairs(tab)do new[id] = v id = id + 1 end return new end function isIcon(self,icon) self = iconInfo(self) icon = iconInfo(icon) for i = 1,3,1 do if self[i] ~= icon[i] then return false end end return true end function toIcon(self,icon) set(self,{image = icon}) end  																			{'volume_up','sound_play','volume_none','sound_stop','navigation_exit'; 'volume_down','sound_pause','script_script','color_invert','navigation_back'; 'color_picker','face_no','home','color_wheel','navigation_menu'; 'folder','extension','alert_circle','lock_lock','navigation_dropdown'; 'music_queue','music_add','face_yes','music_library','navigation_more'; 'sound_loop','volume_mute','alert_triangle','script_code','settings'; 'navigation_moreapps','visibility_visible','search','delete','keybinds'; }; icons2 = {'visibility_opacity','lock_unlock','navigation_minimize','visibility_invisible'; 'discord','music_note','model','save'; 'library','image_image','image_library','music_notes'; }; icons = geticons(icons,'rbxassetid://1008975654',5,7) icons2 = geticons(icons2,'rbxassetid://1010533178',4,3) icons = tablemerge(icons2,icons) 
Color.materialSpread = function(color)
	local m = Color.fromMaterialicons =
	return {[-4] = m(color,50),[-3] = m(color,100),[-2] = m(color,200),[-1] = m(color,400),m(color,500),m(color,600),m(color,700),m(color,800),m(color,900)}
end
Booge.tablerev = function(tab)
	local rev = {}
	for i,v in pairs(tab)do
		rev[#tab-i] = v
	end
	return rev
end
--END
--Theme.New({'Favorite',Color.fromHex('#000000')})
function Color.getFavoriteColor(num,alt)
	local str,content,color
	if not num then num = 1 end
	if not alt then
		str = game.HttpService:GetAsync('http://www.color-hex.com/')
	else
		str = game:HttpGet'http://www.color-hex.com/'
	end
	for i = 1,num,1 do
		str = str:sub(str:find'colordva'+1,#str)
	end
	content = str:sub(1,str:find';">')
	color = content:sub(content:find'#',content:find';'-1)
	return Color.fromHex(color)
end
function Color.getPallete(color,typ,alt)
	local link,tab,ret = 'http://www.color-hex.com/color/',{},{}
	local str,tri,ana,mono,comp,tint,shad
	if not alt then
		str = game.HttpService:GetAsync(link..Color.toHex(color):lower())
	else
		str = game:HttpGet(link..Color.toHex(color))
	end
	--Triadic
	local help = {}
	for test in Color.toHex(color):gmatch(Color.toHex(color):sub(1,1)) do
		table.insert(help,test)
	end
	if #help ~= #Color.toHex(color)then
	tri = str:sub(str:find'Triadic',#str)  tri = tri:sub(tri:find'<tr>',tri:find'</tr>')
	ana = str:sub(str:find'Analogous',#str)  ana = ana:sub(ana:find'<tr>',ana:find'</tr>')
	comp = str:sub(str:find'Complementary',#str) comp = comp:sub(comp:find'<tr>',comp:find'</tr>')
	end
	shad = str:sub(str:find'Shades of',str:find'Tints of')
	tint = str:sub(str:find'Tints of',str:find':#ffffff'+19)
	mono = str:sub(str:find'Monochromatic',#str)  mono = mono:sub(mono:find'colordvconline"',mono:find'<h3>')
	tab.Shades = shad
	tab.Tints = tint
	tab.Monochromatic = mono
	tab.Complementary = comp
	tab.Analogous = ana
	tab.Triadic = tri
	for i,v in pairs(tab)do
		local color
		if i ~= 'Monochromatic' and i ~= 'Shades' and i ~= 'Tints' then
			for col in v:gmatch('td style')do
				color = ''
				color = v:sub(v:find'#'+1,v:find'></td>'-2)
				if not ret[i] then
					ret[i] = {}
				end
				table.insert(ret[i],Color.fromHex(color))
				v = v:sub(v:find'></td>'+6,#v)
			end
		else
			for col in v:gmatch('colordvconline')do
				v = v:sub(v:find'colordvconline'+15)
				color = ''
				color = v:sub(v:find':#'+2,v:find';">'-1)
				if not ret[i] then
					ret[i] = {}
				end
				table.insert(ret[i],Color.fromHex(color))	
			end
		end
	end
	return ret
end
return Booge