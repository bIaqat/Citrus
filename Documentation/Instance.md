# Citrus.Instance
## Creating Instances

#### .new ([string] Class Name | Custom Class Name, ...[Instance]Parent | ...Custom Class Arguments | ...[table]Properties)
	Creates an Instance from either Roblox classes or Citrus custom classes; hooks onto default properties
###### Examples
```lua
	new("Part", Workspace)
	new("CustomClass", Workspace, Color3.new(1,0,0))
	new("Part", {BrickColor = BrickColor.new'Really red'})
	new("CustomClass", Workspace, Color3.new(1,0,0), {Transparency = .4})
```

***

#### .newInstance ([string]ClassName, ...[Instance]Parent | ...[table]Properties)
	Creates a classic Roblox Instance; hooks onto default properties
###### Examples
```lua
	newInstance("Part", Workspace)
	new("Part", {BrickColor = BrickColor.new'Really red'})
	new("CustomClass", Workspace, {BrickColor = BrickColor.new'Really red'})
```

***

#### .newObject ([string]ClassName, ...[Instance]Parent | ...[table] Object Properties, Properties)
	Creates a classic Roblox Instance that is methodized to work with Object Oriented Programming
###### Example
```lua
	local happy = newObject("Part", Workspace, {ImHappy = "Hi"}, {BrickColor = BrickColor.new'Really red'})
	print(happy, happy.Name, happy.ImHappy, happy.BrickColor)

	happy:Index('isHappy',function(self) return self.ImHappy == 'Hi' and true or false end)
	happy:NewIndex('isHappy',function(self,new)
		if new == true then
			self.ImHappy = "Hi"
		else
			self.ImHappy = "Bye"
		end
	end)

	happy:Index('Says',function(self) return self.ImHappy end)

	print(happy.isHappy, happy.Says)
	happy.isHappy = false
	print(happy.isHappy, happy.Says)
```
```
	>>: table     Part     Hi     Really red
	>>: true     Hi
	>>: false     Bye
```

***

