Citrus.Properties.new("BackgroundColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.Theming.insertObject(to, who, 'BackgroundColor3', i)
	else
		who.BackgroundColor3 = to
	end
end)

Citrus.Properties.new("BorderColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.Theming.insertObject(to, who, 'BorderColor3', i)
	else
		who.BackgroundColor3 = to
	end
end)

Citrus.Properties.new("TextColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.Theming.insertObject(to, who, 'TextColor3', i)
	else
		who.BackgroundColor3 = to
	end
end)

Citrus.Properties.new("ImageColor3",function(who, to, i)
	if type(to) == 'string' then
		Citrus.Theming.insertObject(to, who, 'ImageColor3', i)
	else
		who.BackgroundColor3 = to
	end
end)
