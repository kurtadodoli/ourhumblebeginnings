import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/gift_shop_item.dart';

class CafeProvider with ChangeNotifier {
  List<MenuItem> _menuItems = [];
  List<GiftShopItem> _giftShopItems = [];
  List<MenuItem> _cart = [];
  String _selectedCategory = 'All';

  List<MenuItem> get menuItems => _menuItems;
  List<GiftShopItem> get giftShopItems => _giftShopItems;
  List<MenuItem> get cart => _cart;
  String get selectedCategory => _selectedCategory;

  List<String> get menuCategories {
    final categories = _menuItems.map((item) => item.category).toSet().toList();
    return ['All', ...categories];
  }

  List<String> get giftShopCategories {
    final categories = _giftShopItems.map((item) => item.category).toSet().toList();
    return ['All', ...categories];
  }

  List<MenuItem> get filteredMenuItems {
    if (_selectedCategory == 'All') {
      return _menuItems;
    }
    return _menuItems.where((item) => item.category == _selectedCategory).toList();
  }

  double get cartTotal {
    return _cart.fold(0.0, (total, item) => total + item.price);
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addToCart(MenuItem item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(MenuItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void loadMenuItems() {
    // Sample data - in a real app, this would come from an API
    _menuItems = [
      MenuItem(
        id: '1',
        name: 'Artisan Coffee',
        description: 'Freshly roasted coffee beans from local farmers',
        price: 4.50,
        category: 'Beverages',
      ),
      MenuItem(
        id: '2',
        name: 'Homemade Scones',
        description: 'Warm, buttery scones with jam and cream',
        price: 6.00,
        category: 'Pastries',
      ),
      MenuItem(
        id: '3',
        name: 'Avocado Toast',
        description: 'Fresh avocado on artisanal sourdough bread',
        price: 12.00,
        category: 'Breakfast',
      ),
      MenuItem(
        id: '4',
        name: 'Earl Grey Tea',
        description: 'Premium loose leaf Earl Grey tea',
        price: 3.50,
        category: 'Beverages',
      ),
      MenuItem(
        id: '5',
        name: 'Chocolate Croissant',
        description: 'Flaky pastry filled with rich dark chocolate',
        price: 5.50,
        category: 'Pastries',
      ),
    ];
    notifyListeners();
  }

  void loadGiftShopItems() {
    // Sample data - in a real app, this would come from an API
    _giftShopItems = [
      GiftShopItem(
        id: '1',
        name: 'Coffee Beans - House Blend',
        description: 'Take home our signature coffee blend',
        price: 15.00,
        category: 'Coffee',
        stockQuantity: 25,
      ),
      GiftShopItem(
        id: '2',
        name: 'Ceramic Mug',
        description: 'Handcrafted ceramic mug with our logo',
        price: 18.00,
        category: 'Merchandise',
        stockQuantity: 12,
      ),
      GiftShopItem(
        id: '3',
        name: 'Local Honey',
        description: 'Raw honey from local beekeepers',
        price: 8.50,
        category: 'Local Products',
        stockQuantity: 8,
      ),
      GiftShopItem(
        id: '4',
        name: 'Tea Sampler',
        description: 'Selection of our finest teas',
        price: 22.00,
        category: 'Tea',
        stockQuantity: 15,
      ),
    ];
    notifyListeners();
  }
}
