import 'package:flutter/material.dart';
import '../models/map_location.dart';

class MapMarkerWidget extends StatefulWidget {
  final MapLocation location;
  final bool isSelected;
  final VoidCallback onTap;

  const MapMarkerWidget({
    super.key,
    required this.location,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MapMarkerWidget> createState() => _MapMarkerWidgetState();
}

class _MapMarkerWidgetState extends State<MapMarkerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.location.category.color;
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (isSelected)
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15 * _pulseAnimation.value),
                    border: Border.all(
                      color: color.withOpacity(0.3 * _pulseAnimation.value),
                      width: 2,
                    ),
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 42 : 34,
                height: isSelected ? 42 : 34,
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(isSelected ? 0.6 : 0.35),
                      blurRadius: isSelected ? 12 : 6,
                      spreadRadius: isSelected ? 2 : 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: isSelected ? 2.5 : 2,
                  ),
                ),
                child: Icon(
                  widget.location.category.icon,
                  color: Colors.white,
                  size: isSelected ? 20 : 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
