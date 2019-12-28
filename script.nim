import p5bind

proc setup {.exportc.} =
  createCanvas(500, 500)
  let c = color(255,204,0)
  blendMode(DARKEST)
  fill(c)

proc draw {.exportc.} =
  blendMode(DARKEST)
  rotate(QUARTER_PI)
  strokeWeight(30);
  stroke(80, 150, 255);
  line(25, 25, 75, 75);
  stroke(255, 50, 50);
  line(75, 25, 25, 75);

proc deviceTurned {.exportc.} =
  alert(turnAxis)

