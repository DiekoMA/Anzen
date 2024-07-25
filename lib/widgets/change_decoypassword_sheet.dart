import 'package:anzen/main.dart';
import 'package:flutter/material.dart';

class ChangeDecoypasswordSheet extends StatefulWidget {
  const ChangeDecoypasswordSheet({super.key});

  @override
  State<ChangeDecoypasswordSheet> createState() =>
      _ChangeDecoypasswordSheetState();
}

class _ChangeDecoypasswordSheetState extends State<ChangeDecoypasswordSheet> {
  final TextEditingController decoyPasswordTextFieldController =
      TextEditingController();
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
                    'Set Decoy Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                  IconButton(
                      onPressed: () {
                        setDecoyPassword(decoyPasswordTextFieldController.text);
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
                      controller: decoyPasswordTextFieldController,
                    )
                  ])),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> setDecoyPassword(String password) async {
  await secureStorage.write(
      key: 'decoy_vault_master_password', value: password);
}
