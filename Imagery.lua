Imagery = setmetatable({
	Images = setmetatable({},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = function(Name, ImageId, Props, ...) --... Directory
					ImageId = type(ImageId) ~= 'string' and 'rbxassetid://'..ImageId or ImageId
					Props = Props or {}
					Props.Name, Props.Image, Props.BackgroundTransparency = Name, ImageId, 1
					local Image = Instance.new("ImageLabel")
					for i,v in next, Props do
						Image[i] = v
					end
					local index = self
					for i,v in next, {...} do
						if not index[v] then index[v] = {} 
						elseif type(index[v]) ~= 'table' then index[v] = {index[v]} end
						index = index[v]
					end
					index[Name] = Image
				end;
				get = function(...) --... Directory
					local index = self
					for i,v in next, {...} do
						index = self[v]
					end
					return index
				end;
				getImage = function(Name, ...)
					local image = self.get(...)[Name]
					if type(image) == 'table' then
						for i,v in next, image do
							if typeof(v) == 'Instance' then
								return v:Clone()
							end
						end
					end
					return image:Clone()
				end;
				newFromSheet = function(ImageId, XAmt, YAmt, XSiz, YSiz, Names, ...) --...Directory
					local namesIndex = 1
					for y = 0, YAmt - 1 do
						for x = 0, XAmt - 1 do
							local index = {}
							for name in (Names[namesIndex] or 'Icon'):gsub('_','\0'):gmatch('%Z+') do
								table.insert(index,name)
							end
							local name = index[#index]
							table.remove(index,#index)
							self.new(name, ImageId, {ImageRectOffset = Vector2.new(x*XSiz, y*YSiz), ImageRectSize = Vector2.new(XSiz, YSiz)}, ..., unpack(index))
							namesIndex = namesIndex + 1
						end
					end			
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end
	})},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			newInstance = function(Class, Parent, Props, ...) --...Directory
				local image
				if Class and Class ~= 'ImageLabel' then
					image = self.setImage(Class, ...)
				else
					image = self.Images.getImage(...)
				end
				image.Parent = Parent
				for i,v in next, Props do
					image[i] = v
				end
				return image
			end;
			playGif = function(ImageObject, Speed, Repeat, ...) --...Directory
				local sheet = self.Images.get(...)
				ImageObject.ChildAdded:connect(function(who)
					if who.Name == 'STOPGIF' then
						Repeat = false
						game:GetService('Debris'):AddItem(who,.01)
					end
				end)
				spawn(function()
					repeat
						for i,image in next, sheet do
							if not Repeat then break end
							if typeof(image) == 'Instance' then
								for i,image in next, {ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3} do
									ImageObject[i] = image
								end
							end
							wait(Speed)
						end
					until not Repeat
				end)
			end;
			stopGif = function(ImageObject)
				local stop = Instance.new("IntValue")
				stop.Name = 'STOPGIF' 
				stop.Parent = ImageObject
			end;
			setImage = function(ImageObject, ...) --...Directory
				if type(ImageObject) == 'string' then ImageObject = Instance.new(ImageObject) end
				local image = self.Images.getImage(...)
				for i,v in next, {ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3} do
					ImageObject[i] = v
				end
				return image
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
