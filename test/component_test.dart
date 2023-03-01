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

  testWidgets('should not rebuild on setState 2', (widgetTester) async {
    final acc = Accumulator();
    final widget = TestComponent(acc: acc);
    await widgetTester.pumpWidget(widget);
    await widgetTester.pumpAndSettle();
    expect(find.byType(TestComponent), findsOneWidget);
    final actionsState =
        widgetTester.state(find.byType(TestComponent)) as _TestComponentState;
    expect(actionsState.onTest1.isActionEnabled, isTrue);
    expect(actionsState.onTest2.isActionEnabled, isTrue);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Accumulator get acc => widget.acc;

  void onTest1(Test1Intent intent, [BuildContext? context]) {
    onTest1.toggleEnabled();
  }

  void onTest2(Test2Intent intent, [BuildContext? context]) {
    onTest2.toggleEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return withActions(
      actions: {onTest1.toAction()},
      key: const ValueKey('actions'),
      child: MaterialApp(
        home: Scaffold(
          body: Container(
            child: Center(
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      acc.increment(1);
                      return ElevatedButton(
                        onPressed: context.handler(Test1Intent()),
                        child: Text('press'),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
