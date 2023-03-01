part of "../componentt.dart";

class ActionControl {
  final ValueNotifier<bool> _isEnabled = ValueNotifier(true);
  final ValueNotifier<bool> _isConsumesKey = ValueNotifier(true);

  set isActionEnabled(bool newValue) {
    _isEnabled.value = newValue;
  }

  bool get isActionEnabled {
    return _isEnabled.value;
  }

  void toggleEnabled() {
    final action = _storedAction;
    _storedAction?.toggleEnabled();
  }

  bool get isConsumesKey => _storedAction?.isConsumesKey ?? false;

  set isConsumesKey(bool newValue) => _storedAction?.isConsumesKey = newValue;

  void toggleConsumesKey() => _storedAction?.toggleConsumesKey();

  void notify() => _storedAction?.notify();
}
