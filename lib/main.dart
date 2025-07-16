import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/cafe_menu_screen.dart';
import 'screens/gift_shop_screen.dart';
import 'screens/reservations_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/login_screen.dart';
import 'providers/app_provider.dart';
import 'providers/reservation_provider.dart';
import 'providers/cafe_provider.dart';
import 'providers/auth_provider.dart';
import 'utils/theme.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (with placeholder values for now)
  try {
    await Supabase.initialize(
      url: SupabaseConfig.devSupabaseUrl,
      anonKey: SupabaseConfig.devSupabaseAnonKey,
    );
  } catch (e) {
    // For development, continue without Supabase if not configured
    print('Supabase initialization failed: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => CafeProvider()),
      ],
      child: MaterialApp.router(
        title: 'Our Humble Beginnings',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthWrapper(child: HomeScreen()),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const CafeMenuScreen(),
    ),
    GoRoute(
      path: '/giftshop',
      builder: (context, state) => const GiftShopScreen(),
    ),
    GoRoute(
      path: '/reservations',
      builder: (context, state) => const AuthWrapper(child: ReservationsScreen()),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingScreen(),
    ),
  ],
);

// Wrapper to handle authentication routing
class AuthWrapper extends StatelessWidget {
  final Widget child;
  
  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // If user is authenticated or in guest mode, show the child
        if (authProvider.isAuthenticated || authProvider.isGuestMode) {
          return child;
        }
        
        // Otherwise, redirect to login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go('/auth');
          }
        });
        
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
