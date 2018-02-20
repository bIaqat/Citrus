Theming = setmetatable({ --almost 100% positive this is 100% BROKEN
		new = function(name,...)
			local args, filter, funct, vals = {}
			local vals = {...}
			if type(vals[1]) == 'table' then
				filter = vals[1]
				table.remove(vals,1)
			end
			for i,v in next,vals do
				if type(v) == 'function' then
					funct = v
					for x = i+1,#vals do
						table.insert(args,vals[x])
						table.remove(vals,x)
					end
					table.remove(vals,i)
					break
				end
			end
			local newTheme = setmetatable({
					Sync = function(self,...)
						Pineapple.Theming.syncTheme(name,...)
					end;
					Set = function(self,...)
						Pineapple.Theming.setTheme(name,...)
					end;
					Call = function(self,...)
						Pineapple.Theming.callTheme(name,...)
					end;
					Insert = function(self,...)
						Pineapple.Theming.insertObjects(name,...)
					end;
					Values = vals or {};
					Funct = setmetatable({funct or nil,unpack(args)},{
								__call = function(self,...)
									for i,v in pairs(newTheme.Objects)do
										if ... then
											self[1](v,...)
										else
											self[1](v,unpack(Pineapple.Misc.Table.wrap(self,2)))
										end
									end
								end});
					Filter = filter or {};
					Objects = {};
			},{
					__call = function(self,obj,filv)
						local hasClass
						local checks
						local used = {}
						--first checks to make sure its eligible to be used
						for i,v in pairs(self.Filter)do
							if Pineapple.Instance.isAClass(v) or Pineapple.Instance.isAClass(i) then
								if obj:IsA(v) or obj:IsA(i) then
									checks = true
								end
								hasClass = true
							end	
							if Pineapple.Instance.isAClass(i) and type(v) ~= 'boolean' then
								for _,val in pairs(filv or self.Values)do
									if type(val) == type(obj[v]) and not Pineapple.Misc.Table.find(used,v) then
										obj[v] = val
									end
									table.insert(used,val)
								end
							end
						end
						if not hasClass or checks then
							for _,prop in next,self.Filter do
								for _,val in next,filv or self.Values do
									if Pineapple.Properties.hasProperty(obj,prop) and typeof(val) == typeof(obj[prop]) and not Pineapple.Misc.Table.find(used,v) then
										obj[prop] = val
										table.insert(used,val)
									end
								end
							end
						end
						if Pineapple.Misc.Table.length(self.Filter) == 0 then
							for _,val in next,filv or self.Values do
								for i,prop in next,Pineapple.Properties.getProperties(obj)do
									if typeof(obj[prop]) == typeof(val) then
										obj[prop] = val
									end
								end
							end
						end
					end;
				}
			)	
			getmetatable(Pineapple.Theming).Themes[name] = newTheme
			return newTheme
		end;
		getTheme = function(name)
			return Pineapple.Misc.Table.find(getmetatable(Pineapple.Theming).Themes,name)
		end;
		insertObjects = function(name,...)
			local theme = Pineapple.Theming.getTheme(name)
			for in,ob in next,{...} or {} do
				if Pineapple.Instance.isAClass(in) then
					theme.Objects[in] = ob
					theme(in,ob)
				else
					table.insert(theme.Objects,ob)
					theme(ob)
				end
			end
		end;
		callTheme = function(name,...)
			return Pineapple.Theming.getTheme(name).Funct(...)
		end;
		setTheme = function(name,...)
			local used = {}
			local theme = Pineapple.Theming.getTheme(name)
			local vals = theme.Values
			for index,val in next, vals do
				for _,new in next,{...} do
					if typeof(val) == typeof(new) and not Pineapple.Misc.Table.find(used,new) then
						vals[index] = new
						table.insert(used,new)
					end
				end
			end
			theme:Sync()
		end;
		syncTheme = function(name)
			local theme = Pineapple.Themes.getTheme(name)
			for i,v in next,self.Objects do
				if Pineapple.Instance.isAClass(v) then
					theme(v)
				elseif type(v) == 'number'
					local sametype = {}
					local choices = {}
					for _,val in next, theme.Values do
						if not sametype[type(val)] then
							sametype[type(val)] = {}
						end
						table.insert(sametype[type(val)],val)
					end
					for _,fil in next,sametype do
						table.insert(choices,sametype[v])
					end
					theme(v,choices)			
				end
			end;
		end;
				
	
			
	},{
		Themes = {};
	}
)

-- PLAY GROUND
local f = Instance.new("Frame")
--[[
Theme.new (
	arg 1: String Name
	arg 2: Table {String ClassName | String Property | Table [Index String ClassName, Value String Properties] }
	args... anything but Table; one function
]]

Theme.new("Primary",{'Name','Text','TextBox',Frame = {'call','Color3'}},'Hello',Color3.new(1,0,0),'GoodBye',rotate,8,3,3)

--[[
Primary = {
	Values = {'Hello', Color3.new(1,0,0),'Goodbye'}
	Function = {rotate, 8,3,3}
	Filter = {TextBox = true, Frame = {'Color3'}, "Name", "Text"}
	Objects = {}
]]


Theme.insert(Frame,"Primary",2)
--Makes the frame's Color Red
Theme.insert(Frame,"Primary",1)
--Makes the frame's Color Red,  Name 'Hello'
Theme.insert(TextBox,"Primary")
--Makes the TextBox's Name 'Hello, Text 'Goodbye'
Theme.insert(TextLabel,"Primary",1)
--Nothing

Theme.call("Primary") 
--rotates all the frames
Theme.setFilter({Frame = 'Color3'})
