import 'package:google_map_service/data/models/google_map/place_detail_response.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

extension LocationExt on Location {
  LatLng toLatLng({bool reverse = false}) =>
      reverse ? LatLng(lng ?? 0, lat ?? 0) : LatLng(lat ?? 0, lng ?? 0);

  List<double> toCoordinates({bool reverse = false}) =>
      reverse ? [lng ?? 0, lat ?? 0] : [lat ?? 0, lng ?? 0];
}

// extension LocationDataExt on LocationData {
//   LatLng toLatLng({bool reverse = false}) => reverse
//       ? LatLng(coordinates?[1] ?? 0, coordinates?[0] ?? 0)
//       : LatLng(coordinates?[0] ?? 0, coordinates?[1] ?? 0);

//   Location toLocation() => Location(lat: coordinates![0], lng: coordinates![1]);
// }
