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
                onDismiss: () => setState(() => _selectedLocation = null),
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
