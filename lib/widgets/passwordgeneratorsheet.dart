import 'dart:math';
import 'package:flutter/material.dart';

class Passwordgeneratorsheet extends StatefulWidget {
  const Passwordgeneratorsheet({super.key});

  @override
  State<Passwordgeneratorsheet> createState() => _PasswordgeneratorsheetState();
}

class _PasswordgeneratorsheetState extends State<Passwordgeneratorsheet> {
  void generatePassword() {
    int length = 12;
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+-=[]{}|;:",.<>?/~';
    var rng = Random.secure();
    var password = '';
    rng.nextInt(length);

    for (int i = 0; i < 12; i++) {
      password += characters[rng.nextInt(characters.length)];
    }
    setState(() {
      passwordTextController.text = password;
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 1,
        minChildSize: 0,
        expand: true,
        snap: true,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Email/Username'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username/email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Website'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a website';
                    }
                    return null;
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Saving item')),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ))
              ],
            ),
          );
        });
  }
}
