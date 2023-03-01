part of "../componentt.dart";

/// Type definition of [Action] invoke handler
typedef ActionHandlerFn<T extends Intent, R extends Object?> = R
    Function(T intent, [BuildContext? context]);

final _actionStore = Expando();

extension ActionHandlerFnExt<T extends Intent, R extends Object?>
    on ActionHandlerFn<T, R> {
  @visibleForTesting
  ComponentAction<T, R>? get action => _storedAction;

  Type get intentType => T;

  ComponentAction<T, R> toAction() {
    var action = _storedAction;
    if (action == null) {
      action = ComponentAction<T, R>(
        this,
        enabledPredicate: null,
        consumesKeyPredicate: null,
      );

      _storedAction = action;
    }
    return action;
  }

  ComponentAction<T, R>? get _storedAction {
    print('get: this.hashcode = ${this.hashCode}');
    return _actionStore[this] as ComponentAction<T, R>?;
  }

  set _storedAction(ComponentAction<T, R>? newValue) {
    print('set: this.hashcode = ${this.hashCode}');
    _actionStore[this] = newValue;
  }
}
