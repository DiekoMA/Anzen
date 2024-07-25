import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/services/database_manager.dart';
import 'package:anzen/widgets/new_hidden_textfield.dart';
import 'package:anzen/widgets/new_secure_textfield.dart';
import 'package:anzen/widgets/new_textfield.dart';
import 'package:anzen/widgets/new_toggle_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewVaultitemScreen extends StatefulWidget {
  const NewVaultitemScreen({super.key});

  @override
  State<NewVaultitemScreen> createState() => _NewVaultitemScreenState();
}

class _NewVaultitemScreenState extends State<NewVaultitemScreen> {
  final List<Widget> fields = [];
  bool obscurePassword = true;
  var categories = {'Games', 'Random', 'Other'};
  var customFieldTypes = ['Secure', 'String', 'Bool', 'Number'];
  String dropdownValue = 'Item';
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _email = '';
  String _password = '';
  String _url = '';
  String _notes = '';

  @override
  Widget build(BuildContext context) {
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
                      _formKey.currentState?.save();
                      _formKey.currentState?.validate();

                      try {
                        final vaultItem = VaultItem(
                          title: _title,
                          username: _email,
                          password: _password,
                          url: _url,
                          notes: _notes,
                        );
                        DatabaseManager.instance.insertVaultItem(vaultItem);
                        Navigator.of(context).pop();
                        //retrieveVaultContents();
                      } catch (e) {
                        var errorSnackbar =
                            SnackBar(content: Text(e.toString()));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(errorSnackbar);
                      }
                    },
                    icon: const Icon(Icons.save),
                  ),
                ],
              ))
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        clearValueOnUnregister: true,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: FormBuilderTextField(
                  name: 'entryTitle',
                  onTapOutside: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: const InputDecoration(
                    label: Text('Title'),
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                  onChanged: (value) {
                    _title = value!;
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: FormBuilderTextField(
                  name: 'entryEmail',
                  onTapOutside: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
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
                  onSaved: (value) {
                    _email = value!;
                  },
                  onChanged: (value) {
                    _email = value!;
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: FormBuilderTextField(
                  name: 'entryPassword',
                  onTapOutside: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                      label: const Text('Password'),
                      border: const OutlineInputBorder(),
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
                  onSaved: (value) {
                    _password = value!;
                  },
                  onChanged: (value) {
                    _password = value!;
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: FormBuilderTextField(
                  name: 'entryWebsite',
                  onTapOutside: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: const InputDecoration(
                      label: Text('Url'), border: OutlineInputBorder()),
                  onSaved: (value) {
                    _url = value!;
                  },
                  onChanged: (value) {
                    _url = value!;
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: FormBuilderTextField(
                  name: 'entryNote',
                  onTapOutside: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: const InputDecoration(
                    label: Text('Notes'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _notes = value!;
                  },
                  onSaved: (value) {
                    _notes = value!;
                  },
                ),
              ),
              const SizedBox(height: 12),
              ...fields,
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select a field'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      var customTextFieldTextController =
                                          TextEditingController();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Custom Field Name'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text('Cancel')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      setState(() {
                                                        fields.add(NewTextField(
                                                            key: ValueKey(
                                                                customTextFieldTextController
                                                                    .text
                                                                    .toLowerCase()),
                                                            name:
                                                                customTextFieldTextController
                                                                    .text,
                                                            onDelete: () {
                                                              fields.removeWhere((e) =>
                                                                  e.key ==
                                                                  ValueKey(
                                                                      customTextFieldTextController
                                                                          .text
                                                                          .toLowerCase()));
                                                            }));
                                                      });
                                                    },
                                                    child: const Text('Ok')),
                                              ],
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: TextField(
                                                    controller:
                                                        customTextFieldTextController,
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    title: const Text('Text'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      var customHiddenFieldTextController =
                                          TextEditingController();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Custom Field Name'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text('Cancel')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      setState(() {
                                                        fields.add(
                                                            NewHiddenTextfield(
                                                                key: ValueKey(
                                                                    customHiddenFieldTextController
                                                                        .text
                                                                        .toLowerCase()),
                                                                name:
                                                                    customHiddenFieldTextController
                                                                        .text,
                                                                onDelete: () {
                                                                  fields.removeWhere((e) =>
                                                                      e.key ==
                                                                      ValueKey(customHiddenFieldTextController
                                                                          .text
                                                                          .toLowerCase()));
                                                                }));
                                                      });
                                                    },
                                                    child: const Text('Ok')),
                                              ],
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: TextField(
                                                    controller:
                                                        customHiddenFieldTextController,
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    title: const Text('Hidden'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      var customToggleFieldTextController =
                                          TextEditingController();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Custom Field Name'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text('Cancel')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      setState(() {
                                                        fields.add(
                                                            NewToggleTextfield(
                                                                key: ValueKey(
                                                                    customToggleFieldTextController
                                                                        .text
                                                                        .toLowerCase()),
                                                                name:
                                                                    customToggleFieldTextController
                                                                        .text,
                                                                onDelete: () {
                                                                  fields.removeWhere((e) =>
                                                                      e.key ==
                                                                      ValueKey(customToggleFieldTextController
                                                                          .text
                                                                          .toLowerCase()));
                                                                }));
                                                      });
                                                    },
                                                    child: const Text('Ok')),
                                              ],
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: TextField(
                                                    controller:
                                                        customToggleFieldTextController,
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    title: const Text('Bool'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      var customSecureTextFieldTextController =
                                          TextEditingController();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Custom Field Name'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text('Cancel')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      try {
                                                        setState(() {
                                                          fields.add(
                                                              NewSecureTextfield(
                                                                  key: ValueKey(
                                                                      customSecureTextFieldTextController
                                                                          .text
                                                                          .toLowerCase()),
                                                                  name:
                                                                      customSecureTextFieldTextController
                                                                          .text,
                                                                  onDelete: () {
                                                                    fields.removeWhere((e) =>
                                                                        e.key ==
                                                                        ValueKey(customSecureTextFieldTextController
                                                                            .text
                                                                            .toLowerCase()));
                                                                  }));
                                                        });
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                    },
                                                    child: const Text('Ok')),
                                              ],
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: TextField(
                                                    controller:
                                                        customSecureTextFieldTextController,
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    title: const Text('Secure'),
                                    subtitle: const Text(
                                        'Requires a password to view even when the vault is unlocked.'),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Text('New Custom Field')),
              ),
              //DropdownButton(items: categories, onChanged: (newValue) {}),
              // DropdownButton(
              //     value: dropdownValue,
              //     items: customFieldTypes.map((String items) {
              //       return DropdownMenuItem(value: items, child: Text(items));
              //     }).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         dropdownValue = value!;
              //       });
              //     })
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
  }
}
