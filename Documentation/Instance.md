# Citrus.Instance
## Creating Instances

#### .new [Instance] ([string] Class Name | Custom Class Name, ...[Instance]Parent | ...Custom Class Arguments | ...[table]Properties)
	Creates an Instance from either Roblox classes or Citrus custom classes; hooks onto default properties
###### Examples
```lua
Citrus.Instance.new("Part", Workspace)
Citrus.Instance.new("CustomClass", Workspace, Color3.new(1,0,0))
Citrus.Instance.new("Part", {BrickColor = BrickColor.new'Really red'})
Citrus.Instance.new("CustomClass", Workspace, Color3.new(1,0,0), {Transparency = .4})
```

***

#### .newInstance [Instance] ([string]ClassName, ...[Instance]Parent | ...[table]Properties)
	Creates a classic Roblox Instance; hooks onto default properties
###### Examples
```lua
Citrus.Instance.newInstance("Part", Workspace)
Citrus.Instance.newInstance("Part", {BrickColor = BrickColor.new'Really red'})
Citrus.Instance.newInstance("CustomClass", Workspace, {BrickColor = BrickColor.new'Really red'})
```

*.newPure and .newPureInstance are same as .new and .newInstances except that it purposely avoids default properties*

***

#### .newObject [table] ([string]ClassName, ...[Instance]Parent | ...[table] Object Properties, Properties)
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
>>: [table]happy     Part     Hi     Really red
>>: true     Hi
>>: false     Bye
```

***

## Custom Classes

#### .newCustomClass ([string]Name, [function Instance]onCreated(...))
	Creates and Stores a new Custom Citrus Class
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
	return self --Always return the Instance
end)

Citrus.Instance.new("SparklyPart",workspace)
Citrus.Instance.new("SparklyPart",workspace,Color3.new(1,0,0))
```
![Red and Black Part](https://image.prntscr.com/image/wSLEQ2EIQGaIf-UoHUo-RQ.jpeg)

***

## Getters

#### .getObjectOf [table] ([Instance] Instance)
	Returns the Object Oriented Table of the Instance
###### Example
```lua
local a = Citrus.Instance.newObject("Part",workspace)
local b = Citrus.Instance.new("Part")

print(a,Citrus.Instance.getObjectOf(a),Citrus.Instance.getObjectOf(workspace.Part))
print(b,Citrus.Instance.getObjectOf(b))
```
```
>>: [table]a     [table]a     [table]a
>>: Part    nil
```

***

#### .getInstanceOf [Instance] ([Instance]Instance | [table]Custom Object)
	Returns the Instance of an Object Oriented Table
###### Example
```lua
local a = Citrus.Instance.newObject("Part",workspace)
local b = Citrus.Instance.new("Part")

print(a,Citrus.Instance.getInstanceOf(a),Citrus.Instance.getInstanceOf(workspace.Part))
print(b,Citrus.Instance.getInstanceOf(b))
```
```
>>: [table]a     Part     Part
>>: Part     Part
```

***

#### .getAncestors [table] ([Instance] Instance)
	Returns a table of an Instance's ancestory chain
###### Example
```lua
for i,v in pairs(Citrus.Instance.getAncestors( Instance.new("Part",workspace.Camera) )) do
	print(v)
end
```
```
>>: Camera
>>: Workspace
>>: Game
```

***

## Checkers

#### .isA [boolean] ([string]ClassName, [string]ClassName)
	Checks if both ClassNames are under the same hierarchy 
###### Example
```lua
print(Citrus.Instance.isA('Part','Instance'))
print(Citrus.Instance.isA('GuiButton','Part'))
```
```
>>: true
>>: false
```

***

#### .isAClass [boolean] ([string]ClassName)
	Checks if ClassName is a Roblox Class
###### Example
```lua
print(Citrus.Instance.isAClass("Instance"), Citrus.Instance.isAClass("Part"))
```
```
>>: false     true
```

***

#### .isAnObject [boolean] ([Instance]Instace | [table]Object)
	Checks if an Instance is an Object Oriented Instance table
###### Example
```lua
local a = Citrus.Instance.new("Part")
local b = Citrus.Instance.newObject("Part")

print(Citrus.Instance.isAnObject(a), Citrus.Instance.isAnObject(b))
```
```
>>: false     true
```

***

# getmetatable(Citrus.Instance) (Meta Storage)
* Classes
	`Stores Custom Classes`
* Objects
	`Stores Object Oriented Tables and their Instances`
