import 'package:anzen/utils/sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:anzen/main.dart';

class Settingsscreen extends StatefulWidget {
  const Settingsscreen({super.key});

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  bool allowScreenshots = false;
  bool? bioAuth = false;
  bool? useDecoyPassword = false;

  final TextEditingController decoyPasswordTextFieldController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      allowScreenshots =
          SharedPreferencesHelper().getBool("screenshot") ?? false;
      bioAuth = SharedPreferencesHelper().getBool("bio") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Setting tiles for various options
          ListTile(
            leading: const Icon(Icons.lock_clock),
            title: const Text('Lock vault after'),
            onTap: () {},
          ),
          SwitchListTile(
            isThreeLine: false,
            title: const Text('Allow screenshots'),
            secondary: const Icon(Icons.screenshot),
            subtitle:
                const Text('Allows screenshots to be captured in the app'),
            value: allowScreenshots,
            onChanged: (newValue) {
              allowScreenshots = newValue;
              SharedPreferencesHelper().setBool("screenshot", newValue);
            },
          ),
          SwitchListTile(
            isThreeLine: false,
            title: const Text('Enable biometric auth'),
            secondary: const Icon(Icons.fingerprint),
            subtitle: const Text(
                'Allows the unlocking of your vault using biometrics'),
            value: bioAuth ?? false,
            onChanged: (newBioValue) {
              setState(() {
                bioAuth = newBioValue;
                SharedPreferencesHelper().setBool("bio", newBioValue);
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Decoy Password'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Decoy Password'),
                      children: [
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  TextField(
                                    controller:
                                        decoyPasswordTextFieldController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))),
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        setDecoyPassword(
                                            decoyPasswordTextFieldController
                                                .text);
                                      },
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13.0))),
                                      child: const Text('Set Decoy Password'))
                                ],
                              )),
                        )
                      ],
                    );
                  });
            },
          )

          // ... more settings tiles
        ],
      ),
    );
  }
}

Future<void> setDecoyPassword(String password) async {
  await secureStorage.write(
      key: 'decoy_vault_master_password', value: password);
}
