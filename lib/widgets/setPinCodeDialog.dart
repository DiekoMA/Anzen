import 'dart:ffi';

import 'package:anzen/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Setpincodedialog extends StatefulWidget {
  const Setpincodedialog({super.key});

  @override
  State<Setpincodedialog> createState() => _SetpincodedialogState();
}

class _SetpincodedialogState extends State<Setpincodedialog> {
  String? pin;
  bool empty = true;
  TextEditingController pinEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Pin'),
        ),
        body: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 24, right: 24, left: 24),
                child: TextField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  maxLength: 6,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: pinEditingController,
                  onSubmitted: (value) {
                    setState(() {
                      pin = value;
                      var pinSnackbar =
                          SnackBar(content: Text(pin!.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(pinSnackbar);
                      if (int.tryParse(value) == 6) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ),
              GridView.extent(
                primary: false,
                padding: const EdgeInsets.only(
                    top: 100, left: 16, right: 16, bottom: 16),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                maxCrossAxisExtent: 150.0,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}1';
                          }
                        });
                      },
                      child: const Text('1')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}2';
                          }
                        });
                      },
                      child: const Text('2')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}3';
                          }
                        });
                      },
                      child: const Text('3')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}4';
                          }
                        });
                      },
                      child: const Text('4')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}5';
                          }
                        });
                      },
                      child: const Text('5')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}6';
                          }
                        });
                      },
                      child: const Text('6')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}7';
                          }
                        });
                      },
                      child: const Text('7')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}8';
                          }
                        });
                      },
                      child: const Text('8')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}9';
                          }
                        });
                      },
                      child: const Text('9')),
                  TextButton(
                      onPressed: () {
                        pinEditingController.clear();
                        setState(() {
                          pinEditingController.text = "";
                        });
                      },
                      child: const Icon(Icons.close)),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (pinEditingController.text.length != 6) {
                            pinEditingController.text =
                                '${pinEditingController.text}0';
                          }
                        });
                      },
                      child: const Text('0')),
                  TextButton(
                      onPressed: pinEditingController.text.isEmpty
                          ? null
                          : () {
                              setState(() {
                                if (pinEditingController.text.length == 6) {
                                  pin = pinEditingController.text;
                                }
                                setMasterPin(pin!);
                              });
                              Navigator.of(context).pop();
                            },
                      child: const Icon(Icons.check)),
                ],
              )
            ],
          ),
        ));
  }
}

Future<void> setMasterPin(String pin) async {
  await secureStorage.write(key: 'primary_vault_master_pin', value: pin);
}
