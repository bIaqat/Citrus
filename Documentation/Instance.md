# Citrus.Instance
## Creating Instances

#### .new ([string] Class Name | Custom Class Name, ...[Instance]Parent | ...Custom Class Arguments | ...[table]Properties)
	Creates an Instance from either Roblox classes or Citrus custom classes; hooks onto default properties
###### Examples
```lua
Citrus.Instance.new("Part", Workspace)
Citrus.Instance.new("CustomClass", Workspace, Color3.new(1,0,0))
Citrus.Instance.new("Part", {BrickColor = BrickColor.new'Really red'})
Citrus.Instance.new("CustomClass", Workspace, Color3.new(1,0,0), {Transparency = .4})
```

***

#### .newInstance ([string]ClassName, ...[Instance]Parent | ...[table]Properties)
	Creates a classic Roblox Instance; hooks onto default properties
###### Examples
```lua
Citrus.Instance.newInstance("Part", Workspace)
Citrus.Instance.newInstance("Part", {BrickColor = BrickColor.new'Really red'})
Citrus.Instance.newInstance("CustomClass", Workspace, {BrickColor = BrickColor.new'Really red'})
```

*.newPure and .newPureInstance are same as .new and .newInstances except that it purposely avoids default properties*

***

#### .newObject ([string]ClassName, ...[Instance]Parent | ...[table] Object Properties, Properties)
	Creates a classic Roblox Instance that is methodized to work with Object Oriented Programming
###### Example
```lua
local happy = Citrus.Instance.newObject("Part", Workspace, {ImHappy = "Hi"}, {BrickColor = BrickColor.new'Really red'})
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

## Custom Classes

#### .newCustomClass ([string]Name, [function Instance]onCreated(...))
	Creates a Citrus custom class
###### Example
```lua
Citrus.Instance.newCustomClass("SparklyPart",function(color)
	local self = Instance.new("Part")
	self.Name = "SparklyPart"
	self.Material = Enum.Material.Neon
	self.Color = color or Color3.new(0,0,0)
	self.Transparency = .3
	local spark = Instance.new("Sparkles",self)
	spark.SparkleColor = color or Color3.new(0,0,0)
	return self
end)

Citrus.Instance.new("SparklyPart",workspace)
Citrus.Instance.new("SparklyPart",workspace,Color3.new(1,0,0))
```
![Red and Black Part](https://image.prntscr.com/image/wSLEQ2EIQGaIf-UoHUo-RQ.jpeg)
