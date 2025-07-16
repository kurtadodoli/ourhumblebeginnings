class Room {
  final String id;
  final String name;
  final String description;
  final int capacity;
  final double hourlyRate;
  final List<String> amenities;
  final String? imageUrl;
  final bool isAvailable;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    required this.hourlyRate,
    required this.amenities,
    this.imageUrl,
    this.isAvailable = true,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      capacity: json['capacity'] as int,
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      amenities: List<String>.from(json['amenities'] as List),
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'capacity': capacity,
      'hourlyRate': hourlyRate,
      'amenities': amenities,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}
