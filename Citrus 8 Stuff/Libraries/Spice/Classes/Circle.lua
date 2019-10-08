Citrus.object:newClass('Circle',function(Size,Button)
	local circle

	if Button then
		circle = Instance.new'ImageButton'
	else
		circle = Instance.new'ImageLabel'
	end

	circle.Image = 'rbxassetid://550829430'
	circle.BackgroundTransparency = 1
	circle.Size = UDim2.new(0,Size or 0 ,0,Size or 0)

	return circle
end)

Citrus.object:newClass('Circle', function(Size, Button)
	local circle

	if Button then
		circle = Citrus.object:newCustomObject'ImageButton'
	else
		circle = Citrus.object:newCustomObject'ImageLabel'
	end

	local ci, co = circle.Instance, circle.Properties

	co:newIndex('Radius', function(self, newIndex)
		self.Size = UDim2.new(0, newIndex * 2, 0, newIndex * 2)
	end)

	ci.Image = 'rbxassetid://550829430'
	ci.BackgroundTransparency = 1
	ci.Size = UDim2.new(0,Size or 0 ,0,Size or 0)
	co.Radius = Size or 0/2
	co.ClassName = "Circle"
	function co:GetAncestors()
		return Citrus.object.getAncestors(self)
	end;
end)
