Citrus.properties:newCustomProperty("BackgroundColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.theme:insertObjectToTheme(to, i, who, 'BackgroundColor3')
	else
		who.BackgroundColor3 = to
	end
end)
Citrus.properties:newCustomProperty("BorderColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.theme:insertObjectToTheme(to, i, who, 'BorderColor3')
	else
		who.BorderColor3 = to
	end
end)
Citrus.properties:newCustomProperty("TextColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.theme:insertObjectToTheme(to, i, who, 'TextColor3')
	else
		who.TextColor3 = to
	end
end)
Citrus.properties:newCustomProperty("ImageColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.theme:insertObjectToTheme(to, i, who, 'ImageColor3')
	else
		who.ImageColor3 = to
	end
end)

Properties:newCustomProperty("Position",function(who, to, ...)
	Motion:tween(who, "Position", to, ...)
end)