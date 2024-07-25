import 'package:anzen/screens/lock_screen.dart';
import 'package:anzen/services/local_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewSecureTextfield extends StatelessWidget {
  const NewSecureTextfield({
    super.key,
    required this.name,
    this.onDelete,
  });

  final String name;
  final VoidCallback? onDelete;
  final bool obscureContent = true;
  final double blurStrength = 2.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: FormBuilderTextField(
              obscureText: obscureContent,
              name: name,
              // onTap: () async {
              //   final authenticate = await LocalAuth.authenticate();
              //   if (authenticate) {
              //     try {
              //       //blurStrength = 0.0;
              //     } catch (e) {
              //       SnackBar snackBar = SnackBar(content: Text(e.toString()));
              //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //     }
              //   }
              // },
              onTapOutside: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                  label: Text(name), border: const OutlineInputBorder()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
