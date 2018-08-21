local Audio, Color, Effects, Imagery, Misc, Motion, Objects, Positioning, Properties, Table, Theming =  Spice.Audio, Spice.Color, Spice.Effects, Spice.Imagery, Spice.Misc, Spice.Motion, Spice.Objects, Spice.Positioning, Spice.Properties, Spice.Table, Spice.Theming

newAudio, getAudio, getSound = Audio.new, Audio.get, Audio.getSound
getAudioEvents, connectAudio, disconnectAudio = Audio.getAudioConnections, Audio.connect, Audio.disconnect
playAudio = Audio.play
rgb, hsv, hex, cstr, cinv = Color.fromRGB, Color.fromHSV, Color.fromString, Color.toInverse
newColor, getColorSet = Color.Colors.new, Color.Colors.get
getColor, removeColor = Color.fromStored, Color.Colors.remove
newEffect, getEffect, affect = Effects.new, Effects.get, Effects.affect
affectc, affectd, affectca, affectda = Effects.affectChildren, Effects.affectDescendants, Effects.affectOnChildAdded, Effects.affectOnDescendantAdded
affecta, massaffect, affecte = Effects.affectAncestors, Effects.massAffect, Effects.affectOnEvent
newImage, getImage, getImageSet, newImages = Imagery.new, Imagery.get, Imagery.getImage, Imagery.newFromSheet
createImage, playImages, stopImages = Imagery.newInstance, Imagery.playGif, Imagery.stopGif
setImage = Imagery.setImage	
newEasingStyle, newEasingDirection = Motion.Easings.newStyle, Motion.Easings.newDirection
getEasingStyle, getEasingDirection = Motion.Easings.getStyle, Motion.Easings.getDirection
fromBezier = Motion.Easings.fromBezier
ctween, tween, lerp = Motion.customTween, Motion.tweenServiceTween, Motion.lerp
cancelTween, rotate = Motion.cancelTween, Motion.rotate
getAncestors, newClass, isA = Objects.getAncestors, Objects.Classes.new, Objects.isA
getObject, isCustom, newCustom = Objects.Custom.getCustomFromInstance, Objects.Custom.isCustom, Objects.Custom.new
create, create2, create3 = Objects.new, Objects.Custom.new, Objects.newInstance
createD, clone = Objects.newDefault, Objects.clone
ud, um, v2, up = Positioning.new, Positioning.fromUDim, Positioning.fromVector2, Positioning.fromPosition
search = Table.search

