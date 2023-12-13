import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:random_map/models/place_model.dart';
import 'package:random_map/models/place_types_model.dart';

class NearbySearchModel extends ChangeNotifier {
  LatLng? prevPosition;
  double? prevDistance;
  String? prevSelectedType;
  LatLng currPosition = const LatLng(43.6510, -79.3470);
  List<Place> nearbyRestaurants = [];
  Place? randomRestaurant;
  LatLng? randomRestaurantPosition;
  String msg = "Tap the search icon to search for food";

  Future<http.Response> searchNearbyRestaurants(
      LatLng latLng, double distance, String selectedType) {
    List includedTypes = [];
    switch (selectedType) {
      case "Coffee":
        includedTypes = PlaceTypes().getCoffee();
        break;
      case "Light":
        includedTypes = PlaceTypes().getLightFood();
      case "Restaurant":
        List templist = PlaceTypes().getRestaurants();
        for (var i = 0; i < 5; i++) {
          includedTypes.add(templist[Random().nextInt(templist.length)]);
        }
        break;
      default:
        includedTypes = ["restaurant"];
    }
    return http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Goog-Api-Key': dotenv.env["GOOGLE_MAPS_API_KEY"]!,
        'X-Goog-FieldMask':
            'places.id,places.location,places.displayName,places.formattedAddress,places.rating,places.userRatingCount'
      },
      body: jsonEncode(<String, dynamic>{
        "includedTypes": includedTypes,
        'maxResultCount': 20,
        "locationRestriction": {
          "circle": {
            "center": {
              "latitude": latLng.latitude,
              "longitude": latLng.longitude
            },
            "radius": distance
          }
        }
      }),
    );
  }

  Future<void> pickARandomRestaurant(
      double distance, String selectedType) async {
    if (prevPosition == currPosition &&
        prevDistance == distance &&
        prevSelectedType == selectedType &&
        nearbyRestaurants.isNotEmpty) {
      randomRestaurant =
          nearbyRestaurants[Random().nextInt(nearbyRestaurants.length)];
      notifyListeners();
      return;
    }
    http.Response response =
        await searchNearbyRestaurants(currPosition, distance, selectedType);
    if (response.statusCode == 200) {
      prevPosition = currPosition;
      prevDistance = distance;
      prevSelectedType = selectedType;
      Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (result.isEmpty) {
        msg = "Oops, can't find any result, try further distance.";
        notifyListeners();
        return;
      }
      nearbyRestaurants = List<Place>.from(
          result["places"].map((model) => Place.fromJson(model)));
      randomRestaurant =
          nearbyRestaurants[Random().nextInt(nearbyRestaurants.length)];
    } else {
      throw Exception('Failed to load nearby restaurants');
    }
    notifyListeners();
  }

  void setCurrentPosition(LatLng currPosition) {
    this.currPosition = currPosition;
  }
}
