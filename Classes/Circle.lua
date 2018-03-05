Citrus.Instance.newCustomClass("Circle",function(siz,typ)
	local circle
	if typ then
		circle = create("ImageButton")
	else
		circle = create("ImageLabel")
	end
	Citrus.Properties.setProperties(circle,{im = 'rbxassetid://550829430',bt = 1,siz = ud(siz,'o')})
	return circle
end)