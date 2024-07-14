class VaultItem {
  final int? id;
  final String title;
  final String username;
  final String password;
  final String? website;
  final String? notes;
  final Map<String, dynamic> extraFields;
  // final List<String>? tags;

  VaultItem({
    this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.website,
    this.notes,
    this.extraFields = const {}
    // this.tags,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'website': website,
      'notes': notes,
    };

    map.addAll(extraFields);
    return map;
  }

  factory VaultItem.fromMap(Map<String, dynamic> map) {
    final extraFields = Map<String, dynamic>.from(map);
    extraFields.removeWhere((key, value) => ['id', 'title', 'username', 'password', 'website', 'notes'].contains(key));

    return VaultItem(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
      website: map['website'],
      notes: map['notes'],
      extraFields: extraFields,
      // tags: map['tags'] != null ? map['tags'].toString().split('4,') : null,
    );
  }
}
