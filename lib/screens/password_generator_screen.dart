import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_strength/password_strength.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double passwordLength = 12;
  bool useSymbols = true;
  bool useNumbers = true;
  final passwordBoxController = TextEditingController();
  double passwordStrength = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Password Generator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: TextField(
                  minLines: 3,
                  controller: passwordBoxController,
                  readOnly: true,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffix: IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: passwordBoxController.text));
                        },
                        icon: const Icon(Icons.copy)),
                  ),
                ),
              ),
              Chip(
                  label: passwordStrength > 0.5
                      ? const Text('Strong')
                      : const Text('Weak')),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text('Password Length'),
                      Slider(
                        label: 'Password Length',
                        value: passwordLength,
                        onChanged: (value) {
                          setState(() {
                            passwordLength = value;
                          });
                        },
                        min: 4,
                        max: 30,
                      ),
                      Text(passwordLength.toInt().toString()),
                    ],
                  ),
                ),
              ),
              Card(
                  child: SwitchListTile(
                      title: const Text('Use Symbols'),
                      value: useSymbols,
                      onChanged: (value) {
                        setState(() {
                          useSymbols = value;
                        });
                      })),
              Card(
                  child: SwitchListTile(
                      title: const Text('Use Numbers'),
                      value: useNumbers,
                      onChanged: (value) {
                        setState(() {
                          useNumbers = value;
                        });
                      })),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: generatePassword,
          label: const Row(
            children: [Text('Generate'), Icon(Icons.refresh)],
          ),
        ));
  }

  void generatePassword() {
    int length = 12;
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:",.<>?/~';
    var rng = Random.secure();
    var password = '';
    rng.nextInt(length);

    for (int i = 0; i < passwordLength; i++) {
      password += useNumbers && useSymbols
          ? lowercase[rng.nextInt(lowercase.length)] +
              uppercase[rng.nextInt(uppercase.length)] +
              numbers[rng.nextInt(numbers.length)] +
              symbols[rng.nextInt(symbols.length)]
          : lowercase[rng.nextInt(lowercase.length)];
    }
    setState(() {
      passwordBoxController.text = password;
      passwordStrength = estimatePasswordStrength(passwordBoxController.text);
    });
  }
}
