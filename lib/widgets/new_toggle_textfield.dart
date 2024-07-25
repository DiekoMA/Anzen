import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewToggleTextfield extends StatelessWidget {
  const NewToggleTextfield({super.key, required this.name, this.onDelete});

  final String name;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: FormBuilderSwitch(
              name: name,
              title: Text(name),
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
