Objects = setmetatable({
	getAncenstors = function(Object)
		local directory = {game};
		local ind = game
		for name in Object:GetFullName():gsub('%.','\0'):gmatch('%Z+') do
			local temp = ind[name]
			if not name == 'game' and temp:IsAncestorOf(Object) then
				ind = temp
				table.insert(directory,ind)
			end
		end
		return directory
	end;
	Classes = setmetatable({},{
		__index = function(self,index)
			for i,v in next, {
				new = function(ClassName, onCreated)
					self[ClassName] = {onCreated = onCreated, Objects = {}}
				end;
				isA = function(Object, ClassName)
					return Object:IsA(ClassName) or self.ClassName.Objects[Object] or false
				end;
			} do
				local self = getmetatable(self)
				self.__index = {}
				self.__index[i] = v
				if i == index then
					return v
				end
			end
		end		
	});
	Customs = setmetatable({},{
		__index = function(self,index)
			for i,v in next, {
				getCustomFromInstance = function(Object)
					return self[Object] or typeof(Object) == 'userdata' and Object or false
				end;
				cloneCustom = function(Object, Parent, Props)
					local ins = Object.Instance:Clone()
					ins.Parent = Parent
					local clone = Spice.Table.clone(Object)
					clone.Instance = ins
					Spice.Properties.setProperties(clone.Instance, Props and Props or {})
					rawset(self,clone.Instance,clone)
					return clone					
				end;
				isCustom = function(Object)
					return self[Object] and true or false
				end;
				new = function(ClassName, Parent, Props, CustomProps)
					local instance = type(ClassName) ~= 'string' and ClassName or Instance.new(ClassName)
					local object = newproxy(true)
					local objectMeta
					objectMeta = {
						Instance = instance, Object = CustomProps or {}, Index = {}, NewIndex = {};
						__index = function(proxy,ind)
							local objmeta = getmetatable(proxy)
							if ind == 'Instance' or ind == 'Object' then return objmeta[ind] end
							if objmeta.Index[ind] then
								local ret = objmeta.Index[ind]
								return type(ret) ~= 'function' and ret or ret(proxy)
							elseif objmeta.Object[ind] or not pcall(function() return objmeta.Instance[ind] or false end) then
								return objmeta.Object[ind]
							elseif objmeta.Instance[ind] then
								return objmeta.Instance[ind]
							end
						end;	
						__newindex = function(proxy,ind,new)
							local objmeta = getmetatable(proxy)
							if objmeta.NewIndex[ind] then
								objmeta.NewIndex[ind](objmeta,new)
							elseif objmeta.Object[ind] or not pcall(function() return objmeta.Instance[ind] or false end) or type(new) == 'function' then
								rawset(objmeta.Object,ind,new)
							elseif pcall(function() return objmeta.Instance[ind] or false end) then
								objmeta.Instance[ind] = new
							end
						end;
						__call = function(objmeta,prop)
							local objmeta = getmetatable(objmeta)
							Spice.Properties.setProperties(objmeta.Instance,prop)
						end;
						__namecall = function(proxy, ...)
							local args = {...}
							local name = args[#args]
							table.remove(args,#args)
							local objmeta = getmetatable(proxy)
							local default = {
								Index = function(name,what)
									rawset(objmeta.Index,name,what)
								end;
								NewIndex = function(name,what)
									if type(what) == 'function' then
										rawset(objmeta.NewIndex,name,what)
									end
								end;
								Clone = function(parent,prop)
									return self.cloneCustom(proxy,parent,prop)
								end;
							}
							if default[name] then return default[name](unpack(args)) end
							if objmeta.Instance[name] and type(objmeta.Instance[name]) == 'function' then
								return objmeta.Instance[name](objmeta.Instance,unpack(args))
							end
						end;	
					}
					setmetatable(object,objectMeta)
					rawset(self,instance,object)
					object(Props)
					return object					
				end;
			} do
				local self = getmetatable(self)
				self.__index = {}
				self.__index[i] = v
				if i == index then
					return v
				end
			end
		end		
	});
},{
	__index = function(self,index)	
			for i,v in next, {
				newBasic = function(ClassName, Parent, ...) --faster
					local args, instance, props = {...}
					instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
					instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
					if type(args[#args]) == 'table' then
						props = args[#args]
						args[#args] = nil
					end
					Spice.Properties.setProperties(instance, props)
					return instance
				end;
				newInstance = function(ClassName, Parent, Props)
					local instance = Instance.new(ClassName, Parent)
					for i,v in next, Props do
						if not pcall(function() return instance[i] and true or false end) then
							Spice.Properties.setProperties(ClassName,Props)
						else
							instance[i] = v
							Props[i] = nil
						end
					end
					return instance
				end;
				new = function(ClassName, Parent, ...)
					local args, instance, props = {...}
					instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
					instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
					if type(args[#args]) == 'table' then
						props = args[#args]
						args[#args] = nil
					end	
					Spice.Propeties.Defaualt.toDefaultProperties(instance)			
					Spice.Properties.setProperties(instance, props)
					return instance					
				end;
				clone = function(Object, Parent, Props)
					local clone = Object:Clone()
					clone.Parent = Parent
					Spice.Properties.setProperties(Object,Props)
					return clone
				end;
			} do
				local self = getmetatable(self)
				self.__index = {}
				self.__index[i] = v
				if i == index then
					return v
				end
			end
		end		
});