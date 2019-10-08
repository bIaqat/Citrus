local Citrus = require(script.Citrus)
require(script.CitrusAddons)
--[[
local frame = Instance.new("Frame", Instance.new("ScreenGui", script.Parent))
frame.Size = UDim2.new(0,300,0,300)
frame.Position = UDim2.new(.5,-150,.5,-300/2)
frame.BackgroundTransparency = 1
]]

local frame = script.Parent
local ox,oy = 0,0
local sx,sy = 1,1
local radius = 50
local color = Color3.new(1,1,1)
local circleFrame = Instance.new("Frame")
circleFrame.BackgroundTransparency = 1
circleFrame.Size = UDim2.new(0,radius,0,radius)


circleFrame1 = circleFrame:Clone()
circleFrame1.Parent = frame
circleFrame1.Position = UDim2.new(0,radius,0,radius)
circleFrame1.AnchorPoint = Vector2.new(0,0)

circleFrame2 = circleFrame:Clone()
circleFrame2.Parent = frame
circleFrame2.Position = UDim2.new(1,-radius+2,0,radius)
circleFrame2.AnchorPoint = Vector2.new(1,0)

circleFrame3 = circleFrame:Clone()
circleFrame3.Parent = frame
circleFrame3.Position = UDim2.new(0,radius,1,0)
circleFrame3.AnchorPoint = Vector2.new(0,1)


circleFrame4 = circleFrame:Clone()
circleFrame4.Position = UDim2.new(1,-radius+2,1,0)
circleFrame4.AnchorPoint = Vector2.new(1,1)
circleFrame4.Parent = frame

local function rect(thing)
	thing.Image = frame.Image
	thing.ImageRectOffset = Vector2.new(thing.AbsolutePosition.X-frame.AbsolutePosition.X+ox, thing.AbsolutePosition.Y-frame.AbsolutePosition.Y+oy)
	--thing.ImageRectOffset = thing.AbsolutePosition-frame.AbsolutePosition--Vector2.new(thing.Position.X.Offset, thing.Position.Y.Offset)
	thing.ImageRectSize = Vector2.new(thing.AbsoluteSize.X*sx, sy+thing.AbsoluteSize.Y*sy)
	thing.BackgroundTransparency = 1
end

local frames = {circleFrame4, circleFrame2, circleFrame1, circleFrame3}
for d = 1,89 do
	for i = 1, 4 do
		local x,y = math.sin(math.rad(d + (90*(i-1)))), math.cos(math.rad(d +(90*(i-1))))
		local f = Instance.new("ImageLabel", frames[i])
		f.Position = UDim2.new(0,x * radius,0,y * radius)
		f.Size =  UDim2.new(0,radius,0,1)
		rect(f)
		--f.Rotation = d + (90*(i-1)) 
		f.BorderSizePixel = 0
		f.BackgroundColor3 = color
	end
	
end


local filler1 = Instance.new("ImageLabel", frame)
filler1.Size = UDim2.new(1,-radius,1,-radius)
filler1.Position = UDim2.new(.5,0,.5,0)
filler1.AnchorPoint = Vector2.new(.5,.5)
filler1.BackgroundColor3 = color
filler1.BorderSizePixel = 0
filler1.BackgroundTransparency = 1
rect(filler1)

local filler2 = Instance.new("ImageLabel", frame)
filler2.Size = UDim2.new(1,-radius*2,0,radius+1)
filler2.BorderSizePixel = 0
filler2.BackgroundColor3 = color
filler2.AnchorPoint = Vector2.new(.5,0)
filler2.Position = UDim2.new(.5,0,0,1)
rect(filler2)

fil3 = filler2:Clone()
fil3.Parent = frame
fil3.Position = UDim2.new(.5,0,1,1)
fil3.AnchorPoint = Vector2.new(.5,1)
rect(fil3)


local filler2 = Instance.new("ImageLabel", frame)
filler2.Size = UDim2.new(0,radius+1,1,-radius*2)
filler2.BorderSizePixel = 0
filler2.BackgroundColor3 = color
filler2.AnchorPoint = Vector2.new(0,.5)
filler2.Position = UDim2.new(0,1,0.5,0)
rect(filler2)

fil3 = filler2:Clone()
fil3.Parent = frame
fil3.Position = UDim2.new(1,1,.5,0)
fil3.AnchorPoint = Vector2.new(1,.5)
rect(fil3)