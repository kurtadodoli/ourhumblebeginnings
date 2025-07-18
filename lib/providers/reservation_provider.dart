import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../models/room.dart';

class ReservationProvider with ChangeNotifier {
  List<Reservation> _reservations = [];
  List<Room> _rooms = [];
  DateTime _selectedDate = DateTime.now();
  String? _selectedRoomId;

  List<Reservation> get reservations => _reservations;
  List<Room> get rooms => _rooms;
  DateTime get selectedDate => _selectedDate;
  String? get selectedRoomId => _selectedRoomId;

  List<Room> get availableRooms {
    return _rooms.where((room) => room.isAvailable).toList();
  }

  List<Reservation> get todaysReservations {
    final today = DateTime.now();
    return _reservations.where((reservation) {
      return reservation.date.year == today.year &&
          reservation.date.month == today.month &&
          reservation.date.day == today.day;
    }).toList();
  }

  List<Reservation> get upcomingReservations {
    final now = DateTime.now();
    return _reservations.where((reservation) {
      return reservation.date.isAfter(now) &&
          reservation.status != ReservationStatus.cancelled;
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedRoom(String? roomId) {
    _selectedRoomId = roomId;
    notifyListeners();
  }

  void addReservation(Reservation reservation) {
    _reservations.add(reservation);
    notifyListeners();
  }

  void updateReservationStatus(String reservationId, ReservationStatus status) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final reservation = _reservations[index];
      _reservations[index] = Reservation(
        id: reservation.id,
        customerName: reservation.customerName,
        customerEmail: reservation.customerEmail,
        customerPhone: reservation.customerPhone,
        roomId: reservation.roomId,
        roomName: reservation.roomName,
        date: reservation.date,
        startTime: reservation.startTime,
        endTime: reservation.endTime,
        numberOfPeople: reservation.numberOfPeople,
        purpose: reservation.purpose,
        status: status,
        specialRequests: reservation.specialRequests,
        totalCost: reservation.totalCost,
        createdAt: reservation.createdAt,
      );
      notifyListeners();
    }
  }

  bool isRoomAvailable(String roomId, DateTime date, DateTime startTime, DateTime endTime) {
    return !_reservations.any((reservation) =>
        reservation.roomId == roomId &&
        reservation.status != ReservationStatus.cancelled &&
        reservation.date.year == date.year &&
        reservation.date.month == date.month &&
        reservation.date.day == date.day &&
        ((startTime.isBefore(reservation.endTime) && startTime.isAfter(reservation.startTime)) ||
         (endTime.isAfter(reservation.startTime) && endTime.isBefore(reservation.endTime)) ||
         (startTime.isBefore(reservation.startTime) && endTime.isAfter(reservation.endTime))));
  }

  void loadRooms() {
    // Real room data for Our Humble Beginnings
    _rooms = [
      Room(
        id: '1',
        name: 'The Coffee Room',
        description: 'The Coffee Room is best for small meetings, conferences, and other events where guests prefer natural light (during the day).',
        capacity: 10,
        hourlyRate: 700.00,
        amenities: ['WiFi', 'Natural Light', 'Coffee Service', 'Conference Setup'],
        isAvailable: true,
        imageUrl: 'assets/caferoom/caferoom1.jpg', // Primary image
        imageUrls: ['assets/caferoom/caferoom1.jpg'], // Gallery images
        availabilityDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], // Weekdays only
        specialNotes: 'Rate is ₱700 per hour (not consumable). Available weekdays only.',
      ),
      Room(
        id: '2',
        name: 'The Cave Room',
        description: 'The Cave Room is perfect for casual hangouts and meetings, private meals, lounging, and other small gatherings.',
        capacity: 12,
        hourlyRate: 700.00,
        amenities: ['WiFi', 'Cozy Atmosphere', 'Private Dining', 'Lounge Setup'],
        isAvailable: true,
        imageUrl: 'assets/caveroom/caveroom1.jpg', // Primary image
        imageUrls: [
          'assets/caveroom/caveroom1.jpg',
          'assets/caveroom/caveroom2.jpg',
          'assets/caveroom/caveroom3.jpg',
        ], // Gallery images
        availabilityDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'], // All week
        specialNotes: 'Rate is ₱700 per hour (not consumable). Available Monday - Sunday.',
      ),
      Room(
        id: '3',
        name: 'The Humble Annex',
        description: 'The Humble Annex is great for seated dinners, birthdays, anniversary, celebrations, intimate parties, or workshops.',
        capacity: 50,
        hourlyRate: 25000.00, // Base rate for first 3 hours
        amenities: ['WiFi', 'Event Setup', 'Full Kitchen Access', 'Sound System', 'Large Space', 'Party Setup'],
        isAvailable: true,
        imageUrl: 'assets/humbleannex/humbleannex1.jpg', // Primary image
        imageUrls: [
          'assets/humbleannex/humbleannex1.jpg',
          'assets/humbleannex/humbleannex2.jpg',
          'assets/humbleannex/humbleannex3.jpg',
          'assets/humbleannex/humbleannex4.jpg',
          'assets/humbleannex/humbleannex5.jpg',
          'assets/humbleannex/humbleannex6.jpg',
          'assets/humbleannex/humbleannex7.jpg',
        ], // Gallery images
        availabilityDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'], // Monday - Thursday only
        specialNotes: '₱25,000 for first 3 hours (₱15,000 consumable). Additional ₱3,000 per hour (not consumable). Monday - Thursday only.',
      ),
    ];
    notifyListeners();
  }

  void loadReservations() {
    // Sample data - in a real app, this would come from an API
    final now = DateTime.now();
    _reservations = [
      Reservation(
        id: '1',
        customerName: 'John Smith',
        customerEmail: 'john@example.com',
        customerPhone: '+1234567890',
        roomId: '1',
        roomName: 'The Coffee Room',
        date: now.add(const Duration(days: 1)),
        startTime: DateTime(now.year, now.month, now.day + 1, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 12, 0),
        numberOfPeople: 4,
        purpose: 'Team Meeting',
        status: ReservationStatus.confirmed,
        totalCost: 1400.00, // 2 hours * ₱700
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Reservation(
        id: '2',
        customerName: 'Sarah Johnson',
        customerEmail: 'sarah@company.com',
        customerPhone: '+1987654321',
        roomId: '2',
        roomName: 'The Cave Room',
        date: now.add(const Duration(days: 3)),
        startTime: DateTime(now.year, now.month, now.day + 3, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 16, 0),
        numberOfPeople: 8,
        purpose: 'Birthday Celebration',
        status: ReservationStatus.confirmed,
        specialRequests: 'Birthday decorations setup',
        totalCost: 1400.00, // 2 hours * ₱700
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
    notifyListeners();
  }
}
