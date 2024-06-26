class VaultItem {
  final int? id;
  final String title;
  final String username;
  final String password;
  final String? website;
  final String? notes;
  // final List<String>? tags;

  VaultItem({
    this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.website,
    this.notes,
    // this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'website': website,
      'notes': notes,
      // 'tags': tags?.join(', '),
    };
  }

  factory VaultItem.fromMap(Map<String, dynamic> map) {
    return VaultItem(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
      website: map['website'],
      notes: map['notes'],
      // tags: map['tags'] != null ? map['tags'].toString().split(',') : null,
    );
  }
}
