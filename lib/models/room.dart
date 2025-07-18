class Room {
  final String id;
  final String name;
  final String description;
  final int capacity;
  final double hourlyRate;
  final List<String> amenities;
  final String? imageUrl;
  final List<String> imageUrls; // Multiple images for gallery
  final bool isAvailable;
  final List<String> availabilityDays;
  final String? specialNotes;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    required this.hourlyRate,
    required this.amenities,
    this.imageUrl,
    this.imageUrls = const [],
    this.isAvailable = true,
    this.availabilityDays = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    this.specialNotes,
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
      imageUrls: json['imageUrls'] != null 
        ? List<String>.from(json['imageUrls'] as List)
        : const [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      availabilityDays: json['availabilityDays'] != null 
        ? List<String>.from(json['availabilityDays'] as List)
        : const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
      specialNotes: json['specialNotes'] as String?,
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
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
      'availabilityDays': availabilityDays,
      'specialNotes': specialNotes,
    };
  }
}
