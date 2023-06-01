part of "../componentt.dart";

/// Provide access to [ComponentStateMixin] using context
class _ComponentScope extends InheritedWidget {
  final ComponentStateMixin component;

  const _ComponentScope({
    Key? key,
    required Widget child,
    required this.component,
  }) : super(key: key, child: child);

  /// Returns nearest [_ComponentScope]
  static _ComponentScope _of(BuildContext context) {
    final _ComponentScope? result =
        context.dependOnInheritedWidgetOfExactType<_ComponentScope>();
    assert(result != null, 'No ComponentScope found in context');
    return result!;
  }

  /// Provide successor of [ComponentStateMixin] from [_ComponentScope] and downcast it to type [C]
  ///
  /// Throws [AssertionError] in debug if [component] is not implement [C]
  static C componentOf<C extends ComponentStateMixin>(BuildContext context) {
    final component = _of(context).component;
    assert(
      component is C,
      'ComponentState $C not present in current context. '
      'ComponentState ${component.runtimeType} available in current context',
    );
    return component as C;
  }

  @override
  bool updateShouldNotify(_ComponentScope old) {
    return component != old.component;
  }
}
