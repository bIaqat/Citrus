Properties = setmetatable({
		new = function(name,func,...)
			local storage = getmetatable(Citrus.Properties).Custom
			storage[name] = setmetatable({func,...},{
					__call = function(self,...)
						return self[1](...)
					end;
					__index = function(self,indexed)
						for i = 2,#self do
							if self[i]:lower() == 'all' or indexed:IsA(self[i]) then
								return true
							end
						end
						return false
					end;
			})
		end;
		hasProperty = function(who,prop) --EDIT LATER FOR CUSTOM OBJECTS
			if pcall(function() return who[Citrus.Properties[prop]] end) then
				return true
			else
				return false
			end
		end;
		getProperties = function(who)
			local p = getmetatable(Citrus.Properties).RobloxAPI
			local new = {}
			for i,v in next,p do
				if Citrus.Properties.hasProperty(who,v) then
					rawset(new,v,who[v])
				end
			end
			return new
		end;
		setProperties = function(who,props)
			local c = getmetatable(Citrus.Properties).Custom
			for i,v in next,props do
				if c[i] then
					if type(v) ~= 'table' then v = {v} end
					--custom object check
					c[i](who,unpack(v))
				elseif Citrus.Properties.hasProperty(who,i) then
					pcall(function() who[Citrus.Properties[i]] = v end)
				end
			end
			return who
		end;
		getObjectOfProperty = function(property,directory)
			local objects = {}
			for _,object in next,type(directory) == 'table' and directory or directory:GetDescendants() do
				if Citrus.Properties.hasProperty(object,property) then
					table.insert(objects,object)
				end
			end
			return objects
		end;
					
	},{
		__index = function(self,ind)
			return Citrus.Misc.Table.search(getmetatable(self).RobloxAPI,ind)
		end;
		Custom = setmetatable({},{
				__index = function(self,ind)
					for i,v in next,self do
						if i:sub(1,#ind):lower() == ind then
							return v
						end
					end
				end});
		RobloxAPI = {
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
		}
	}
)