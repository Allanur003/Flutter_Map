import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/map_location.dart';
import '../l10n/app_localizations.dart';
import '../widgets/side_menu.dart';
import '../widgets/map_marker_widget.dart';
import '../widgets/location_info_card.dart';
import '../widgets/floating_controls.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  MapLocation? _selectedLocation;
  late AnimationController _menuAnimController;
  late Animation<double> _menuAnimation;

  static const LatLng _ashgabatCenter = LatLng(37.9601, 58.3261);

  @override
  void initState() {
    super.initState();
    _menuAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _menuAnimation = CurvedAnimation(
      parent: _menuAnimController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _menuAnimController.dispose();
    super.dispose();
  }

  void _toggleMenu(AppProvider provider) {
    provider.toggleMenu();
    if (provider.isMenuOpen) {
      _menuAnimController.forward();
    } else {
      _menuAnimController.reverse();
    }
  }

  void _closeMenu(AppProvider provider) {
    provider.closeMenu();
    _menuAnimController.reverse();
  }

  void _onMarkerTapped(MapLocation location) {
    setState(() {
      _selectedLocation = _selectedLocation?.id == location.id ? null : location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);
    final isDark = provider.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _ashgabatCenter,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 19.0,
              onTap: (_, __) {
                setState(() => _selectedLocation = null);
                if (provider.isMenuOpen) _closeMenu(provider);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: provider.isSatelliteMode
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : isDark
                        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                        : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                maxZoom: 19,
                userAgentPackageName: 'com.example.ashgabat_map',
              ),
              if (provider.currentPosition != null && _selectedLocation != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [
                        provider.currentPosition!,
                        _selectedLocation!.position,
                      ],
                      color: const Color(0xFF1A5F7A),
                      strokeWidth: 4,
                    ),
                  ],
                ),
              if (provider.currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: provider.currentPosition!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.my_location, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: provider.filteredLocations.map((location) {
                  final isSelected = _selectedLocation?.id == location.id;
                  return Marker(
                    point: location.position,
                    width: isSelected ? 52 : 40,
                    height: isSelected ? 52 : 40,
                    child: MapMarkerWidget(
                      location: location,
                      isSelected: isSelected,
                      onTap: () => _onMarkerTapped(location),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          if (provider.isMenuOpen)
            GestureDetector(
              onTap: () => _closeMenu(provider
