Spice.Instance.newClass('RoundedFrame',function(roundsize)
	local frame = Spice.Instance.newObject('Frame',{TopBarColor3 = Color3.fromRGB(163,162,165),BottomBarColor3 = Color3.fromRGB(163,162,165),BackgroundTransparency = 0, RoundSize = roundsize or 8},{Round = roundsize or 8})
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
	frame:NewIndex('TopBarColor3',function(self,new)
		local round = self.Instance.RoundedGuiObject
		round.Corner_1.ImageColor3 = new
		round.Corner_2.ImageColor3 = new
		round.Top.BackgroundColor3 = new
		self.Object.TopBarColor3 = new
	end)
	frame:NewIndex('BottomBarColor3',function(self,new)
		local round = self.Instance.RoundedGuiObject
		round.Corner_3.ImageColor3 = new
		round.Corner_4.ImageColor3 = new
		round.Top.BackgroundColor3 = new
		self.Object.BottomBarColor3 = new
	end)
	frame:NewIndex('TopBarRoundSize',function(self,new)
		local round = self.Instance.RoundedGuiObject.RadiusValues
		round.Corner_1.Value = new
		round.Corner_2.Value = new
	end)
	frame:NewIndex('BottomBarRoundSize',function(self,new)
		local round = self.Instance.RoundedGuiObject.RadiusValues
		round.Corner_3.Value = new
		round.Corner_4.Value = new
	end)
	frame:Index('TopBarRoundSize',function(self)
		return self.Instance.RoundedGuiObject.RadiusValues.Corner_1.Value
	end)
	frame:Index('BottomBarRoundSize',function(self)
		return self.Instance.RoundedGuiObject.RadiusValues.Corner_3.Value
	end)
	return frame
end)