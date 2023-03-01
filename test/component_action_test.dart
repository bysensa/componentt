import 'dart:developer';

import 'package:componentt/componentt.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int defaultTestHandler(TestIntent intent, [BuildContext? context]) {
    return 0;
  }

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

  test('should return is enabled', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.isActionEnabled, isTrue);
  });

  test('should change is enabled', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.isActionEnabled, isTrue);
    action.isActionEnabled = false;
    expect(action.isActionEnabled, isFalse);
  });

  test('should toggle is enabled', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.isActionEnabled, isTrue);
    action.toggleEnabled();
    expect(action.isActionEnabled, isFalse);
  });

  test('should evaluate is enabled without predicate', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.isEnabled(TestIntent()), isTrue);
  });

  test('should evaluate is enabled with predicate', () {
    final action = ComponentAction(
      defaultTestHandler,
      enabledPredicate: (_) => false,
    );
    expect(action.isEnabled(TestIntent()), isFalse);
  });

  test('should return isConsumesKey', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.isConsumesKey, isTrue);
  });

  test('should change isConsumesKey', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.isConsumesKey, isTrue);
    action.isConsumesKey = false;
    expect(action.isConsumesKey, isFalse);
  });

  test('should toggle isConsumesKey', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.isConsumesKey, isTrue);
    action.toggleConsumesKey();
    expect(action.isConsumesKey, isFalse);
  });

  test('should evaluate isConsumesKey without predicate', () {
    final action = ComponentAction(defaultTestHandler);
    expect(action.consumesKey(TestIntent()), isTrue);
  });

  test('should evaluate isConsumesKey with predicate', () {
    final action = ComponentAction(
      defaultTestHandler,
      consumesKeyPredicate: (_) => false,
    );
    expect(action.consumesKey(TestIntent()), isFalse);
  });

  test('should invoke handler', () {
    var handlerInvocationCount = 0;
    int handler(TestIntent intent, [BuildContext? context]) {
      handlerInvocationCount += 1;
      return 0;
    }

    final action = ComponentAction(handler);
    expect(handlerInvocationCount, 0);
    action.invoke(TestIntent());
    expect(handlerInvocationCount, 1);
  });

  test('should notify listeners', () {
    var counter = 0;
    void listener(Action action) => counter += 1;
    final action = ComponentAction(defaultTestHandler);
    action.addActionListener(listener);
    expect(counter, 0);
    action.notify();
    expect(counter, 1);
    action.removeActionListener(listener);
    action.notify();
    expect(counter, 1);
  });

  test('should notify on enabled or consumesKey change', () {
    var counter = 0;
    void listener(Action action) => counter += 1;
    final action = ComponentAction(defaultTestHandler);
    action.addActionListener(listener);
    expect(counter, 0);
    action.isActionEnabled = false;
    expect(counter, 1);
    action.isActionEnabled = false;
    expect(counter, 1);
    action.toggleEnabled();
    expect(counter, 2);
    action.isConsumesKey = false;
    expect(counter, 3);
    action.isConsumesKey = false;
    expect(counter, 3);
    action.toggleConsumesKey();
    expect(counter, 4);
  });
}

class TestIntent extends Intent {}

class IsNotIntent {}
