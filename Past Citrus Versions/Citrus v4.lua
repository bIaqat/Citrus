-- The begining of the end 
-- /? () `/ /\ |_ [- /? |_| ]3 `/   ^/_ (\) '| "/
--[[
───────────────────────────────────
───────────────────────────────────
───▄██████▄─────────────▄██████▄───
─▄██▀────▀██▄─────────▄██▀────▀██▄─
─██────────██─────────██────────██─
─██────────██─███████─██────────██─
─██────────██─────────██────────██─
──██▄────▄██───────────██▄────▄██──
───▀██████▀─────────────▀██████▀───
───────────────────────────────────
───────────────────────────────────
					   𝓻𝓸𝓾𝓰𝒆.
]]
local sm = setmetatable
local gm = getmetatable
				    --🍋𝓒𝔦𝓽𝔯𝓾ş🍊--
Citrus = {} --Finally calling it citrus 💛
BETA = sm(Citrus,{}) --For things that are a WIP
ForMe = sm(BETA,{})
DataService = sm(ForMe,{})
local ds = DataService

DataService.Storage = {}
local Storage = ds.Storage

ds.DataTypes = {}
DataService.new = function(name,data)
	local new = DataService.DataTypes[name] or {}
	local function merge(from,to)
		for i,v in pairs(from)do
			if type(v) == 'table' then
				merge(v,to[i])
			else
				to[i] = v
			end			
		end
	end
	merge(data or {},new)
	return new
end
DataService.newDataType = function(name,data)
	rawset(data,'IsA',function(self,what)
		if what == name then
			return true
		end
		return false		
	end)
	rawset(data,'new',function(self,data)
		return ds.new(name,data)
	end)
	rawset(data,'__type',name)

	DataService.DataTypes[name] = data	
end

--METATABLES
Citrus.Metas = {} --Shoulda had this in Lush but whatever
Metas = Citrus.Metas
Metas.Search = {
	__index = function(self,ind)
		for i,v in pairs(self)do
			if (i == ind and type(i) == 'string') or (v == ind) then
				return v
			end
		end
		local tab,tex = {},''
		for i,v in pairs(self)do
			if type(v) == 'string' then
				if v:sub(1,1):lower() == ind:sub(1,1):lower() then
					for w in v:gmatch('%u')do
						table.insert(tab,w)
					end
					for _,e in pairs(tab)do
						tex = tex..e
					end
					if ind:lower() == tex:lower() then
						return v
					elseif v:sub(1,#ind):lower() == ind:lower() then
						return v
					else
						tex = ''
						tab = {}
					end
				end
			end
		end
		return false,ind
	end
}
Metas.Found = {
	__index = function(self,ind)
		for i,v in pairs(self)do
			if (i == ind and type(i) == 'string') or (v == ind) then
				return true
			end
		end
		return false
	end
} 
--PROPERTIES
Citrus.Properties = sm({ -- This is the new "Shortcuts" table; More avanced than last time; To support Class custom Properties too instead of just Roblox API's
	Class = { --New Custom Properties for Custom Classes
		 
	};
	Custom = { --Custom Property/Function like Ripple
		
	};
	RobloxAPI = sm({
		'Archivable','ClassName','Name','Parent','AttachmentForward','AttachmentPoint','AttachmentPos','AttachmentRight','AttachmentUp';
		'Animation','AnimationId','IsPlaying','Length','Looped','Priority','Speed','TimePosition','WeightCurrent','WeightTarget','Axis','CFrame','Orientation';
		'Position','Rotation','SeconaryAxis','Visible','WorldAxis','WorldOrientation','WorldPosition','WorldSecondaryAxis','Version','DisplayOrder','ResetOnSpawn','Enabled';
		'AbsolutePosition','AbsoluteRotation','AbsoluteSize','ScreenOrientation','ShowDevelopmentGui','Attachment0','Attachment1','Color','CurveSize0','CurveSize1','FaceCamera';
		'LightEmission','Segments','Texture','TextureLength','TextureMode','TextureSpeed','Transparency','Width0','Width1','ZOffset','AngularVelocity','MaxTorque','P','Force','D';
		'MaxForce','Location','Velocity','CartoonFactor','MaxSpeed','MaxThrust','Target','TargetOffset','TargetRadius','ThrustD','ThrustP','TurnD','TurnP','Value','CameraSubject','CameraType';
		'FieldOfView','Focus','HeadLocked','HeadScale','ViewportSize','HeadColor','HeadColor3','LeftArmColor','LeftArmColor3','LeftLegColor','LeftLegColor3','RightArmColor','RightArmColor3','RightLegColor','RightLegColor3','TorsoColor','TorsoColor3';
		'BaseTextureId','BodyPart','MeshId','OverlayTextureId','PantsTemplate','ShirtTemplate','Graphic','SkinColor','LoadDefaultChat','CursorIcon','MaxActivationDistance','MaxAngularVelocity','PrimaryAxisOnly','ReactionTorqueEnabled','Responsiveness','RigidityEnabled';
		'ApplyAtCenterOfMass','MaxVelocity','ReactionForceEnabled','Radius','Restitution','TwistLimitsEnabled','TwistLowerAngle','TwistUpperAngle','UpperAngle','ActuatorType','AngularSpeed','CurrentAngle','LimitsEnabled','LowerAngle','MotorMaxAcceleration','MotorMaxTorque','ServoMaxTorque','TargetAngle';
		'InverseSquareLaw','Magnitude','CurrentDistance','Thickness','CurrentPosition','LowerLimit','Size','TargetPosition','UpperLimit','Heat','SecondaryColor';
		'BackgroundColor3','AnchorPoint','BackgroundTransparency','BorderColor3','BorderSizePixel','ClipsDescendants','Draggable','LayoutOrder','NextSelectionDown','NextSelectionLeft','NextSelectionRight','NextSelectionUp','Selectable','SelectionImageObject','SizeConstraint','SizeFromContents','ZIndex';
		'Style','AutoButtonColor','Modal','Selected','Image','ImageColor3','ImageRectOffset','ImageRectSize','ImageTransparency','IsLoaded','ScaleType','SliceCenter','TileSize','Font','Text','TextBounds','TextColor3','TextFits';
		'TextScaled','TextSize','TextStrokeColor3','TextStrokeTransparency','TextTransparency','TextWrapped','TextXAlignment','TextYAlignment','Active','AbsoluteWindowSize','BottomImage','CanvasPosition','CanvasSize','HorizontalScrollBarInset','MidImage','ScrollBarThickness','ScrollingEnabled','TopImage','VerticalScrollBarInset';
		'VerticalScrollBarPosition','ClearTextOnFocus','MultiLine','PlaceholderColor3','PlaceholderText','ShowNativeInput','Adornee','AlwaysOnTop','ExtentsOffset','ExtentsOffsetWorldSpace','LightInfluence','MaxDistance','PlayerToHideForm','SizeOffset','StudsOffset','StudsOffsetWorldSpace','ToolPunchThroughDistance','Face','DecayTime','Density','Diffusion','Duty','Frequency';
		'Depth','Mix','Rate','Attack','GainMakeup','Ratio','Release','SieChain','Threshold','Level','Delay','DryLevel','Feedback','WetLevel','HighGain','LowGain','MidGain','Octave','Volume','MaxSize','MinSize','AspectRatio','DominantAxis','AspectType','MaxTextSize','MinTextSize','CellPadding','CellSize','FillDirectionMaxCells','StartCorner';
		'AbsoluteContentSize','FillDirection','HorizontalAlignment','SortOrder','VerticalAlignment','Padding','Animated','Circular','CurrentPage','EasingDirection','EasingStyle','GamepadInputEnabled','ScrollWhellInputEnabled','TweenTime','TouchImputEnable','FillEmptySpaceColumns','FillEmptySpaceRows','MajorAxis','PaddingBottom','PaddingLeft','PaddingRight','PaddingTop','Scale'
	},Metas.Search);

},{
	__index = function(self,index)
		return self.RobloxApi[index]
	end;
	__call = function(self,typ,index)
		local switch = Misc.switch(self.Class,self.Custom,self.RobloxAPI)
		typ = switch[typ]
		return typ[index]
	end
})

Properties = Citrus.Properties
table.sort(Properties.RobloxAPI,function(a,b)
	return #a < #b
end)



--🌟Instance / Create✨
Citrus.Instance = {} --Instance.new, proeprty settings here
Create = Citrus.Instance

Storage.Objects = sm({},{ --Storage place for custom objects
	__index = function(self,who)
		return sm(self,Metas.Search)[who]
	end;
	__call = function(self,who)
		return sm(self,Metas.Found)[who]
	end;
})

Storage.Classes = sm({},{--Storage place for custom classes
	__call = function(self,who,type)
		local switch = Misc.switch(sm((self[type] and self[type].Objects) or {},Metas.Found)[who])
		switch.type = {type}
		switch.Default = function() 
			for i,v in pairs(self)do
				if sm(v.Objects,Metas.Found)[who] then
					return i
				end
			end
			return false
		end
		return switch(type)
	end
})

function Create.newClass(name,funct)
	local class = {onCreate = funct,Objects = {}}
	Storage.Classes[name] = class
end

function Create.new(class,parent,...)
	local new
	local prop = ...
	if Storage.Classes[class] then
		local class = Storage.Classes[class]
		local args = {...}
		if type(args[#args]) == 'table' then
			prop = args[#args]
			args[#args] = nil
		end
		new = class.onCreate(unpack(args))
	else new = Instance.new(class,parent)
	end
	new.Parent = parent or nil
	if prop then
		Create.setProperties(new,prop)
	end
	return new
end
function Create.setProperties(who,prop)
	if type(who) == 'table' and Create.Objects(who) then
		who = who[1]
	end
	for i,v in pairs(prop)do
		who[i] = v
	end
	return who
end


--🔬Positioning, UDim, Vector, Lerping
Citrus.Linear = {}
Linear = Citrus.Linear



--Color table 😍🎨
Citrus.Color = {}
Color = Citrus.Color

function Color.getInverse(color)
	if type(color) == 'string' then
		color = Color.fromHex(color)
	end
	local h,s,v = Color.toHSV(color)
	return Color.fromHSV(h,v,s)
end
function Color.fromHex(hex)
	if hex:sub(1,1) == '#' then
		hex = hex:sub(2,#hex)			
	end
	local r,g,b
	if #hex >= 6 then
		r = tonumber(hex:sub(1, 2), 16)
		g = tonumber(hex:sub(3, 4), 16)
		b = tonumber(hex:sub(5, 6), 16)
	elseif #hex >= 3 then
		r = tonumber(hex:sub(1, 1)..hex:sub(1, 1), 16)
		g = tonumber(hex:sub(2, 2)..hex:sub(2, 2), 16)
		b = tonumber(hex:sub(3, 3)..hex:sub(3, 3), 16)	
	end		
	return Color.fromRGB(r,g,b)
end
function Color.toHex(a,b,c,d)
	local r,g,b,hex,ro
	local round,ts = Misc.round,tostring
	if c then
		a = Color3.fromRGB(a,b,c)
	end
	r =("%02X"):format(round(a.r*255))
	g =("%02X"):format(round(a.g*255))
	b =("%02X"):format(round(a.b*255))
	hex = ts(r)..ts(g)..ts(b)
	if not c and b then
		hex = '#'..hex
	elseif d then
		hex = '#'..hex
	end
	return hex
end
function Color.fromHSV(h,s,v)
	return Color3.fromHSV(h/360,s*.01,v/100)
end
function Color.toHSV(color)
	local h,s,v = Color3.toHSV(color)
	return h*360,s*100,v*100
end
function Color.setHSV(color,a,b,c)
	local h,s,v = Color.toHSV(color)
	if not c then
		if not b or b == 1 then
			h = a
		elseif b == 2 then
			s = a
		elseif b == 3 then
			v = a
		end
	else
		h,s,v = a,b,c
	end
	return Color.fromHSV(h,s,v)
end
function Color.editHSV(color,sign,a,b,c)
	if type(sign) == 'number' then
		c = b
		b = a
		a = sign
		sign = '+'	
	end
	local h,s,v = Color.toHSV(color)
	if not c then
		if not b or b == 1 then
			h = loadstring('return '..h..sign..a)()
		elseif b == 2 then
			s = loadstring('return '..s..sign..a)()
		elseif b == 3 then
			v = loadstring('return '..v..sign..a)()
		end
	else
		h,s,v = loadstring('return '..h..sign..a)(),loadstring('return '..s..sign..b)(),loadstring('return '..v..sign..c)()
	end
	return Color.fromHSV(h,s,v)
end
function Color.fromRGB(r,g,b)
	return Color3.fromRGB(r,g,b)
end
function Color.toRGB(color)
	return color.r*255,color.g*255,color.b*255
end
function Color.setRGB(color,a,d,c)
	local r,g,b = Color.toRGB(color)
	if not c then
		if not d or d == 1 then
			r = a
		elseif d == 2 then
			g = a
		elseif d == 3 then
			b = a
		end
	else
		r,g,b = a,d,c
	end
	return Color.fromRGB(r,g,b)
end
function Color.editRGB(color,sign,a,b,c)
	if type(sign) == 'number' then
		c = b
		b = a
		a = sign
		sign = '+'	
	end
	local h,s,v = Color.toRGB(color)
	if not c then
				if not b or b == 1 then
			h = loadstring('return '..h..sign..a)()
		elseif b == 2 then
			s = loadstring('return '..s..sign..a)()
		elseif b == 3 then
			v = loadstring('return '..v..sign..a)()
		end
	else
		h,s,v = loadstring('return '..h..sign..a)(),loadstring('return '..s..sign..b)(),loadstring('return '..v..sign..c)()
	end
	return Color.fromRGB(h,s,v)
end
function Color.new(name,number)
	return Color.Colours[name][number] or Color.Colours[name][4]
end
Color.Colours = sm({},{
	__index = function(self,index)
		for i,v in pairs(self)do
			if v[0] and sm(v[0],Metas.Search)[index] then
				return v
			end
		end
	end
})

function ForMe.insertCitrusColor(name,main,inverse,...)
	local alias = {...}
	local new = main
	for i,v in pairs(inverse)do
		new[-i] = v
	end
	for i,v in pairs(new)do
		if type(v) == 'string' then
			new[i] = Color.fromHex(v)
		end
	end
	new[0] = alias
	Color.Colours[name] = new
	return new
end
local citrusColor = ForMe.insertCitrusColor
citrusColor('Ruby',{'EA8A97';
				'E06071';
				'CF3F4E';
				'C43140';
				'9E1F2C';
				'891A27';
				'77111F';}, {'EE8896';
						'E57683';
						'E0616E';
						'CE3B4A';
						'C0303F';
						'9F1F30';
'751522';},'Royale ruby','Brick red')
citrusColor('Red',{'EA8B8A','E06260','CF463F','C43831','9E251F','891E1A','771211'},
	{'EE8988','E57A76','E06761','CE423B','C03730','9F211F','751615'},'Mahogany'
)
citrusColor('Deep orange',{'EA958A','E06F60','CF543F','C44731','9E321F','89291A','771D11'},
	{'EE9488','E58576','E07461','CE513B','C04530','9F2E1F','752015'},'Peach','Mojo'
)
citrusColor('Orange',{'EAA58A','E08460','CF6C3F','C45F31','9E471F','893B1A','772E11'},
	{'EEA588','E59776','E08961','CE693B','C05D30','9F431F','753015'},'Raw sienna','Tuscany'
)
citrusColor('Yellow',{'EAC58A','E0AF60','CF9C3F','C49031','9E711F','89601A','775011'},
	{'EEC788','E5BC76','E0B361','CE9A3B','C08D30','9F6E1F','755015'},'Gold'
)
citrusColor('Lime',{'C7EA8A','B1E060','96CF3F','8AC431','6C9E1F','5F891A','527711'},
	{'C9EE88','BBE576','AEE061','94CE3B','87C030','709F1F','527515'}, 'Pear','Atlantis'
)
citrusColor('Mint',{'8AEABD','60E0A4','3FCF90','31C484','1F9E67','1A8957','117747'},
	{'88EEBE','76E5B3','61E0A9','3BCE8E','30C081','1F9F63','157548'},'Jade','Shamrock','Jewel'
)
citrusColor('Green',{'8AEA95','60E06F','3FCF54','31C447','1F9E32','1A8929','11771D'},
	{'88EE94','76E585','61E074','3BCE51','30C045','1F9F2E','157520'},'Apple','Emerald'
)
citrusColor("Teal",{'8AEADD','60E0CF','3FCFC0','31C4B5','1F9E91','1A897C','117769'},
	{'88EEE0','76E5D8','61E0D3','3BCEBF','30C0B1','1F9F8E','157568'},'Aquamarine'
)
citrusColor("Cyan",{'8ADFEA','60D1E0','3FBACF','31AEC4','1F8B9E','1A7A89','116C77'},
	{'88E3EE','76D6E5','61CDE0','3BB8CE','30ABC0','1F909F','156A75'}
)
citrusColor("Light blue",{'8ACFEA','60BCE0','3FA2CF','3196C4','1F769E','1A6889','115B77'},
	{'88D2EE','76C4E5','61B8E0','3BA0CE','3093C0','1F7B9F','155A75'},'Cornflower','Blumine'
)
citrusColor('Blue',{'8AAFEA','6091E0','3F72CF','3165C4','1F4C9E','1A4389','113877'},
	{'88AFEE','769FE5','618EE0','3B6FCE','3063C0','1F509F','153A75'},'Indigo','Cerulean blue'
)
citrusColor('Purple',{'AD8AEA','8F60E0','783FCF','6C31C4','521F9E','441A89','361177'},
	{'AD88EE','A076E5','9461E0','763BCE','6930C0','4E1F9F','381575'}
)
citrusColor('Pink',{'EA8ADF','E060D1','CF3FBA','C431AE','9E1F8B','891A7A','77116B'},
	{'EE88E2','E576D6','E061CD','CE3BB8','C030AB','9F1F90','75156A'},'Violet','Orchid'
)
citrusColor('Hot pink',{'EA8AB7','E0609C','CF3F7E','C43171','9E1F56','891A4C','771141'},
	{'EE88B8','E576A8','E06198','CE3B7B','C0306F','9F1F5B','751542'},'Rose'
)

--👥Sync channels + Theming channels
Citrus.Sync = {}
Sync = Citrus.Sync
syncChannel = ds.newDataType('SyncChannel',{
	Value = nil;
	Objects = {};
	Default = {};
	ValueChangedEvent = nil; --havet made event type yet
	Sync = function(self)
		
	end;
	toDefault = function(self)
	
	end;
	
})


--Icons👑
Citrus.Iconography = {}
Icon = Citrus.Iconography
Icon.Icons = {}


--Table Manipulation
Citrus.TableEditing = {}
Table = Citrus.TableEditing



--Miscellaneous❓❔
Citrus.Misc = {}
Misc = Citrus.Misc

function Misc.round(number)
	return math.floor(number + .5)
end

function Misc.switch(...)
	return sm({type = {},D4 = false,Get = function(self,number)
		if type(number) ~= 'number' then
			for i,v in pairs(self.type)do
				if v == number then
					number = i
				end
			end
			if type(number)~= 'number' then
				number = nil
			end
		end
		if number == nil then
			return self.D4
		else
			return self[number]
		end
	end,...},{
		__index = function(self,index)
			return self:Get(index)
		end;
		__newindex = function(self,index,new)
			if index == 'Default' then
				self['D4'] = new
			end
		end;
		__call = function(self,type,...)
			if typeof(self[type]) == 'function' then
				return self:Get(type)(...)
			else
				return self[type]
			end
		end;
	})
end


BETA.ColorClass = sm({},{
	__call = function(self,color,hsv)
		local a,b,c
		if type(color) == 'table' then
			return color
		end
		if hsv then
			a,b,c = Color.toHSV(color)
		else
			a,b,c = Color.toRGB(color)
		end
		return self.new(a,b,c,hsv)
	end
})
local color = BETA.ColorClass

color.meta = {
		isHSV = false;
		__index = function(self,index)
			index = index:lower()
			if index == 'r' or index == 'g' or index == 'b' then
				return Misc.round(self.Color[index]*255)
			elseif index == 'h' or index == 's' or index == 'v' then
				local h,s,v = Color.toHSV(self.Color)
				local tab = {h = h,s = s,v = v}
				return Misc.round(tab[index])
			elseif index == 'type' then
				if gm(self).isHSV then
					return 'HSV'
				else
					return 'RGB'
				end
			else return self.Color
			end
		end;
		__call = function(self)
			if gm(self).isHSV then
				gm(self).isHSV = false
			else
				gm(self).isHSV = true
			end
			return self
		end;
		__add = function(self,b)
			if gm(self).isHSV then
				return color(Color.editHSV(self.Color,'+',b,b,b))
			end
			return color(Color.editRGB(self.Color,'+',b,b,b))
		end;
		__sub = function(self,b)
			if gm(self).isHSV then
				return color(Color.editHSV(self.Color,'-',b,b,b))
			end
			return color(Color.editRGB(self.Color,'-',b,b,b))
		end;
		__div = function(self,b)
			if gm(self).isHSV then
				return color(Color.editHSV(self.Color,'/',b,b,b))
			end
			return color(Color.editRGB(self.Color,'/',b,b,b))
		end;
		__mul = function(self,b)
			if gm(self).isHSV then
				return color(Color.editHSV(self.Color,'*',b,b,b))
			end
			return color(Color.editRGB(self.Color,'*',b,b,b))
		end;
		__mod = function(self,b)
			if gm(self).isHSV then
				return color(Color.editHSV(self.Color,'%',b,b,b))
			end
			return color(Color.editRGB(self.Color,'%',b,b,b))
		end;
		__pow = function(self,b)
			if gm(self).isHSV then
				return color(Color.editHSV(self.Color,'^',b,b,b))
			end
			return color(Color.editRGB(self.Color,'^',b,b,b))
		end;
		__tostring = function(self)
			if gm(self).isHSV then
				return ""..self.h..", "..self.s..", "..self.v
			end
			return ""..self.r..", "..self.g..", "..self.b
		end;
		__concat = function(self,v)
			return tostring(self)..v
		end;
		__unm = function(self)
			local h,s,v = Color.toHSV(self.Color)
			return color(Color.fromHSV(h,v,s))		
		end;
		__newindex = function(self,a,b)
			if a == 'r' then
				return color(Color.setRGB(self.Color,b))
			elseif a == 'g' then
				return color(Color.setRGB(self.Color,b,2))
			elseif a == 'b' then
				return color(Color.setRGB(self.Color,b,3))
			elseif a == 'h' then
				return color(Color.setHSV(self.Color,b))
			elseif a == 's' then
				return color(Color.setHSV(self.Color,b,2))
			elseif a == 'v' then
				return color(Color.setHSV(self.Color,b,3))
			else
				return self
			end
		end
	}
ds.newDataType('Color',sm({
	Color = Color3.new(0,0,0)
},color.meta))
function color.new(r,g,b,h)
	if type(r) == 'string' then
		h = g
		r,g,b = Color.toRGB(Color.fromHex(r))
	end
	local col
	if not h then
		col = Color.fromRGB(r,g,b)
	else
		col = Color.fromHSV(r,g,b)
	end
	local new = ds.new('Color',{Color = col})
	if h then
		gm(new).isHSV = true
	end
	return new
end

print(color.new('f00'))

