import 'package:anzen/models/vaultitem.dart';
import 'package:anzen/utils/databaseManager.dart';
import 'package:anzen/widgets/new_textfield.dart';
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
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _email = '';
  String _password = '';
  String _website = '';
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
                                        website: _website,
                                        notes: _notes,
                                      );
                                      DatabaseManager.instance
                                          .insertVaultItem(vaultItem);
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'entryTitle',
                            decoration: const InputDecoration(
                              label: Text('Title'),
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
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'entryEmail',
                            decoration: const InputDecoration(
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
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'entryPassword',
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
                            onSaved: (value) {
                              _password = value!;
                            },
                            onChanged: (value) {
                              _password = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'entryWebsite',
                            decoration: const InputDecoration(
                                label: Text('Website'), icon: Icon(Icons.web)),
                            onSaved: (value) {
                              _website = value!;
                            },
                            onChanged: (value) {
                              _website = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'entryNote',
                            decoration: InputDecoration(
                                label: const Text('Notes'),
                                suffix: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert)),
                                icon: const Icon(Icons.lock_clock)),
                            onChanged: (value) {
                              _notes = value!;
                            },
                            onSaved: (value) {
                              _notes = value!;
                            },
                          ),
                          ...fields,
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
                              return [
                                PopupMenuItem(
                                  onTap: () {
                                    final newTextFieldName = 'TOTP';
                                    final newTextFieldKey = ValueKey('totp');
                                    setState(() {
                                      fields.add(NewTextField(
                                        key: newTextFieldKey,
                                        name: newTextFieldName,
                                        icon: const Icon(Icons.output),
                                        onDelete: () {
                                          fields.removeWhere((e) => e.key == newTextFieldKey);
                                        }
                                      ));
                                    });
                                  },
                                  child: const Text('TOTP'),
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  child: const Text('Website'),
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  child: const Text('Password'),
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  child: const Text('Note'),
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  child: const Text('Custom'),
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
  }
}