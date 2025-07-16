# Our Humble Beginnings

A Flutter mobile application for "Our Humble Beginnings" - a cozy cafe, gift shop, and meeting room reservation system.

## Features

### 🍽️ Cafe & Menu
- Browse delicious food and beverages
- Filter items by category (Beverages, Pastries, Breakfast, etc.)
- Add items to cart and place orders
- View detailed item descriptions and prices

### 🎁 Gift Shop
- Browse unique local products and merchandise
- Categories include Coffee, Tea, Local Products, and Merchandise
- Check stock availability
- View detailed product information

### 📅 Room Reservations
- Book meeting rooms for various purposes
- Available rooms:
  - **Cozy Corner** - Perfect for intimate gatherings (6 people)
  - **The Boardroom** - Professional meetings (12 people)
  - **Garden View** - Creative sessions with natural light (8 people)
  - **Community Space** - Large workshops and activities (20 people)

### 🏢 Room Features
- Interactive calendar for date selection
- Time slot booking system
- Real-time availability checking
- Amenity information (WiFi, Projector, Whiteboard, etc.)
- Customer details management
- Special requests handling

## Technical Features

- **Cross-platform**: Compatible with Android and iOS
- **State Management**: Provider pattern for efficient state handling
- **Navigation**: Go Router for declarative routing
- **UI/UX**: Material Design 3 with custom theming
- **Calendar Integration**: Table Calendar for booking management
- **Responsive Design**: Optimized for mobile devices

## Project Structure

```
lib/
├── main.dart                    # App entry point and routing
├── models/                      # Data models
│   ├── menu_item.dart
│   ├── gift_shop_item.dart
│   ├── reservation.dart
│   └── room.dart
├── providers/                   # State management
│   ├── app_provider.dart
│   ├── cafe_provider.dart
│   └── reservation_provider.dart
└── screens/                     # UI screens
    ├── home_screen.dart
    ├── cafe_menu_screen.dart
    ├── gift_shop_screen.dart
    ├── reservations_screen.dart
    └── booking_screen.dart
```

## Dependencies

- `provider` - State management
- `go_router` - Navigation
- `table_calendar` - Calendar widget for bookings
- `intl` - Date formatting
- `http` - API communication (future implementation)
- `shared_preferences` - Local storage
- `image_picker` - Image handling
- `font_awesome_flutter` - Icons

## Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd our_humble_beginnings
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Development

### Adding New Features

1. **New Screens**: Add screen files to `lib/screens/`
2. **Data Models**: Add model classes to `lib/models/`
3. **State Management**: Extend or create new providers in `lib/providers/`
4. **Navigation**: Update routes in `main.dart`

### Code Style

- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add documentation for complex functions
- Implement proper error handling

## Future Enhancements

- [ ] User authentication and profiles
- [ ] Online payment integration
- [ ] Push notifications for reservations
- [ ] Photo uploads for menu items and rooms
- [ ] Reviews and ratings system
- [ ] Loyalty program
- [ ] Admin dashboard
- [ ] API integration for backend services
- [ ] Offline mode support

## Screenshots

*Screenshots will be added once the app is running*

## Support

For support or questions about the app, please contact the development team.

## License

This project is proprietary software for Our Humble Beginnings cafe.
