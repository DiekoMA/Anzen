import 'package:anzen/screens/dashboard_screen.dart';
import 'package:anzen/screens/decoyscreen.dart';
import 'package:flutter/material.dart';
import 'package:anzen/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController passwordTextFieldController =
      TextEditingController();

  SharedPreferences? prefs;
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Text(
              'Anzen',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please enter your password to unlock the vault.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: obscurePassword,
              controller: passwordTextFieldController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
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
                label: const Text('Vault Password'),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              direction: Axis.horizontal,
              spacing: 20.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    bool isPasswordCorrect = await verifyMasterPassword(
                        passwordTextFieldController.text);
                    bool isDecoyPassword = await verifyDecoyPassword(
                        passwordTextFieldController.text);
                    if (isPasswordCorrect) {
                      try {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      } catch (e) {
                        SnackBar snackBar =
                            SnackBar(content: Text(e.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else if (isDecoyPassword) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Decoyscreen(),
                        ),
                      );
                    } else {
                      var errorSnackbar = SnackBar(
                        clipBehavior: Clip.antiAlias,
                        behavior: SnackBarBehavior.floating,
                        width: 350,
                        action:
                            SnackBarAction(label: ('label'), onPressed: () {}),
                        content: const Text('Incorrect Password'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [Icon(Icons.lock), Text('Unlock')],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [Icon(Icons.restore), Text('Reset')],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

Future<bool> verifyMasterPassword(String password) async {
  String? storedPassword =
      await secureStorage.read(key: 'primary_vault_master_password');

  // Compare the entered password with the stored password
  return password == storedPassword;
}

Future<bool> verifyDecoyPassword(String decoyPassword) async {
  String? storedPassword =
      await secureStorage.read(key: 'decoy_vault_master_password');

  // Compare the entered password with the stored password
  return decoyPassword == storedPassword;
}
