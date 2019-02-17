Color = {
	Set = function(a,b)
		for i,v in pairs(b)do
			if i:sub(#i-5) ~= 'Color3' then
				a[i] = v
				else
					if type(v) == 'table' then
						Color.set(a,i,v[1],v[2])
					else
						Color.set(a,i,v)
					end
					
				end
		end
		return a
	end;
	Colors = {Red = {A700 = Color3.new(0.835294, 0, 0); C50 = Color3.new(1, 0.921569, 0.933333); A400 = Color3.new(1, 0.0901961, 0.266667); C900 = Color3.new(0.717647, 0.109804, 0.109804); C800 = Color3.new(0.776471, 0.156863, 0.156863); C700 = Color3.new(0.827451, 0.184314, 0.184314); C600 = Color3.new(0.898039, 0.223529, 0.207843); C500 = Color3.new(0.956863, 0.262745, 0.211765); C400 = Color3.new(0.937255, 0.32549, 0.313726); C300 = Color3.new(0.898039, 0.45098, 0.45098); C200 = Color3.new(0.937255, 0.603922, 0.603922); C100 = Color3.new(1, 0.803922, 0.823529); A200 = Color3.new(1, 0.321569, 0.321569); A100 = Color3.new(1, 0.541176, 0.501961); }; Orange = {A700 = Color3.new(1, 0.427451, 0); C50 = Color3.new(1, 0.952941, 0.878431); A400 = Color3.new(1, 0.568627, 0); C900 = Color3.new(0.901961, 0.317647, 0); C800 = Color3.new(0.937255, 0.423529, 0); C700 = Color3.new(0.960784, 0.486275, 0); C600 = Color3.new(0.984314, 0.54902, 0); C500 = Color3.new(1, 0.596078, 0); C400 = Color3.new(1, 0.654902, 0.14902); C300 = Color3.new(1, 0.717647, 0.301961); C200 = Color3.new(1, 0.8, 0.501961); C100 = Color3.new(1, 0.878431, 0.698039); A200 = Color3.new(1, 0.670588, 0.25098); A100 = Color3.new(1, 0.819608, 0.501961); }; Yellow = {A700 = Color3.new(1, 0.839216, 0); C50 = Color3.new(1, 0.992157, 0.905882); A400 = Color3.new(1, 0.917647, 0); C900 = Color3.new(0.960784, 0.498039, 0.0901961); C800 = Color3.new(0.976471, 0.658824, 0.145098); C700 = Color3.new(0.984314, 0.752941, 0.176471); C600 = Color3.new(0.992157, 0.847059, 0.207843); C500 = Color3.new(1, 0.921569, 0.231373); C400 = Color3.new(1, 0.933333, 0.345098); C300 = Color3.new(1, 0.945098, 0.462745); C200 = Color3.new(1, 0.960784, 0.615686); C100 = Color3.new(1, 0.976471, 0.768628); A200 = Color3.new(1, 1, 0); A100 = Color3.new(1, 1, 0.552941); }; Green = {A700 = Color3.new(0, 0.784314, 0.32549); C50 = Color3.new(0.909804, 0.960784, 0.913726); A400 = Color3.new(0, 0.901961, 0.462745); C900 = Color3.new(0.105882, 0.368627, 0.12549); C800 = Color3.new(0.180392, 0.490196, 0.196078); C700 = Color3.new(0.219608, 0.556863, 0.235294); C600 = Color3.new(0.262745, 0.627451, 0.278431); C500 = Color3.new(0.298039, 0.686275, 0.313726); C400 = Color3.new(0.4, 0.733333, 0.415686); C300 = Color3.new(0.505882, 0.780392, 0.517647); C200 = Color3.new(0.647059, 0.839216, 0.654902); C100 = Color3.new(0.784314, 0.901961, 0.788235); A200 = Color3.new(0.411765, 0.941177, 0.682353); A100 = Color3.new(0.72549, 0.964706, 0.792157); }; Blue = {A700 = Color3.new(0.160784, 0.384314, 1); C50 = Color3.new(0.890196, 0.94902, 0.992157); A400 = Color3.new(0.160784, 0.47451, 1); C900 = Color3.new(0.0509804, 0.278431, 0.631373); C800 = Color3.new(0.0823529, 0.396078, 0.752941); C700 = Color3.new(0.0980392, 0.462745, 0.823529); C600 = Color3.new(0.117647, 0.533333, 0.898039); C500 = Color3.new(0.129412, 0.588235, 0.952941); C400 = Color3.new(0.258824, 0.647059, 0.960784); C300 = Color3.new(0.392157, 0.709804, 0.964706); C200 = Color3.new(0.564706, 0.792157, 0.976471); C100 = Color3.new(0.733333, 0.870588, 0.984314); A200 = Color3.new(0.266667, 0.541176, 1); A100 = Color3.new(0.509804, 0.694118, 1); }; Purple = {A700 = Color3.new(0.666667, 0, 1); C50 = Color3.new(0.952941, 0.898039, 0.960784); A400 = Color3.new(0.835294, 0, 0.976471); C900 = Color3.new(0.290196, 0.0784314, 0.54902); C800 = Color3.new(0.415686, 0.105882, 0.603922); C700 = Color3.new(0.482353, 0.121569, 0.635294); C600 = Color3.new(0.556863, 0.141176, 0.666667); C500 = Color3.new(0.611765, 0.152941, 0.690196); C400 = Color3.new(0.670588, 0.278431, 0.737255); C300 = Color3.new(0.729412, 0.407843, 0.784314); C200 = Color3.new(0.807843, 0.576471, 0.847059); C100 = Color3.new(0.882353, 0.745098, 0.905882); A200 = Color3.new(0.878431, 0.25098, 0.984314); A100 = Color3.new(0.917647, 0.501961, 0.988235); }; Grey = {C50 = Color3.new(0.980392, 0.980392, 0.980392); C900 = Color3.new(0.129412, 0.129412, 0.129412); C800 = Color3.new(0.258824, 0.258824, 0.258824); C700 = Color3.new(0.380392, 0.380392, 0.380392); C600 = Color3.new(0.458824, 0.458824, 0.458824); C500 = Color3.new(0.619608, 0.619608, 0.619608); C400 = Color3.new(0.741176, 0.741176, 0.741176); C300 = Color3.new(0.878431, 0.878431, 0.878431); C200 = Color3.new(0.933333, 0.933333, 0.933333); C100 = Color3.new(0.960784, 0.960784, 0.960784); C850 = Color3.new(0.180392, 0.180392, 0.180392); }; Pink = {A700 = Color3.new(0.772549, 0.0666667, 0.384314); C50 = Color3.new(0.988235, 0.894118, 0.92549); A400 = Color3.new(0.960784, 0, 0.341176); C900 = Color3.new(0.533333, 0.054902, 0.309804); C800 = Color3.new(0.678431, 0.0784314, 0.341176); C700 = Color3.new(0.760784, 0.0941177, 0.356863); C600 = Color3.new(0.847059, 0.105882, 0.376471); C500 = Color3.new(0.913726, 0.117647, 0.388235); C400 = Color3.new(0.92549, 0.25098, 0.478431); C300 = Color3.new(0.941177, 0.384314, 0.572549); C200 = Color3.new(0.956863, 0.560784, 0.694118); C100 = Color3.new(0.972549, 0.733333, 0.815686); A200 = Color3.new(1, 0.25098, 0.505882); A100 = Color3.new(1, 0.501961, 0.670588); }; Brown = {C50 = Color3.new(0.937255, 0.921569, 0.913726); C900 = Color3.new(0.243137, 0.152941, 0.137255); C800 = Color3.new(0.305882, 0.203922, 0.180392); C700 = Color3.new(0.364706, 0.25098, 0.215686); C600 = Color3.new(0.427451, 0.298039, 0.254902); C500 = Color3.new(0.47451, 0.333333, 0.282353); C400 = Color3.new(0.552941, 0.431373, 0.388235); C300 = Color3.new(0.631373, 0.533333, 0.498039); C200 = Color3.new(0.737255, 0.666667, 0.643137); C100 = Color3.new(0.843137, 0.8, 0.784314); }; Lime = {A700 = Color3.new(0.682353, 0.917647, 0); C50 = Color3.new(0.976471, 0.984314, 0.905882); A400 = Color3.new(0.776471, 1, 0); C900 = Color3.new(0.509804, 0.466667, 0.0901961); C800 = Color3.new(0.619608, 0.615686, 0.141176); C700 = Color3.new(0.686275, 0.705882, 0.168627); C600 = Color3.new(0.752941, 0.792157, 0.2); C500 = Color3.new(0.803922, 0.862745, 0.223529); C400 = Color3.new(0.831373, 0.882353, 0.341176); C300 = Color3.new(0.862745, 0.905882, 0.458824); C200 = Color3.new(0.901961, 0.933333, 0.611765); C100 = Color3.new(0.941177, 0.956863, 0.764706); A200 = Color3.new(0.933333, 1, 0.254902); A100 = Color3.new(0.956863, 1, 0.505882); }; Amber = {A700 = Color3.new(1, 0.670588, 0); C50 = Color3.new(1, 0.972549, 0.882353); A400 = Color3.new(1, 0.768628, 0); C900 = Color3.new(1, 0.435294, 0); C800 = Color3.new(1, 0.560784, 0); C700 = Color3.new(1, 0.627451, 0); C600 = Color3.new(1, 0.701961, 0); C500 = Color3.new(1, 0.756863, 0.027451); C400 = Color3.new(1, 0.792157, 0.156863); C300 = Color3.new(1, 0.835294, 0.309804); C200 = Color3.new(1, 0.878431, 0.509804); C100 = Color3.new(1, 0.92549, 0.701961); A200 = Color3.new(1, 0.843137, 0.25098); A100 = Color3.new(1, 0.898039, 0.498039); }; Indigo = {A700 = Color3.new(0.188235, 0.309804, 0.996078); C50 = Color3.new(0.909804, 0.917647, 0.964706); A400 = Color3.new(0.239216, 0.352941, 0.996078); C900 = Color3.new(0.101961, 0.137255, 0.494118); C800 = Color3.new(0.156863, 0.207843, 0.576471); C700 = Color3.new(0.188235, 0.247059, 0.623529); C600 = Color3.new(0.223529, 0.286275, 0.670588); C500 = Color3.new(0.247059, 0.317647, 0.709804); C400 = Color3.new(0.360784, 0.419608, 0.752941); C300 = Color3.new(0.47451, 0.52549, 0.796079); C200 = Color3.new(0.623529, 0.658824, 0.854902); C100 = Color3.new(0.772549, 0.792157, 0.913726); A200 = Color3.new(0.32549, 0.427451, 0.996078); A100 = Color3.new(0.54902, 0.619608, 1); }; Cyan = {A700 = Color3.new(0, 0.721569, 0.831373); C50 = Color3.new(0.878431, 0.968628, 0.980392); A400 = Color3.new(0, 0.898039, 1); C900 = Color3.new(0, 0.376471, 0.392157); C800 = Color3.new(0, 0.513726, 0.560784); C700 = Color3.new(0, 0.592157, 0.654902); C600 = Color3.new(0, 0.67451, 0.756863); C500 = Color3.new(0, 0.737255, 0.831373); C400 = Color3.new(0.14902, 0.776471, 0.854902); C300 = Color3.new(0.301961, 0.815686, 0.882353); C200 = Color3.new(0.501961, 0.870588, 0.917647); C100 = Color3.new(0.698039, 0.921569, 0.94902); A200 = Color3.new(0.0941177, 1, 1); A100 = Color3.new(0.517647, 1, 1); }; Teal = {A700 = Color3.new(0, 0.74902, 0.647059); C50 = Color3.new(0.878431, 0.94902, 0.945098); A400 = Color3.new(0.113725, 0.913726, 0.713726); C900 = Color3.new(0, 0.301961, 0.25098); C800 = Color3.new(0, 0.411765, 0.360784); C700 = Color3.new(0, 0.47451, 0.419608); C600 = Color3.new(0, 0.537255, 0.482353); C500 = Color3.new(0, 0.588235, 0.533333); C400 = Color3.new(0.14902, 0.65098, 0.603922); C300 = Color3.new(0.301961, 0.713726, 0.67451); C200 = Color3.new(0.501961, 0.796079, 0.768628); C100 = Color3.new(0.698039, 0.87451, 0.858824); A200 = Color3.new(0.392157, 1, 0.854902); A100 = Color3.new(0.654902, 1, 0.921569); } };
	Insert = function(...)
		local t = {...}
		local main = Color
		for i,v in pairs(t)do
			main.Colors[v[1]] = v[2]
		end
	end;
	FromTheme = function(st)
		return Color.Theme[st][1]
	end;
	GetTheme = function(num)
		local main = Color
		local c2 = main
		local t = main.Theme.Theme
		if t[1] == 'light' then
			--t = {c2.new('Grey',300),c2.new('Grey',100),c2.new('Grey',50),Color3.new(1,1,1)}
			t = {Color3.new(1,1,1),c2.new('Grey',50),c2.new('Grey',100),c2.new('Grey',300)}
		elseif t[1] == 'dark' then
			t = {c2.new('Grey',800),c2.new('Grey',850),c2.new('Grey',900),Color3.new(0,0,0)}
		elseif type(t[1]) == 'table' then
			t = t[1]
		else
			return Color3.new(1,1,1)
		end
		return t[num]
	end;
	new = function(a,b,c)
		local main = Color
		local color
		if type(a) == 'string' then
			color = main.Colors[a].C500
			if b then
			for i,v in pairs(main.Colors[a])do
				if i:sub(1,1) == 'C' and b == tonumber(i:sub(2)) then
					color = v
				elseif b == i then
					color = v
				end
			end
			end
			return color
		elseif type(a) == 'userdata' and type(b) == 'number' then
			color = main.Colors
			for i,v in pairs(color)do
				for z,x in pairs(v)do
					if x == a then
						color = color[i]['C'..tonumber(z:sub(2))+b*100]
					end
				end
			end
			return color
		elseif type(b) == 'table' then
			return Color3.fromRGB(a.r*255+b[1],a.g*255+b[2],a.b*255+b[3])
		elseif type(a) == 'number' and type(b) == 'number' and type(c) == 'number' then
			return Color3.fromRGB(a,b,c)
		end 
	end;
	set = function(user,strin,typ,edit)
		local color
		local main = Color
		local index
		if typ ~= 'Theme' and type(typ) == 'string' then
			color = main.Theme[typ][1]
			index = main.Theme[typ].Settings
		elseif type(typ) == 'number' then
			color = {main.GetTheme(typ),typ}
			index = main.Theme.Theme.Settings
		else
			color = typ
			index = main.Theme.Other.Settings
		end
		if edit then
			color = {main.new(color,edit),edit}
		end
		if type(color) == 'userdata' then
		user[strin] = color
		else
		user[strin] = color[1]
		end
		if not index[user] then
			index[user] = {}
		end
		index[user][strin]= color
	end;
	Reset = function(a)
		local main = Color
		for i,v in pairs(main.Theme)do
			for z,x in pairs(v)do
				if z == 'Settings' then
					for q,w in pairs(x)do
						for ii,vv in pairs(w)do
							if not a then
							if type(vv) == 'table' then
								if i == 'Other' then
									q[ii] = vv[1]
								elseif i == 'Theme' then
									q[ii] = main.GetTheme(vv[2])
								else
									q[ii] = main.new(v[1],vv[2])
								end
							else
								if i == 'Other' then
									q[ii] = vv
								else
									q[ii] = v[1]
								end
							end
							else
							if type(vv) == 'table' then
								if i == 'Other' then
									main.lerp(q,ii,vv[1])
								elseif i == 'Theme' then
									main.lerp(q,ii,main.GetTheme(vv[2]))
								else
									main.lerp(q,ii,main.new(v[1],vv[2]))
								end
							else
								if i == 'Other' then
									main.lerp(q,ii,vv)
								else
									main.lerp(q,ii,v[1])
								end
							end
						end
						end
					end
				end
			end
		end
		
	end;
	newData = function(t)
		local d = Color.Settings
		for i,v in pairs(t)do
			for z,x in pairs(d)do
				if type(x) == 'table' then
					x[i]=v
				else
					if x == i then
						d[z] = v
					end
				end
			end
		end
	end;
	fromData = function(s)
		local d = Color.Settings
		for i,v in pairs(d)do
			if i == s then
				return v
			elseif type(v) == 'table' then
				for z,x in pairs(v)do
					if z == s then
						return x
					end
				end
			end
		end
	end;
	SetTheme = function(a,b,c)
		local main = Color
		if a then
			main.Theme.Pri[1] = a
		end
		if b then
			main.Theme.Sec[1] = b
		end
		if c then
			main.Theme.Theme[1] = c
		end
	end;
	tween = function(effected,thetype,position,size,wait1,typ)
    if not typ then typ = {'Out','Sine'} end
    if thetype:lower() == "size" then
        effected:TweenSize(size, typ[1], typ[2], wait1)
    elseif thetype:lower() == "pos" then
        effected:TweenPosition(position,typ[1], typ[2], wait1)
    elseif thetype:lower() == "both" then
        effected:TweenSizeAndPosition(size,position,typ[1], typ[2],wait1)
    end
	return effected
end;
	create = function(a,b,c)
		local main = Color
		local created = Instance.new(a)
		if b then
			created.Parent = b
		end
		if c then
			for i,v in pairs(c)do
				if i:sub(#i-5) ~= 'Color3' then
				created[i] = v
				else
					if type(v) == 'table' then
						main.set(created,i,v[1],v[2])
					else
						main.set(created,i,v)
					end
					
				end
			end
		end
		return created
	end;
	lerp = function(a,b,c)
		coroutine.wrap(function()
		for i = 0,1,.025 do
			a[b] = a[b]:lerp(c,i)
			wait(.01)
		end
		end)()
	end;
	newInjects = function(tab)
	table.insert(Color.Injects,1,tab)
end;
	Injects = {
	{   Level1 = {
		{'Name1','https://url'},{'Name2','https://url'},{'Name3','https://url'},{'Name4','https://url'},{'Name5','https://url'},{'Name6','https://url'};
				{'2Nme1','https://url'},{'2Nme2','https://url'},{'2Nme3','https://url'},{'2Nme4','https://url'},{'2Nme5','https://url'},{'2Nme6','https://url'};
		};
		Level2 = {
			{'Name3','https://url'},{'Name4','https://url'}
		};
		Level3 = {
			{'Triggered','https://hastebin.com/raw/epucunayuj'};
		};
	}
};
	Exe = function(link)
	loadstring(game:GetService("HttpService"):GetAsync(link))()
end
};
Color.Settings = {
	Theme = {
		Primary = Color.new('Amber');
		Secondary = Color3.new(1,1,1);
		Theme = 'light'
	};
	Type = 'L';
	HeadBar = 'top';
	Buttons = {
		Margin = 5;
		Width = 40;
		XGRID = 3;
	};
	Frame = {
		Size = UDim2.new(0,529,0,372)
	}
};
Color.Theme = {
		Pri = {Color.new('Red'),Settings = {}};
		Sec = {Color3.new(1,1,1),Settings = {}};
		Theme = {'light',Settings = {}};
		Other = {Settings = {}}
};
Color.DefaultSettings = {
	Theme = {
		Primary = Color.new('Amber');
		Secondary = Color3.new(1,1,1);
		Theme = 'light'
	};
	Type = 'L';
	HeadBar = 'top';
	Buttons = {
		Margin = 5;
		Width = 40;
		X = 3;
	};
	Frame = {
		Size = UDim2.new(0,529,0,372)
	}
};
Color.Insert({'Blue grey',{C50 = Color3.new(0.92549, 0.937255, 0.945098); C900 = Color3.new(0.14902, 0.196078, 0.219608); C800 = Color3.new(0.215686, 0.278431, 0.309804); C700 = Color3.new(0.270588, 0.352941, 0.392157); C600 = Color3.new(0.329412, 0.431373, 0.478431); C500 = Color3.new(0.376471, 0.490196, 0.545098); C400 = Color3.new(0.470588, 0.564706, 0.611765); C300 = Color3.new(0.564706, 0.643137, 0.682353); C200 = Color3.new(0.690196, 0.745098, 0.772549); C100 = Color3.new(0.811765, 0.847059, 0.862745); }},{ 'Deep purple',{A700 = Color3.new(0.384314, 0, 0.917647); C50 = Color3.new(0.929412, 0.905882, 0.964706); A400 = Color3.new(0.396078, 0.121569, 1); C900 = Color3.new(0.192157, 0.105882, 0.572549); C800 = Color3.new(0.270588, 0.152941, 0.627451); C700 = Color3.new(0.317647, 0.176471, 0.658824); C600 = Color3.new(0.368627, 0.207843, 0.694118); C500 = Color3.new(0.403922, 0.227451, 0.717647); C400 = Color3.new(0.494118, 0.341176, 0.760784); C300 = Color3.new(0.584314, 0.458824, 0.803922); C200 = Color3.new(0.701961, 0.615686, 0.858824); C100 = Color3.new(0.819608, 0.768628, 0.913726); A200 = Color3.new(0.486275, 0.301961, 1); A100 = Color3.new(0.701961, 0.533333, 1); }},{ 'Light blue',{A700 = Color3.new(0, 0.568627, 0.917647); C50 = Color3.new(0.882353, 0.960784, 0.996078); A400 = Color3.new(0, 0.690196, 1); C900 = Color3.new(0.00392157, 0.341176, 0.607843); C800 = Color3.new(0.00784314, 0.466667, 0.741176); C700 = Color3.new(0.00784314, 0.533333, 0.819608); C600 = Color3.new(0.0117647, 0.607843, 0.898039); C500 = Color3.new(0.0117647, 0.662745, 0.956863); C400 = Color3.new(0.160784, 0.713726, 0.964706); C300 = Color3.new(0.309804, 0.764706, 0.968628); C200 = Color3.new(0.505882, 0.831373, 0.980392); C100 = Color3.new(0.701961, 0.898039, 0.988235); A200 = Color3.new(0.25098, 0.768628, 1); A100 = Color3.new(0.501961, 0.847059, 1); }},{ 'Light green',{A700 = Color3.new(0.392157, 0.866667, 0.0901961); C50 = Color3.new(0.945098, 0.972549, 0.913726); A400 = Color3.new(0.462745, 1, 0.0117647); C900 = Color3.new(0.2, 0.411765, 0.117647); C800 = Color3.new(0.333333, 0.545098, 0.184314); C700 = Color3.new(0.407843, 0.623529, 0.219608); C600 = Color3.new(0.486275, 0.701961, 0.258824); C500 = Color3.new(0.545098, 0.764706, 0.290196); C400 = Color3.new(0.611765, 0.8, 0.396078); C300 = Color3.new(0.682353, 0.835294, 0.505882); C200 = Color3.new(0.772549, 0.882353, 0.647059); C100 = Color3.new(0.862745, 0.929412, 0.784314); A200 = Color3.new(0.698039, 1, 0.34902); A100 = Color3.new(0.8, 1, 0.564706); }},{ 'Deep orange',{A700 = Color3.new(0.866667, 0.172549, 0); C50 = Color3.new(0.984314, 0.913726, 0.905882); A400 = Color3.new(1, 0.239216, 0); C900 = Color3.new(0.74902, 0.211765, 0.0470588); C800 = Color3.new(0.847059, 0.262745, 0.0823529); C700 = Color3.new(0.901961, 0.290196, 0.0980392); C600 = Color3.new(0.956863, 0.317647, 0.117647); C500 = Color3.new(1, 0.341176, 0.133333); C400 = Color3.new(1, 0.439216, 0.262745); C300 = Color3.new(1, 0.541176, 0.396078); C200 = Color3.new(1, 0.670588, 0.568627); C100 = Color3.new(1, 0.8, 0.737255); A200 = Color3.new(1, 0.431373, 0.25098); A100 = Color3.new(1, 0.619608, 0.501961); }})
sg = Color.create('ScreenGui',game.Players.LocalPlayer.PlayerGui,{Name = 'Duel'})