import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class FloatingControls extends StatelessWidget {
  final MapController mapController;

  const FloatingControls({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;

    return Positioned(
      bottom: 24,
      right: 16,
      child: Column(
        children: [
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

  const _FabButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white70 : const Color(0xFF1A5F7A),
          size: 20,
        ),
      ),
    );
  }
}
