import 'package:anzen/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:anzen/main.dart';

class SetLockscreen extends StatefulWidget {
  const SetLockscreen({super.key});

  @override
  State<SetLockscreen> createState() => _SetLockscreenState();
}

class _SetLockscreenState extends State<SetLockscreen> {
  final TextEditingController passwordTextFieldController =
      TextEditingController();

  final TextEditingController confirmPasswordTextFieldController =
      TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(54.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Text(
              'Please set a password for your vault',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                obscureText: obscurePassword,
                controller: passwordTextFieldController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: obscurePassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  label: const Text('Set Password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                obscureText: obscurePassword,
                controller: confirmPasswordTextFieldController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: obscurePassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  label: const Text('Confirm Password'),
                ),
              ),
            ),
            OutlinedButton(
                onPressed: () async {
                  const confirmationSnackbar = SnackBar(
                    content: Text('Vault Password succesfully set.'),
                  );
                  if (confirmPasswordTextFieldController.text ==
                      passwordTextFieldController.text) {
                    setMasterPassword(passwordTextFieldController.text);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(confirmationSnackbar);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [Icon(Icons.lock), Text('Set Password')],
                ))
          ],
        ),
      )),
    );
  }
}

Future<void> setMasterPassword(String password) async {
  await secureStorage.write(
      key: 'primary_vault_master_password', value: password);
}
