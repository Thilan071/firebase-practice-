class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? statusMessage;
  final List<String> groups;
  final bool isAdmin;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.statusMessage,
    this.groups = const [],
    this.isAdmin = false,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      statusMessage: map['statusMessage'],
      groups: List<String>.from(map['groups'] ?? []),
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'statusMessage': statusMessage,
      'groups': groups,
      'isAdmin': isAdmin,
    };
  }
}
