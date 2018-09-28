Imagery = setmetatable({
	Images = setmetatable({},{
		SortedStorage = {};
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = function(Name, ImageId, Props, ...) --... Index
					local oldName
					if type(Name) == 'table' then
						oldName = Name[2]
						Name = Name[1]
					end
					local dir = ({...})[1]
					if not self[dir] then self[dir] = setmetatable({},{
						__index = function(self, ind) 
							local gelf = getmetatable(self)
							if gelf[ind] then return gelf[ind] end
							local maybe = {}
							for i,v in next, gelf do
								if i:sub(1,#ind):lower() == ind:lower() then
									return v
								end
								if i:find(ind) then
									table.insert(maybe,v)
								end
							end
							if #maybe > 0 then
								return maybe[1]
							end
							return nil
					end, __call = function(self,pic, name) rawset(getmetatable(self),name, pic) end}) end
					ImageId = type(ImageId) ~= 'string' and 'rbxassetid://'..ImageId or ImageId
					Props = Props or {}
					Props.Name, Props.Image, Props.BackgroundTransparency = Name, ImageId, 1
					local Image = Instance.new("ImageLabel")
					for i,v in next, Props do
						Image[i] = v
					end
					self[dir](Image, oldName or Name)
					local index = self
					for i,v in next, {...} do
						if not index[v] then
							index[v] = {}
						end
						if type(index[v]) == 'userdata' then
							index = {v = index[v]}
						else
							index = index[v]
						end
					end
					if not index[Name] then index[Name] = Image
					else
						if type(index[Name]) ~= 'table' then index[Name] = {index[Name]} end
						for i,v in next, type(Image) == 'table' and Image or {Image}  do
							if type(i) == 'string' then
								index[Name][i] = v
							else
								table.insert(index[Name],v)
							end
						end
					end
				end;
				get = function(...) --... Index
					local index = self
					local nextup
					for i,v in next, {...} do
						index = rawget(index,v) or index[v] or index
						nextup = next({...},i) or nextup
					end
					return index, nextup
				end;
				remove = function(Name, ...) --... Index
					local index = self
					for i,v in next, {...} do
						index = index[v]
					end		
					index[Name] = nil
				end;
				getImage = function(Name, ...)
					local geta = {...}
					table.insert(geta,Name)
					local image, name = self.get(unpack(geta))
					local rname = geta[#geta]
					local en = false
					while not (en or type(image) ~= 'table') do
						if type(image) == 'table' and not next(image) then en = true end
						for i,v in next, image do
							if typeof(v) == 'Instance' then
								return v:Clone()
							end
						end
						_,image = next(image)
					end 
					return type(image) ~= 'userdata' and error'Incorrect Image Name or Directory' or image:Clone()
				end;
				newFromSheet = function(ImageId, XAmt, YAmt, XSiz, YSiz, Names, ...) --...Directory
					local namesIndex = 1
					for y = 0, YAmt - 1 do
						for x = 0, XAmt - 1 do
							local index = {}
							local oldName = Names and Names[namesIndex] or string.format('Icon-%.3i', namesIndex)
							for name in (oldName):gsub('_','\0'):gmatch('%Z+') do
								table.insert(index,name)
							end
							local name = index[#index]
							table.remove(index,#index)
							for i,v in next, {...} do
								table.insert(index, i, v)
							end
							self.new({name, oldName}, ImageId, {ImageRectOffset = Vector2.new(x*XSiz, y*YSiz), ImageRectSize = Vector2.new(XSiz, YSiz)}, unpack(index))
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
				for i,v in next, Props or {} do
					image[i] = v
				end
				return image
			end;
			playGif = function(ImageObject, Speed, Repeat, ...) --...Directory
				local sheet = self.Images.get(...)
				local br
				ImageObject.ChildAdded:connect(function(who)
					if who.Name == 'STOPGIF' then
						Repeat = false
						br = true
						game:GetService('Debris'):AddItem(who,.01)
					end
				end)
				spawn(function()
					local once = false
					repeat
						for i,image in next, sheet do
							if not Repeat and once or br then break end
							if typeof(image) == 'Instance' then
								for i,image in next, {ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3} do
									ImageObject[i] = image
								end
							end
							wait(Speed)
						end
						once = true
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
				for i,v in next, {Name = image.Name,ImageRectOffset = image.ImageRectOffset, ImageRectSize = image.ImageRectSize, ScaleType = image.ScaleType, Image = image.Image, ImageColor3 = image.ImageColor3, BackgroundTransparency = image.BackgroundTransparency, ImageTransparency = image.ImageTransparency} do
					ImageObject[i] = v
				end
				return ImageObject
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
