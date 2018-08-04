Spice.Objects.Classes.new("RoundedFrame",function(round)
	round = round or 15;
	local ud,v2 = Spice.Positioning.new, Spice.Positioning.fromVector2
	local Class = {
		Round = round;
		setRound = function(self,new,d)
			if self.Object.Round ~= new or d then
				self.Object.Round = new
				if self.RoundValue.Value ~= self.Object.Value then 
					self.RoundValue.Value = new
				end
				local ud = Spice.Positioning.new
				for i,v in next, d and d:GetChildren() or self.Rounded:GetChildren() do
					if Spice.Objects.Custom.isCustom(v) then
						Spice.Objects.Custom.getCustomFromInstance(v).Radius = new/2					
					elseif v:IsA('GuiObject') and v.Name ~= 'Border' and v.Name ~= 'Main' then
						local var = v.Size.X.Scale
						local si = var == 1 and ud(1,-new*2,0,new) or var == 0 and ud(0,new,1,-new*2)
						v.Size = si
					elseif v.Name == 'Main' then
						v.Size = ud(1,-new*2,3)
					end
				end
				if not d then self:setRound(new,self.Rounded.Border) end
			end
		end;
		setTransparency = function(self,new)
			self.Instance.Transparency = 1
			if new > 0 then
				self.Rounded.Border.Visible = false
			else
				self.Rounded.Border.Visible = true
			end
			for i,v in next, self.Rounded:GetChildren() do
				if Spice.Properties.hasProperty(v,Spice.Misc.dynamicProperty(v)..'Transparency') and v.Name ~= 'Border' then
					v[Spice.Misc.dynamicProperty(v)..'Transparency'] = new
				end
			end
		end;
		setColor = function(self,new,d)
			for i,v in next, not d and self.Rounded:GetChildren() or d:GetChildren() do
				if Spice.Properties.hasProperty(v,Spice.Misc.dynamicProperty(v)..'Color3') then
					v[Spice.Misc.dynamicProperty(v)..'Color3'] = new
				end
			end			
		end;
		setBorder = function(self,new)
			if new > 0 and self.Transparency <= 0 then
				self.Rounded.Border.Visible = true
				self.Rounded.Border.Size = ud(1,new*2,3)
			else
				self.Rounded.Border.Visible = false
				self.Rounded.Border.Size = ud(1,0,3)
			end
		end;
		setBorderColor = function(self,new)
			self:setColor(new,self.Rounded.Border)
		end;
		PropertyChanged = function(self,sig,fun)
			self.GetPropertyChangedSignal(self.Instance,sig):connect(function()
				self[fun](self,self[sig])
			end)
		end;
		resetSignal = function(self)
			self:PropertyChanged('BackgroundColor3','setColor')
			self:PropertyChanged('BackgroundTransparency','setTransparency')	
			self:PropertyChanged('BorderColor3','setBorderColor')
			self:PropertyChanged('BorderSizePixel','setBorder')	
			self.RoundValue.Value = self.Round	
			self.RoundValue.Changed:connect(function(a)
				self.Round = a
			end)
		end
	}
	local rounded = Spice.Objects.newInstance('Frame',{siz = ud(1),trans = 1,nam = 'Rounded'})
	for i = 1,4 do
		local stuff = {ud(0,0,1),ud(1,0,1),ud(0,1,1),ud(1,1,1),v2(0,0),v2(1,0),v2(0,1),v2(1,1),{-1,-1},{1,-1},{-1,1},{1,1}}
		local c = Spice.Objects.new("Circle",rounded)
		Spice.Properties.setProperties(c,{pos = stuff[i],ap = stuff[i+4];
			irs = v2(250),iro =  v2(stuff[i+4].X*250,stuff[i+4].Y*250),nam = tostring(i)
		})
		c.Radius = round/2
	end
	for i = 1,4 do
		local stuff = {ud(1,-round*2,0,round), ud(0,round,1,-round*2),ud(.5,0,1),ud(0,.5,1),ud(.5,1,1),ud(1,.5,1),v2(.5,0),v2(0,.5),v2(.5,1),v2(1,.5),'Top','Left','Bottom','Right'}
		local fram = Spice.Objects.newInstance("Frame",rounded,{siz = stuff[i%2 == 0 and 2 or 1], pos = stuff[2+i], ap = stuff[6+i], bsp = 0, nam = stuff[10+i], bac = Color3.new(.2,.2,.2)})
	end
	
	local border = Spice.Objects.newInstance('Frame',{siz = ud(1),trans = 1,vis = false,nam = "Border",par = rounded, ap = v2(.5), pos = ud(.5), siz = ud(1)})
	for i,v in next,rounded:GetChildren() do
		if v.Name ~= 'Border' then
			local b = (Spice.Objects.Custom.getCustomFromInstance(v) or v):Clone()
			local c = (Spice.Objects.Custom.getCustomFromInstance(v) or v):Clone()
			v:Destroy()
			c.Parent = rounded
			b.Parent = border
		end
	end
	
	Spice.Objects.newInstance("Frame",rounded,{nam = "Main", ap = v2(.5), siz = ud(1,-round*2,3), pos = ud(.5),bsp = 0; bac = Color3.new(.2,.2,.2)})
	
	local new = Spice.Objects.Custom.new("Frame",Class,{trans = 1})
	new.RoundValue = Spice.Objects.newInstance("IntValue",rounded,{nam = 'Round'})

	new.TweenSize = function(self,...)	
		return self.Instance:TweenSize(...)
	end
	new.TweenPosition = function(self,...)
		return self.Instance:TweenPosition(...)
	end
	new.TweenSizeAndPosition = function(self,...)
		return self.Instance:TweenSizeAndPosition(...)
	end
	new.TweenRound = function(self,round,direction,style,timer)
		Spice.Motion.tweenServiceTween(self.RoundValue, 'Value', round, timer,false, style, direction)
	end
	new.TweenRoundAndSize = function(self,round,size,direction,style,timer)
		self:TweenRound(round,direction,style,timer)
		self:TweenSize(size,direction,style,timer,true)
	end
	new.TweenRoundAndPosition = function(self,round,pos,direction,style,timer)
		self:TweenRound(round,direction,style,timer)
		self:TweenPosition(pos,direction,style,timer,true)
	end
	new.TweenRoundAndSizeAndPosition = function(self,round,size,pos,direction,style,timer)
		self:TweenRound(round,direction,style,timer)
		self:TweenSizeAndPosition(size,pos,direction,style,timer,true)
	end
	 
	new:NewIndex("Round",function(self,n)
		self:setRound(n)
	end)
	new:Index("Transparency",function(self)
		return self.Rounded.Main.Transparency
	end)

	new.Clone = function(self,parent,prop)
		return error'Cloning this object is unavaiable at this time.'
		--[[
		local clone = Spice.Instance.cloneObject(self,parent,prop)
		clone:resetSignal()
		return clone]]
	end;
	new:resetSignal()
	rounded.Parent = new.Instance
	return new
end)