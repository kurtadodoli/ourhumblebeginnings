class AppConstants {
  // App Information
  static const String appName = 'Our Humble Beginnings';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.ourhumblebeginnings.com';
  static const String menuEndpoint = '/api/menu';
  static const String giftShopEndpoint = '/api/giftshop';
  static const String reservationsEndpoint = '/api/reservations';
  static const String roomsEndpoint = '/api/rooms';
  
  // Local Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String cartKey = 'shopping_cart';
  static const String favoritesKey = 'favorites';
  
  // Timing Constants
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 4.0;
  static const double buttonRadius = 12.0;
  
  // Business Hours
  static const int openingHour = 7;  // 7 AM
  static const int closingHour = 22; // 10 PM
  
  // Reservation Limits
  static const int maxReservationDays = 90;  // 3 months ahead
  static const int minReservationHours = 1;
  static const int maxReservationHours = 8;
  
  // Contact Information
  static const String phoneNumber = '+1 (555) 123-4567';
  static const String email = 'info@ourhumblebeginnings.com';
  static const String address = '123 Cozy Street, Hometown, ST 12345';
}

class AppStrings {
  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Server error. Please try again later';
  static const String validationError = 'Please check your input';
  static const String bookingConflictError = 'Room is not available at the selected time';
  
  // Success Messages
  static const String bookingSuccess = 'Room booked successfully!';
  static const String orderSuccess = 'Order placed successfully!';
  static const String cancellationSuccess = 'Reservation cancelled successfully';
  
  // General
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String tryAgain = 'Try Again';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String close = 'Close';
}
