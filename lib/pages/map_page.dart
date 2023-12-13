import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:random_map/models/nearby_search_model.dart';
import 'package:random_map/widgets/message_widget.dart';

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
  bool isBottomSheeUp = true;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              getLocationUpdates();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location_outlined),
          ),
          const SizedBox(
            height: 16,
          ),
          const SelectionFAB()
        ],
      ),
      body: Consumer<NearbySearchModel>(
          builder: (context, nearbySearchModel, child) {
        if (kIsWeb) {
          markers.add(Marker(
              markerId: const MarkerId("_currentLocation"),
              icon: BitmapDescriptor.defaultMarkerWithHue(240),
              position: nearbySearchModel.currPosition));
        }
        if (nearbySearchModel.randomRestaurant != null) {
          LatLng position = LatLng(
              nearbySearchModel.randomRestaurant!.location.latitude,
              nearbySearchModel.randomRestaurant!.location.longitude);
          markers.add(Marker(
            markerId: const MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: position,
          ));
          _cameraToPosition(
              LatLng(position.latitude - 0.008, position.longitude));
        }

        return Stack(children: [
          GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              // save to our controller so we have access to the location
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: const CameraPosition(
                target: _torontoLocation,
                zoom: 15,
              ),
              markers: markers),
          nearbySearchModel.randomRestaurant != null
              ? const RandomResultWidget()
              : const MessageWidget()
        ]);
      }),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 14);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> initLocation() async {
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
  }

  void getLocationUpdates() async {
    LocationData currentLocation = await _locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      LatLng currPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      if (!context.mounted) return;
      // update the current posisiton without affecting the UI
      Provider.of<NearbySearchModel>(context, listen: false)
          .setCurrentPosition(currPosition);
      _cameraToPosition(
          LatLng(currPosition.latitude - 0.008, currPosition.longitude));
    }
  }
}
