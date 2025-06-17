class TrackedObject {
  final String id;
  final String name;
  final String description;
  final String location;
  final String status;
  final String userId;
  final DateTime createdAt;

  TrackedObject({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.userId,
    required this.createdAt,
  });

  TrackedObject copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    String? status,
    String? userId,
    DateTime? createdAt,
  }) {
    return TrackedObject(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'status': status,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TrackedObject.fromMap(Map<String, dynamic> map, String id) {
    return TrackedObject(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      status: map['status'] as String,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'TrackedObject(id: $id, name: $name, description: $description, location: $location, status: $status, userId: $userId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrackedObject &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.location == location &&
        other.status == status &&
        other.userId == userId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        location.hashCode ^
        status.hashCode ^
        userId.hashCode ^
        createdAt.hashCode;
  }
}
