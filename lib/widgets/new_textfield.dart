import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewTextField extends StatelessWidget {
  const NewTextField({
    super.key,
    required this.name,
    this.onDelete,
  });
  final String name;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: FormBuilderTextField(
                name: name,
                onTapOutside: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                    label: Text(name), border: const OutlineInputBorder()),
              ),
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
