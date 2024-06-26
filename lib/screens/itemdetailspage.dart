import 'package:anzen/models/vaultitem.dart';
import 'package:flutter/material.dart';

class Itemdetailspage extends StatefulWidget {
  final VaultItem vaultItemDetails;

  const Itemdetailspage({Key? key, required this.vaultItemDetails})
      : super(key: key);

  @override
  State<Itemdetailspage> createState() => _ItemdetailspageState();
}

class _ItemdetailspageState extends State<Itemdetailspage> {
  @override
  Widget build(BuildContext context) {
    final vaultItemInfo = widget.vaultItemDetails;
    return Scaffold(
      appBar: AppBar(
        title: Text(vaultItemInfo.title),
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
                subtitle: Text(vaultItemInfo.title),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Password'),
                leading: const Icon(Icons.password),
                subtitle: Text(vaultItemInfo.password),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Notes'),
                leading: const Icon(Icons.note),
                subtitle: Text(vaultItemInfo.notes!),
              ),
            ),
            const Text('Created at 24/06/2024')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
    );
  }
}
