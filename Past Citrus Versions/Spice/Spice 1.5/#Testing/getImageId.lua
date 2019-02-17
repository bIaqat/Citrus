getImageId = function(id)
	id = tonumber(id)
	id = game:GetService("InsertService"):LoadAsset(id):GetChildren()[1]
	id = id[Spice.Misc.switch('Graphic','PantsTemplate','ShirtTemplate','Texture'):Filter('ShirtGraphic', 'Shirt', 'Pants', 'Decal')(id.ClassName)]
	return id:sub(id:find'='+1)
end
