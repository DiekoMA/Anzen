import 'package:anzen/screens/dashboard_screen.dart';
import 'package:anzen/screens/decoy_screen.dart';
import 'package:anzen/services/local_auth_service.dart';
import 'package:anzen/services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:anzen/main.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final bioAuth = SharedPreferencesHelper().getBool("bio") ?? false;
  bool usePattern = SharedPreferencesHelper().getBool("usepattern") ?? false;
  bool usePin = SharedPreferencesHelper().getBool("usepin") ?? false;
  final LocalAuthentication auth = LocalAuthentication();
  //_SupportState _supportState = _SupportState.unknown;
  String? pin;
  final TextEditingController pinTextFieldController = TextEditingController();
  final TextEditingController securityPhraseTextFieldController =
      TextEditingController();
  final TextEditingController passwordTextFieldController =
      TextEditingController();
  SharedPreferences? prefs;
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Anzen',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 16),
              const Text(
                'Please enter your password to unlock the vault.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 16),
              usePin
                  ? TextField(
                      obscureText: obscurePassword,
                      controller: pinTextFieldController,
                      keyboardType: TextInputType.number,
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
                        label: const Text('PIN'),
                      ))
                  : TextField(
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
              Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(8))),
                  //   onPressed: () {},
                  //   child: const Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     mainAxisSize: MainAxisSize.max,
                  //     children: [Icon(Icons.restore), Text('Reset')],
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  // FilledButton(
                  //     onPressed: !usePin
                  //         ? null
                  //         : () {
                  //             showModalBottomSheet(
                  //                 context: context,
                  //                 isDismissible: true,
                  //                 useSafeArea: true,
                  //                 isScrollControlled: true,
                  //                 showDragHandle: true,
                  //                 builder: (BuildContext context) {
                  //                   return Padding(
                  //                     padding:
                  //                         MediaQuery.of(context).viewInsets,
                  //                     child: SizedBox(
                  //                       height: 320,
                  //                       child: Column(
                  //                         children: [
                  //                           TextField(
                  //                             controller:
                  //                                 pinTextFieldController,
                  //                             readOnly: true,
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   );
                  //                 });
                  //           },
                  //     style: OutlinedButton.styleFrom(
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8))),
                  //     child: const Icon(Icons.pin)),
                  // const SizedBox(width: 8),
                  FilledButton(
                    onPressed: !bioAuth
                        ? null
                        : () => authenticateWithBiometrics(this.context),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Icon(Icons.lock_open),
                        Text('Unlock with biometrics')
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: usePin
                        ? () async {
                            final navigator = Navigator.of(context);
                            bool isPinCorrect = await verifyMasterPin(
                                pinTextFieldController.text);
                            if (isPinCorrect) {
                              try {
                                navigator.pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardScreen(),
                                  ),
                                );
                              } catch (e) {
                                SnackBar snackBar =
                                    SnackBar(content: Text(e.toString()));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              var errorSnackbar = SnackBar(
                                clipBehavior: Clip.antiAlias,
                                behavior: SnackBarBehavior.floating,
                                width: 350,
                                action: SnackBarAction(
                                    label: ('Close'),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                                content: const Text('Incorrect Password'),
                              );
                              scaffoldMessenger.showSnackBar(errorSnackbar);
                            }
                          }
                        : () async {
                            final navigator = Navigator.of(context);
                            bool isPasswordCorrect = await verifyMasterPassword(
                                passwordTextFieldController.text);
                            bool isDecoyPassword = await verifyDecoyPassword(
                                passwordTextFieldController.text);
                            if (isPasswordCorrect) {
                              try {
                                navigator.pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardScreen(),
                                  ),
                                );
                              } catch (e) {
                                SnackBar snackBar =
                                    SnackBar(content: Text(e.toString()));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
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
                                action: SnackBarAction(
                                    label: ('Close'),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                                content: const Text('Incorrect Password'),
                              );
                              var scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              scaffoldMessenger.showSnackBar(errorSnackbar);
                            }
                          },
                    //child: const Icon(Icons.lock_open),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Icon(Icons.lock_open),
                        Text('Unlock')
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Submit'),
                                )
                              ],
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Use your security phrase to access your vault.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller:
                                        securityPhraseTextFieldController,
                                    decoration: const InputDecoration(
                                      label: Text('Security Phrase'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller:
                                        securityPhraseTextFieldController,
                                    decoration: const InputDecoration(
                                      label: Text('New Password'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller:
                                        securityPhraseTextFieldController,
                                    decoration: const InputDecoration(
                                      label: Text('Confirm New Password'),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Forgot password ?'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> authenticateWithBiometrics(context) async {
  final authenticate = await LocalAuth.authenticate();
  if (authenticate) {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    } catch (e) {
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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

Future<bool> verifyMasterPin(String pin) async {
  String? storedPin =
      (await secureStorage.read(key: 'primary_vault_master_pin'));

  if (pin == storedPin) {
    return true;
  } else {
    return false;
  }
}
