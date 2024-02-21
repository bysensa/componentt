import 'package:componentt/componentt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class First extends ComponentWidget {
  const First({Key? key}) : super(key: key);

  @override
  ComponentState<First> createState() => _FirstState();
}

class _FirstState extends ComponentState<First> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      print(context.read<_FirstState>());

      return const Second();
    });
  }
}

class Second extends ComponentWidget {
  const Second({Key? key}) : super(key: key);

  @override
  ComponentState<Second> createState() => _SecondState();
}

class _SecondState extends ComponentState<Second> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      print(context.read<_FirstState>());
      print(context.read<_SecondState>());

      return const Third();
    });
  }
}

class Third extends ComponentWidget {
  const Third({Key? key}) : super(key: key);

  @override
  ComponentState<Third> createState() => _ThirdState();
}

class _ThirdState extends ComponentState<Third> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      print(context.read<_FirstState>());
      print(context.read<_SecondState>());
      print(context.read<_ThirdState>());

      return const Placeholder();
    });
  }
}

void main() {
  testWidgets('should access Scope on any level', (tester) async {
    final widget = const MaterialApp(home: First());
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  });
}
