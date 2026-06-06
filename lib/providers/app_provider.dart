import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/map_location.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _languageCode = 'tk';
  bool _isSatelliteMode = false;
  Set<LocationCategory> _selectedCategories = {};
  bool _isMenuOpen = false;

  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;
  bool get isSatelliteMode => _isSatelliteMode;
  Set<LocationCategory> get selectedCategories => _selectedCategories;
  bool get isAllSelected => _selectedCategories.length == LocationCategory.values.length;
  bool get isMenuOpen => _isMenuOpen;

  AppProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _languageCode = prefs.getString('language') ?? 'tk';
    _isSatelliteMode = prefs.getBool('satellite') ?? false;
    final saved = prefs.getStringList('categories');
    if (saved != null) {
      _selectedCategories = saved
          .map((s) => LocationCategory.values.firstWhere((e) => e.name == s))
          .toSet();
    }
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
    notifyListeners();
  }

  Future<void> toggleMapMode() async {
    _isSatelliteMode = !_isSatelliteMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('satellite', _isSatelliteMode);
    notifyListeners();
  }

  Future<void> toggleCategory(LocationCategory category) async {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    await _saveCategories();
    notifyListeners();
  }

  Future<void> toggleAllCategories() async {
    if (isAllSelected) {
      _selectedCategories.clear();
    } else {
      _selectedCategories = Set.from(LocationCategory.values);
    }
    await _saveCategories();
    notifyListeners();
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'categories',
      _selectedCategories.map((e) => e.name).toList(),
    );
  }

  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    notifyListeners();
  }

  void closeMenu() {
    _isMenuOpen = false;
    notifyListeners();
  }

  List<MapLocation> get filteredLocations {
    if (_selectedCategories.isEmpty) return [];
    return AshgabatData.locations
        .where((loc) => _selectedCategories.contains(loc.category))
        .toList();
  }
}
