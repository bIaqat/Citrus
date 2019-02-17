Spice.Properties.Custom.new('Shadow',function(self, thickness,lightness)
	local shadow = Instance.new('ImageLabel', self)
	shadow.Name = 'Shadow'
	shadow.BackgroundTransparency = 1
	shadow.Position = UDim2.new(0,0,1,0)
	shadow.Size = UDim2.new(1,0,0,thickness and type(thickness) == 'number' and thickness or 8)
	shadow.Image = 'rbxasset://textures/ui/TopBar/dropshadow@2x.png'
	shadow.ImageTransparency = lightness or .8
end)
