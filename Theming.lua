Theming = setmetatable({ --based on sync tables and magiik's theming
		--new, get, set, to, from, typeOf, lerp,call,setFilter, setValues,insertObject
		new = function(name,...)
			local filter, funct, args, vals
			local new = setmetatable({
				Values {};
				Funct = {};
				Filter = {};
				Objects = {};
			},{
					__index = function(self,obj)
						local checked = nil
						local done = {}
						local 
						for class,val in next,self.Filter do
							if obj:IsA(class) then
								checked = true
								if type(val) ~= 'boolean' then
									for i,v in next,self.Values do
										if typeof(v) == typeof(obj[val]) and not Pineapple.Misc.Table.find(done,v) then
											obj[val] = v
											table.insert(done,v)
										end
									end
								end
							end
						end
										
										
						
			local vals = {...}
			if type(vals[1]) == 'table' then
				filter = vals[1]
				table.remove(vals,1)
			end
			
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
