--non object
Spice.Instance.newClass("Circle",function(siz,typ)
	local circle
	if typ then
		circle = Spice.Instance.newPure("ImageButton")
	else
		circle = Spice.Instance.newPure("ImageLabel")
	end
	Spice.Properties.setProperties(circle,{im = 'rbxassetid://550829430',bt = 1,siz = Spice.Positioning.new(siz,2)})
	return circle
end)

--object
Spice.Instance.newClass("Circle",function(rad,typ)
	local circle
	local obj = {Radius = rad or 0,ClassName = 'Circle',GetAncestors = function(self)
		return Spice.Instance.getAncestors(self)
	end}
	if typ then
		circle = Spice.Instance.newObject("ImageButton",obj)
	else
		circle = Spice.Instance.newObject("ImageLabel",obj)
	end
	circle:NewIndex('Radius',function(self,new)
		self.Size = Spice.Positioning.new(new*2,2)
		self.Object.Radius = new
	end);
	circle.Radius = rad or 0
	circle{im = 'rbxassetid://1487012691',bt = 1, ic = Color3.new(.2,.2,.2)}
	return circle
end)
