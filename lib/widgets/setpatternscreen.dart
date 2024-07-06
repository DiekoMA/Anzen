import 'package:anzen/main.dart';
import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';

class Setpatternscreen extends StatefulWidget {
  const Setpatternscreen({super.key});

  @override
  State<Setpatternscreen> createState() => _SetpatternscreenState();
}

class _SetpatternscreenState extends State<Setpatternscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Set a pattern for your vault (Optional)'),
        ),
        body: Center(
          child: PatternLock(
            pointRadius: 8,
            selectedColor: Colors.red,
            dimension: 3,
            showInput: true,
            fillPoints: true,
            onInputComplete: (List<int> input) {
              Navigator.of(context).pop();
            },
          ),
        ));
  }
}
