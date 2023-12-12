import 'package:random_map/models/display_name.dart';
import 'package:random_map/models/location_model.dart';

class Place {
  final String id;
  final String formattedAddress;
  final double rating;
  final int userRatingCount;
  final DisplayName displayName;
  final Location location;

  const Place(
      {required this.id,
      required this.formattedAddress,
      required this.rating,
      required this.userRatingCount,
      required this.displayName,
      required this.location});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      formattedAddress: json['formattedAddress'],
      rating: double.tryParse(json['rating'].toString()) ?? -1,
      userRatingCount: json['userRatingCount'],
      displayName: DisplayName.fromJson(json['displayName']),
      location: Location.fromJson(json['location']),
    );
  }
}
