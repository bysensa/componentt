import 'package:componentt/componentt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SampleWidget(),
    );
  }
}

class SampleWidget extends ComponentWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  ComponentState<SampleWidget> createState() => _SampleWidgetState();
}

class IncrementIntent extends Intent {}

class NotifyIntent extends Intent {
  final String text;

  const NotifyIntent(this.text);
}

mixin _ViewModel on ComponentState<SampleWidget> {
  late final ValueNotifier<int> _count;

  ValueListenable<int> get count => _count;

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

  @override
  Set<Action<Intent>> get actions => {
        _onIncrement.action(),
        onNotify.action(),
      };

  void _onIncrement(IncrementIntent intent) {
    _count.value += 1;
  }

  void onNotify(NotifyIntent intent, [BuildContext? context]) {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 200),
        content: Text(
          intent.text,
        ),
      ),
    );
  }
}

class _SampleWidgetState extends ComponentState<SampleWidget> with _ViewModel {
  @override
  Widget build(BuildContext context) {
    return withActions(
      actions: {_onIncrement.action(), onNotify.action()},
      child: const _Layout(
        count: _Count(),
        evenOrOdd: _EventOddMark(),
        button: _IncrementButton(),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  final Widget count;
  final Widget evenOrOdd;
  final Widget button;

  const _Layout({
    Key? key,
    required this.count,
    required this.evenOrOdd,
    required this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          count,
          evenOrOdd,
          const Divider(color: Colors.transparent),
          button,
        ],
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _SampleWidgetState component = context.component();

    return ValueListenableBuilder<int>(
      valueListenable: component.count,
      builder: (context, value, child) {
        // Notify if value is odd
        if (value % 2 == 0) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.invoke(NotifyIntent('Value $value is odd'));
          });
        }

        return Text('$value');
      },
    );
  }
}

class _EventOddMark extends StatelessWidget {
  static const _evenText = 'Even';
  static const _oddText = 'Odd';

  const _EventOddMark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ViewModel viewModel = context.component();

    const even = Text(_evenText);
    const odd = Text(_oddText);

    return ValueListenableBuilder<int>(
      valueListenable: viewModel.count,
      builder: (context, value, child) => Visibility(
        visible: value % 2 == 0,
        replacement: odd,
        child: even,
      ),
    );
  }
}

class _IncrementButton extends StatelessWidget {
  const _IncrementButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: context.handler(IncrementIntent()),
      child: const Text('Increment'),
    );
  }
}
