Spice.Properties.new('Shadow',function(self, thicc, lightness)
	local a = Spice.Instance.newInstance('ImageLabel', self, {Name = 'Shadow',bt = 1, pos = ud(0,1,1), siz = ud(1,thicc and type(thicc) == 'number' and thicc or 8,4), Image = 'rbxasset://textures/ui/TopBar/dropshadow@2x.png', it = lightness or .8})
end)