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
        title: Text(
          'Book a Room',
          style: Theme.of(context).textTheme.headlineLarge,
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
      body: Consumer<ReservationProvider>(
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
                        weekendTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF8B7355),
                        ),
                        defaultTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF3C2A1E),
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: const Color(0xFF3C2A1E),
                        ),
                        leftChevronIcon: const Icon(
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
                        Text(
                          'Number of people:',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3C2A1E),
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
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF3C2A1E),
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

                const SizedBox(height: 32),

                // Customer Details Section
                if (_selectedRoom != null) ...[
                  _buildVintageSection(
                    context,
                    title: 'Customer Details',
                    icon: Icons.person_outlined,
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
                          _buildVintageTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildVintageTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            icon: Icons.email_outlined,
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
                          _buildVintageTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildVintageTextField(
                            controller: _purposeController,
                            label: 'Purpose of Meeting',
                            icon: Icons.business_center_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the purpose';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildVintageTextField(
                            controller: _specialRequestsController,
                            label: 'Special Requests (Optional)',
                            icon: Icons.note_outlined,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Booking Summary
                  _buildVintageSection(
                    context,
                    title: 'Booking Summary',
                    icon: Icons.receipt_outlined,
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
                          _buildSummaryRow('Room', _selectedRoom!.name),
                          _buildSummaryRow('Date', DateFormat('MMM dd, yyyy').format(_selectedDate)),
                          _buildSummaryRow('Time', '${_formatTimeOfDay(_startTime)} - ${_formatTimeOfDay(_endTime)}'),
                          _buildSummaryRow('People', '$_numberOfPeople'),
                          _buildSummaryRow('Duration', '${_calculateDuration()} hours'),
                          const Divider(color: Color(0xFFE8DCC6)),
                          _buildSummaryRow(
                            'Total Cost', 
                            '₱${_calculateTotalCost().toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Book Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B4513).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: const Color(0xFFFAF0E6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Book Room',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper methods
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
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
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF3C2A1E),
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
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Description with vintage styling
                  Text(
                    room.description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color(0xFF8B7355),
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

  Widget _buildVintageTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF3C2A1E),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF8B7355),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF8B4513),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8DCC6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8DCC6), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFFAF0E6).withOpacity(0.3),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFF3C2A1E),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.w600,
              color: isTotal ? const Color(0xFF8B4513) : const Color(0xFF3C2A1E),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dateTime);
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
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
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (time != null && (time.hour > _startTime.hour ||
        (time.hour == _startTime.hour && time.minute > _startTime.minute))) {
      setState(() {
        _endTime = time;
      });
    }
  }

  int _calculateDuration() {
    return _endTime.hour - _startTime.hour;
  }

  double _calculateTotalCost() {
    if (_selectedRoom == null) return 0.0;
    final duration = _calculateDuration();
    return _selectedRoom!.hourlyRate * duration;
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate() || _selectedRoom == null) {
      return;
    }

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
      status: ReservationStatus.confirmed,
      specialRequests: _specialRequestsController.text.isNotEmpty
          ? _specialRequestsController.text
          : null,
      totalCost: _calculateTotalCost(),
      createdAt: DateTime.now(),
    );

    context.read<ReservationProvider>().addReservation(reservation);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Room booked successfully!'),
        backgroundColor: Color(0xFF8B4513),
      ),
    );

    context.go('/reservations');
  }
}

class Event {
  final String title;
  Event(this.title);
}
