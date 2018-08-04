Spice.Properties.Custom.new("Round",function(who, ...)
	local round = Spice.Objects.new('RoundedGuiObject',{Size = UDim2.new(1,0,1,0), Name = 'RoundedGuiObject'})
	local setRound = function(who,...)
		local function getRadius(...)
			local args = type(({...})[1]) == 'table' and ({...})[1] or {...}
			if #args >= 4 then
				return {args[1],args[2],args[3],args[4]}
			elseif #args >= 2 then
				return {args[1],args[2],args[2],args[3] or args[1]}
			elseif #args == 1 then
				return {args[1],args[1],args[1],args[1]}
			else
				return {0,0,0,0}
			end
		end
		local rad = getRadius(...)
		local val = who.RadiusValues
		val.Corner_1.Value = rad[1]
		val.Corner_2.Value = rad[2]
		val.Corner_3.Value = rad[3]
		val.Corner_4.Value = rad[4]
	end
	setRound(round,...)
	who.ZIndex = who.ZIndex + 1
	round.Parent = who
end)