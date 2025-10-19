import 'package:google_map_service/data/models/google_map/place_detail_response.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

/// An extension on the [Location] class that provides convenient
/// conversion methods between the Google Maps API `Location` model
/// and Flutter's [LatLng] type or coordinate lists.
///
/// This helps to easily convert location data retrieved from
/// Google Maps responses into formats usable by the `google_maps_flutter` package.
extension LocationExt on Location {
  /// Converts the current [Location] object into a [LatLng] instance.
  ///
  /// The [reverse] parameter controls the order of latitude and longitude:
  /// - If `false` (default): returns `LatLng(lat, lng)`
  /// - If `true`: returns `LatLng(lng, lat)`
  ///
  /// Example:
  /// ```dart
  /// final location = Location(lat: 37.4219983, lng: -122.084);
  /// final latLng = location.toLatLng(); // LatLng(37.4219983, -122.084)
  /// ```
  LatLng toLatLng({bool reverse = false}) =>
      reverse ? LatLng(lng ?? 0, lat ?? 0) : LatLng(lat ?? 0, lng ?? 0);

  /// Converts the current [Location] object into a list of coordinates `[lat, lng]`.
  ///
  /// The [reverse] parameter determines the order of the coordinates:
  /// - If `false` (default): returns `[lat, lng]`
  /// - If `true`: returns `[lng, lat]`
  ///
  /// Example:
  /// ```dart
  /// final location = Location(lat: 37.4219983, lng: -122.084);
  /// final coords = location.toCoordinates(); // [37.4219983, -122.084]
  /// ```
  List<double> toCoordinates({bool reverse = false}) =>
      reverse ? [lng ?? 0, lat ?? 0] : [lat ?? 0, lng ?? 0];
}

// -----------------------------------------------------------------------------
// The following extension is commented out, but demonstrates how you could
// extend support for converting between `LocationData` and `Location` models.
// -----------------------------------------------------------------------------

// /// An extension on [LocationData] that provides helper methods for
// /// converting to [LatLng] and [Location] instances.
// extension LocationDataExt on LocationData {
//   /// Converts [LocationData] into a [LatLng] object.
//   ///
//   /// The [reverse] parameter allows swapping coordinate order.
//   LatLng toLatLng({bool reverse = false}) => reverse
//       ? LatLng(coordinates?[1] ?? 0, coordinates?[0] ?? 0)
//       : LatLng(coordinates?[0] ?? 0, coordinates?[1] ?? 0);

//   /// Converts [LocationData] into a [Location] instance for use
//   /// with Google Maps API models.
//   Location toLocation() => Location(lat: coordinates![0], lng: coordinates![1]);
// }
