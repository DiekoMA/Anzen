import 'package:anzen/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:anzen/main.dart';
import 'package:kdbx/kdbx.dart';

class SetMasterPasswordScreen extends StatefulWidget {
  const SetMasterPasswordScreen({super.key});

  @override
  State<SetMasterPasswordScreen> createState() =>
      _SetMasterPasswordScreenState();
}

class _SetMasterPasswordScreenState extends State<SetMasterPasswordScreen> {
  final TextEditingController vaultNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lets create your vault'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                obscureText: obscurePassword,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
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
                  label: const Text('Master Password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                obscureText: obscurePassword,
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
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
                  label: const Text('Confirm Master Password'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                FilledButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    Future.delayed(const Duration(seconds: 10), () {
                      setState(() {
                        isLoading = false;
                      });
                    });
                    const confirmationSnackbar = SnackBar(
                      content: Text('Vault Password succesfully set.'),
                    );
                    if (confirmPasswordController.text ==
                        passwordController.text) {
                      // setMasterPassword(passwordController.text);
                      setMasterPassword(passwordController.text);
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
                  child: !isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.lock), Text('Create Vault')],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.check), Text('Created')]),
                )
              ],
            )
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
