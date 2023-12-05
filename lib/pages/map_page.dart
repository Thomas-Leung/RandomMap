import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:random_map/Model/place_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  LatLng? _currentPosition;
  List<Place> nearbyRestaurants = [];
  String randomRestaurant = "Loading...";
  LatLng? randomRestaurantPosition;
  List<IconData> icons = [
    Icons.menu_book_rounded,
    Icons.storefront_rounded,
    Icons.restaurant_menu_rounded,
    Icons.restaurant_menu_rounded,
    Icons.local_cafe_rounded,
    Icons.ramen_dining_rounded,
    Icons.local_dining_rounded,
    Icons.takeout_dining_rounded,
    Icons.dinner_dining_rounded,
    Icons.table_restaurant_rounded,
    Icons.set_meal_rounded,
    Icons.tapas_rounded,
    Icons.rice_bowl_rounded,
    Icons.bento_rounded
  ];

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    pickARandomRestaurant();
  }

  Future<void> pickARandomRestaurant() async {
    http.Response response = await searchNearbyRestaurants(
        _currentPosition != null
            ? _currentPosition!
            : const LatLng(43.6510, -79.3470));
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
        'X-Goog-Api-Key': FlutterConfig.get("GOOGLE_MAPS_API_KEY"),
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
      body: _currentPosition == null
          ? const Center(
              child: Text("Loading..."),
            )
          : Stack(children: [
              GoogleMap(
                  // save to out controller so we have access to the location
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  initialCameraPosition: const CameraPosition(
                    target: _pGooglePlex,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                        markerId: const MarkerId("_currentLocation"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(240),
                        position: _currentPosition!),
                    Marker(
                        markerId: const MarkerId("_sourceLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: randomRestaurantPosition!)
                  }),
              Positioned(
                left: 16,
                bottom: 16,
                child: Card(
                  elevation: 8.0,
                  clipBehavior: Clip.hardEdge,
                  color: Colors.black87,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Wrap(
                        children: [
                          ListTile(
                            title: const Text(
                              'Your ramdom nearby restaurant:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              await pickARandomRestaurant();
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              icons[Random().nextInt(icons.length)],
                              color: Colors.white70,
                            ),
                            title: Text(
                              randomRestaurant,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: randomRestaurant));
                            },
                          )
                        ],
                      )),
                ),
              ),
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

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentPosition!);
        });
      }
    });
  }
}
