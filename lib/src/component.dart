part of "../componentt.dart";

abstract class ComponentWidget extends StatefulWidget {
  const ComponentWidget({Key? key}) : super(key: key);

  @override
  StatefulElement createElement() => ComponentWidgetElement(this);

  @override
  ComponentStateMixin createState();
}

abstract class ComponentState<T extends StatefulWidget> = State<T>
    with ComponentStateMixin<T>;

mixin ComponentStateMixin<T extends StatefulWidget> on State<T> {
  ActionDispatcher get actionDispatcher => const ActionDispatcher();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    assert(
      false,
      'The setState method must not be used in class which extends ComponentState or mix ComponentStateMixin. '
      'Please use other primitives for this purpose like'
      'ChangeNotifier, ValueNotifier or Stream',
    );
    super.setState(fn);
  }

  /// Provide [Action]s available for for invocation in childrens of child widget
  Set<Action> get actions => {};

  /// Provides [ComponentAction]'s and this successor of [ComponentStateMixin] through [BuildContext]
  Widget withActions({
    required Widget child,
    Key? key,
    Set<Action> actions = const {},
  }) {
    final resolvedActions = {
      for (final action in actions) action.intentType: action
    };
    return _ComponentScope(
      component: this,
      child: Actions(
        key: key,
        actions: resolvedActions,
        dispatcher: actionDispatcher,
        child: child,
      ),
    );
  }
}

/// Element of [ComponentWidget] used to embed widget created by [State.build] method
/// in component related widget tree
class ComponentWidgetElement extends StatefulElement {
  ComponentWidgetElement(ComponentWidget widget) : super(widget);

  @override
  Widget build() {
    // check that State is descendant of ComponentStateMixin
    assert(
      state is ComponentStateMixin,
      'Invalid component declaration. '
      'State should mix ComponentStateMixin or extend ComponentState',
    );
    // cast state to ComponentStateMixin
    final cmp = state as ComponentStateMixin;
    // build component
    Widget widget = super.build();
    // checking the built widget. If widget is _ComponentScope this mean it created using
    // withActions method and we can return this widget as result.
    if (widget is _ComponentScope) {
      return widget;
    }
    // get actions provided by ComponentStateMixin
    final actions = cmp.actions;
    // create final widget
    return cmp.withActions(
      actions: actions,
      child: widget,
    );
  }
}
