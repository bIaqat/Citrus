# Citrus.Instance
## Creating Instances

#### .new ([string] Class Name | Custom Class Name, ...[Instance]Parent ...Custom Class Arguments ...[table]Properties)
	Creates an Instance from either Roblox classes or Citrus custom classes; hooks onto default properties
###### Examples
```lua
	new("Part", Workspace)
	new("CustomClass", Workspace, Color3.new(1,0,0))
	new("Part", {BrickColor = BrickColor.new'Really red'})
	new("CustomClass", Workspace, Color3.new(1,0,0), {Transparency = .4})
```

#### .newInstance ([string]Class Name, ...[Instance]Parent ...[table]Properties)
	Creates a classic Roblox Instance; hooks onto default properties
###### Examples
```lua
	newInstance("Part", Workspace)
	new("Part", {BrickColor = BrickColor.new'Really red'})
	new("CustomClass", Workspace, {BrickColor = BrickColor.new'Really red'})
```
