import 'package:anzen/colors.dart';
import 'package:anzen/main.dart';
import 'package:anzen/screens/set_master_password_screen.dart';
import 'package:anzen/services/shared_preferences_helper.dart';
import 'package:anzen/services/theme_provider.dart';
import 'package:anzen/widgets/change_decoypassword_sheet.dart';
import 'package:anzen/widgets/change_masterpassword_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedDropdownValue = 0;
  int loginAttempts = SharedPreferencesHelper().getInt("loginattempts") ?? 3;
  int vaultLockTime = SharedPreferencesHelper().getInt("vaultlocktime") ?? 60;
  bool allowScreenshots =
      SharedPreferencesHelper().getBool("screenshot") ?? false;
  bool usePattern = SharedPreferencesHelper().getBool("usepattern") ?? false;
  bool usePin = SharedPreferencesHelper().getBool("usepin") ?? false;
  bool bioAuth = SharedPreferencesHelper().getBool("bio") ?? false;
  bool secureMode = SharedPreferencesHelper().getBool("securemode") ?? false;
  bool useDarkMode = SharedPreferencesHelper().getBool("darkmode") ?? false;
  bool showPasswordStrength =
      SharedPreferencesHelper().getBool("showpasswordstrength") ?? false;
  bool useDecoyPassword =
      SharedPreferencesHelper().getBool("usedecoy") ?? false;
  bool useMaterialTheming =
      SharedPreferencesHelper().getBool("usematerialtheming") ?? false;
  TextEditingController pinTextFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            dense: true,
            enabled: true,
            title: Text('Security'),
          ),
          ListTile(
            title: const Text('Delete database'),
            subtitle: const Text(
                'Your vault can not be retrieved so be sure before you use this.'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_clock),
            title: Text('Lock vault after $vaultLockTime seconds'),
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
                            title: const Text('30 Seconds'),
                            value: 30,
                            groupValue: vaultLockTime,
                            onChanged: (value) {
                              setState(() {
                                vaultLockTime = value!;
                                SharedPreferencesHelper()
                                    .setInt("vaultlocktime", value);
                                Navigator.of(context).pop();
                              });
                            }),
                        RadioListTile(
                            title: const Text('1 minute'),
                            value: 60,
                            groupValue: loginAttempts,
                            onChanged: (value) {
                              setState(() {
                                vaultLockTime = value!;
                                SharedPreferencesHelper()
                                    .setInt("vaultlocktime", value);
                                Navigator.of(context).pop();
                              });
                            }),
                        RadioListTile(
                            title: const Text('5 minutes'),
                            value: 300,
                            groupValue: vaultLockTime,
                            onChanged: (value) {
                              setState(() {
                                vaultLockTime = value!;
                                SharedPreferencesHelper()
                                    .setInt("vaultlocktime", value);
                                Navigator.of(context).pop();
                              });
                            }),
                        RadioListTile(
                            title: const Text('10 minutes'),
                            value: 600,
                            groupValue: vaultLockTime,
                            onChanged: (value) {
                              setState(() {
                                vaultLockTime = value!;
                                SharedPreferencesHelper()
                                    .setInt("vaultlocktime", value);
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
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change Master Password'),
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const ChangeMasterpasswordSheet();
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
            title: const Text('Show Password Strength'),
            secondary: const Icon(Icons.security_rounded),
            subtitle: const Text(
                'Shows the paassword strength in the item details page.'),
            value: showPasswordStrength,
            onChanged: (newValue) {
              setState(() {
                showPasswordStrength = newValue;
                SharedPreferencesHelper()
                    .setBool("showpasswordstrength", newValue);
              });
            },
          ),
          SwitchListTile(
            isThreeLine: false,
            dense: true,
            title: const Text('Allow screenshots'),
            secondary: const Icon(Icons.screenshot),
            subtitle:
                const Text('Allows screenshots to be captured in the app'),
            value: allowScreenshots,
            onChanged: (newValue) async {
              try {
                if (allowScreenshots == true) {
                  await FlutterWindowManager.addFlags(
                      FlutterWindowManager.FLAG_SECURE);
                } else {
                  await FlutterWindowManager.clearFlags(
                      FlutterWindowManager.FLAG_SECURE);
                }
              } on PlatformException catch (e) {
                print("Error disabling screenshots on Android: ${e.message}");
              }
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
            subtitle: const Text(
                'Allows you have a fake pin/password to avoid unwanted eyes'),
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
                    return const ChangeDecoypasswordSheet();
                  });
            },
          ),
          ListTile(
            title: const Text('Set Pin code'),
            subtitle: const Text(
                'This will prioritise using a pin instead of a password for easier access'),
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Enter your pin code.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel')),
                        FilledButton(
                            onPressed: () {
                              setMasterPin(pinTextFieldController.text);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Set PIN'))
                      ],
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                              'Set your PIN code for unlocking Anzen, this will be used instead of your master password.'),
                          const SizedBox(height: 12),
                          TextField(
                            controller: pinTextFieldController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                label: const Text('PIN'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4))),
                          ),
                        ],
                      ),
                    );
                  });
              // Navigator.of(context).push(
              //   MaterialPageRoute<void>(
              //     fullscreenDialog: true,
              //     builder: (BuildContext context) {
              //       return const Setpincodescreen();
              //     },
              //   ),
              // );
            },
          ),
          // const SizedBox(height: 12),
          // const Divider(),
          // const ListTile(
          //   dense: true,
          //   enabled: false,
          //   title: Text(
          //     'Customization',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          //   ),
          //   leading: Icon(Icons.palette),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.delete),
          //   title: const Text('Custom theme'),
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: const Text('Custom Theme'),
          //           content: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             mainAxisSize: MainAxisSize.min,
          //             children: [],
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
          const ListTile(
            dense: true,
            enabled: true,
            title: Text('Appearance'),
          ),
          // ListTile(
          //   onTap: null,
          //   title: const Text('App Theme'),
          //   trailing: DropdownMenu(
          //     onSelected: (value) {
          //       setState(() {
          //         _selectedDropdownValue = value!;
          //         switch (_selectedDropdownValue) {
          //           case 0:
          //             themeProvider.setLightScheme(lightColorScheme);
          //             themeProvider.setThemeMode(ThemeMode.light);
          //             break;
          //           case 1:
          //             break;
          //         }
          //       });
          //     },
          //     dropdownMenuEntries: const [
          //       DropdownMenuEntry(value: 0, label: 'Light'),
          //       DropdownMenuEntry(value: 1, label: 'Dark'),
          //     ],
          //   ),
          // ),
          SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text(
                  'Extracts colours from your wallpaper and creates a colour pallete.'),
              value: useDarkMode,
              onChanged: (value) {
                SharedPreferencesHelper().setBool("darkmode", value);
                setState(() {
                  useDarkMode = value;
                });
                if (useDarkMode) {
                  themeProvider.setDarkScheme(darkColorScheme);
                  themeProvider.setThemeMode(ThemeMode.dark);
                } else {
                  themeProvider.setLightScheme(lightColorScheme);
                  themeProvider.setThemeMode(ThemeMode.light);
                }
              })
        ],
      ),
    );
  }
}

Future<void> setMasterPin(String pin) async {
  await secureStorage.write(key: 'primary_vault_master_pin', value: pin);
}


/// Wow you found this, idk what you're doing down here unless you're looking for this function but O_O
