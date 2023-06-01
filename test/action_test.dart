import 'package:componentt/componentt.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

typedef ActionFn<I extends Intent, R> = R Function(I intent);
typedef ContextActionFn<I extends Intent, R> = R Function(I intent,
    [BuildContext? context]);

class TestIntent extends Intent {}

void handlerWithOutContext(TestIntent intent) {}
void handlerWithContext(TestIntent intent, [BuildContext? context]) {}

void main() {
  test('must resolve fn type correctly', () {
    expect(handlerWithContext.hasContextParameter, true);
    expect(handlerWithOutContext.hasContextParameter, false);
  });
}
