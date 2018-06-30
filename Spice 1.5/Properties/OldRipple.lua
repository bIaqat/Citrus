--Coincides with Ripple Effect
Spice.Properties.new('Ripple',function(who,...)
	local trans, speed, color
	for _,arg in next,{...} do
		if type(arg) == 'number' then
			speed = not speed and trans and arg
			trans = not trans and arg
		elseif typeof(arg) == 'Color3' then
			color = arg
		end
	end                                                                                                        
	who.ClipsDescendants = true
	who.MouseButton1Click:connect(function()
		local m = game.Players.LocalPlayer:GetMouse()
		local c = Spice.Instance.newPure('Circle',who,{ic = color or Color3.new(0,0,0)})
		Spice.Effects.affect(c,'Ripple',speed or .6,trans or .9, color, UDim2.new(0,m.X-c.AbsolutePosition.X,0,m.Y-c.AbsolutePosition.Y))
	end)
end)