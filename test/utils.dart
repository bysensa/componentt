class CallCount {
  var _count = 0;
  int get count => _count;

  void reset() {
    _count = 0;
  }

  void call() {
    _count += 1;
  }
}
