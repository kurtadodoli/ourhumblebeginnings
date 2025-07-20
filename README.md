# Our Humble Beginnings 🏪☕

A beautiful Flutter mobile application for "Our Humble Beginnings" - a cozy café, gift shop, and meeting room reservation system with vintage charm.

## ✨ Features

### ☕ Café & Menu
- Browse delicious food and beverages with beautiful UI
- Filter items by category (Coffee, Food, Desserts)
- Shopping cart functionality
- Vintage-themed design with warm colors
- Real images from your café space

### 🎁 Gift Shop
- Browse unique local products and merchandise
- Categories include Coffee, Tea, Local Products, and Merchandise
- Stock management and availability checking
- Beautiful product displays

### 📅 Room Reservations
- Book meeting rooms for various purposes
- Interactive calendar for date selection
- Time slot booking system with real-time availability
- Multiple room options with different capacities
- Amenity information and special requests

### 🔐 Authentication System
- **User Accounts**: Full registration and login system
- **Guest Mode**: Explore the app without signing up
- **Supabase Integration**: Secure backend with PostgreSQL
- **Profile Management**: User profiles and preferences

### 🖼️ Visual Experience
- **Vintage Design**: Warm café-inspired color palette
- **Real Images**: Your actual café photos in the app
- **Logo Integration**: Your café logo prominently displayed
- **Photo Gallery**: Showcase your cozy space

## 🛠️ Technical Stack

- **Flutter 3.29.2** with Dart 3.7.2
- **Supabase + PostgreSQL** for backend and authentication
- **Provider** for state management
- **Go Router** for navigation
- **Material Design 3** with custom vintage theming
- **Table Calendar** for booking management
- **Cross-platform** support for Android and iOS

## 📱 Project Structure

```
lib/
├── main.dart                    # App entry point and routing
├── config/
│   └── supabase_config.dart     # Backend configuration
├── models/                      # Data models
│   ├── menu_item.dart
│   ├── gift_shop_item.dart
│   ├── reservation.dart
│   └── room.dart
├── providers/                   # State management
│   ├── app_provider.dart
│   ├── auth_provider.dart       # Authentication logic
│   ├── cafe_provider.dart
│   └── reservation_provider.dart
├── screens/                     # UI screens
│   ├── home_screen.dart         # Main landing page
│   ├── login_screen.dart        # Authentication
│   ├── cafe_menu_screen.dart
│   ├── gift_shop_screen.dart
│   ├── reservations_screen.dart
│   └── booking_screen.dart
└── utils/
    └── theme.dart               # Vintage color theme
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Supabase account (for backend)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kurtadodoli/ourhumblebeginnings.git
   cd ourhumblebeginnings
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase backend:**
   - Follow the detailed instructions in `SUPABASE_SETUP.md`
   - Update `lib/config/supabase_config.dart` with your credentials

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🔧 Backend Setup

This app uses **Supabase** for backend services. See `SUPABASE_SETUP.md` for:
- Creating your Supabase project
- Database schema setup
- Authentication configuration
- Row Level Security policies
- Sample data insertion

## 🎨 Design Philosophy

The app features a **vintage café aesthetic** inspired by warm, cozy coffee shop atmospheres:
- **Color Palette**: Coffee browns, cream whites, and warm beiges
- **Typography**: Clean, readable fonts with proper hierarchy
- **Images**: Real photos from your café space
- **User Experience**: Intuitive navigation with guest-friendly design

## 📋 Key Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.2              # State management
  go_router: ^14.2.0           # Navigation
  supabase_flutter: ^2.3.4     # Backend & auth
  table_calendar: ^3.0.9       # Calendar widget
  image_picker: ^1.1.1         # Image handling
  shared_preferences: ^2.2.3   # Local storage
  intl: ^0.19.0                # Date formatting
  http: ^1.2.1                 # HTTP requests
```

## 🔒 Security Features

- **Row Level Security (RLS)** on all database tables
- **Guest mode** for exploring without accounts
- **Secure credential management**
- **Input validation** and error handling
- **Protected routes** for authenticated features

## 🚧 Future Enhancements

- [ ] Online payment integration (Stripe/PayPal)
- [ ] Push notifications for reservations
- [ ] Admin dashboard for management
- [ ] Reviews and ratings system
- [ ] Loyalty program and rewards
- [ ] Social media integration
- [ ] Advanced analytics



## 📞 Support

For questions about setup or development:
- Check `SUPABASE_SETUP.md` for backend setup
- Review Flutter documentation for app development
- Create GitHub issues for bugs or feature requests

## 📄 License

This project is proprietary software for Our Humble Beginnings café.

---

*Built with ❤️ for the Our Humble Beginnings community*
