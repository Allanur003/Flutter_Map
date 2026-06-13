import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  static const String _baseUrl = 'https://router.project-osrm.org/route/v1/driving';

  static Future<Map<String, dynamic>> getRouteWithDetails(LatLng start, LatLng end) async {
    final url = '$_baseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return {'points': [start, end], 'distance': 0.0, 'duration': 0.0};
      }

      final data = jsonDecode(response.body);
      final routes = data['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) {
        return {'points': [start, end], 'distance': 0.0, 'duration': 0.0};
      }

      final route = routes[0];
      final geometry = route['geometry']['coordinates'] as List<dynamic>;
      final points = geometry.map((coord) => LatLng(coord[1] as double, coord[0] as double)).toList();

      final distance = (route['distance'] as num).toDouble();
      final duration = (route['duration'] as num).toDouble();

      return {
        'points': points,
        'distance': distance,
        'duration': duration,
      };
    } catch (e) {
      return {'points': [start, end], 'distance': 0.0, 'duration': 0.0};
    }
  }
}
