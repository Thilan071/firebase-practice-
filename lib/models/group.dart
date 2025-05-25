class Group {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String createdBy;
  final List<String> members;
  final List<String> admins;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdBy,
    required this.members,
    required this.admins,
    required this.createdAt,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      createdBy: map['createdBy'],
      members: List<String>.from(map['members'] ?? []),
      admins: List<String>.from(map['admins'] ?? []),
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'members': members,
      'admins': admins,
      'createdAt': createdAt,
    };
  }
}
