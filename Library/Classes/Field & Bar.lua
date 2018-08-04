Spice.Objects.Classes.new("Field",function(siz,...)
	local rest = type(siz) == 'string' and true or false
	local pos, br, pad, brcol
	local args = {...}
	if type(args[1]) == 'number' then
		pos, br, pad, brcol = ...
	else
		br, pad, brcol = ...
	end
	local field = Spice.Objects.newInstance("Frame",nil,{Position = ud(0,pos or 0,2),Transparency = 1,Size = not rest and ud(1,siz,4) or ud(1,0,1),BorderSizePixel = 0})
	if br then
		local bre = Spice.Objects.newInstance('Frame',field,{Size = ud(1,-(pad or 0)*2,0,1),BackgroundColor3 = brcol or hex'#e9e9e9',BorderSizePixel = 0,Position = ud(0,pad or 0,1,0),ap = v2(0,1)})
	end
	if rest then
		field.AncestryChanged:connect(function(me, mom)
			me.Size = ud(1,0,1,-me.Position.Y.Offset - (me.Position.Y.Scale*mom.AbsoluteSize.Y))
		end)
	end
	return field
end)

Spice.Objects.Classes.new("Bar",function(thick,width)
	thick = thick or 1
	local frame = Spice.Objects.Custom.new("Frame",{Thickness = thick},{siz = ud(width or UDim.new(0,0), um(0,thick))})
	frame:NewIndex('Thickness',function(self,new)
		self.Object.Thickness = new
		self.Instance.Size = ud(self.Instance.Size.X, um(self.Instance.Size.Y.Scale, new))
	end)
	frame:NewIndex('Width',function(self,new)
		self.Instance.Size = ud(new, self.Instance.Size.Y)
	end)
	frame:Index('Width',function(self)
		return self.Instance.Size.X
	end)
	function frame:TweenWidth(new, direction, style, timer,interupt, funct)
		return self.Instance:TweenSize(ud(new, self.Instance.Size.Y), direction, style, timer, interupt, funct)
	end
	function frame:TweenThickness(new, direction, style, timer,interupt, funct)
		return self.Instance:TweenSize(ud(self.Instance.Size.X, um(self.Instance.Size.Y.Scale, new)), direction, style, timer, interupt, funct)
	end
	function frame:TweenColor3(new, direction, style, timer,...)
		return Spice.Motion.tweenServiceTween(self,'BackgroundColor3',new,timer,false,style,direction,...)
	end
	function frame:TweenPosition(...)
		return self.Instance:TweenPosition(...)
	end
	function frame:TweenSize(siz,...)
		self.Object.Thickness = siz.Y.Offset
		return self.Instance:TweenSize(siz,...)
	end
	return frame
end)