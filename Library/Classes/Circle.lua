Spice.Objects.Classes.new('Circle',function(Size,Button)
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