import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/screens/itemdetailspage.dart';
import 'package:anzen/screens/lock_screen.dart';
import 'package:anzen/screens/settingsscreen.dart';
import 'package:anzen/screens/vaultsecurityscreen.dart';
import 'package:anzen/utils/databaseManager.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<VaultItem> vaultContents = [];
  TextEditingController searchController = TextEditingController();
  bool obscurePassword = true;
  bool editMode = false;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _email = '';
  String _password = '';
  String _website = '';
  String _notes = '';

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
        child: ListView.builder(
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
                  resizeToAvoidBottomInset: true,
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
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
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
                                      retrieveVaultContents();
                                    } catch (e) {
                                      var errorSnackbar =
                                          SnackBar(content: Text(e.toString()));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(errorSnackbar);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.save),
                              ),
                            ],
                          ))
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
                              label: Text('Entry Title'),
                              icon: Icon(Icons.title),
                            ),
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
                                label: Text('Website'), icon: Icon(Icons.web)),
                            onChanged: (value) {
                              _website = value;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: InputDecoration(
                                label: const Text('TOTP'),
                                suffix: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert)),
                                icon: const Icon(Icons.lock_clock)),
                            // onSaved: (value) {
                            //   _totp = value!;
                            // },
                          ),
                          const SizedBox(height: 12),
                          PopupMenuButton(
                            onSelected: (value) {
                              switch (value) {
                                case 'TOTP':
                                  var snackbar = const SnackBar(
                                      content: Text('totp selected'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                  break;
                                default:
                              }
                            },
                            itemBuilder: ((context) {
                              return const [
                                PopupMenuItem(
                                  child: Text('TOTP'),
                                ),
                                PopupMenuItem(
                                  child: Text('Website'),
                                ),
                                PopupMenuItem(
                                  child: Text('Password'),
                                ),
                                PopupMenuItem(
                                  child: Text('Note'),
                                ),
                                PopupMenuItem(
                                  child: Text('Custom'),
                                ),
                              ];
                            }),
                            child: const Icon(Icons.add),
                          ),
                          // Expanded(
                          //   child: TextFormField(
                          //     decoration: const InputDecoration(
                          //         border: OutlineInputBorder(),
                          //         label: Text('Notes'),
                          //         icon: Icon(Icons.note)),
                          //     expands: true,
                          //     keyboardType: TextInputType.multiline,
                          //     maxLines: null,
                          //     onChanged: (value) {
                          //       _notes = value;
                          //     },
                          //   ),
                          // ),
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
