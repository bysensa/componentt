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

  /// Provide successor of [ComponentStateMixin] from [_ComponentScope] and downcast it to type [C]
  ///
  /// Throws [AssertionError] in debug if [component] is not implement [C]
  static C read<C extends Object>(BuildContext context) {
    InheritedElement? maybeTarget =
        context.getElementForInheritedWidgetOfExactType<_ComponentScope>();
    while (maybeTarget != null) {
      final maybeTargetScope = maybeTarget.widget as _ComponentScope;
      final component = maybeTargetScope.component;
      if (component is C) {
        return component as C;
      }

      // получаем следующий элемент виджета _ComponentScope используя context текущего ComponentState.
      // если использовать для этого текущий maybeTarget то мы попадем в цикл
      maybeTarget =
          component.context.getElementForInheritedWidgetOfExactType<_ComponentScope>();
    }

    throw StateError('No ComponentState of type $C in current context');
  }

  /// Provide successor of [ComponentStateMixin] from [_ComponentScope] and downcast it to type [C]
  ///
  /// Throws [AssertionError] in debug if [component] is not implement [C]
  static C listen<C extends Object>(BuildContext context) {
    InheritedElement? maybeTarget =
        context.getElementForInheritedWidgetOfExactType<_ComponentScope>();
    while (maybeTarget != null) {
      final maybeTargetScope = maybeTarget.widget as _ComponentScope;
      final component = maybeTargetScope.component;
      if (component is C) {
        context.dependOnInheritedElement(maybeTarget);
        return component as C;
      }

      // получаем следующий элемент виджета _ComponentScope используя context текущего ComponentState.
      // если использовать для этого текущий maybeTarget то мы попадем в цикл
      maybeTarget =
          component.context.getElementForInheritedWidgetOfExactType<_ComponentScope>();
    }

    throw StateError('No ComponentState of type $C in current context');
  }

  @override
  bool updateShouldNotify(_ComponentScope old) {
    final isChanged = component != old.component;
    if (isChanged) {
      Zone.current.handleUncaughtError(
        StateError('Component of type $component changed'),
        StackTrace.current,
      );
    }
    return isChanged;
  }
}
