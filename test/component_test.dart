import 'package:componentt/componentt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestIntent extends Intent {}

class TestIntent2 extends Intent {}

void handler(TestIntent intent, [BuildContext? context]) {}

void simpleHandler(TestIntent2 intent) {}

void main() {
  test("should create action", () {
    expect(handler.action, isA<Function>());
    expect(simpleHandler.action, isA<Function>());
    handler.action();
    simpleHandler.action();
  });

  test("should not be same action instance", () {
    expect(handler.action(), isNot(handler.action()));
    expect(simpleHandler.action(), isNot(simpleHandler.action()));
  });

  testWidgets("should create widget", (tester) async {
    var widgets = [
      const MaterialApp(home: TestWidget()),
      const SizedBox.shrink()
    ];
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
    expect(find.byType(TestWidget), findsOneWidget);
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
  });

  testWidgets("should invoke action for TestIntent", (tester) async {
    var widgets = [
      const MaterialApp(home: TestWidget()),
      const SizedBox.shrink()
    ];
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'intent'));
    await tester.pumpAndSettle();
    final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
    expect(state.lastIntent.runtimeType, TestIntent);
  });

  testWidgets("should invoke action for TestIntent2", (tester) async {
    var widgets = [
      const MaterialApp(home: TestWidget()),
      const SizedBox.shrink()
    ];
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'intent2'));
    await tester.pumpAndSettle();
    final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
    expect(state.lastIntent.runtimeType, TestIntent2);
  });

  testWidgets("control has listeners", (tester) async {
    var widgets = [
      const MaterialApp(home: TestWidget()),
      const SizedBox.shrink()
    ];
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
    final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
    state.ensureControlsIsListening();
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
    state.ensureControlsIsNotListening();
  });
}

class TestWidget extends ComponentWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  ComponentState<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends ComponentState<TestWidget> {
  Intent? lastIntent;

  late final handlerControl = handler.control();
  late final handler2Control = handler2.control();

  @override
  Set<Action<Intent>> get actions => {
        handler.action(handlerControl),
        handler2.action(handler2Control),
      };

  @override
  void initState() {
    super.initState();
  }

  void ensureControlsIsListening() {
    expect(handlerControl.hasIsEnabledListeners, isTrue);
    expect(handlerControl.hasIsConsumesKeyListeners, isTrue);

    expect(handler2Control.hasIsEnabledListeners, isTrue);
    expect(handler2Control.hasIsConsumesKeyListeners, isTrue);
  }

  void ensureControlsIsNotListening() {
    expect(handlerControl.hasIsEnabledListeners, isFalse);
    expect(handlerControl.hasIsConsumesKeyListeners, isFalse);

    expect(handler2Control.hasIsEnabledListeners, isFalse);
    expect(handler2Control.hasIsConsumesKeyListeners, isFalse);
  }

  void handler(TestIntent intent, [BuildContext? context]) {
    lastIntent = intent;
  }

  void handler2(TestIntent2 intent) {
    lastIntent = intent;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: context.handler(TestIntent()),
              child: const Text('intent'),
            ),
            ElevatedButton(
              onPressed: context.handler(TestIntent2()),
              child: const Text('intent2'),
            ),
          ],
        );
      },
    );
  }
}
