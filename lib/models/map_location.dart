import 'dart:convert';  
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

enum LocationCategory {
  trafficLight,
  tunnel,
  roundabout,
  underpass,
}

extension LocationCategoryExtension on LocationCategory {
  Color get color {
    switch (this) {
      case LocationCategory.trafficLight:
        return const Color(0xFFFF6B35);
      case LocationCategory.tunnel:
        return const Color(0xFF2ECC71);
      case LocationCategory.roundabout:
        return const Color(0xFFE74C3C);
      case LocationCategory.underpass:
        return const Color(0xFFF39C12);
    }
  }

  String get iconEmoji {
    switch (this) {
      case LocationCategory.trafficLight:
        return '🚦';
      case LocationCategory.tunnel:
        return '🚇';
      case LocationCategory.roundabout:
        return '🔄';
      case LocationCategory.underpass:
        return '🌉';
    }
  }

  IconData get icon {
    switch (this) {
      case LocationCategory.trafficLight:
        return Icons.traffic;
      case LocationCategory.tunnel:
        return Icons.roundabout_right;
      case LocationCategory.roundabout:
        return Icons.circle_outlined;
      case LocationCategory.underpass:
        return Icons.swap_vert;
    }
  }
}

class MapLocation {
  final String id;
  final LatLng position;
  final LocationCategory category;
  final Map<String, String> names;

  const MapLocation({
    required this.id,
    required this.position,
    required this.category,
    required this.names,
  });

  String getName(String lang) => names[lang] ?? names['tk'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': position.latitude,
      'lng': position.longitude,
      'category': category.name,
      'names': names,
    };
  }

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      id: json['id'],
      position: LatLng(json['lat'], json['lng']),
      category: LocationCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      names: Map<String, String>.from(json['names']),
    );
  }
}

class AshgabatData {
  static final List<MapLocation> _defaultLocations = [
    // ---- TRAFFIC LIGHTS ----
    MapLocation(
      id: 'tl_01',
      position: LatLng(37.9601, 58.3261),
      category: LocationCategory.trafficLight,
      names: {'tk': 'Türkmenbaşy şaýoly', 'ru': 'Туркменбашы', 'en': 'Turkmenbashy'},
    ),
    MapLocation(
      id: 'tl_02',
      position: LatLng(37.9555, 58.3489),
      category: LocationCategory.trafficLight,
      names: {'tk': 'Görogly köçesi', 'ru': 'Героглы', 'en': 'Gorogly'},
    ),
    MapLocation(
      id: 'tl_03',
      position: LatLng(37.9480, 58.3810),
      category: LocationCategory.trafficLight,
      names: {'tk': 'Bitarap Türkmenistan', 'ru': 'Нейтральный Туркменистан', 'en': 'Bitarap'},
    ),
    MapLocation(
      id: 'tl_04',
      position: LatLng(37.9620, 58.3640),
      category: LocationCategory.trafficLight,
      names: {'tk': 'Magtymguly', 'ru': 'Махтумкули', 'en': 'Magtymguly'},
    ),
    MapLocation(
      id: 'tl_05',
      position: LatLng(37.9510, 58.3920),
      category: LocationCategory.trafficLight,
      names: {'tk': 'Garashsyzlyk', 'ru': 'Независимости', 'en': 'Independence'},
    ),
    MapLocation(
      id: 'tl_06',
      position: LatLng(37.9680, 58.3380),
      category: LocationCategory.trafficLight,
      names: {'tk': 'Archabil', 'ru': 'Арчабиль', 'en': 'Archabil'},
    ),
    MapLocation(
      id: 'tl_07',
      position: LatLng(37.9445, 58.4150),
      category: LocationCategory.trafficLight,
      names: {'tk': 'Aeroport', 'ru': 'Аэропорт', 'en': 'Airport'},
    ),

    // ---- TUNNELS ----
    MapLocation(
      id: 'tn_01',
      position: LatLng(37.9580, 58.3520),
      category: LocationCategory.tunnel,
      names: {'tk': 'Berzengi', 'ru': 'Берзенги', 'en': 'Berzengi'},
    ),
    MapLocation(
      id: 'tn_02',
      position: LatLng(37.9495, 58.3745),
      category: LocationCategory.tunnel,
      names: {'tk': 'Şaherara 1', 'ru': 'Городской 1', 'en': 'City 1'},
    ),
    MapLocation(
      id: 'tn_03',
      position: LatLng(37.9720, 58.3290),
      category: LocationCategory.tunnel,
      names: {'tk': 'Köpetdag', 'ru': 'Копетдаг', 'en': 'Kopetdag'},
    ),
    MapLocation(
      id: 'tn_04',
      position: LatLng(37.9530, 58.4010),
      category: LocationCategory.tunnel,
      names: {'tk': 'Köçe 2', 'ru': 'Уличный 2', 'en': 'Street 2'},
    ),
    MapLocation(
      id: 'tn_05',
      position: LatLng(37.9605, 58.3850),
      category: LocationCategory.tunnel,
      names: {'tk': 'Merkezi', 'ru': 'Центральный', 'en': 'Central'},
    ),

    // ---- ROUNDABOUTS ----
    MapLocation(
      id: 'rb_01',
      position: LatLng(37.9540, 58.3680),
      category: LocationCategory.roundabout,
      names: {'tk': 'Magtymguly', 'ru': 'Махтумкули', 'en': 'Magtymguly'},
    ),
    MapLocation(
      id: 'rb_02',
      position: LatLng(37.9590, 58.3440),
      category: LocationCategory.roundabout,
      names: {'tk': 'Türkmenbaşy', 'ru': 'Туркменбашы', 'en': 'Turkmenbashy'},
    ),
    MapLocation(
      id: 'rb_03',
      position: LatLng(37.9460, 58.3900),
      category: LocationCategory.roundabout,
      names: {'tk': 'Archabil', 'ru': 'Арчабиль', 'en': 'Archabil'},
    ),
    MapLocation(
      id: 'rb_04',
      position: LatLng(37.9660, 58.3740),
      category: LocationCategory.roundabout,
      names: {'tk': 'Bitarap', 'ru': 'Нейтральный', 'en': 'Bitarap'},
    ),
    MapLocation(
      id: 'rb_05',
      position: LatLng(37.9420, 58.4080),
      category: LocationCategory.roundabout,
      names: {'tk': 'Gündogar', 'ru': 'Восточный', 'en': 'Eastern'},
    ),
    MapLocation(
      id: 'rb_06',
      position: LatLng(37.9700, 58.3560),
      category: LocationCategory.roundabout,
      names: {'tk': 'Demirgazyk', 'ru': 'Северный', 'en': 'Northern'},
    ),

    // ---- UNDERPASSES ----
    MapLocation(
      id: 'up_01',
      position: LatLng(37.9565, 58.3615),
      category: LocationCategory.underpass,
      names: {'tk': 'Garashsyzlyk', 'ru': 'Независимости', 'en': 'Independence'},
    ),
    MapLocation(
      id: 'up_02',
      position: LatLng(37.9505, 58.3820),
      category: LocationCategory.underpass,
      names: {'tk': 'Bitarap', 'ru': 'Нейтральный', 'en': 'Bitarap'},
    ),
    MapLocation(
      id: 'up_03',
      position: LatLng(37.9625, 58.3490),
      category: LocationCategory.underpass,
      names: {'tk': 'Magtymguly', 'ru': 'Махтумкули', 'en': 'Magtymguly'},
    ),
    MapLocation(
      id: 'up_04',
      position: LatLng(37.9470, 58.4020),
      category: LocationCategory.underpass,
      names: {'tk': 'Aeroport', 'ru': 'Аэропорт', 'en': 'Airport'},
    ),
    MapLocation(
      id: 'up_05',
      position: LatLng(37.9640, 58.3800),
      category: LocationCategory.underpass,
      names: {'tk': 'Söwda', 'ru': 'Торговый', 'en': 'Shopping'},
    ),
    MapLocation(
      id: 'up_06',
      position: LatLng(37.9515, 58.3560),
      category: LocationCategory.underpass,
      names: {'tk': 'Merkezi', 'ru': 'Центральный', 'en': 'Central'},
    ),
  ];


  static List<MapLocation> locations = [];

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = locations.map((loc) => loc.toJson()).toList();
    await prefs.setString('locations', jsonEncode(jsonList));
  }


  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('locations');

    if (jsonString == null || jsonString.isEmpty) {
    
      locations = List.from(_defaultLocations);
      await save();  
    } else {
   
      final jsonList = jsonDecode(jsonString) as List;
      locations = jsonList
          .map((json) => MapLocation.fromJson(json as Map<String, dynamic>))
          .toList();
    }
  }
}
