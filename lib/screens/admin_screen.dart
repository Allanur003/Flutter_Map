import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/map_location.dart';
import '../providers/app_provider.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _tkNameController = TextEditingController();
  final _ruNameController = TextEditingController();
  final _enNameController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  
  LocationCategory _selectedCategory = LocationCategory.trafficLight;

  @override
  void dispose() {
    _idController.dispose();
    _tkNameController.dispose();
    _ruNameController.dispose();
    _enNameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _addLocation() {
    if (!_formKey.currentState!.validate()) return;

    final newLocation = MapLocation(
      id: _idController.text.trim(),
      position: LatLng(
        double.parse(_latController.text),
        double.parse(_lngController.text),
      ),
      category: _selectedCategory,
      names: {
        'tk': _tkNameController.text.trim(),
        'ru': _ruNameController.text.trim(),
        'en': _enNameController.text.trim(),
      },
    );

    // Veriyi ekle
    AshgabatData.locations.add(newLocation);
    
    // Provider'ı güncelle (haritayı yenile)
    context.read<AppProvider>().notifyListeners();

    // Formu temizle
    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lokasyon eklendi!')),
    );
  }

  void _deleteLocation(String id) {
    setState(() {
      AshgabatData.locations.removeWhere((loc) => loc.id == id);
    });
    context.read<AppProvider>().notifyListeners();
  }

  void _clearForm() {
    _idController.clear();
    _tkNameController.clear();
    _ruNameController.clear();
    _enNameController.clear();
    _latController.clear();
    _lngController.clear();
    _selectedCategory = LocationCategory.trafficLight;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color(0xFF1A5F7A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === EKLEME FORMU ===
            Text(
              'Yeni Lokasyon Ekle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // ID
                  _TextField(
                    controller: _idController,
                    label: 'ID (örn: tl_08)',
                    validator: (v) => v?.isEmpty ?? true ? 'Zorunlu' : null,
                  ),
                  const SizedBox(height: 8),
                  
                  // Kategori seçimi
                  DropdownButtonFormField<LocationCategory>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: LocationCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(_categoryName(cat)),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(height: 8),
                  
                  // İsimler
                  _TextField(
                    controller: _tkNameController,
                    label: 'Türkmençe İsim',
                    validator: (v) => v?.isEmpty ?? true ? 'Zorunlu' : null,
                  ),
                  const SizedBox(height: 8),
                  _TextField(
                    controller: _ruNameController,
                    label: 'Rusça İsim',
                  ),
                  const SizedBox(height: 8),
                  _TextField(
                    controller: _enNameController,
                    label: 'İngilizce İsim',
                  ),
                  const SizedBox(height: 8),
                  
                  // Koordinatlar
                  Row(
                    children: [
                      Expanded(
                        child: _TextField(
                          controller: _latController,
                          label: 'Enlem (Lat)',
                          keyboardType: TextInputType.number,
                          validator: (v) => v?.isEmpty ?? true ? 'Zorunlu' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _TextField(
                          controller: _lngController,
                          label: 'Boylam (Lng)',
                          keyboardType: TextInputType.number,
                          validator: (v) => v?.isEmpty ?? true ? 'Zorunlu' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Ekle butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _addLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A5F7A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('EKLE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            
            // === MEVCUT LİSTE ===
            Text(
              'Mevcut Lokasyonlar (${AshgabatData.locations.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            ...AshgabatData.locations.map((loc) => _LocationItem(
              location: loc,
              onDelete: () => _deleteLocation(loc.id),
              isDark: isDark,
            )),
          ],
        ),
      ),
    );
  }

  String _categoryName(LocationCategory cat) {
    switch (cat) {
      case LocationCategory.trafficLight: return '🚦 Swetafor';
      case LocationCategory.tunnel: return '🚇 Tunel';
      case LocationCategory.roundabout: return '🔄 Krug';
      case LocationCategory.underpass: return '🌉 Päddemka';
    }
  }
}

// === YARDIMCI WIDGETLAR ===

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _TextField({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _LocationItem extends StatelessWidget {
  final MapLocation location;
  final VoidCallback onDelete;
  final bool isDark;

  const _LocationItem({
    required this.location,
    required this.onDelete,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: location.category.color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: location.category.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(location.category.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.names['tk'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  '${location.position.latitude.toStringAsFixed(4)}, ${location.position.longitude.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
