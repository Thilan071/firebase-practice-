class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String location;
  final String groupId;
  final String groupName;
  final String createdBy;
  final List<String> attendees;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.groupId,
    required this.groupName,
    required this.createdBy,
    this.attendees = const [],
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      date: map['date'].toDate(),
      location: map['location'],
      groupId: map['groupId'],
      groupName: map['groupName'],
      createdBy: map['createdBy'],
      attendees: List<String>.from(map['attendees'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'groupId': groupId,
      'groupName': groupName,
      'createdBy': createdBy,
      'attendees': attendees,
    };
  }
}
