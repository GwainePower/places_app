import 'dart:convert';

import 'package:http/http.dart' as http;

const googleMapsApiKey = 'AIzaSyAN1J2Ccdzuk7r_bTBCZmrgcyC0h08d9xI';

class LocationHelper {
  static String generateLocationPreviewImageUrl({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:black%7Clabel:X%7C$latitude,$longitude&key=$googleMapsApiKey';
  }

  static Future<String> getPlaceAddress({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&language=ru&key=$googleMapsApiKey');
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
