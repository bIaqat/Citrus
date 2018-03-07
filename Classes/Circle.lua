--non custom instance
Citrus.Instance.newCustomClass("Circle",function(siz,typ)
	local circle
	if typ then
		circle = Citrus.Instance.new("ImageButton")
	else
		circle = Citrus.Instance.new("ImageLabel")
	end
	Citrus.Properties.setProperties(circle,{im = 'rbxassetid://550829430',bt = 1,siz = Citrus.Positioning.new(siz,'o')})
	return circle
end)

--custom instance
Citrus.Instance.newCustomClass("Circle",function(diam,typ)
	local circle
	diam = diam or 50
	local obj = {Radius = diam/2,ClassName = 'Circle',GetAncestors = function(self)
		return Citrus.Instance.getAncestors(self)
	end}
	if typ then
		circle = Citrus.Instance.newObject("ImageButton",obj)
	else
		circle = Citrus.Instance.newObject("ImageLabel",obj)
	end
	circle:NewIndex('Radius',function(self,new)
		self.Size = Citrus.Positioning.new(new*2,2)
		self.Object.Radius = new
	end);
	circle:Index('Color',function(self)
		return self.ImageColor3;
	end)
	circle:NewIndex('Color',function(self,new)
		self.ImageColor3 = new;
	end)
	circle{im = 'rbxassetid://1487012691',bt = 1,siz = Citrus.Positioning.new(diam,'o')}
	return circle
end)