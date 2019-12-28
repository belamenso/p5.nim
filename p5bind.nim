import
  strutils, macros

macro stringConstants(cs: typed): untyped =
  result = newStmtList()
  for c in split($cs, " "):
    let i = newIdentNode(c)
    result.add quote do:
      var `i`* {.importc,inject.}: cstring

macro functionAllNumbers(declaration: typed): untyped =
  expectKind(declaration, nnkStrLit)
  let funName = ($declaration).split("(")[0].newIdentNode
  let args = ($declaration).split("(")[1].split(")")[0].split(",")

  proc makeParams(): NimNode =
    result = newTree(nnkIdentDefs)
    for a in args:
      result.add newIdentNode(a)
    result.add newIdentNode("Number")
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
  Number = cint | cfloat # XXX ?

#################
## RENDERING
#################

stringConstants("WEBGL P2D")
stringConstants("BLEND DARKEST LIGHTEST DIFFERENCE MULTIPLY")
stringConstants("EXCLUSION SCREEN REPLACE OVERLAY HARD_LIGHT")
stringConstants("SOFT_LIGHT DODGE BURN ADD REMOVE SUBTRACT")

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

