import 'package:componentt/componentt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

class TestIntent extends Intent {}

void testHandler(TestIntent intent, [BuildContext? context]) {}

void main() {
  late CallCount enabledNotifyCounter;
  late CallCount consumesKeyNotifyCounter;

  setUp(() {
    enabledNotifyCounter = CallCount();
    consumesKeyNotifyCounter = CallCount();
  });

  test('should not notify on first set enabled = true', () {
    final control = testHandler.control();
    control.addIsEnabledListener(enabledNotifyCounter);
    control.isActionEnabled = true;
    expect(enabledNotifyCounter.count, 0);
  });

  test('should notify on set enabled = true', () {
    final control = testHandler.control();
    control.isActionEnabled = false;
    control.addIsEnabledListener(enabledNotifyCounter);
    control.isActionEnabled = true;
    expect(enabledNotifyCounter.count, 1);
  });

  test('should notify on first set enabled = false', () {
    final control = testHandler.control();
    control.addIsEnabledListener(enabledNotifyCounter);
    control.isActionEnabled = false;
    expect(enabledNotifyCounter.count, 1);
  });

  test('should notify on toggle enabled', () {
    final control = testHandler.control();
    control.addIsEnabledListener(enabledNotifyCounter);
    control.toggleEnabled();
    expect(enabledNotifyCounter.count, 1);
    control.toggleEnabled();
    expect(enabledNotifyCounter.count, 2);
  });

  test('should correctly add and remove listener', () {
    final control = testHandler.control();
    control.toggleEnabled();
    expect(enabledNotifyCounter.count, 0);
    control.addIsEnabledListener(enabledNotifyCounter);
    control.toggleEnabled();
    expect(enabledNotifyCounter.count, 1);
    control.removeIsEnabledListener(enabledNotifyCounter);
    control.toggleEnabled();
    expect(enabledNotifyCounter.count, 1);
  });

  ////

  test('should not notify on first set enabled = true', () {
    final control = testHandler.control();
    control.addIsConsumesKeyListener(consumesKeyNotifyCounter);
    control.isConsumesKey = true;
    expect(consumesKeyNotifyCounter.count, 0);
  });

  test('should notify on set enabled = true', () {
    final control = testHandler.control();
    control.isConsumesKey = false;
    control.addIsConsumesKeyListener(consumesKeyNotifyCounter);
    control.isConsumesKey = true;
    expect(consumesKeyNotifyCounter.count, 1);
  });

  test('should notify on first set enabled = false', () {
    final control = testHandler.control();
    control.addIsConsumesKeyListener(consumesKeyNotifyCounter);
    control.isConsumesKey = false;
    expect(consumesKeyNotifyCounter.count, 1);
  });

  test('should notify on toggle enabled', () {
    final control = testHandler.control();
    control.addIsConsumesKeyListener(consumesKeyNotifyCounter);
    control.toggleConsumesKey();
    expect(consumesKeyNotifyCounter.count, 1);
    control.toggleConsumesKey();
    expect(consumesKeyNotifyCounter.count, 2);
  });

  test('should correctly add and remove listener', () {
    final control = testHandler.control();
    control.toggleConsumesKey();
    expect(consumesKeyNotifyCounter.count, 0);
    control.addIsConsumesKeyListener(consumesKeyNotifyCounter);
    control.toggleConsumesKey();
    expect(consumesKeyNotifyCounter.count, 1);
    control.removeIsConsumesKeyListener(consumesKeyNotifyCounter);
    control.toggleConsumesKey();
    expect(consumesKeyNotifyCounter.count, 1);
  });
}
