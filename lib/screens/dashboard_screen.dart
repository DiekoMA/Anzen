import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/screens/item_details_screen.dart';
import 'package:anzen/screens/lock_screen.dart';
import 'package:anzen/screens/new_vault_item_screen.dart';
import 'package:anzen/screens/password_generator_screen.dart';
import 'package:anzen/screens/settings_screen.dart';
import 'package:anzen/screens/vault_security_screen.dart';
import 'package:anzen/services/database_manager.dart';
import 'package:anzen/services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<VaultItem> vaultContents = [];
  List<VaultItem> filteredVaultContents = [];

  TextEditingController searchController = TextEditingController();
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      retrieveVaultContents();
    });
  }

  Future<void> retrieveVaultContents() async {
    final dbManager = DatabaseManager.instance;
    final retrievedContents = await dbManager.getMainVaultContent();
    setState(() {
      vaultContents = retrievedContents;
      filteredVaultContents = retrievedContents;
    });
  }

  Set<int> selectedIndexes = {};
  //int vaultLockTime = SharedPreferencesHelper().getInt("vaultlocktime") ?? 60;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              label: Text('Search vault'),
            ),
            canRequestFocus: true,
            onChanged: (value) {
              searchVault(value);
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort_by_alpha),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            retrieveVaultContents();
          });
        },
        child: vaultContents.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '-_-',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'You have no Passwords saved.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: filteredVaultContents.length,
                itemBuilder: (BuildContext context, int index) {
                  final vaultItem = filteredVaultContents[index];
                  //var siteUrl = vaultItem.url?.toLowerCase();
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.password),
                      title: Text(vaultItem.title),
                      subtitle: Text(vaultItem.username),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => Itemdetailspage(
                                    vaultItemDetails: vaultItem))));
                      },
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      ),
                  icon: const Icon(Icons.settings)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PasswordGeneratorScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.password)),
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Vaultsecurityscreen(),
                        ),
                      ),
                  icon: const Icon(Icons.security)),
              IconButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LockScreen(),
                        ),
                      ),
                  icon: const Icon(Icons.lock)),
            ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return const NewVaultitemScreen();
              },
            ),
          );
          retrieveVaultContents();
        },
        label: const Row(
          children: [Icon(Icons.add), Text('New Item')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  void searchVault(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredVaultContents = vaultContents;
      });
    } else {
      final suggestions = vaultContents.where((vaultItem) {
        final title = vaultItem.title.toLowerCase();
        final input = query.toLowerCase();

        return title.contains(input);
      }).toList();

      setState(() {
        filteredVaultContents = suggestions;
      });
    }
  }
}
