Spice.Instance.newClass('RoundedFrame',function(roundsize)
	local frame = Spice.Instance.newObject('Frame',{BackgroundTransparency = 0, RoundSize = roundsize or 8},{Round = roundsize or 8})
	frame:NewIndex('RoundSize',function(self,new)
		for i,v in next, self.Instance.RoundedGuiObject.RadiusValues:GetChildren() do
			v.Value = new
		end
		self.Object.RoundSize = new
	end)
	frame:NewIndex('BackgroundTransparency',function(self,new)
		self.Object.BackgroundTransparency = new
		for i,v in next, self.Instance.RoundedGuiObject:GetChildren() do
			if v:IsA'GuiObject' then
				if v.ClassName == 'ImageLabel' then
					v.ImageTransparency = new
				else
					v.BackgroundTransparency = new
				end
			end
		end
	end)
	return frame
end)