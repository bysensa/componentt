part of "../componentt.dart";

abstract class Component<T extends StatefulWidget> = State<T>
    with ComponentMixin<T>;

mixin ComponentMixin<T extends StatefulWidget> on State<T> {
  ActionDispatcher get actionDispatcher => const ActionDispatcher();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    assert(
      false,
      'The setState method must not be used in class which extends Component or mix ComponentMixin. '
      'Please use other primitives for this purpose like'
      'ChangeNotifier, ValueNotifier or Stream',
    );
    super.setState(fn);
  }

  /// Provides [ComponentAction]'s and this successor of [ComponentMixin] through [BuildContext]
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
