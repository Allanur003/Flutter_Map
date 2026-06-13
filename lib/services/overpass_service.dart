import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/map_location.dart';

class OverpassService {
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  static Future<List<MapLocation>> fetchTrafficLights() async {
    return _fetchByQuery('''
      [out:json][timeout:25];
      area["name"="Ashgabat"]->.searchArea;
      (
        node["highway"="traffic_signals"](area.searchArea);
      );
      out body;
    ''', LocationCategory.trafficLight);
  }

  static Future<List<MapLocation>> fetchTunnels() async {
    return _fetchByQuery('''
      [out:json][timeout:25];
      area["name"="Ashgabat"]->.searchArea;
      (
        way["tunnel"="yes"](area.searchArea);
        node["tunnel"="yes"](area.searchArea);
      );
      out body center;
    ''', LocationCategory.tunnel);
  }

  static Future<List<MapLocation>> fetchRoundabouts() async {
    return _fetchByQuery('''
      [out:json][timeout:25];
      area["name"="Ashgabat"]->.searchArea;
      (
        way["junction"="roundabout"](area.searchArea);
        node["junction"="roundabout"](area.searchArea);
      );
      out body center;
    ''', LocationCategory.roundabout);
  }

  static Future<List<MapLocation>> fetchUnderpasses() async {
    return _fetchByQuery('''
      [out:json][timeout:25];
      area["name"="Ashgabat"]->.searchArea;
      (
        way["highway"="footway"]["tunnel"="yes"](area.searchArea);
        way["highway"="steps"]["tunnel"="yes"](area.searchArea);
        node["highway"="footway"]["tunnel"="yes"](area.searchArea);
      );
      out body center;
    ''', LocationCategory.underpass);
  }

  static Future<List<MapLocation>> _fetchByQuery(String query, LocationCategory category) async {
    try {
      final response = await http.post(
        Uri.parse(_overpassUrl),
        body: {'data': query},
      );

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final elements = data['elements'] as List<dynamic>? ?? [];

      final results = <MapLocation>[];
      var index = 0;

      for (final element in elements) {
        final lat = element['lat'] as double?;
        final lon = element['lon'] as double?;
        final center = element['center'] as Map<String, dynamic>?;
        
        final finalLat = lat ?? center?['lat'] as double?;
        final finalLon = lon ?? center?['lon'] as double?;

        if (finalLat == null || finalLon == null) continue;

        final tags = element['tags'] as Map<String, dynamic>? ?? {};
        final name = tags['name'] as String? ?? 'Bilinmeyan';

        results.add(MapLocation(
          id: '${category.name}_$index',
          position: LatLng(finalLat, finalLon),
          category: category,
          names: {
            'tk': name,
            'ru': name,
            'en': name,
          },
        ));
        index++;
      }

      return results;
    } catch (e) {
      return [];
    }
  }

  static Future<List<MapLocation>> fetchAll() async {
    final trafficLights = await fetchTrafficLights();
    final tunnels = await fetchTunnels();
    final roundabouts = await fetchRoundabouts();
    final underpasses = await fetchUnderpasses();

    return [
      ...trafficLights,
      ...tunnels,
      ...roundabouts,
      ...underpasses,
    ];
  }
}
