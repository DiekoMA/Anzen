import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/screens/itemdetailspage.dart';
import 'package:anzen/screens/lock_screen.dart';
import 'package:anzen/screens/new_vaultitem_screen.dart';
import 'package:anzen/screens/password_generator_screen.dart';
import 'package:anzen/screens/settingsscreen.dart';
import 'package:anzen/screens/vaultsecurityscreen.dart';
import 'package:anzen/utils/databaseManager.dart';
import 'package:anzen/widgets/new_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<VaultItem> vaultContents = [];

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
    });
  }

  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: editMode
          ? AppBar(
              title: const Text('Edit mode'),
            )
          : AppBar(
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
                  onChanged: searchVault,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt),
                )
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
                    Text('You have no Passwords saved.'),
                    Text('-_-'),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: vaultContents.length,
                itemBuilder: (BuildContext context, int index) {
                  final vaultItem = vaultContents[index];
                  var siteUrl = vaultItem.website?.toLowerCase();
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.password),
                      title: Text(vaultItem.title),
                      subtitle: Text(vaultItem.username),
                      onLongPress: () {
                        setState(() {
                          editMode = true;
                          if (selectedIndexes.contains(index)) {
                            selectedIndexes.remove(index);
                          } else {
                            selectedIndexes.add(index);
                          }
                        });
                      },
                      selected: selectedIndexes.contains(index),
                      selectedTileColor: Colors.blue.withOpacity(0.5),
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
                          builder: (context) => const Settingsscreen(),
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
    final suggestions = vaultContents.where((vaultItem) {
      final title = vaultItem.title.toLowerCase();
      final input = query.toLowerCase();

      return title.contains(input);
    }).toList();

    setState(() {
      vaultContents = suggestions;
    });
  }
}
