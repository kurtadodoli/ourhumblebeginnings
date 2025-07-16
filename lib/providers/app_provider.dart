import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  int _selectedBottomNavIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  int get selectedBottomNavIndex => _selectedBottomNavIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setBottomNavIndex(int index) {
    _selectedBottomNavIndex = index;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
