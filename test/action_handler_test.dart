import 'package:componentt/componentt.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class TestIntent extends Intent {}

void handler(TestIntent intent, [BuildContext? context]) {}

void main() {
  test("should create action", () {
    expect(handler.action, isNull);
    final _ = handler.action();
  });

  test("should be same action instance", () {
    expect(handler.action(), handler.action());
  });

  testWidgets("should create widget", (tester) async {
    var widgets = [const TestWidget(), const SizedBox.shrink()];
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
    expect(find.byType(TestWidget), findsOneWidget);
    await tester.pumpWidget(widgets.removeAt(0));
    await tester.pumpAndSettle();
  });
}

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends Component<TestWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void handler(TestIntent intent, [BuildContext? context]) {}

  @override
  Widget build(BuildContext context) {
    return withActions(
      actions: {handler.action()},
      child: const Placeholder(),
    );
  }
}
