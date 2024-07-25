class VaultItem {
  final int? id;
  final String title;
  final String username;
  final String password;
  final String? url;
  final String? notes;
  final Map<String, dynamic> extraFields;
  // final List<String>? tags;

  VaultItem(
      {this.id,
      required this.title,
      required this.username,
      required this.password,
      required this.url,
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
      'url': url,
      'notes': notes,
    };

    map.addAll(extraFields);
    return map;
  }

  factory VaultItem.fromMap(Map<String, dynamic> map) {
    final extraFields = Map<String, dynamic>.from(map);
    extraFields.removeWhere((key, value) =>
        ['id', 'title', 'username', 'password', 'url', 'notes'].contains(key));

    return VaultItem(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
      url: map['url'],
      notes: map['notes'],
      extraFields: extraFields,
      // tags: map['tags'] != null ? map['tags'].toString().split('4,') : null,
    );
  }
}
