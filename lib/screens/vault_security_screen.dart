import 'package:anzen/services/database_manager.dart';
import 'package:flutter/material.dart';

class Vaultsecurityscreen extends StatefulWidget {
  const Vaultsecurityscreen({super.key});

  @override
  State<Vaultsecurityscreen> createState() => _VaultsecurityscreenState();
}

int repeatedPasswordCount = 0;

Future<void> getRepeatedEntries() async {
  final dbManager = DatabaseManager.instance;
  final retrievedContents = await dbManager.getMainVaultContent();
  final vaultItem = retrievedContents[retrievedContents.length];
  final repeatedPasswordCount = retrievedContents
      .where((vaultItem) {
        final password = vaultItem.password;

        if (password == password) {}
        return false;
      })
      .toList()
      .length;
}

class _VaultsecurityscreenState extends State<Vaultsecurityscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          children: [
            const Icon(Icons.security),
            SizedBox(
              width: 20,
            ),
            const Text('Vault Security')
          ],
        ),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 2,
                child: const Card(
                  child: Column(
                    children: [
                      Text('Card Header'),
                      Text(
                        '5',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 2,
                child: const Card(
                  child: Column(
                    children: [
                      Text('Card Header'),
                      Text(
                        '5',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            child: Card(
              child: ListTile(
                onTap: () {},
                title: const Text('4 Week Passwords Found.'),
                subtitle: const Text(
                    'Use symbols and numbers to make your password harder to crack, also make sure your passwords are not  '),
              ),
            ),
          ),
          SizedBox(
            child: Card(
              child: ListTile(
                onTap: () {},
                title: const Text('8 Repeated Passwords found.'),
                subtitle: const Text(
                    'Try not to use the same password for multiple accounts to reduce the chances of your account being comprimised.'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
