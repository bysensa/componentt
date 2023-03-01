part of "../componentt.dart";

/// Type definition of predicate for [ComponentAction]<T>
typedef ComponentActionPredicate<T extends Intent> = bool Function(T);

class ComponentAction<T extends Intent, R extends Object?>
    extends ContextAction<T> {
  final ActionHandlerFn<T, R> _handler;
  final ComponentActionPredicate<T>? _enabledPredicate;
  final ComponentActionPredicate<T>? _consumesKeyPredicate;
  bool _enabled = true;
  bool _consumesKey = true;

  ComponentAction(
    this._handler, {
    ComponentActionPredicate<T>? enabledPredicate,
    ComponentActionPredicate<T>? consumesKeyPredicate,
  })  : assert(
          T != Never,
          "Wrong handler first parameter Type. Please ensure first parameter type extends Intent",
        ),
        _enabledPredicate = enabledPredicate,
        _consumesKeyPredicate = consumesKeyPredicate;

  Type get resultType => R;

  @override
  bool get isActionEnabled => _enabled;

  set isActionEnabled(bool newValue) {
    final shouldNotify = _enabled != newValue;
    _enabled = newValue;
    if (shouldNotify) {
      notifyActionListeners();
    }
  }

  void toggleEnabled() {
    _enabled = !_enabled;
    notifyActionListeners();
  }

  @override
  bool isEnabled(T intent) {
    if (_enabledPredicate == null) {
      return _enabled;
    }
    return _enabled && _enabledPredicate!(intent);
  }

  bool get isConsumesKey => _consumesKey;

  set isConsumesKey(bool newValue) {
    final shouldNotify = _consumesKey != newValue;
    _consumesKey = newValue;
    if (shouldNotify) {
      notifyActionListeners();
    }
  }

  void toggleConsumesKey() {
    _consumesKey = !_consumesKey;
    notifyActionListeners();
  }

  @override
  bool consumesKey(T intent) {
    if (_consumesKeyPredicate == null) {
      return _consumesKey;
    }
    return _consumesKey && _consumesKeyPredicate!(intent);
  }

  @override
  R invoke(T intent, [BuildContext? context]) => _handler(intent, context);

  void notify() {
    notifyActionListeners();
  }
}
