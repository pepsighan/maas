// Internal variable to check the profile of the app.
var _debug = false;

/// Run this function before any other thing, to find out the debug status of 
/// the app.
void setupDebugStatus() {
  // In production builds `assert` is not going to run, hence _debug stays 
  // false.
  assert(() {
    _debug = true;
    return true;
  }());
}

/// Getter to find the debug profile of the app.
bool get isDebug {
  return _debug;
}
