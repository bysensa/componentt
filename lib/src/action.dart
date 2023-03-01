part of "../componentt.dart";

class ComponentAction<T extends Intent, R extends Object?>
    extends ContextAction<T> {
  final ActionHandlerFn<T, R> _handler;
  final ActionControl _control;

  // collection to store listeners of action. this collection need to correctly
  // add and remove listeners of control
  final Set<Object> _listeners = {};

  ComponentAction._(
    this._handler, {
    ActionControl? control,
  })  : assert(
          T != Never,
          "Wrong handler first parameter Type. Please ensure first parameter type extends Intent",
        ),
        _control = control ?? ActionControl._();

  Type get resultType => R;

  @override
  bool get isActionEnabled => _control.isActionEnabled;

  @override
  bool isEnabled(T intent) {
    return _control.isEnabled(intent);
  }

  @override
  bool consumesKey(T intent) {
    return _control.consumesKey(intent);
  }

  @override
  R invoke(T intent, [BuildContext? context]) => _handler(intent, context);

  // notify action listeners then control is changed
  void _controlListener() {
    notifyActionListeners();
  }

  @override
  void addActionListener(ActionListenerCallback listener) {
    // check there are  no listeners
    final shouldSubscribeOnControl = _listeners.isEmpty;
    // add listener to action
    super.addActionListener(listener);
    // store added listener internally
    _listeners.add(listener);
    // if there are no listeners before add than add listener to control
    if (shouldSubscribeOnControl) {
      _control.addIsEnabledListener(_controlListener);
      _control.addIsEnabledListener(_controlListener);
    }
  }

  @override
  void removeActionListener(ActionListenerCallback listener) {
    // remove listener from action
    super.removeActionListener(listener);
    // remove listener from internal collection
    _listeners.remove(listener);
    // if internal collection of listeners is empty then we can remove listener from control
    if (_listeners.isEmpty) {
      _control.removeIsEnabledListener(_controlListener);
      _control.removeIsConsumesKeyListener(_controlListener);
    }
  }
}
