import 'package:anzen/screens/onboarding/setmasterpasswordscreen.dart';
import 'package:anzen/utils/sharedPreferencesHelper.dart';
import 'package:anzen/widgets/setpatternscreen.dart';
import 'package:anzen/widgets/setpincodescreen.dart';
import 'package:flutter/material.dart';
import 'package:anzen/main.dart';

class Settingsscreen extends StatefulWidget {
  const Settingsscreen({super.key});

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  bool obscurePassword = true;
  int loginAttempts = SharedPreferencesHelper().getInt("loginattempts") ?? 3;
  bool allowScreenshots =
      SharedPreferencesHelper().getBool("screenshot") ?? false;
  bool usePattern = SharedPreferencesHelper().getBool("usepattern") ?? false;
  bool usePin = SharedPreferencesHelper().getBool("usepin") ?? false;
  bool bioAuth = SharedPreferencesHelper().getBool("bio") ?? false;
  bool secureMode = SharedPreferencesHelper().getBool("securemode") ?? false;
  bool useDecoyPassword =
      SharedPreferencesHelper().getBool("usedecoy") ?? false;

  final TextEditingController decoyPasswordTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            dense: true,
            enabled: false,
            title: Text(
              'Security',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            leading: Icon(Icons.security),
          ),
          const Divider(),
          // Setting tiles for various options
          ListTile(
            leading: const Icon(Icons.lock_clock),
            title: const Text('Lock vault after'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change Master Password'),
            onTap: () {
              final TextEditingController passwordEditingController =
                  TextEditingController();
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Text(
                                    'Change master password',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.justify,
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        setMasterPassword(
                                            passwordEditingController.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Save'))
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
                                                obscurePassword =
                                                    !obscurePassword;
                                              });
                                            },
                                            icon: obscurePassword
                                                ? const Icon(Icons.visibility)
                                                : const Icon(
                                                    Icons.visibility_off),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                    )
                                  ])),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text('Delete Vault after $loginAttempts attempts.'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Login Attempts'),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                            title: const Text('1 Attempt'),
                            value: 1,
                            groupValue: loginAttempts,
                            onChanged: (value) {
                              setState(() {
                                loginAttempts = value!;
                                SharedPreferencesHelper()
                                    .setInt("loginattempts", value);
                                Navigator.of(context).pop();
                              });
                            }),
                        RadioListTile(
                            title: const Text('2 Attempts'),
                            value: 2,
                            groupValue: loginAttempts,
                            onChanged: (value) {
                              setState(() {
                                loginAttempts = value!;
                                SharedPreferencesHelper()
                                    .setInt("loginattempts", value);
                                Navigator.of(context).pop();
                              });
                            }),
                        RadioListTile(
                            title: const Text('3 Attempts'),
                            value: 3,
                            groupValue: loginAttempts,
                            onChanged: (value) {
                              setState(() {
                                loginAttempts = value!;
                                SharedPreferencesHelper()
                                    .setInt("loginattempts", value);
                                Navigator.of(context).pop();
                              });
                            }),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          SwitchListTile(
            isThreeLine: false,
            title: const Text('Allow screenshots'),
            secondary: const Icon(Icons.screenshot),
            subtitle:
                const Text('Allows screenshots to be captured in the app'),
            value: allowScreenshots,
            onChanged: (newValue) {
              setState(() {
                allowScreenshots = newValue;
                SharedPreferencesHelper().setBool("screenshot", newValue);
              });
            },
          ),
          SwitchListTile(
            isThreeLine: false,
            title: const Text('Enable biometric auth'),
            secondary: const Icon(Icons.fingerprint),
            subtitle: const Text(
                'Allows the unlocking of your vault using biometrics'),
            value: bioAuth,
            onChanged: (newBioValue) {
              setState(() {
                bioAuth = newBioValue;
                SharedPreferencesHelper().setBool("bio", newBioValue);
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.shield),
            title: const Text('Decoy Password'),
            enabled: useDecoyPassword,
            trailing: Switch(
              value: useDecoyPassword,
              onChanged: (value) {
                setState(() {
                  useDecoyPassword = value;
                  SharedPreferencesHelper().setBool("usedecoy", value);
                });
              },
            ),
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Text(
                                    'Set Decoy Password',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.justify,
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        setDecoyPassword(
                                            decoyPasswordTextFieldController
                                                .text);
                                      },
                                      child: const Text('Save'))
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(children: [
                                    TextField(
                                      controller:
                                          decoyPasswordTextFieldController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                    )
                                  ])),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
          ListTile(
            title: const Text('Set Pattern'),
            enabled: usePattern,
            leading: const Icon(Icons.pattern),
            trailing: Switch(
              value: usePattern,
              onChanged: (value) {
                setState(() {
                  usePattern = value;
                  SharedPreferencesHelper().setBool("usepattern", value);
                });
              },
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (BuildContext context) {
                    return const Setpatternscreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Set Pin code'),
            enabled: usePin,
            leading: const Icon(Icons.pin),
            trailing: Switch(
              value: usePin,
              onChanged: (value) {
                setState(() {
                  usePin = value;
                  SharedPreferencesHelper().setBool("usepin", value);
                });
              },
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (BuildContext context) {
                    return const Setpincodescreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const Divider(),
          const ListTile(
            dense: true,
            enabled: false,
            title: Text(
              'Customization',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            leading: Icon(Icons.palette),
          ),
        ],
      ),
    );
  }
}

Future<void> setDecoyPassword(String password) async {
  await secureStorage.write(
      key: 'decoy_vault_master_password', value: password);
}


/// Wow you found this, idk what you're doing down here unless you're looking for this function but O_O