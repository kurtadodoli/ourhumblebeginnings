import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/reservation_provider.dart';
import '../models/reservation.dart';
import '../models/room.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();
  final _specialRequestsController = TextEditingController();
  
  Room? _selectedRoom;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  int _numberOfPeople = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5), // Warm cream background - same as home
      appBar: AppBar(
        title: const Text(
          'Book a Room',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C2A1E),
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color(0xFFFAF0E6), // Linen background
        foregroundColor: const Color(0xFF3C2A1E),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF8B4513),
            ),
          ),
          onPressed: () => context.go('/'),
        ),
      ),
        return Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Calendar Section
                _buildVintageSection(
                  context,
                  title: 'Select Date',
                  icon: Icons.calendar_today_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE8DCC6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B4513).withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TableCalendar<Event>(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _selectedDate,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        selectedDecoration: const BoxDecoration(
                          color: Color(0xFF8B4513),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF8B4513).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: const TextStyle(
                          color: Color(0xFF8B7355),
                        ),
                        defaultTextStyle: const TextStyle(
                          color: Color(0xFF3C2A1E),
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C2A1E),
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Color(0xFF8B4513),
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Room Selection Section
                _buildVintageSection(
                  context,
                  title: 'Select Room',
                  icon: Icons.meeting_room_outlined,
                  child: Column(
                    children: provider.availableRooms.map((room) => _buildRoomCard(room)).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // Time Selection Section
                _buildVintageSection(
                  context,
                  title: 'Select Time',
                  icon: Icons.access_time_outlined,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE8DCC6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B4513).withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimeSelector(
                                context,
                                'Start Time',
                                _formatTimeOfDay(_startTime),
                                Icons.play_arrow_outlined,
                                () => _selectStartTime(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTimeSelector(
                                context,
                                'End Time',
                                _formatTimeOfDay(_endTime),
                                Icons.stop_outlined,
                                () => _selectEndTime(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Number of People Section
                _buildVintageSection(
                  context,
                  title: 'Number of People',
                  icon: Icons.people_outlined,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE8DCC6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B4513).withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Number of people:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3C2A1E),
                          ),
                        ),
                        Row(
                          children: [
                            _buildCounterButton(
                              icon: Icons.remove,
                              onPressed: _numberOfPeople > 1
                                  ? () => setState(() => _numberOfPeople--)
                                  : null,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF8B4513).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                '$_numberOfPeople',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3C2A1E),
                                ),
                              ),
                            ),
                            _buildCounterButton(
                              icon: Icons.add,
                              onPressed: _selectedRoom != null && _numberOfPeople < _selectedRoom!.capacity
                                  ? () => setState(() => _numberOfPeople++)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                            IconButton(
                              onPressed: _selectedRoom != null && _numberOfPeople < _selectedRoom!.capacity
                                  ? () => setState(() => _numberOfPeople++)
                                  : null,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Customer Details
                _buildSectionTitle('Your Details'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _purposeController,
                          decoration: const InputDecoration(
                            labelText: 'Purpose of Meeting',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the purpose of your meeting';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _specialRequestsController,
                          decoration: const InputDecoration(
                            labelText: 'Special Requests (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Booking Summary
                if (_selectedRoom != null) ...[
                  _buildSectionTitle('Booking Summary'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryRow('Room', _selectedRoom!.name),
                          _buildSummaryRow('Date', DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate)),
                          _buildSummaryRow('Time', '${_formatTimeOfDay(_startTime)} - ${_formatTimeOfDay(_endTime)}'),
                          _buildSummaryRow('Duration', '${_calculateDuration()} hours'),
                          _buildSummaryRow('People', '$_numberOfPeople'),
                          const Divider(),
                          _buildSummaryRow(
                            'Total Cost',
                            '\$${_calculateTotalCost().toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Book Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedRoom != null ? () => _bookRoom(context, provider) : null,
                    child: const Text('Book Room'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    final isSelected = _selectedRoom?.id == room.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? const Color(0xFF8B4513) 
              : const Color(0xFFE8DCC6),
          width: isSelected ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withOpacity(isSelected ? 0.15 : 0.08),
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedRoom = room),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview with vintage overlay
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  room.imageUrl != null
                      ? Image.asset(
                          room.imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: const Color(0xFFFAF0E6),
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Color(0xFF8B7355),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: const Color(0xFFFAF0E6),
                          child: const Icon(
                            Icons.meeting_room,
                            size: 50,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                  
                  // Selection indicator overlay
                  if (isSelected)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF8B4513),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content with vintage styling
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3C2A1E),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF8B4513).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '₱${room.hourlyRate.toStringAsFixed(0)}/hour',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Description with vintage styling
                  Text(
                    room.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF8B7355),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Capacity and availability with vintage icons
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Up to ${room.capacity} people',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3C2A1E),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.schedule_outlined,
                          size: 16,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          room.availabilityDays.length == 7 
                              ? 'Mon - Sun' 
                              : room.availabilityDays.length == 5 
                                  ? 'Mon - Fri'
                                  : room.availabilityDays.join(', '),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3C2A1E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Amenities with vintage styling
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.amenities.map((amenity) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF0E6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE8DCC6),
                        ),
                      ),
                      child: Text(
                        amenity,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B7355),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                  
                  // Special notes with vintage styling
                  if (room.specialNotes != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2691E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD2691E).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: const Color(0xFFD2691E).withOpacity(0.8),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              room.specialNotes!,
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFFD2691E).withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // Photo gallery indicator with vintage styling
                  if (room.imageUrls.length > 1) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.photo_library_outlined,
                          size: 16,
                          color: Color(0xFF8B7355),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${room.imageUrls.length} photos available',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B7355),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (time != null) {
      setState(() {
        _startTime = time;
        // Ensure end time is after start time
        if (_endTime.hour < _startTime.hour || 
            (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute)) {
          _endTime = TimeOfDay(hour: _startTime.hour + 1, minute: _startTime.minute);
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (time != null && (time.hour > _startTime.hour || 
        (time.hour == _startTime.hour && time.minute > _startTime.minute))) {
      setState(() => _endTime = time);
    } else if (time != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
    }
  }

  double _calculateDuration() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    return (endMinutes - startMinutes) / 60.0;
  }

  double _calculateTotalCost() {
    if (_selectedRoom == null) return 0.0;
    return _selectedRoom!.hourlyRate * _calculateDuration();
  }

  void _bookRoom(BuildContext context, ReservationProvider provider) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoom == null) return;

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    
    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    // Check if room is available
    if (!provider.isRoomAvailable(_selectedRoom!.id, _selectedDate, startDateTime, endDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room is not available at the selected time')),
      );
      return;
    }

    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: _nameController.text,
      customerEmail: _emailController.text,
      customerPhone: _phoneController.text,
      roomId: _selectedRoom!.id,
      roomName: _selectedRoom!.name,
      date: _selectedDate,
      startTime: startDateTime,
      endTime: endDateTime,
      numberOfPeople: _numberOfPeople,
      purpose: _purposeController.text,
      specialRequests: _specialRequestsController.text.isNotEmpty 
          ? _specialRequestsController.text 
          : null,
      totalCost: _calculateTotalCost(),
      createdAt: DateTime.now(),
    );

    provider.addReservation(reservation);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room booked successfully!')),
    );

    context.go('/reservations');
  }

  // Vintage styling helper methods
  Widget _buildVintageSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF8B4513),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C2A1E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTimeSelector(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF8B4513).withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE8DCC6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: const Color(0xFF8B4513),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8B7355),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C2A1E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null 
            ? const Color(0xFF8B4513).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: onPressed != null 
              ? const Color(0xFF8B4513).withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: onPressed != null 
              ? const Color(0xFF8B4513)
              : Colors.grey,
        ),
        iconSize: 20,
      ),
    );
  }
}

class Event {
  final String title;
  Event(this.title);
}
