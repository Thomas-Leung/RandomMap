import 'package:random_map/Model/display_name.dart';
import 'package:random_map/Model/location_model.dart';

class Place {
  final String id;
  final DisplayName displayName;
  final Location location;

  const Place({required this.id, required this.displayName, required this.location});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      displayName: DisplayName.fromJson(json['displayName']),
      location: Location.fromJson(json['location'])
    );
  }
}
