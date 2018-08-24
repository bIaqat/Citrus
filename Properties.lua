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
	RobloxAPI = setmetatable({"C0","C1","F0","F1","F2","F3","Hit","hit","Mix","Sit","Axes","Axis","Drag","Duty","Face","Font","Grip","Heat","Icon","Jump","Line","Loop","Name","Port","Rate","SIMD","size","Size","Text","Time","Tone","Angle","Coils","Color","Delay","Delta","Depth","Faces","focus","Focus","Force","force","Genre","Guest","Image","InOut","InUse","JobId","Level","Modal","OsVer","Pitch","Point","Range","Ratio","Scale","Score","Shape","Shiny","Speed","Steer","Style","Title","TurnD","TurnP","Value","Active","Attack","CFrame","cframe","Color3","FaceId","FogEnd","GameId","GripUp","Health","Height","Length","Locked","Looped","MeshId","Octave","Offset","Origin","Radius","Source","Spread","Status","Ticket","Torque","userId","UserId","Volume","Weight","Width0","Width1","ZIndex","Ambient","BaseUrl","BinType","Damping","Density","Enabled","GcLimit","GcPause","GfxCard","Graphic","Gravity","GripPos","KeyCode","LowGain","MaxSize","MidGain","MinSize","Neutral","Opacity","Padding","PlaceId","Playing","Purpose","Release","RigType","Shadows","SoundId","summary","Texture","ThrustD","ThrustP","Timeout","ToolTip","UnitRay","Version","Visible","ZOffset","ActionId","Anchored","Animated","AutoRuns","BodyPart","CellSize","ChatMode","Circular","Contrast","DataCost","Disabled","DryLevel","Duration","Feedback","FogColor","FogStart","FontSize","Friction","GridSize","HighGain","IsLoaded","IsPaused","IsSmooth","JobCount","Lifetime","LocaleId","Localize","location","Location","Material","maxForce","MaxForce","MaxItems","MaxSpeed","MaxValue","MeshType","MidImage","MinValue","Outlines","position","Position","Priority","Rotation","RotSpeed","Segments","Selected","SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","Specular","TextFits","TextSize","TextWrap","Throttle","TileSize","TopImage","UseCSGv2","Velocity","velocity","VRDevice","WetLevel","BaseAngle","Browsable","ClassName","className","ClockTime","Condition","CreatorId","DataModel","DataReady","DecayTime","Diffusion","Draggable","EnableFRM","Frequency","GcStepMul","GripRight","HeadColor","HeadScale","HipHeight","Intensity","IsBackend","IsEnabled","IsPlaying","isPlaying","IsWindows","JumpPower","LeftRight","Magnitude","MajorAxis","maxHealth","MaxHealth","MaxLength","MaxThrust","MaxTorque","maxTorque","MinLength","MultiLine","OsIs64Bit","PackageId","PrintBits","ScaleType","SkinColor","SortOrder","StarCount","StatusTip","Stiffness","TeamColor","TestCount","TextColor","TextureId","TextureID","Thickness","Threshold","TimeOfDay","TintColor","TopBottom","TopParamA","TopParamB","Transform","TurnSpeed","TweenInfo","TweenTime","UIMaximum","UIMinimum","VersionId","ViewSizeX","ViewSizeY","VREnabled","WalkSpeed","WarnCount","WorldAxis","AccountAge","AllowSleep","Archivable","archivable","AspectType","AutoRotate","BackParamA","BackParamB","brickColor","BrickColor","Brightness","BubbleChat","CameraMode","CameraType","CanCollide","CanvasSize","ColorShift","Constraint","CursorIcon","CurveSize0","CurveSize1","DataGCRate","Deprecated","Elasticity","ErrorCount","Expression","FaceCamera","formFactor","FormFactor","FreeLength","Fullscreen","GainMakeup","HeadColor3","HeadLocked","HoverImage","Insertable","IsFinished","LeftParamA","LeftParamB","LineHeight","LowerAngle","LowerLimit","MaskWeight","MaxExtents","MaxPlayers","MenuIsOpen","NavBarSize","NearPlaneZ","NumPlayers","numPlayers","OsPlatform","PaddingTop","ReceiveAge","RelativeTo","Saturation","Selectable","ShouldSkip","SizeOffset","SteerFloat","Teleported","TextBounds","TextColor3","TextScaled","TimeLength","TopSurface","TorsoColor","UINumTicks","UpperAngle","UpperLimit","UserDialog","WaterColor","WidthScale","WireRadius","AlwaysOnTop","AnchorPoint","AnimationId","AspectRatio","BackSurface","BlastRadius","BorderColor","BottomImage","CellPadding","ChatHistory","ChatVisible","ClassicChat","ControlMode","CreatorType","CurrentLine","CycleOffset","Description","DisplayName","EasingStyle","EmitterSize","EmptyCutoff","FieldOfView","FrontParamA","FrontParamB","GcFrequency","GripForward","HttpEnabled","ImageColor3","IsDebugging","IsTreeShown","LayoutOrder","LeftSurface","LuaRamLimit","MaxDistance","MaxTextSize","MaxVelocity","MinDistance","MinTextSize","Orientation","PaddingLeft","PlayerCount","PrintEvents","ReceiveRate","Reflectance","Restitution","RightParamA","RightParamB","RollOffMode","RotVelocity","ShadowColor","SizeInCells","SliceCenter","SpreadAngle","StartCorner","StudsOffset","TargetAngle","TargetPoint","TextureMode","TextureSize","TextWrapped","TorsoColor3","VertexColor","VideoMemory","VIPServerId","WalkToPoint","WorldCFrame","AbsoluteSize","Acceleration","ActuatorType","AngularSpeed","AttachmentUp","AutoFRMLevel","AutoLocalize","BehaviorType","BorderColor3","BottomParamA","BottomParamB","CameraOffset","CanBeDropped","CenterOfMass","CurrentAngle","DataSendKbps","DataSendRate","DesiredAngle","DisableCSGv2","DisplayOrder","DominantAxis","DopplerScale","FollowUserId","FrontSurface","GraphicsMode","LeftArmColor","LeftLegColor","LinkedSource","LockedToPart","MasterVolume","ModalEnabled","MouseEnabled","OsPlatformId","PaddingRight","PlaceVersion","PlayOnRemove","PressedImage","PrintFilters","PrintTouches","QualityLevel","ReloadAssets","ResetOnSpawn","RightSurface","RiseVelocity","RobloxLocked","RolloffScale","RotationType","SparkleColor","StickyWheels","SunTextureId","SurfaceColor","TargetOffset","TargetRadius","TeleportedIn","TextTruncate","TextureSpeed","TimePosition","TouchEnabled","Transparency","UsePartColor","VideoQuality","ViewportSize","VRDeviceName","WeightTarget","AmbientReverb","AttachmentPos","BaseTextureId","BlastPressure","BottomBarSize","BottomSurface","CartoonFactor","ClassCategory","ContactsCount","CurrentLength","DataMtuAdjust","ExplorerOrder","ExplosionType","ExtentsOffset","FillDirection","FloorMaterial","GlobalShadows","GoodbyeDialog","HardwareMouse","HasEverUsedVR","ImageRectSize","InitialPrompt","InstanceCount","IsModalDialog","LeftArmColor3","LeftLegColor3","LightEmission","LimitsEnabled","LineThickness","LocalizedText","MaxSlopeAngle","MeshCacheSize","MoonTextureId","MotorMaxForce","MouseBehavior","MoveDirection","NameOcclusion","PaddingBottom","PantsTemplate","PlatformStand","PlaybackSpeed","PlaybackState","RightArmColor","RightLegColor","RobloxVersion","SchedulerRate","ScriptContext","SecondaryAxis","ServoMaxForce","ShirtTemplate","SoftwareSound","StatusBarSize","StudsPerTileU","StudsPerTileV","SurfaceColor3","TargetSurface","TextureLength","ThrottleFloat","TouchSendRate","TriangleCount","TriggerOffset","UserInputType","WaterWaveSize","WeightCurrent","WorldPosition","WorldRotation","AreOwnersShown","AutoAssignable","AutomaticRetry","CanvasPosition","DataComplexity","DistanceFactor","ErrorReporting","GamepadEnabled","HeadsUpDisplay","IgnoreGuiInset","IsSleepAllowed","LightInfluence","MembershipType","MotorMaxTorque","OutdoorAmbient","PrintInstances","RequiresHandle","ResponseDialog","Responsiveness","RightArmColor3","RightLegColor3","RobloxLocaleId","SecondaryColor","ServoMaxTorque","SizeConstraint","SourceLocaleId","SunAngularSize","SystemLocaleId","TargetPosition","TextXAlignment","TextYAlignment","ThreadPoolSize","TrackDataTypes","UserHeadCFrame","UserInputState","VelocitySpread","WaterWaveSpeed","ZIndexBehavior","angularvelocity","AngularVelocity","AreAnchorsShown","AreRegionsShown","AttachmentPoint","AttachmentRight","AutoButtonColor","AutoJumpEnabled","BackgroundColor","BorderSizePixel","CameraYInverted","CoordinateFrame","CurrentDistance","CurrentPosition","DataReceiveKbps","DefaultWaitTime","EasingDirection","EditingDisabled","ElasticBehavior","ExtraMemoryUsed","HeartbeatTimeMs","ImageRectOffset","IsSFFlagsLoaded","KeyboardEnabled","LoadDefaultChat","MoonAngularSize","NumberOfPlayers","OnTopOfCoreBlur","PhysicsSendKbps","PhysicsSendRate","PlaceholderText","PreferredParent","PrimaryAxisOnly","PrimitivesCount","PrintProperties","ResizeableFaces","ResizeIncrement","RigidityEnabled","ScriptsDisabled","ShowNativeInput","SpecificGravity","TopSurfaceInput","TriggerDistance","TwistLowerAngle","TwistUpperAngle","AbsolutePosition","AbsoluteRotation","BackgroundColor3","BackSurfaceInput","ChatScrollLength","ClearTextOnFocus","ClipsDescendants","CollisionEnabled","CollisionGroupId","ComparisonMethod","ConstrainedValue","DataSendPriority","DebuggingEnabled","EditQualityLevel","FilteringEnabled","FrameRateManager","FreeMemoryMBytes","GearGenreSetting","GyroscopeEnabled","InclinationAngle","InverseSquareLaw","IsLuaChatEnabled","LeftSurfaceInput","MouseIconEnabled","MouseSensitivity","NetworkOwnerRate","OverlayTextureId","PhysicsMtuAdjust","PlaybackLoudness","PreferredParents","PreferredPlayers","ProcessUserInput","RequestQueueSize","ScrollingEnabled","SimulationRadius","StreamingEnabled","TextStrokeColor3","TextTransparency","ThreadPoolConfig","VIPServerOwnerId","WaterReflectance","WorldOrientation","AppearanceDidLoad","AreBodyTypesShown","AreHingesDetected","AttachmentForward","EmissionDirection","FrontSurfaceInput","HealthDisplayType","ImageTransparency","IsReceiveAgeShown","PhysicsStepTimeMs","PlaceholderColor3","PrintSplitMessage","RightSurfaceInput","RobloxProductName","SavedQualityLevel","ScreenOrientation","ShowBoundingBoxes","SystemProductName","TouchInputEnabled","TouchMovementMode","VerticalAlignment","WaterTransparency","WorldRotationAxis","AbsoluteWindowSize","AdditionalLuaState","AngularRestitution","AreAssembliesShown","AreMechanismsShown","ArePartCoordsShown","BottomSurfaceInput","BubbleChatLifetime","CharacterAutoLoads","DevEnableMouseLock","DevTouchCameraMode","EagerBulkExecution","ExplorerImageIndex","FillEmptySpaceRows","GeographicLatitude","GuiInputUserCFrame","LegacyNamingScheme","ManualFocusRelease","MaxAngularVelocity","MaxCollisionSounds","MaxPlayersInternal","OverlayNativeInput","PhysicsReceiveKbps","PrintPhysicsErrors","SchedulerDutyCycle","ScrollBarThickness","ScrollingDirection","ShowDevelopmentGui","SimulateSecondsLag","SizeRelativeOffset","ThrottleAdjustTime","TwistLimitsEnabled","WorldSecondaryAxis","AbsoluteContentSize","AngularActuatorType","ApplyAtCenterOfMass","AreModelCoordsShown","AreWorldCoordsShown","AutoColorCharacters","CharacterAppearance","DataComplexityLimit","DevelopmentLanguage","DisplayDistanceType","DistributedGameTime","GamepadInputEnabled","GoodbyeChoiceActive","HorizontalAlignment","NameDisplayDistance","PhysicsSendPriority","PreferredClientPort","ReportSoundWarnings","RotationAxisVisible","SurfaceTransparency","TrackPhysicsDetails","UsedHideHudShortcut","VelocityInheritance","VideoCaptureEnabled","VRRotationIntensity","AccelerometerEnabled","AllowThirdPartySales","AllTutorialsDisabled","AngularLimitsEnabled","AutoSelectGuiEnabled","BubbleChatMaxBubbles","CelestialBodiesShown","CollisionSoundVolume","ComputerMovementMode","ConversationDistance","CustomizedTeleportUI","DevTouchMovementMode","ExecuteWithStudioRun","GazeSelectionEnabled","GuiNavigationEnabled","IsLuaHomePageEnabled","IsQueueErrorComputed","IsTextScraperRunning","ManualActivationOnly","MotorMaxAcceleration","OnboardingsCompleted","OnScreenKeyboardSize","ReactionForceEnabled","ScrollBarImageColor3","StudsBetweenTextures","WaitingThreadsBudget","AllowCustomAnimations","AllowInsertFreeModels","AreContactPointsShown","CameraMaxZoomDistance","CameraMinZoomDistance","CharacterAppearanceId","ClientPhysicsSendRate","CollisionSoundEnabled","DevComputerCameraMode","EnableMouseLockOption","ExportMergeByMaterial","FillDirectionMaxCells","FillEmptySpaceColumns","HealthDisplayDistance","HostWidgetWasRestored","IsLuaGamesPageEnabled","MaxActivationDistance","MouseDeltaSensitivity","MovingPrimitivesCount","OverrideStarterScript","ReactionTorqueEnabled","RenderStreamedRegions","ResetPlayerGuiOnSpawn","StudsOffsetWorldSpace","UsePhysicsPacketCache","AllowTeamChangeOnTouch","AreContactIslandsShown","AreUnalignedPartsShown","BackgroundTransparency","DevCameraOcclusionMode","Is30FpsThrottleEnabled","IsFmodProfilingEnabled","IsUsingCameraYInverted","PhysicsAnalyzerEnabled","ReportAbuseChatHistory","TextStrokeTransparency","UseInstancePacketCache","VerticalScrollBarInset","AreScriptStartsReported","AutomaticScalingEnabled","ComparisonDiffThreshold","ComparisonPsnrThreshold","DevComputerMovementMode","ExtentsOffsetWorldSpace","IncommingReplicationLag","LoadCharacterAppearance","MaximumSimulationRadius","OnScreenKeyboardVisible","OnScreenProfilerEnabled","PerformanceStatsVisible","RenderCSGTrianglesDebug","RespectFilteringEnabled","ScrollWheelInputEnabled","TouchCameraMovementMode","AreAwakePartsHighlighted","AreJointCoordinatesShown","CoreGuiNavigationEnabled","CurrentScreenOrientation","CustomPhysicalProperties","FallenPartsDestroyHeight","GamepadCameraSensitivity","HorizontalScrollBarInset","LegacyInputEventsEnabled","MicroProfilerWebServerIP","OnScreenKeyboardPosition","PreferredPlayersInternal","PrintStreamInstanceQuota","ShowActiveAnimationAsset","TickCountPreciseOverride","ToolPunchThroughDistance","AdditionalCoreIncludeDirs","DestroyJointRadiusPercent","ForcePlayModeGameLocaleId","LocalTransparencyModifier","OverrideMouseIconBehavior","ShowDecompositionGeometry","VerticalScrollBarPosition","CanLoadCharacterAppearance","ComputerCameraMovementMode","DevTouchCameraMovementMode","MicroProfilerWebServerPort","ScrollBarImageTransparency","UsedCoreGuiIsVisibleToggle","ClickableWhenViewportHidden","ForcePlayModeRobloxLocaleId","IsScriptStackTracingEnabled","MotorMaxAngularAcceleration","MouseSensitivityFirstPerson","MouseSensitivityThirdPerson","ArePhysicsRejectionsReported","PhysicsEnvironmentalThrottle","UsedCustomGuiIsVisibleToggle","DevComputerCameraMovementMode","MicroProfilerWebServerEnabled","IsPhysicsEnvironmentalThrottled","IsUsingGamepadCameraSensitivity","RobloxForcePlayModeGameLocaleId","OnScreenKeyboardAnimationDuration","RobloxForcePlayModeRobloxLocaleId","TemporaryLegacyPhysicsSolverOverride"}
		,{
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
					local op = getmetatable(self.RobloxAPI).ObjectProperties
					if not op[Object.ClassName] then
						for i,property in next, self.RobloxAPI do
							if  pcall(function() return Object[property] and true end) then
								rawset(props,property,Object[property])
							end
						end
						op[Object.ClassName] = props
					else props = op[Object.ClassName] end
					return props
				end;
				getChildrenOfProperty = function(Object, Property, Value)
					local children = {}
					for i,child in next, Object:GetChildren() do
						if pcall(function() return child[Property] and true end) then
							if Value and child[Property] == Value then
								table.insert(children,child)
							end
						end
					end
					return children
				end;
				getDescendantsOfProperty = function(Object, Property, Value)
					local descendants = {}
					for i,desc in next, Object:GetDescendants() do
						if pcall(function() return desc[Property] and true end) then
							if Value and desc[Property] == Value then
								table.insert(descendants,desc)
							end
						end
					end
					return descendants
				end;
				setProperties = function(Object, Properties, dontIncludeShorts, dontIncludeCustom, includeDefault)
					local custom, api, default = self.Custom, self.RobloxAPI, self.Default
					if includeDefault then
						self.Default.toDefaultProperties(Object,type(includeDefault) == 'number' or nil)
					end
					for property, value in next, Properties do
						if not dontIncludeShorts then property = self.RobloxAPI:search(property) or property end
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
