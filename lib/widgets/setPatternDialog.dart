import 'package:anzen/main.dart';
import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';

class Setpatterndialog extends StatefulWidget {
  const Setpatterndialog({super.key});

  @override
  State<Setpatterndialog> createState() => _SetpatterndialogState();
}

class _SetpatterndialogState extends State<Setpatterndialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
