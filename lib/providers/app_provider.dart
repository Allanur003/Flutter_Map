import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong2/latlong.dart';
import '../models/map_location.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _languageCode = 'tk';
  bool _isSatelliteMode = false;
  Set<LocationCategory> _selectedCategories = {};
  bool _isMenuOpen = false;
  LatLng? _currentPosition;
  double? _routeDistance;

  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;
  bool get isSatelliteMode => _isSatelliteMode;
  Set<LocationCategory> get selectedCategories => _selectedCategories;
  bool get isAllSelected => _selectedCategories.length == LocationCategory.values.length;
  bool get isMenuOpen => _isMenuOpen;
  LatLng? get currentPosition => _currentPosition;
  double? get routeDistance => _routeDistance;

  AppProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _languageCode = prefs.getString('language') ?? 'tk';
    _isSatelliteMode = prefs.getBool('satellite') ?? false;
    final saved = prefs.getStringList('categories');
    if (saved != null && saved.isNotEmpty) {
      _selectedCategories = saved
          .map((s) => LocationCategory.values.firstWhere(
                (e) => e.name == s,
                orElse: () => LocationCategory.trafficLight,
              ))
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

  Future<void> getCurrentLocation() async {
    final location = loc.Location();
    
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permission = await location.hasPermission();
    if (permission == loc.PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != loc.PermissionStatus.granted) return;
    }

    final locationData = await location.getLocation();
    _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    notifyListeners();
  }

  void setRouteDistance(double distance) {
    _routeDistance = distance;
    notifyListeners();
  }

  void clearRoute() {
    _routeDistance = null;
    notifyListeners();
  }

  List<MapLocation> get filteredLocations {
    if (_selectedCategories.isEmpty) return [];
    return AshgabatData.locations
        .where((loc) => _selectedCategories.contains(loc.category))
        .toList();
  }
}
