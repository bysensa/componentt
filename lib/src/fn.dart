part of "../componentt.dart";

/// Type definition of [Action] invoke handler
typedef ActionHandlerFn<T extends Intent, R extends Object?> = R
    Function(T intent, [BuildContext? context]);

extension ActionHandlerFnExt<T extends Intent, R extends Object?>
    on ActionHandlerFn<T, R> {
  /// Return [Type] of handler intent
  Type get intentType => T;

  /// Return [ComponentAction]<T,R> with this function as invoke handler
  ComponentAction<T, R> action([ActionControl<T>? control]) {
    return ComponentAction<T, R>._(this, control: control);
  }

  ActionControl<T> control({
    bool isEnabled = true,
    bool isConsumesKey = true,
  }) {
    return ActionControl<T>._(
      isConsumesKey: isConsumesKey,
      isEnabled: isEnabled,
    );
  }
}
