import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:random_map/models/place_model.dart';
import 'package:random_map/widgets/random_result_widget.dart';
import 'package:random_map/widgets/selection_fab.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  static const LatLng _torontoLocation = LatLng(43.6510, -79.3470);
  LatLng? _currentPosition;
  List<Place> nearbyRestaurants = [];
  String randomRestaurant = "Loading...";
  LatLng? randomRestaurantPosition;
  bool isBottomSheeUp = true;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    // pickARandomRestaurant();
  }

  Future<void> pickARandomRestaurant() async {
    http.Response response = await searchNearbyRestaurants(
        _currentPosition != null ? _currentPosition! : _torontoLocation);
    if (response.statusCode == 200) {
      Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      nearbyRestaurants = List<Place>.from(
          result["places"].map((model) => Place.fromJson(model)));
      Place randomResult =
          nearbyRestaurants[Random().nextInt(nearbyRestaurants.length)];
      setState(() {
        randomRestaurant = randomResult.displayName.text;
        randomRestaurantPosition = LatLng(
            randomResult.location.latitude, randomResult.location.longitude);
      });
    } else {
      throw Exception('Failed to load nearby restaurants');
    }
  }

  Future<http.Response> searchNearbyRestaurants(LatLng latLng) {
    return http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Goog-Api-Key': dotenv.env["GOOGLE_MAPS_API_KEY"]!,
        'X-Goog-FieldMask': 'places.displayName,places.id,places.location'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: const SelectionFAB(),
      body: Stack(children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            // save to our controller so we have access to the location
            onMapCreated: ((GoogleMapController controller) =>
                _mapController.complete(controller)),
            initialCameraPosition: const CameraPosition(
              target: _torontoLocation,
              zoom: 15,
            ),
            // markers: {
            //   Marker(
            //       markerId: const MarkerId("_currentLocation"),
            //       icon: BitmapDescriptor.defaultMarkerWithHue(240),
            //       position: _currentPosition!),
            //   Marker(
            //       markerId: const MarkerId("_sourceLocation"),
            //       icon: BitmapDescriptor.defaultMarker,
            //       position: randomRestaurantPosition!)
            // },
          ),
        ),
        RandomResultWidget()
      ]),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 14);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData currentLocation = await _locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        _currentPosition = LatLng(
            currentLocation.latitude! - 0.008, currentLocation.longitude!);
        _cameraToPosition(_currentPosition!);
      });
    }
  }
}
