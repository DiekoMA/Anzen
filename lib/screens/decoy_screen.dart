import 'package:anzen/screens/lock_screen.dart';
import 'package:flutter/material.dart';

class Decoyscreen extends StatefulWidget {
  const Decoyscreen({super.key});

  @override
  State<Decoyscreen> createState() => _DecoyscreenState();
}

class _DecoyscreenState extends State<Decoyscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Amazon'),
            subtitle: const Text('fakeemail@gmail.com'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Google'),
            subtitle: const Text('fakeemail@gmail.com'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Apple'),
            subtitle: const Text('fakeemail@gmail.com'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Youtube'),
            subtitle: const Text('fakeemail@gmail.com'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Netflix'),
            subtitle: const Text('fakeemail@gmail.com'),
            onTap: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.password)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.security)),
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
