import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/screens/itemdetailspage.dart';
import 'package:anzen/screens/lock_screen.dart';
import 'package:anzen/screens/settingsscreen.dart';
import 'package:anzen/screens/vaultsecurityscreen.dart';
import 'package:anzen/utils/databaseManager.dart';
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
  bool obscurePassword = true;
  Future<void> retrieveVaultContents() async {
    final dbManager = DatabaseManager.instance;
    final retrievedContents = await dbManager.getMainVaultContent();
    setState(() {
      vaultContents = retrievedContents;
    });
  }

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _email = '';
  String _password = '';
  String _website = '';
  String _notes = '';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 20),
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              icon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
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
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('New Item'),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              final vaultItem = VaultItem(
                                title: _title,
                                username: _email,
                                password: _password,
                                website: _website,
                                notes: _notes,
                              );
                              DatabaseManager.instance
                                  .insertVaultItem(vaultItem);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save'),
                        ),
                      )
                    ],
                  ),
                  body: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Entry Title'),
                                icon: Icon(Icons.email)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _title = value;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Email/Username'),
                                icon: Icon(Icons.email)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: const Text('Password'),
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: obscurePassword
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                ),
                                icon: const Icon(Icons.password)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Website'),
                                icon: Icon(Icons.web)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _website = value;
                            },
                          ),
                          // const SizedBox(height: 12),
                          // TextFormField(
                          //   decoration: const InputDecoration(
                          //       border: OutlineInputBorder(),
                          //       label: Text('TOTP'),
                          //       icon: Icon(Icons.lock_clock)),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter some text';
                          //     }
                          //     return null;
                          //   },
                          //   onSaved: (value) {
                          //     _totp = value!;
                          //   },
                          // ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Notes'),
                                  icon: Icon(Icons.note)),
                              expands: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                                _notes = value;
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('New Field'),
                                    contentPadding: const EdgeInsets.all(15.0),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              label: Text('Field Name')),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          child: const Text('Submit'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.add),
                          )
                        ],
                      ),
                    ),
                  ),
                );
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
