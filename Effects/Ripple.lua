Citrus.Effects.new("Ripple",function(who,...)
	local color, timer, typ, siz, lightness = Color3.new(0,0,0), .8, Citrus.Misc.dynamicType(who), who.Parent:IsA'GuiObject' and (who.Parent.AbsoluteSize.X > who.Parent.AbsoluteSize.Y and who.Parent.AbsoluteSize.X or who.Parent.AbsoluteSize.Y)
	local args = {...}
	for i,v in next, args do
		typ = type(v) == 'string' and v or typ
		color = type(v) == 'Color3' and v or color
		timer = lightness and type(v) == 'number' and v or timer
		lightness = not lightness and type(v) == 'number' and v or lightness
	end
	if not lightness then lightness = .85 end
	if not siz then siz = who.AbsoluteSize.X * 5 end
	Citrus.Properties.setProperties(who,{[typ..'Color3'] = color, [typ..'Transparency'] = lightness})
	Citrus.Misc.destroyIn(who,timer + .01)
	Citrus.Positioning.tweenObject(who,'siz',UDim2.new(0,siz,0,siz),timer,'Sine','Out')
	Citrus.Misc.tweenService(who,'ImageTransparency',1,timer,'Sine','Out')
end)