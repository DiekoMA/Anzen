import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/screens/itemdetailspage.dart';
import 'package:anzen/screens/lock_screen.dart';
import 'package:anzen/screens/settingsscreen.dart';
import 'package:anzen/screens/vaultsecurityscreen.dart';
import 'package:anzen/utils/databaseManager.dart';
import 'package:anzen/widgets/newVaultItemDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<VaultItem> vaultContents = [];

  @override
  void initState() {
    super.initState();
    retrieveVaultContents();
  }

  @override
  Future<void> retrieveVaultContents() async {
    final dbManager = DatabaseManager.instance;
    final retrievedContents = await dbManager.getMainVaultContent();
    setState(() {
      vaultContents = retrievedContents;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 20),
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              label: Text('Search vault'),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            retrieveVaultContents();
          });
        },
        child: ListView.builder(
          itemCount: vaultContents.length,
          itemBuilder: (BuildContext context, int index) {
            final vaultItem = vaultContents[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.password),
                title: Text(vaultItem.title),
                subtitle: Text(vaultItem.username),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              Itemdetailspage(vaultItemDetails: vaultItem))));
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
              IconButton(onPressed: () {}, icon: const Icon(Icons.password)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return Newvaultitemdialog();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
