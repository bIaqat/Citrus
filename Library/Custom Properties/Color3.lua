Spice.Properties.Custom.new("BackgroundColor3",function(who, to, i)
	if type(to) == 'string' then
		Spice.Theming.insertObject(to, who, 'BackgroundColor3', i)
	else
		who.BackgroundColor3 = to
	end
end)
Spice.Properties.Custom.new("BorderColor3",function(who, to, i)
	if type(to) == 'string' then
		Spice.Theming.insertObject(to, who, 'BorderColor3', i)
	else
		who.BorderColor3 = to
	end
end)
Spice.Properties.Custom.new("TextColor3",function(who, to, i)
	if type(to) == 'string' then
		Spice.Theming.insertObject(to, who, 'TextColor3', i)
	else
		who.TextColor3 = to
	end
end)
Spice.Properties.Custom.new("ImageColor3",function(who, to, i)
	if type(to) == 'string' then
		Spice.Theming.insertObject(to, who, 'ImageColor3', i)
	else
		who.ImageColor3 = to
	end
end)
