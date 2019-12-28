# p5.js Nim bindings (work in progress)

Compile with

```bash
nim js script.nim
python -m http.server
```

## TODO
* fix polymorphism
* bindings for undocumented `LEFT_ARROW` and such
* document hooks
* more general js binding framework
* `noDecl` pragma
* `getURLParams()`
* `p5.Font`

## Notes
* `print` will not be implemented, use Nim's `echo`

