Iconography = setmetatable({
	insertIconList = function(img,xlen,ylen,xgrid,ygrid,names)
		if not names then names = ygrid ygrid = xgrid end
		local count = 1
		for y = 0, ylen-1,1 do
			for x = 0,xlen-1,1 do
				local icon = Instance.new("ImageLabel")
				icon.BackgroundTransparency = 1
				icon.Image = img
				icon.ImageRectOffset = Vector2.new(x*xgrid,y*ygrid)
				icon.ImageRectSize = Vector2.new(xgrid,ygrid)
				local namefil = Spice.Misc.stringFilterOut(names[count] or 'Icon','_',nil,true)
				local name = namefil[#namefil]
				table.remove(namefil,#namefil)
				Spice.Iconography.insertIcon(name,icon,unpack(namefil))
				count = count + 1
			end
		end
	end;			
	insertIcon = function(name,icon,...)
		local index = getmetatable(Spice.Iconography).Icons
		for i,v in next,{...} or {} do
			v = v:sub(1,1):upper()..v:sub(2)
			if not index[v] then
				index[v] = {}
			end
			index = index[v]
		end
		if index[name] and type(index[name]) ~= 'table' then
			index[name] = {index[name]}
		end
		if index[name] then
			table.insert(index[name],icon)
		else
			index[name] = icon
		end			
	end;		
	new = function(name,...)
		local index = getmetatable(Spice.Iconography).Icons
		for i,v in next,{...} or {} do
			v = v:sub(1,1):upper()..v:sub(2)
			index = index[v]
		end
		local icon = Spice.Table.search(index,name,true)
		return icon:Clone()
	end;		
	getIconData = function(...)
		local i = Spice.Iconography.new(...)
		return {Image = i.Image, ImageRectSize = i.ImageRectSize, ImageRectOffset = i.ImageRectOffset}
	end;
},{
	Icons = {}
	}
);
