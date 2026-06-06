import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum LocationCategory {
  trafficLight,
  tunnel,
  roundabout,
  underpass,
  water,
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
      case LocationCategory.water:
        return const Color(0xFF3498DB);
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
      case LocationCategory.water:
        return '💧';
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
      case LocationCategory.water:
        return Icons.water;
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
}

class AshgabatData {
  static final List<MapLocation> locations = [
    // ---- TRAFFIC LIGHTS (Swetaforlar) ----
    MapLocation(
      id: 'tl_01',
      position: LatLng(37.9601, 58.3261),
      category: LocationCategory.trafficLight,
      names: {
        'tk': 'Türkmenbaşy şaýoly swetafory',
        'ru': 'Светофор на пр. Туркменбашы',
        'en': 'Turkmenbashy Ave Traffic Light',
      },
    ),
    MapLocation(
      id: 'tl_02',
      position: LatLng(37.9555, 58.3489),
      category: LocationCategory.trafficLight,
      names: {
        'tk': 'Görogly köçesi swetafory',
        'ru': 'Светофор на ул. Героглы',
        'en': 'Gorogly St Traffic Light',
      },
    ),
    MapLocation(
      id: 'tl_03',
      position: LatLng(37.9480, 58.3810),
      category: LocationCategory.trafficLight,
      names: {
        'tk': 'Bitarap Türkmenistan şaýoly swetafory',
        'ru': 'Светофор на пр. Нейтральный Туркменистан',
        'en': 'Bitarap Turkmenistan Ave Traffic Light',
      },
    ),
    MapLocation(
      id: 'tl_04',
      position: LatLng(37.9620, 58.3640),
      category: LocationCategory.trafficLight,
      names: {
        'tk': 'Magtymguly şaýoly swetafory',
        'ru': 'Светофор на пр. Махтумкули',
        'en': 'Magtymguly Ave Traffic Light',
      },
    ),
    MapLocation(
      id: 'tl_05',
      position: LatLng(37.9510, 58.3920),
      category: LocationCategory.trafficLight,
      names: {
        'tk': 'Garashsyzlyk şaýoly swetafory',
        'ru': 'Светофор на пр. Независимости',
        'en': 'Garaşsyzlyk Ave Traffic Light',
      },
    ),
    MapLocation(
      id: 'tl_06',
      position: LatLng(37.9680, 58.3380),
      category: LocationCategory.trafficLight,
      names: {
        'tk': 'Archabil şaýoly swetafory',
        'ru': 'Светофор на Арчабильском шоссе',
        'en': 'Archabıl Highway Traffic Light',
      },
    ),
    MapLocation(
      id: 'tl_07',
      position: LatLng(37.9445, 58.4150),
      category: LocationCategory.trafficLight,
      names: {
        'tk': 'Halkara aeroporty swetafory',
        'ru': 'Светофор у Международного аэропорта',
        'en': 'International Airport Traffic Light',
      },
    ),

    // ---- TUNNELS (Tuneller) ----
    MapLocation(
      id: 'tn_01',
      position: LatLng(37.9580, 58.3520),
      category: LocationCategory.tunnel,
      names: {
        'tk': 'Berzengi tuneli',
        'ru': 'Туннель Берзенги',
        'en': 'Berzengi Tunnel',
      },
    ),
    MapLocation(
      id: 'tn_02',
      position: LatLng(37.9495, 58.3745),
      category: LocationCategory.tunnel,
      names: {
        'tk': 'Şaherara tuneli No.1',
        'ru': 'Городской туннель №1',
        'en': 'City Tunnel No.1',
      },
    ),
    MapLocation(
      id: 'tn_03',
      position: LatLng(37.9720, 58.3290),
      category: LocationCategory.tunnel,
      names: {
        'tk': 'Köpetdag tuneli',
        'ru': 'Туннель Копетдаг',
        'en': 'Kopetdag Tunnel',
      },
    ),
    MapLocation(
      id: 'tn_04',
      position: LatLng(37.9530, 58.4010),
      category: LocationCategory.tunnel,
      names: {
        'tk': 'Köçe tuneli No.2',
        'ru': 'Уличный туннель №2',
        'en': 'Street Tunnel No.2',
      },
    ),
    MapLocation(
      id: 'tn_05',
      position: LatLng(37.9605, 58.3850),
      category: LocationCategory.tunnel,
      names: {
        'tk': 'Merkezi tunel',
        'ru': 'Центральный туннель',
        'en': 'Central Tunnel',
      },
    ),

    // ---- ROUNDABOUTS (Kruglar) ----
    MapLocation(
      id: 'rb_01',
      position: LatLng(37.9540, 58.3680),
      category: LocationCategory.roundabout,
      names: {
        'tk': 'Magtymguly krugy',
        'ru': 'Круг Махтумкули',
        'en': 'Magtymguly Roundabout',
      },
    ),
    MapLocation(
      id: 'rb_02',
      position: LatLng(37.9590, 58.3440),
      category: LocationCategory.roundabout,
      names: {
        'tk': 'Türkmenbaşy krugy',
        'ru': 'Круг Туркменбашы',
        'en': 'Turkmenbashy Roundabout',
      },
    ),
    MapLocation(
      id: 'rb_03',
      position: LatLng(37.9460, 58.3900),
      category: LocationCategory.roundabout,
      names: {
        'tk': 'Archabil krugy',
        'ru': 'Арчабильский круг',
        'en': 'Archabıl Roundabout',
      },
    ),
    MapLocation(
      id: 'rb_04',
      position: LatLng(37.9660, 58.3740),
      category: LocationCategory.roundabout,
      names: {
        'tk': 'Bitarap Türkmenistan krugy',
        'ru': 'Круг Нейтральный Туркменистан',
        'en': 'Bitarap Turkmenistan Roundabout',
      },
    ),
    MapLocation(
      id: 'rb_05',
      position: LatLng(37.9420, 58.4080),
      category: LocationCategory.roundabout,
      names: {
        'tk': 'Gündogar krugy',
        'ru': 'Восточный круг',
        'en': 'Eastern Roundabout',
      },
    ),
    MapLocation(
      id: 'rb_06',
      position: LatLng(37.9700, 58.3560),
      category: LocationCategory.roundabout,
      names: {
        'tk': 'Demirgazyk krugy',
        'ru': 'Северный круг',
        'en': 'Northern Roundabout',
      },
    ),

    // ---- UNDERPASSES (Päddemkalar / Piyada geçelgeleri) ----
    MapLocation(
      id: 'up_01',
      position: LatLng(37.9565, 58.3615),
      category: LocationCategory.underpass,
      names: {
        'tk': 'Garashsyzlyk köçesi päddemkasy',
        'ru': 'Подземный переход на ул. Независимости',
        'en': 'Independence St Underpass',
      },
    ),
    MapLocation(
      id: 'up_02',
      position: LatLng(37.9505, 58.3820),
      category: LocationCategory.underpass,
      names: {
        'tk': 'Bitarap Türkmenistan päddemkasy',
        'ru': 'Подземный переход Нейтральный Туркменистан',
        'en': 'Bitarap Turkmenistan Underpass',
      },
    ),
    MapLocation(
      id: 'up_03',
      position: LatLng(37.9625, 58.3490),
      category: LocationCategory.underpass,
      names: {
        'tk': 'Magtymguly şaýoly päddemkasy',
        'ru': 'Подземный переход пр. Махтумкули',
        'en': 'Magtymguly Ave Underpass',
      },
    ),
    MapLocation(
      id: 'up_04',
      position: LatLng(37.9470, 58.4020),
      category: LocationCategory.underpass,
      names: {
        'tk': 'Aeroport ýoly päddemkasy',
        'ru': 'Подземный переход аэропортовой дороги',
        'en': 'Airport Road Underpass',
      },
    ),
    MapLocation(
      id: 'up_05',
      position: LatLng(37.9640, 58.3800),
      category: LocationCategory.underpass,
      names: {
        'tk': 'Söwda merkeziniň päddemkasy',
        'ru': 'Подземный переход торгового центра',
        'en': 'Shopping Center Underpass',
      },
    ),
    MapLocation(
      id: 'up_06',
      position: LatLng(37.9515, 58.3560),
      category: LocationCategory.underpass,
      names: {
        'tk': 'Merkezi päddemka',
        'ru': 'Центральный подземный переход',
        'en': 'Central Underpass',
      },
    ),

    // ---- WATER (Suw) ----
    MapLocation(
      id: 'wt_01',
      position: LatLng(37.9480, 58.3280),
      category: LocationCategory.water,
      names: {
        'tk': 'Aşgabat suw howuzy',
        'ru': 'Ашхабадское водохранилище',
        'en': 'Ashgabat Reservoir',
      },
    ),
    MapLocation(
      id: 'wt_02',
      position: LatLng(37.9570, 58.4200),
      category: LocationCategory.water,
      names: {
        'tk': 'Köpetdag kanalы',
        'ru': 'Канал Копетдаг',
        'en': 'Kopetdag Canal',
      },
    ),
    MapLocation(
      id: 'wt_03',
      position: LatLng(37.9710, 58.3450),
      category: LocationCategory.water,
      names: {
        'tk': 'Berzengi çeşmesi',
        'ru': 'Источник Берзенги',
        'en': 'Berzengi Spring',
      },
    ),
    MapLocation(
      id: 'wt_04',
      position: LatLng(37.9550, 58.3970),
      category: LocationCategory.water,
      names: {
        'tk': 'Şäher howuzy',
        'ru': 'Городской бассейн',
        'en': 'City Pool',
      },
    ),
    MapLocation(
      id: 'wt_05',
      position: LatLng(37.9430, 58.4100),
      category: LocationCategory.water,
      names: {
        'tk': 'Gündogar kanal',
        'ru': 'Восточный канал',
        'en': 'Eastern Canal',
      },
    ),
  ];
}
