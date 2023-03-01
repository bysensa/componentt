import 'package:componentt/componentt.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class IncrementIntent extends Intent {}

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends Component<MyHomePage> {
  final _maxValue = 15;
  final _counter = ValueNotifier(0);

  void _onIncrement(IncrementIntent intent, [BuildContext? context]) {
    _counter.value += 1;
    if (_counter.value == _maxValue) {
      _onIncrement.isActionEnabled = false;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You reach count limit equal to $_maxValue'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return withActions(
      actions: {_onIncrement.toAction()},
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text('Button become disabled when counter reach $_maxValue.'),
              ValueListenableBuilder(
                  valueListenable: _counter,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  }),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: context.handler(IncrementIntent()),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
