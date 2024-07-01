import 'package:anzen/customwidgets/PasswordBox.dart';
import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/utils/databaseManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Itemdetailspage extends StatefulWidget {
  final VaultItem vaultItemDetails;

  const Itemdetailspage({Key? key, required this.vaultItemDetails})
      : super(key: key);

  @override
  State<Itemdetailspage> createState() => _ItemdetailspageState();
}

class _ItemdetailspageState extends State<Itemdetailspage> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController notesTextEditingController = TextEditingController();

  bool editMode = false;
  bool obscurePassword = true;
  VaultItem? vaultItemInfo;
  @override
  void initState() {
    super.initState();
    vaultItemInfo = widget.vaultItemDetails;
    usernameTextEditingController.text = widget.vaultItemDetails.title;
    passwordTextEditingController.text = widget.vaultItemDetails.password;
    notesTextEditingController.text = widget.vaultItemDetails.notes!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vaultItemInfo!.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_outline),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              child: ListTile(
                title: const Text('Username'),
                leading: const Icon(Icons.alternate_email),
                subtitle: TextField(
                  controller: usernameTextEditingController,
                  decoration: InputDecoration(
                    enabled: editMode,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            // Card(
            //   child: ListTile(
            //     leading: const Icon(Icons.password),
            //     subtitle: Passwordbox(
            //       enabled: editMode,
            //       title: 'Password',
            //       borderRadius: 8,
            //       textEditingController: passwordTextEditingController,
            //     ),
            //   ),
            // ),
            Card(
              child: ListTile(
                title: const Text('Notes'),
                leading: const Icon(Icons.note),
                subtitle: TextField(
                  controller: notesTextEditingController,
                  decoration: InputDecoration(
                    enabled: editMode,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // widget.vaultItemDetails.password = value;
                      DatabaseManager.instance
                          .updateVaultItem(widget.vaultItemDetails);
                    });
                  },
                ),
              ),
            ),
            const Text('Created at 24/06/2024')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            editMode = !editMode;
          });
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
    );
  }
}
