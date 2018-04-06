--non custom instance
Citrus.Instance.newClass("Circle",function(siz,typ)
	local circle
	if typ then
		circle = Citrus.Instance.newPure("ImageButton")
	else
		circle = Citrus.Instance.newPure("ImageLabel")
	end
	Citrus.Properties.setProperties(circle,{im = 'rbxassetid://550829430',bt = 1,siz = Citrus.Positioning.new(siz,2)})
	return circle
end)

--custom instance
Citrus.Instance.newClass("Circle",function(rad,typ)
	local circle
	local obj = {Radius = rad or 0,ClassName = 'Circle',GetAncestors = function(self)
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
	circle.Radius = rad or 0
	circle{im = 'rbxassetid://1487012691',bt = 1, ic = Color3.new(.2,.2,.2)}
	return circle
end)