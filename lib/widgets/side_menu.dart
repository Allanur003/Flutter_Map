import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/map_location.dart';
import '../l10n/app_localizations.dart';
import '../screens/admin_screen.dart';

class SideMenu extends StatelessWidget {
  final VoidCallback onClose;

  const SideMenu({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<<AppProvider>();
    final loc = AppLocalizations.of(context);
    final isDark = provider.isDarkMode;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.78,
      height: double.infinity,
      child: Material(
        elevation: 20,
        shadowColor: Colors.black45,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF12121F) : const Color(0xFFF8F9FC),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MenuHeader(loc: loc, isDark: isDark, onClose: onClose),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _SectionLabel(text: loc.categories, isDark: isDark),
                        const SizedBox(height: 8),
                        _AllCategoriesButton(provider: provider, loc: loc, isDark: isDark),
                        const SizedBox(height: 8),
                        ...LocationCategory.values.map((cat) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _CategoryTile(
                            category: cat,
                            isSelected: provider.selectedCategories.contains(cat),
                            provider: provider,
                            loc: loc,
                            isDark: isDark,
                          ),
                        )),
                        const SizedBox(height: 16),
                        _Divider(isDark: isDark),
                        const SizedBox(height: 16),
                        _SectionLabel(text: loc.mapMode, isDark: isDark),
                        const SizedBox(height: 8),
                        _MapModeToggle(provider: provider, loc: loc, isDark: isDark),
                        const SizedBox(height: 16),
                        _Divider(isDark: isDark),
                        const SizedBox(height: 16),
                        _SectionLabel(text: loc.language, isDark: isDark),
                        const SizedBox(height: 8),
                        _LanguageSelector(provider: provider, loc: loc, isDark: isDark),
                        const SizedBox(height: 16),
                        _Divider(isDark: isDark),
                        const SizedBox(height: 16),
                        _SectionLabel(text: loc.darkMode, isDark: isDark),
                        const SizedBox(height: 8),
                        _DarkModeToggle(provider: provider, loc: loc, isDark: isDark),
                        const SizedBox(height: 16),
                        _Divider(isDark: isDark),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            onClose();
                            final provider = context.read<<AppProvider>();
                            await provider.loadFromOverpass();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Veriler güncellendi!')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2ECC71),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.download, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Verileri Guncelle (OSM)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            onClose();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AdminScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A5F7A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Admin Panel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  final AppLocalizations loc;
  final bool isDark;
  final VoidCallback onClose;

  const _MenuHeader({required this.loc, required this.isDark, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A5F7A), Color(0xFF0D3D52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A5F7A).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.map_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            loc.menu,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;

  const _SectionLabel({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: isDark ? Colors.white38 : Colors.black38,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.08),
    );
  }
}

class _AllCategoriesButton extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  final bool isDark;

  const _AllCategoriesButton({
    required this.provider,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isAll = provider.isAllSelected;
    return GestureDetector(
      onTap: provider.toggleAllCategories,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isAll
              ? const Color(0xFF1A5F7A)
              : (isDark ? const Color(0xFF1E1E2E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAll
                ? const Color(0xFF1A5F7A)
                : (isDark ? Colors.white12 : Colors.black12),
          ),
          boxShadow: isAll
              ? [
                  BoxShadow(
                    color: const Color(0xFF1A5F7A).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isAll
                    ? Colors.white.withOpacity(0.2)
                    : (isDark ? Colors.white10 : Colors.black.withOpacity(0.06)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isAll ? Icons.layers : Icons.layers_outlined,
                color: isAll ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isAll ? loc.deselectAll : loc.selectAll,
                style: TextStyle(
                  color: isAll ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isAll
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF1A5F7A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${AshgabatData.locations.length}',
                style: TextStyle(
                  color: isAll ? Colors.white : const Color(0xFF1A5F7A),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final LocationCategory category;
  final bool isSelected;
  final AppProvider provider;
  final AppLocalizations loc;
  final bool isDark;

  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.provider,
    required this.loc,
    required this.isDark,
  });

  String _getCategoryName() {
    switch (category) {
      case LocationCategory.trafficLight:
        return loc.trafficLights;
      case LocationCategory.tunnel:
        return loc.tunnels;
      case LocationCategory.roundabout:
        return loc.roundabouts;
      case LocationCategory.underpass:
        return loc.underpasses;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = category.color;
    final count = AshgabatData.locations
        .where((l) => l.category == category)
        .length;

    return GestureDetector(
      onTap: () => provider.toggleCategory(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected
              ? catColor.withOpacity(isDark ? 0.2 : 0.1)
              : (isDark ? const Color(0xFF1E1E2E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? catColor.withOpacity(0.6) : (isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? catColor : catColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                category.icon,
                color: isSelected ? Colors.white : catColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getCategoryName(),
                    style: TextStyle(
                      color: isSelected
                          ? catColor
                          : (isDark ? Colors.white.withOpacity(0.87) : Colors.black87),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '$count ${loc.locations}',
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? catColor : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? catColor : (isDark ? Colors.white30 : Colors.black26),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapModeToggle extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  final bool isDark;

  const _MapModeToggle({
    required this.provider,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          _MapModeBtn(
            label: loc.normal,
            icon: Icons.map_outlined,
            isActive: !provider.isSatelliteMode,
            onTap: () {
              if (provider.isSatelliteMode) provider.toggleMapMode();
            },
            isDark: isDark,
          ),
          const SizedBox(width: 4),
          _MapModeBtn(
            label: loc.satellite,
            icon: Icons.satellite_alt,
            isActive: provider.isSatelliteMode,
            onTap: () {
              if (!provider.isSatelliteMode) provider.toggleMapMode();
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _MapModeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;

  const _MapModeBtn({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1A5F7A) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Colors.white : (isDark ? Colors.white54 : Colors.black45),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : (isDark ? Colors.white54 : Colors.black45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  final bool isDark;

  const _LanguageSelector({
    required this.provider,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final langs = [
      ('tk', loc.turkmen, '🇹🇲'),
      ('ru', loc.russian, '🇷🇺'),
      ('en', loc.english, '🇬🇧'),
    ];
    return Row(
      children: langs.map((item) {
        final isActive = provider.languageCode == item.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: item.$1 == 'en' ? 0 : 6),
            child: GestureDetector(
              onTap: () => provider.setLanguage(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1A5F7A)
                      : (isDark ? const Color(0xFF1E1E2E) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF1A5F7A)
                        : (isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                  ),
                ),
                child: Column(
                  children: [
                    Text(item.$3, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Colors.white
                            : (isDark ? Colors.white60 : Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DarkModeToggle extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  final bool isDark;

  const _DarkModeToggle({
    required this.provider,
    required this.loc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          _DarkModeBtn(
            label: loc.day,
            icon: Icons.wb_sunny_outlined,
            isActive: !isDark,
            onTap: () { if (isDark) provider.toggleDarkMode(); },
            isDark: isDark,
            activeColor: const Color(0xFFF39C12),
          ),
          const SizedBox(width: 4),
          _DarkModeBtn(
            label: loc.night,
            icon: Icons.nightlight_round,
            isActive: isDark,
            onTap: () { if (!isDark) provider.toggleDarkMode(); },
            isDark: isDark,
            activeColor: const Color(0xFF3498DB),
          ),
        ],
      ),
    );
  }
}

class _DarkModeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;
  final Color activeColor;

  const _DarkModeBtn({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.isDark,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? Colors.white : (isDark ? Colors.white54 : Colors.black45),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : (isDark ? Colors.white54 : Colors.black45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
