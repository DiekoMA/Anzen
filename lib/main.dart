import 'package:anzen/screens/set_lockscreen.dart';
import 'package:anzen/screens/lock_screen.dart';
import 'package:anzen/utils/sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().init();
  runApp(const MyApp());
}

const secureStorage = FlutterSecureStorage();
bool allowDecoy = false;
Future<bool> checkMasterPasswordExists() async {
  String? masterPassword =
      await secureStorage.read(key: 'primary_vault_master_password');
  return masterPassword != null;
}

Future<bool> checkDecoyPasswordExists() async {
  String? decoyPassword =
      await secureStorage.read(key: 'decoy_vault_master_password');
  return decoyPassword != null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anzen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff686D76),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: checkMasterPasswordExists(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.data == true) {
                return const LockScreen();
              } else {
                return const SetLockscreen();
              }
            }
          },
        ));
  }
}
