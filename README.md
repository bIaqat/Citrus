# Citrus.Instance
## Creation Features
***
###### .new ([string] Class Name | Custom Class Name, ...[Instance]Parent ...Custom Class Arguments ...[table]Properties)
	Creates an Instance from either Roblox classes or Citrus custom classes

#####Examples
	new("Part", Workspace)
	new("CustomClass", Workspace, Color3.new(1,0,0))
	new("Part", {BrickColor = BrickColor.new'Really red'})
	new("CustomClass", Workspace, Color3.new(1,0,0), {Transparency = .4})
