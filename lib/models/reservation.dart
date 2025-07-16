enum ReservationStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

class Reservation {
  final String id;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String roomId;
  final String roomName;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final int numberOfPeople;
  final String purpose;
  final ReservationStatus status;
  final String? specialRequests;
  final double totalCost;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.roomId,
    required this.roomName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.numberOfPeople,
    required this.purpose,
    this.status = ReservationStatus.pending,
    this.specialRequests,
    required this.totalCost,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhone: json['customerPhone'] as String,
      roomId: json['roomId'] as String,
      roomName: json['roomName'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      numberOfPeople: json['numberOfPeople'] as int,
      purpose: json['purpose'] as String,
      status: ReservationStatus.values.firstWhere(
        (e) => e.toString() == 'ReservationStatus.${json['status']}',
        orElse: () => ReservationStatus.pending,
      ),
      specialRequests: json['specialRequests'] as String?,
      totalCost: (json['totalCost'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'roomId': roomId,
      'roomName': roomName,
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'purpose': purpose,
      'status': status.toString().split('.').last,
      'specialRequests': specialRequests,
      'totalCost': totalCost,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
