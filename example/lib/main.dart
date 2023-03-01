import 'package:componentt/componentt.dart';
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

class SampleWidget extends StatefulWidget {
  const SampleWidget({Key? key}) : super(key: key);

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class IncrementIntent extends Intent {}

class _SampleWidgetState extends Component<SampleWidget> {
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
