import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/cafe_provider.dart';
import '../providers/reservation_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CafeProvider>().loadMenuItems();
      context.read<CafeProvider>().loadGiftShopItems();
      context.read<ReservationProvider>().loadRooms();
      context.read<ReservationProvider>().loadReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5), // Warm cream background
      body: CustomScrollView(
        slivers: [
          // Vintage-style App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFFAF0E6),
            actions: [
              // Auth Status and Profile
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.isAuthenticated) {
                    return PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      onSelected: (value) {
                        if (value == 'logout') {
                          authProvider.signOut();
                          context.go('/auth');
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'profile',
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline, color: Color(0xFF8B4513)),
                              const SizedBox(width: 12),
                              Text(authProvider.user?.email ?? 'Profile'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Color(0xFF8B4513)),
                              SizedBox(width: 12),
                              Text('Sign Out'),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (authProvider.isGuestMode) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () => context.go('/auth'),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF8B4513).withOpacity(0.1),
                          foregroundColor: const Color(0xFF8B4513),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Sign In'),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFAF0E6), // Linen
                      Color(0xFFFFFDF5), // Cream
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/ohb/logo.jpg',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.coffee_outlined,
                              size: 32,
                              color: Color(0xFF8B4513),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'OUR HUMBLE BEGINNINGS',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3C2A1E),
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Cafe + Gift Shop',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8B7355),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vintage Welcome Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.waving_hand,
                                color: Color(0xFFD2691E),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Welcome to Our Cozy Corner',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3C2A1E),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            String welcomeText;
                            if (authProvider.isAuthenticated) {
                              final userName = authProvider.user?.userMetadata?['full_name'] ?? 
                                              authProvider.user?.email?.split('@')[0] ?? 
                                              'there';
                              welcomeText = 'Welcome back, $userName! Where every cup tells a story and every moment matters.';
                            } else if (authProvider.isGuestMode) {
                              welcomeText = 'Welcome, Guest! Explore our artisan coffee, handpicked gifts, and memorable spaces.';
                            } else {
                              welcomeText = 'Where every cup tells a story and every moment matters. Join us for artisan coffee, handpicked gifts, and memorable gatherings.';
                            }
                            
                            return Text(
                              welcomeText,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Color(0xFF8B7355),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Photo Gallery Section
                  const Text(
                    'Our Cozy Space',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2A1E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPhotoGallery(),
                  const SizedBox(height: 40),

                  // Quick Actions
                  const Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2A1E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildMinimalistActionGrid(context),
                  const SizedBox(height: 40),

                  // Today's Highlights
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Consumer2<CafeProvider, ReservationProvider>(
                    builder: (context, cafeProvider, reservationProvider, child) {
                      return Column(
                        children: [
                          // Featured Menu Item
                          if (cafeProvider.menuItems.isNotEmpty)
                            _buildMinimalistInfoCard(
                              context,
                              title: cafeProvider.menuItems.first.name,
                              subtitle: cafeProvider.menuItems.first.description,
                              trailing: '\$${cafeProvider.menuItems.first.price.toStringAsFixed(2)}',
                              icon: Icons.coffee_outlined,
                            ),
                          const SizedBox(height: 16),
                          
                          // Today's Reservations Count
                          _buildMinimalistInfoCard(
                            context,
                            title: 'Reservations Today',
                            subtitle: '${reservationProvider.todaysReservations.length} rooms booked',
                            trailing: null,
                            icon: Icons.event_outlined,
                            onTap: () => context.go('/reservations'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalistActionGrid(BuildContext context) {
    final actions = [
      {
        'title': 'Menu',
        'subtitle': 'Food & drinks',
        'icon': Icons.restaurant_outlined,
        'route': '/menu',
      },
      {
        'title': 'Gift Shop',
        'subtitle': 'Local items',
        'icon': Icons.card_giftcard_outlined,
        'route': '/giftshop',
      },
      {
        'title': 'Book Room',
        'subtitle': 'Meeting spaces',
        'icon': Icons.event_available_outlined,
        'route': '/booking',
      },
      {
        'title': 'Reservations',
        'subtitle': 'Your bookings',
        'icon': Icons.calendar_today_outlined,
        'route': '/reservations',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildMinimalistActionCard(
          context,
          title: action['title'] as String,
          subtitle: action['subtitle'] as String,
          icon: action['icon'] as IconData,
          onTap: () => context.go(action['route'] as String),
        );
      },
    );
  }

  Widget _buildMinimalistActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    // Map each action to a background image
    String? backgroundImage;
    switch (title) {
      case 'Café Menu':
        backgroundImage = 'assets/ohb/image7.jpg';
        break;
      case 'Gift Shop':
        backgroundImage = 'assets/ohb/image8.jpg';
        break;
      case 'Book Room':
        backgroundImage = 'assets/ohb/image9.jpg';
        break;
      default:
        backgroundImage = null;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8DCC6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background image (subtle)
            if (backgroundImage != null)
              Positioned.fill(
                child: Image.asset(
                  backgroundImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            // Overlay for readability
            if (backgroundImage != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ),
            // Content
            Material(
              color: backgroundImage != null ? Colors.transparent : Colors.white,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          size: 28,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C2A1E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8B7355),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalistInfoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    String? trailing,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    trailing,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGallery() {
    final List<String> images = [
      'assets/ohb/image1.jpg',
      'assets/ohb/image2.jpg',
      'assets/ohb/image3.jpg',
      'assets/ohb/image4.jpg',
      'assets/ohb/image5.jpg',
      'assets/ohb/image6.jpg',
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 12,
              right: index == images.length - 1 ? 0 : 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B4513).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B4513).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
