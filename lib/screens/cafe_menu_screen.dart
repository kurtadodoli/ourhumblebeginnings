import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/cafe_provider.dart';
import '../models/menu_item.dart';

class CafeMenuScreen extends StatelessWidget {
  const CafeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5), // Warm cream background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF0E6),
        title: const Text(
          'Café Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: Color(0xFF3C2A1E),
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF3C2A1E)),
          onPressed: () => context.go('/'),
        ),
        actions: [
          Consumer<CafeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (provider.cart.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${provider.cart.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _showCartDialog(context, provider),
              );
            },
          ),
        ],
      ),
      body: Consumer<CafeProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Category Filter
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.menuCategories.length,
                  itemBuilder: (context, index) {
                    final category = provider.menuCategories[index];
                    final isSelected = category == provider.selectedCategory;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => provider.setSelectedCategory(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF8B4513).withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected 
                                  ? const Color(0xFF8B4513)
                                  : const Color(0xFFE8DCC6),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              color: isSelected 
                                  ? const Color(0xFF8B4513)
                                  : const Color(0xFF8B7355),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: provider.filteredMenuItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.filteredMenuItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMinimalistMenuItemCard(context, item, provider),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMinimalistMenuItemCard(BuildContext context, MenuItem item, CafeProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            // Item Image Placeholder - Vintage style
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE8DCC6),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.coffee_outlined,
                color: Color(0xFF8B4513),
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2A1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B7355),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Add Button - Vintage style
            Container(
              decoration: BoxDecoration(
                color: item.isAvailable 
                    ? const Color(0xFF8B4513)
                    : const Color(0xFFE8DCC6),
                borderRadius: BorderRadius.circular(10),
                boxShadow: item.isAvailable ? [
                  BoxShadow(
                    color: const Color(0xFF8B4513).withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.isAvailable
                      ? () => provider.addToCart(item)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      item.isAvailable ? 'Add' : 'N/A',
                      style: TextStyle(
                        color: item.isAvailable 
                            ? const Color(0xFFFAF0E6)
                            : const Color(0xFF8B7355),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartDialog(BuildContext context, CafeProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Cart'),
        content: provider.cart.isEmpty
            ? const Text('Your cart is empty')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...provider.cart.map((item) => ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => provider.removeFromCart(item),
                        ),
                      )),
                  const Divider(),
                  Text(
                    'Total: \$${provider.cartTotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (provider.cart.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                provider.clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: const Text('Place Order'),
            ),
        ],
      ),
    );
  }
}
