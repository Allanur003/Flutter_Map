import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class FloatingControls extends StatelessWidget {
  final MapController mapController;

  static const LatLng _ashgabatCenter = LatLng(37.9601, 58.3261);

  const FloatingControls({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;

    return Positioned(
      bottom: 24,
      right: 16,
      child: Column(
        children: [
          // Zoom in
          _FabButton(
            icon: Icons.add,
            onTap: () {
              final zoom = mapController.camera.zoom;
              if (zoom < 19) {
                mapController.move(
                  mapController.camera.center,
                  zoom + 1,
                );
              }
            },
            isDark: isDark,
          ),
          const SizedBox(height: 6),
          // Zoom out
          _FabButton(
            icon: Icons.remove,
            onTap: () {
              final zoom = mapController.camera.zoom;
              if (zoom > 5) {
                mapController.move(
                  mapController.camera.center,
                  zoom - 1,
                );
              }
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _FabButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final Color? color;
  final bool isMain;

  const _FabButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.color,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? (isDark ? const Color(0xFF1E1E2E) : Colors.white);
    final iconColor = color != null
        ? Colors.white
        : (isDark ? Colors.white70 : const Color(0xFF1A5F7A));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isMain ? 50 : 44,
        height: isMain ? 50 : 44,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(isMain ? 15 : 12),
          boxShadow: [
            BoxShadow(
              color: (color ?? Colors.black).withOpacity(isMain ? 0.35 : 0.18),
              blurRadius: isMain ? 14 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: isMain ? 22 : 20),
      ),
    );
  }
}
