This library provides a set of classes and methods to simplify the 
usage of widgets with the Intent and Action classes.

## Getting Started

Let's imagine that you have a StatefulWidget

```dart
class SampleWidget extends StatefulWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class _SampleWidgetState extends State<SampleWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

And you want to implement the processing of user actions through the Intent 
and Action mechanism, while leaving the implementation of the intent 
processing logic in the same place where the widget state is declared. Since 
the implementation of this mechanism in the standard Flutter library 
provides only basic primitives, the only way that can be used is 
CallbackAction. And even in this case, the final implementation remains 
quite rough. This library provides a set of methods and primitives to 
simplify the use of Intent and Action in an application. 

The first thing to do is to add library import and replace inheritance from 
State with inheritance from ComponentState 

```dart
import 'package:componentt/componentt.dart';

class SampleWidget extends StatefulWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class _SampleWidgetState extends ComponentState<SampleWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

After that, you can declare the Intent that you want to handle

```dart
import 'package:componentt/componentt.dart';

class SampleWidget extends StatefulWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class IncrementIntent extends Intent {}

class _SampleWidgetState extends ComponentState<SampleWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

To process Intent, you need a handler. It can be declared as a method of the 
widget state class. Let's declare it and add a variable that we will change 
when the handler is called.  

```dart
import 'package:componentt/componentt.dart';

class SampleWidget extends StatefulWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class IncrementIntent extends Intent {}

class _SampleWidgetState extends ComponentState<SampleWidget> {
  late final ValueNotifier<int> _count;

  @override
  void initState() {
    super.initState();
    _count = ValueNotifier(0);
  }
  
  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }
  
  void _onIncrement(IncrementIntent intent, [BuildContext? context]) {
    _count.value += 1;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```
In the example above, we declared the _`onIncrement` function as a handler. 
You should pay attention to the signature of the method. The `context` 
parameter is optional, but in practice the library API is implemented in 
such a way that the context will always be presented. This is achieved due 
to the fact that the internal implementation uses the `ContextAction` class 
for which `BuildContext` is always passed when calling the `invoke` method. The 
`BuildContext` instance will point to the Element within which the `invoke` call 
was made. The `invoke` call occurs when one of the methods of the `Actions` 
class (`handler`, `invoke`, `maybeInvoke`) is called.     

We already have a handler and an Intent, now it remains to create an `Action` 
and make it available for calling in child widgets. To do this, we use the 
`withActions` method of the `ComponentState` class, in the named parameter of which 
we will pass a collection of instances of the `ComponentAction` class received 
through the `action` extension method.

```dart
import 'package:componentt/componentt.dart';

class SampleWidget extends StatefulWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class IncrementIntent extends Intent {}

class _SampleWidgetState extends ComponentState<SampleWidget> {
  late final ValueNotifier<int> _count;

  @override
  void initState() {
    super.initState();
    _count = ValueNotifier(0);
  }

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  void _onIncrement(IncrementIntent intent, [BuildContext? context]) {
    _count.value += 1;
  }

  @override
  Widget build(BuildContext context) {
    return withActions(
      actions: {_onIncrement.action()},
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: _count,
              builder: (context, value, child) => Text('$value'),
            ),
            const Divider(color: Colors.transparent),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: context.handler(IncrementIntent()),
                  child: const Text('Increment'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

```

You may have noticed that instead of the `Actions` class, `context` is used to 
call the `handler` method. This is possible because the library declares an 
extension of the `BuildContext` class that makes the main methods of the 
`Actions` class available for calling.

In principle, this is all you need to do to start using the Intent and 
Action in your application. 

An alternative way to create the component shown in the examples above is as follows:

```dart
import 'package:componentt/componentt.dart';

class SampleWidget extends ComponentWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  ComponentState<SampleWidget> createState() => _SampleWidgetState();
}

class IncrementIntent extends Intent {}

class _SampleWidgetState extends ComponentState<SampleWidget> {
  late final ValueNotifier<int> _count;

  Set<Action<Intent>> get actions => {_onIncrement.action()};

  @override
  void initState() {
    super.initState();
    _count = ValueNotifier(0);
  }

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  void _onIncrement(IncrementIntent intent, [BuildContext? context]) {
    _count.value += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: _count,
            builder: (context, value, child) => Text('$value'),
          ),
          const Divider(color: Colors.transparent),
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: context.handler(IncrementIntent()),
                child: const Text('Increment'),
              );
            },
          )
        ],
      ),
    );
  }
}

```

## Additional information

For more information about Intent and Action read the documentation:
- [Intent](https://api.flutter.dev/flutter/widgets/Intent-class.html) - 
  documentation for Intent class
- [Action](https://api.flutter.dev/flutter/widgets/Action-class.html) - 
  documentation for Intent class
