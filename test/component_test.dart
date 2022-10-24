import 'package:componentt/componentt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should not rebuild on setState', (widgetTester) async {
    final acc = Accumulator();
    final widget = TestComponent(acc: acc);
    await widgetTester.pumpWidget(widget);
    await widgetTester.pumpAndSettle();
    expect(find.byType(ElevatedButton), findsOneWidget);
    final btn = find.byType(ElevatedButton);
    expect(acc.value, 1);
    await widgetTester.tap(btn);
    await widgetTester.pumpAndSettle();
    expect(acc.value, 2);
  });
}

class Test1Intent extends Intent {}

class Test2Intent extends Intent {}

class TestComponent extends StatefulWidget {
  final Accumulator acc;
  const TestComponent({
    Key? key,
    required this.acc,
  }) : super(key: key);

  @override
  State<TestComponent> createState() => _TestComponentState();
}

class _TestComponentState extends Component<TestComponent> {
  late final test1Action = ComponentAction(_onTest1);

  Accumulator get acc => widget.acc;

  @override
  void initState() {
    super.initState();
    test1Action.attachTo(this);
  }

  void _onTest1(Test1Intent intent, [BuildContext? context]) {
    test1Action.toggleEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return component(
      child: MaterialApp(
        home: Scaffold(
          body: Container(
            child: Center(
              child: Column(
                children: [
                  Builder(builder: (context) {
                    acc.increment(1);
                    return ElevatedButton(
                      onPressed: context.handler(Test1Intent()),
                      child: Text('press'),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
