Spice.Imagery = setmetatable({
	new = function(name, id,props, ...)
		if type(id) ~= 'string' then id = 'rbxassetid://'..id end
		if not props then props = {} end
		props.Name = name
		props.Image = id
		props.BackgroundTransparency = 1
		local ImageLabel = Instance.new('ImageLabel')
		Spice.Properties.setProperties(ImageLabel,props)
		local index = getmetatable(Spice.Imagery).Images
		for i,v in next,{...} do
			if index[v] and type(index[v]) ~= 'table' then index[v] = {index[v]} end
			if not index[v] then index[v] = {} end
			index = index[v]
		end
		index[name] = ImageLabel
	end;
	get = function(...)
		local index = getmetatable(Spice.Imagery).Images
		for i,v in next, {...} do
			index = index[v]
		end
		return index
	end;
	getImageId = function(id)
		id = tonumber(id)
		id = game:GetService("InsertService"):LoadAsset(id):GetChildren()[1]
		id = id[Spice.Misc.switch('Graphic','PantsTemplate','ShirtTemplate','Texture'):Filter('ShirtGraphic', 'Shirt', 'Pants', 'Decal')(id.ClassName)]
		return id:sub(id:find'='+1)
	end;
	getImage = function(name,...)
		local got = Spice.Imagery.get(...)
		local gotten = got[name]
		if type(gotten) == 'table' then
			for i,v in next, gotten do
				if type(v) == 'userdata' then
					return v:Clone(), i
				end
			end
		else
			return gotten:Clone()
		end
	end;
	insertImage = function(parent,props,...)
		local image = Spice.Imagery.getImage(...)
		image.Parent = parent
		Spice.Properties.setProperties(image,props)
	end;
	getImageProperties = function(image)
		return {ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3}
	end;
	play = function(to,speed,loop,...)
		local got = Spice.Imagery.get(...)
		spawn(function()
			repeat
				for i,v in next, got do
					if type(v) == 'userdata' then
						Spice.Properties.setProperties(to, Spice.Imagery.getImageProperties(v))
					end
					wait(speed)
				end
			until not loop
		end)
	end;
	fromSheet = function(id, xaxis, yaxis, xsiz, ysiz, names,...)
		local cnt = 1
		for y = 0, yaxis - 1 do
			for x = 0, xaxis - 1 do
				local index = Spice.Misc.stringFilterOut(names[cnt] or 'Icon','_',nil,true)
				local name = index[#index]
				table.remove(index,#index)
				Spice.Imagery.new(name, id, {ImageRectOffset = Vector2.new(x*xsiz, y*ysiz), ImageRectSize = Vector2.new(xsiz, ysiz)}, ..., unpack(index))
				cnt = cnt + 1
			end
		end
	end;
	toImage = function(object, ...)
		Spice.Properties.setProperties(object, Spice.Imagery.getImageProperties(Spice.Imagery.getImage(...)))
	end;
},
{
	Images = {};
})