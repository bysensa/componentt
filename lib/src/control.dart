part of "../componentt.dart";

/// Type definition of predicate for [ComponentAction]<T>
typedef IntentPredicate<T extends Intent> = bool Function(T);

class ActionControl<T extends Intent> {
  final _Flag _isEnabled;
  final _Flag _isConsumesKey;

  Type get intentType => T;

  IntentPredicate<T>? _enabledPredicate;

  set enabledPredicate(IntentPredicate<T>? newPredicate) {
    _enabledPredicate = newPredicate;
  }

  IntentPredicate<T>? _consumesKeyPredicate;

  set consumesKeyPredicate(IntentPredicate<T>? newPredicate) {
    _consumesKeyPredicate = newPredicate;
  }

  ActionControl._({
    bool isEnabled = true,
    bool isConsumesKey = true,
  })  : _isEnabled = _Flag(isEnabled),
        _isConsumesKey = _Flag(isConsumesKey);

  @visibleForTesting
  bool get hasIsEnabledListeners => _isEnabled.isListening;

  @visibleForTesting
  bool get hasIsConsumesKeyListeners => _isConsumesKey.isListening;

  void addIsEnabledListener(VoidCallback listener) {
    _isEnabled.addListener(listener);
  }

  void removeIsEnabledListener(VoidCallback listener) {
    _isEnabled.removeListener(listener);
  }

  void addIsConsumesKeyListener(VoidCallback listener) {
    _isConsumesKey.addListener(listener);
  }

  void removeIsConsumesKeyListener(VoidCallback listener) {
    _isConsumesKey.removeListener(listener);
  }

  set isActionEnabled(bool newValue) {
    _isEnabled.value = newValue;
  }

  bool get isActionEnabled {
    return _isEnabled.value;
  }

  void toggleEnabled() {
    _isEnabled.value = !_isEnabled.value;
  }

  bool get isConsumesKey {
    return _isConsumesKey.value;
  }

  set isConsumesKey(bool newValue) {
    _isConsumesKey.value = newValue;
  }

  void toggleConsumesKey() {
    _isConsumesKey.value = !_isConsumesKey.value;
  }

  bool isEnabled(T intent) {
    if (_enabledPredicate == null) {
      return isActionEnabled;
    }
    return isActionEnabled && _enabledPredicate!(intent);
  }

  bool consumesKey(T intent) {
    if (_consumesKeyPredicate == null) {
      return isConsumesKey;
    }
    return isConsumesKey && _consumesKeyPredicate!(intent);
  }

  void dispose() {
    _isEnabled.dispose();
    _isConsumesKey.dispose();
  }
}

class _Flag = ValueNotifier<bool> with _FlagMixin;

mixin _FlagMixin on ValueNotifier<bool> {
  bool get isListening => hasListeners;
}
