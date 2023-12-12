import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:random_map/models/place_model.dart';

class NearbySearchModel extends ChangeNotifier {
  int test = 0;
  LatLng currentPosition = const LatLng(43.6510, -79.3470);
  List<Place> nearbyRestaurants = [];
  Place? randomRestaurant;
  LatLng? randomRestaurantPosition;

  Future<http.Response> searchNearbyRestaurants(LatLng latLng) {
    return http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Goog-Api-Key': dotenv.env["GOOGLE_MAPS_API_KEY"]!,
        'X-Goog-FieldMask':
            'places.id,places.location,places.displayName,places.formattedAddress,places.rating,places.userRatingCount'
      },
      body: jsonEncode(<String, dynamic>{
        "includedTypes": ["restaurant"],
        'maxResultCount': 20,
        "locationRestriction": {
          "circle": {
            "center": {
              "latitude": latLng.latitude,
              "longitude": latLng.longitude
            },
            "radius": 2000.0
          }
        }
      }),
    );
  }

  Future<void> pickARandomRestaurant() async {
    http.Response response = await searchNearbyRestaurants(currentPosition);
    if (response.statusCode == 200) {
      Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      nearbyRestaurants = List<Place>.from(
          result["places"].map((model) => Place.fromJson(model)));
      randomRestaurant =
          nearbyRestaurants[Random().nextInt(nearbyRestaurants.length)];
      notifyListeners();
    } else {
      throw Exception('Failed to load nearby restaurants');
    }
    notifyListeners();
  }

  void setCurrentPosition(LatLng currentPosition) {
    this.currentPosition = currentPosition;
  }
}
