Citrus.Instance.newCustomClass("Icon",function(...)
	return Citrus.Iconography.new(...)
end)

Citrus.Instance.newCustomClass("IconButton",function(...)
	return Citrus.Instance.newInstance("ImageButton",Citrus.Table.merge(Citrus.Iconography.getIconData(...),{BackgroundTransparency = 1}))
end)
