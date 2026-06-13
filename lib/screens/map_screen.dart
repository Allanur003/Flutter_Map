import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
              if (provider.routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: provider.routePoints,
                      color: const Color(0xFF2d6a4f),
                      strokeWidth: 4,
                    ),
                    Polyline(
                      points: provider.routePoints,
                      color: const Color(0xFF52b788),
                      strokeWidth: 2,
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
              onTap: () => _closeMenu(provider),
              child: AnimatedBuilder(
                animation: _menuAnimation,
                builder: (context, _) => Container(
                  color: Colors.black.withOpacity(0.4 * _menuAnimation.value),
                ),
              ),
            ),
          AnimatedBuilder(
            animation: _menuAnimation,
            builder: (context, child) {
              final offset = (1.0 - _menuAnimation.value) * -(size.width * 0.78);
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: SideMenu(
              onClose: () => _closeMenu(provider),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  _MenuButton(
                    onTap: () => _toggleMenu(provider),
                    isOpen: provider.isMenuOpen,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TitleCard(title: loc.appTitle, isDark: isDark),
                  ),
                ],
              ),
            ),
          ),
          FloatingControls(mapController: _mapController),
          if (_selectedLocation != null)
            Positioned(
              bottom: 90,
              left: 16,
              right: 16,
              child: LocationInfoCard(
                location: _selectedLocation!,
                langCode: provider.languageCode,
                onDismiss: () => setState(() {
                  _selectedLocation = null;
                  provider.clearRoute();
                }),
              ),
            ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 160,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: provider.routeDistance != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aralyk: ${(provider.routeDistance! / 1000).toStringAsFixed(1)} km',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                if (provider.routeDuration != null)
                                  Text(
                                    'Süre: ${provider.routeDuration! ~/ 60} dk',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    ),
                                  ),
                              ],
                            )
                          : Text(
                              '',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        await provider.drawRouteToLocation(_selectedLocation!);
                        if (provider.routePoints.isNotEmpty) {
                          final bounds = LatLngBounds.fromPoints(provider.routePoints);
                          _mapController.fitCamera(
                            CameraFit.bounds(
                              bounds: bounds,
                              padding: const EdgeInsets.all(60),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A5F7A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.route, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Yoly Çyz',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (provider.selectedCategories.isEmpty)
            Center(
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.black : Colors.white).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    loc.noMarkersSelected,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isOpen;
  final bool isDark;

  const _MenuButton({
    required this.onTap,
    required this.isOpen,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isOpen
              ? const Color(0xFF1A5F7A)
              : (isDark ? const Color(0xFF1E1E2E) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          isOpen ? Icons.close : Icons.menu,
          color: isOpen
              ? Colors.white
              : (isDark ? Colors.white : const Color(0xFF1A5F7A)),
          size: 22,
        ),
      ),
    );
  }
}

class _TitleCard extends StatelessWidget {
  final String title;
  final bool isDark;

  const _TitleCard({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF1A5F7A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A5F7A),
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
