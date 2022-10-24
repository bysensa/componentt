import 'package:componentt/componentt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should infer intent and result types from high order function', () {
    int testHandler(TestIntent intent, [BuildContext? context]) {
      return 0;
    }

    final action = ComponentAction(testHandler);
    expect(action.intentType, TestIntent);
    expect(action.resultType, int);
  });

  test(
    'should assert if handler first parameter type is not extends Intent',
    () {
      int testHandler(IsNotIntent intent, [BuildContext? context]) {
        return 0;
      }

      expect(() => ComponentAction(testHandler), throwsAssertionError);
    },
  );
}

class TestIntent extends Intent {}

class IsNotIntent {}
