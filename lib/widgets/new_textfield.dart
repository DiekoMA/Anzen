import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewTextField extends StatelessWidget {
  const NewTextField({
    super.key,
    required this.name,
    required this.icon,
    this.onDelete,
  });
  final Icon icon;
  final String name;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: FormBuilderTextField(
              name: name,
              // validator: FormBuilderValidators.minLength(4),
              decoration: InputDecoration(
                label: Text(name),
                icon: icon,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}