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
    // Sample data - in a real app, this would come from an API
    _rooms = [
      Room(
        id: '1',
        name: 'Cozy Corner',
        description: 'Perfect for intimate family gatherings and small meetings',
        capacity: 6,
        hourlyRate: 25.00,
        amenities: ['WiFi', 'Whiteboard', 'Coffee Service'],
      ),
      Room(
        id: '2',
        name: 'The Boardroom',
        description: 'Professional space for business meetings and presentations',
        capacity: 12,
        hourlyRate: 45.00,
        amenities: ['WiFi', 'Projector', 'Whiteboard', 'Conference Phone', 'Coffee Service'],
      ),
      Room(
        id: '3',
        name: 'Garden View',
        description: 'Bright room with beautiful garden views, ideal for creative sessions',
        capacity: 8,
        hourlyRate: 35.00,
        amenities: ['WiFi', 'Natural Light', 'Flip Chart', 'Coffee Service'],
      ),
      Room(
        id: '4',
        name: 'Community Space',
        description: 'Large open area perfect for workshops and group activities',
        capacity: 20,
        hourlyRate: 60.00,
        amenities: ['WiFi', 'Sound System', 'Projector', 'Moveable Furniture', 'Coffee Service'],
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
        roomName: 'Cozy Corner',
        date: now.add(const Duration(days: 1)),
        startTime: DateTime(now.year, now.month, now.day + 1, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 12, 0),
        numberOfPeople: 4,
        purpose: 'Family Meeting',
        status: ReservationStatus.confirmed,
        totalCost: 50.00,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Reservation(
        id: '2',
        customerName: 'Sarah Johnson',
        customerEmail: 'sarah@company.com',
        customerPhone: '+1987654321',
        roomId: '2',
        roomName: 'The Boardroom',
        date: now.add(const Duration(days: 3)),
        startTime: DateTime(now.year, now.month, now.day + 3, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 16, 0),
        numberOfPeople: 8,
        purpose: 'Business Presentation',
        status: ReservationStatus.confirmed,
        specialRequests: 'Need extra chairs',
        totalCost: 90.00,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
    notifyListeners();
  }
}
