Properties = setmetatable({
	Default = setmetatable({},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				set = function(ClassName, Properties, Z) --If the Z is higher it overlaps the Zs lower
					if not self[Z or 0] then self[Z or 0] = {} end
					self[Z or 0][ClassName] = Properties
				end;
				get = function(ClassName, Z)
					local props = {}
					local function checkAndGet(i,v)
						if pcall(function() return Instance.new(ClassName):IsA(i) end) or i == ClassName then
							for i,v in next, v do
								props[i] = v
							end
						end						
					end
					if Z then
						for i,v in next, self[Z] do
							checkAndGet(i,v)
						end
					else
						for i,v in next, self do
							for i,v in next, v do
								checkAndGet(i,v)
							end
						end
					end
					return props
				end;
				toDefaultProperties = function(Object,Z)
					local props = self.get(Object.ClassName,Z)
					for i,v in next, props do
						Object[i] = v
					end
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end
	});
	Custom = setmetatable({},{
		__index = function(self,index)
			getmetatable(self).__index = {}
			getmetatable(self).__index.new = function(Name, Function, ...) --... Classes that can use this property
				self[Name] = setmetatable({Function = Function,Classes = {...}},{
					__index = function(self, Object)
						local class = self.Classes
						if #class == 0 then
							return true
						end
						for i,ClassName in next, class do
							if Object:IsA(ClassName) or ClassName == 'all' then
								return true
							end
						end
						return false
					end;
					__call = function(self,Object,...)
						if self[Object] then
							self.Function(Object,...)
						end
					end;
				})
			end
			if index == 'new' then return getmetatable(self).__index.new end
		end
	});
	RobloxApi = setmetatable({
		'Shape','Anchored','BackSurfaceInput','BottomParamA','BottomParamB','BottomSurface','BottomSurfaceInput','BrickColor','CFrame','CanCollide','CenterOfMass','CollisionGroupId','Color','CustomPhysicalProperties','FrontParamA','FrontParamB','FrontSurface','FrontSurfaceInput';
		'LeftParamA','LeftParamB','LeftSurface','LeftSurfaceInput','Locked','Material','Orientation','Reflectance','ResizeIncrement','ResizeableFaces','RightParamA','RightParamB','RightSurface','RightSurfaceInput','RotVelocity','TopParamA','TopParamB','TopSurface','TopSurfaceInput','Velocity';
		'Archivable','ClassName','Name','Parent','AttachmentForward','AttachmentPoint','AttachmentPos','AttachmentRight','AttachmentUp';
		'Animation','AnimationId','IsPlaying','Length','Looped','Priority','Speed','TimePosition','WeightCurrent','WeightTarget','Axis','CFrame','Orientation';
		'Position','Rotation','SeconaryAxis','Visible','WorldAxis','WorldOrientation','WorldPosition','WorldSecondaryAxis','Version','DisplayOrder','ResetOnSpawn','Enabled';
		'AbsolutePosition','AbsoluteRotation','AbsoluteSize','ScreenOrientation','ShowDevelopmentGui','Attachment0','Attachment1','Color','CurveSize0','CurveSize1','FaceCamera';
		'LightEmission','Segments','Texture','TextureLength','TextureMode','TextureSpeed','Transparency','Width0','Width1','ZOffset','AngularVelocity','MaxTorque','P','Force','D';
		'MaxForce','Location','Velocity','CartoonFactor','MaxSpeed','MaxThrust','Target','TargetOffset','TargetRadius','ThrustD','ThrustP','TurnD','TurnP','Value','CameraSubject','CameraType';
		'FieldOfView','Focus','HeadLocked','HeadScale','ViewportSize','HeadColor','HeadColor3','LeftArmColor','LeftArmColor3','LeftLegColor','LeftLegColor3','RightArmColor','RightArmColor3','RightLegColor','RightLegColor3','TorsoColor','TorsoColor3';
		'BaseTextureId','BodyPart','MeshId','OverlayTextureId','PantsTemplate','ShirtTemplate','Graphic','SkinColor','LoadDefaultChat','CursorIcon','MaxActivationDistance','MaxAngularVelocity','PrimaryAxisOnly','ReactionTorqueEnabled','Responsiveness','RigidityEnabled';
		'ApplyAtCenterOfMass','MaxVelocity','ReactionForceEnabled','Radius','Restitution','TwistLimitsEnabled','TwistLowerAngle','TwistUpperAngle','UpperAngle','ActuatorType','AngularSpeed','CurrentAngle','LimitsEnabled','LowerAngle','MotorMaxAcceleration','MotorMaxTorque','ServoMaxTorque','TargetAngle';
		'InverseSquareLaw','Magnitude','Thickness','CurrentPosition','LowerLimit','Size','TargetPosition','UpperLimit','Heat','SecondaryColor';
		'BackgroundColor3','AnchorPoint','BackgroundTransparency','BorderColor3','BorderSizePixel','ClipsDescendants','Draggable','LayoutOrder','NextSelectionDown','NextSelectionLeft','NextSelectionRight','NextSelectionUp','Selectable','SelectionImageObject','SizeConstraint','SizeFromContents','ZIndex';
		'Style','AutoButtonColor','Modal','Selected','Image','ImageColor3','ImageRectOffset','ImageRectSize','ImageTransparency','IsLoaded','ScaleType','SliceCenter','TextSize','TileSize','Font','Text','TextBounds','TextColor3','TextFits';
		'TextScaled','TextStrokeColor3','TextStrokeTransparency','TextTransparency','TextWrapped','TextXAlignment','TextYAlignment','Active','AbsoluteWindowSize','BottomImage','CanvasPosition','CanvasSize','HorizontalScrollBarInset','MidImage','ScrollBarThickness','ScrollingEnabled','TopImage','VerticalScrollBarInset';
		'VerticalScrollBarPosition','ClearTextOnFocus','MultiLine','PlaceholderColor3','PlaceholderText','ShowNativeInput','Adornee','AlwaysOnTop','ExtentsOffset','ExtentsOffsetWorldSpace','LightInfluence','MaxDistance','PlayerToHideForm','SizeOffset','StudsOffset','StudsOffsetWorldSpace','ToolPunchThroughDistance','Face','DecayTime','Density','Diffusion','Duty','Frequency';
		'Depth','Mix','Rate','Attack','GainMakeup','Ratio','Release','SieChain','Threshold','Level','Delay','DryLevel','Feedback','WetLevel','HighGain','LowGain','MidGain','Octave','Volume','MaxSize','MinSize','AspectRatio','DominantAxis','AspectType','MaxTextSize','MinTextSize','CellPadding','CellSize','FillDirectionMaxCells','StartCorner';
		'AbsoluteContentSize','FillDirection','HorizontalAlignment','SortOrder','VerticalAlignment','Padding','Animated','Circular','CurrentPage','EasingDirection','EasingStyle','GamepadInputEnabled','ScrollWhellInputEnabled','TweenTime','TouchImputEnable','FillEmptySpaceColumns','FillEmptySpaceRows','MajorAxis','PaddingBottom','PaddingLeft','PaddingRight','PaddingTop','Scale'
	},{
		ObjectProperties = {};
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				sort = function(self,func)
					table.sort(self,func)
				end;
				search = function(self, index, keepSimilar)
					return Spice.Table.search(self,index,false,keepSimilar, true, false,true)
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end;
	});
},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = self.Custom.new;
				hasProperty = function(Object,Property)
					local has = pcall(function() return Object[Property] and true end)
					return has, has and Object[Property] or nil
				end;
				getProperties = function(Object)
					local props = {}
					local op = getmetatable(self.RobloxApi).ObjectProperties
					if not op[Object.ClassName] then
						for i,property in next, self.RobloxApi do
							if  pcall(function() return Object[property] and true end) then
								rawset(props,property,Object[property])
							end
						end
						op[Object.ClassName] = props
					else props = op[Object.ClassName] end
					return props
				end;
				getChildrenOfProperty = function(Object, Property)
					local children = {}
					for i,child in next, Object:GetChildren() do
						if pcall(function() return child[Property] and true end) then
							table.insert(children,child)
						end
					end
					return children
				end;
				getDescendantsOfProperty = function(Object, Property)
					local desc = {}
					for i,child in next, Object:GetDescendants() do
						if pcall(function() return child[Property] and true end) then
							table.insert(desc,child)
						end
					end
					return desc
				end;
				setProperties = function(Object, Properties, dontIncludeShorts, dontIncludeCustom, includeDefault)
					local custom, api, default = self.Custom, self.RobloxApi, self.Default
					if includeDefault then
						self.Default.toDefaultProperties(Object,type(includeDefault) == 'number' or nil)
					end
					for property, value in next, Properties do
						if not dontIncludeShorts then property = self.RobloxApi:search(property) or property end
						if not dontIncludeCustom and self.Custom[property] then
							self.Custom[property](Object,type(value) == 'table' and unpack(value) or value)
						elseif pcall(function() return Object[property] and true end) then
							Object[property] = value
						end
					end
					return Object
				end;
				setVanillaProperties = function(Object, Properties)
					for i,v in next, Properties do
						Object[i] = v
					end
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end;	
});
