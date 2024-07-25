import 'package:anzen/main.dart';
import 'package:flutter/material.dart';

class ChangeMasterpasswordSheet extends StatefulWidget {
  const ChangeMasterpasswordSheet({super.key});

  @override
  State<ChangeMasterpasswordSheet> createState() =>
      _ChangeMasterpasswordSheetState();
}

class _ChangeMasterpasswordSheetState extends State<ChangeMasterpasswordSheet> {
  bool obscurePassword = true;
  TextEditingController passwordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 170,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Change master password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                  IconButton(
                      onPressed: () {
                        setMasterPassword(passwordEditingController.text);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.save))
                ],
              ),
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    TextField(
                      obscureText: obscurePassword,
                      controller: passwordEditingController,
                      decoration: InputDecoration(
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: obscurePassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    )
                  ])),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> setMasterPassword(String password) async {
  await secureStorage.write(
      key: 'primary_vault_master_password', value: password);
}
