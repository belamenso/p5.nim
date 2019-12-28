import
  strutils, macros, jsffi

# TODO polymorphic numbers!

macro variables(T: typed, cs: typed): untyped =
  expectKind(cs, nnkStrLit)
  # expectKind(T, nnkSym)

  result = newStmtList()
  for c in split($cs, " "):
    let i = newIdentNode(c)
    result.add quote do:
      var `i`* {.importc,inject.}: `T`

macro constants(T: typed, cs: typed): untyped =
  # TODO
  quote do:
    variables(`T`, `cs`)

macro functionAllNumbers(declaration: typed): untyped =
  expectKind(declaration, nnkStrLit)

  let funName = ($declaration).split("(")[0].newIdentNode
  let args = ($declaration).split("(")[1].split(")")[0].split(",")

  proc makeParams(): NimNode =
    result = newTree(nnkIdentDefs)
    for a in args:
      result.add newIdentNode(a)
    result.add newIdentNode("Number") # TODO XXX?
    result.add newEmptyNode()

  newTree(nnkProcDef, 
          newTree(nnkPostfix,
                  newIdentNode("*"),
                  funName),
          newEmptyNode(),
          newEmptyNode(),
          newTree(nnkFormalParams,
                  newEmptyNode(),
                  makeParams()),
          newTree(nnkPragma,
                  newIdentNode("importc")),
          newEmptyNode(),
          newEmptyNode())

#################

type 
  Color* {.importc.} = ref object
  Graphics* {.importc.} = ref object
  Number = cint | cdouble # XXX ?

#################
## RENDERING
#################

constants(cstring, "WEBGL P2D")
constants(cstring, "BLEND DARKEST LIGHTEST DIFFERENCE MULTIPLY")
constants(cstring, "EXCLUSION SCREEN REPLACE OVERLAY HARD_LIGHT")
constants(cstring, "SOFT_LIGHT DODGE BURN ADD REMOVE SUBTRACT")

proc reset*(g: var Graphics) {.importcpp.}
proc remove*(g: var Graphics) {.importcpp.}

proc createCanvas*(x, y: cint) {.importc.}
proc createCanvas*(x, y: cint, renderer: cstring) {.importc.}
proc resizeCanvas*(w, h: cint) {.importc.}
proc resizeCanvas*(w, h: cint, noRedraw: bool) {.importc.}
proc noCanvas*() {.importc.}
proc createGraphics*(w, h: cint) {.importc.}
proc createGraphics*(w, h: cint, renderer: cstring) {.importc.}
proc blendMode*(mode: cstring) {.importc.}
proc setAttributes*(key: cstring, value: bool) {.importc.}
proc setAttributes*[T](obj: T) {.importc.} # XXX?

#################
## TRANSFORM
#################

functionAllNumbers("applyMatrix(a, b, c, d, e, f)")
proc resetMatrix*() {.importc.}
functionAllNumbers("rotate(angle)")
# TODO rotate(angle, vec[Number])
functionAllNumbers("rotateX(angle)")
functionAllNumbers("rotateY(angle)")
functionAllNumbers("rotateZ(angle)")
# TODO scale
functionAllNumbers("shearX(angle)")
functionAllNumbers("shearY(angle)")
functionAllNumbers("translate(x, y)")
functionAllNumbers("translate(x, y, z)")
# TODO translate(vector)

#################
## CONSTANTS
#################

constants(cdouble, "HALF_PI PI QUARTER_PI TAU TWO_PI")
constants(cstring, "DEGREES RADIANS")

#################
## EVENTS
#################

## Acceleration
constants(cstring, "LANDSCAPE PORTRAIT")
variables(cstring, "deviceOrientation")
variables(cint, "accelerationX accelerationY accelerationZ")
variables(cint, "paccelerationX paccelerationY paccelerationZ")
variables(cint, "rotationX rotationY rotationZ")
variables(cint, "protationX protationY protationZ")
variables(cstring, "turnAxis")
functionAllNumbers("setShakeThreshold(value)")
functionAllNumbers("setMoveThreshold(value)")

## Keyboard
variables(bool, "keyIsPressed")
variables(cint, "key keyCode")
functionAllNumbers("keyIsDown(code)")

## Mouse
variables(cint, "movedX movedY mouseX mouseY pmouseX pmouseY") # XXX are these really int?
variables(cint, "winMouseX winMouseY pwinMouseX pwinMouseY")
constants(cstring, "LEFT RIGHT CENTER")
variables(cstring, "mouseButton")
variables(bool, "mouseIsPressed")
proc requestPointerLock*() {.importc.}
proc exitPointerLock*() {.importc.}

# Touch
type
  TouchInfo {.importc.} = ref object
    x, y, winX, winY, id: cint
variables(seq[TouchInfo], "touches")

#################
## ENVIRONMENT
#################
variables(cint, "frameCount deltaTime")
variables(bool, "focused")
proc frameRate*(): cint {.importc.}
proc frameRate*(fps: cint) {.importc.}
proc noCursor*(): cint {.importc.}
variables(cint, "displayWidth displayHeight windowWidth windowHeight width height")
proc fullscreen*(): bool {.importc.}
proc fullscreen*(val: bool) {.importc.}
functionAllNumbers("pixelDensity(val)")
proc pixelDensity*(): cint {.importc.} # XXX cint?
proc displayDensity*(): cint {.importc.} # XXX cint?
proc getURL*(): cstring {.importc.}
proc getURLPath*(): seq[cstring] {.importc.}
# proc getURLParams*(): ref JsObject {.importc.} # TODO !
constants(cstring, "ARROW CROSS HAND MOVE TEXT WAIT")
proc cursor*(`type`: cstring) {.importc.}
proc cursor*(`type`: cstring, x: cint) {.importc.}
proc cursor*(`type`: cstring, x, y: cint) {.importc.}

#################
## STRUCTURE
#################

proc remove*() {.importc.}
variables(bool, "disableFriendlyErrors")
proc noLoop*() {.importc.}
proc loop*() {.importc.}
proc push*() {.importc.}
proc pop*() {.importc.}
proc redraw*() {.importc.}
proc redraw*(n: cint) {.importc.}

#################
## TYPOGRAPHY
#################

## Attributes
constants(cstring, "TOP BOTTOM BASELINE")
type TextAlignment* {.importc.} = ref object
  horizontal, vertical: cstring
proc textAlign*(): TextAlignment {.importc.}
proc textAlign*(horizAlign: cstring) {.importc.}
proc textAlign*(horizAlign, vertAlign: cstring) {.importc.}
proc textLeading*(): cint {.importc.}
proc textLeading*(leading: cint) {.importc.}
proc textSize*(): cint {.importc.}
proc textSize*(size: cint) {.importc.}
constants(cstring, "NORMAL ITALIC BOLD BOLDITALIC")
proc textStyle*(): cstring {.importc.}
proc textStyle*(style: cstring) {.importc.}
proc textWidth*(text: cstring): cdouble {.importc.}
proc textAscent*(): cint {.importc.}
proc textDescent*(): cint {.importc.}

## Loading & Displaying
# TODO returns p5.Font
proc loadFont*(path: cstring) {.importc.}
proc loadFont*(path: cstring, callback: proc():void) {.importc.}
proc loadFont*(path: cstring, callback: proc(), onError: proc()) {.importc.}
# TODO text
# TODO textFont
# TODO p5.Font

#####
## COLOR
#####

proc toString*(c: var Color) {.importcpp.}

proc color*(grayscale: cint): Color {.importc.}
proc color*(r, g, b: cint): Color {.importc.}

#####
## VARIOUS
#####

proc fill*(c: Color) {.importc.}
proc rect*(a,b,c,d: cint) {.importc.}
proc line*(a,b,c,d: cint) {.importc.}
proc stroke*(a,b,d: cint) {.importc.}
proc strokeWeight*(a: cint) {.importc.}

proc alert*(_: cdouble) {.importc.}
proc clear*() {.importc.}
proc text*(_:cstring, x,y:cint) {.importc.}


