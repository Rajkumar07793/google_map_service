import 'package:google_map_service/data/models/google_map/place_detail_response.dart';

class PlaceDetailByGeocodeResponse {
  PlaceDetailByGeocodeResponse({
    required this.plusCode,
    required this.results,
    required this.status,
  });

  final PlusCode? plusCode;
  final List<PlaceDetails> results;
  final String? status;

  PlaceDetailByGeocodeResponse copyWith({
    PlusCode? plusCode,
    List<PlaceDetails>? results,
    String? status,
  }) {
    return PlaceDetailByGeocodeResponse(
      plusCode: plusCode ?? this.plusCode,
      results: results ?? this.results,
      status: status ?? this.status,
    );
  }

  factory PlaceDetailByGeocodeResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailByGeocodeResponse(
      plusCode: json["plus_code"] == null
          ? null
          : PlusCode.fromJson(json["plus_code"]),
      results: json["results"] == null
          ? []
          : List<PlaceDetails>.from(
              json["results"]!.map((x) => PlaceDetails.fromJson(x)),
            ),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "plus_code": plusCode?.toJson(),
    "results": results.map((x) => x.toJson()).toList(),
    "status": status,
  };
}

// class PlusCode {
//   PlusCode({
//     required this.compoundCode,
//     required this.globalCode,
//   });

//   final String? compoundCode;
//   final String? globalCode;

//   PlusCode copyWith({
//     String? compoundCode,
//     String? globalCode,
//   }) {
//     return PlusCode(
//       compoundCode: compoundCode ?? this.compoundCode,
//       globalCode: globalCode ?? this.globalCode,
//     );
//   }

//   factory PlusCode.fromJson(Map<String, dynamic> json) {
//     return PlusCode(
//       compoundCode: json["compound_code"],
//       globalCode: json["global_code"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "compound_code": compoundCode,
//         "global_code": globalCode,
//       };
// }

// class Result {
//   Result({
//     required this.addressComponents,
//     required this.formattedAddress,
//     required this.geometry,
//     required this.navigationPoints,
//     required this.placeId,
//     required this.plusCode,
//     required this.types,
//   });

//   final List<AddressComponent> addressComponents;
//   final String? formattedAddress;
//   final Geometry? geometry;
//   final List<NavigationPoint> navigationPoints;
//   final String? placeId;
//   final PlusCode? plusCode;
//   final List<String> types;

//   Result copyWith({
//     List<AddressComponent>? addressComponents,
//     String? formattedAddress,
//     Geometry? geometry,
//     List<NavigationPoint>? navigationPoints,
//     String? placeId,
//     PlusCode? plusCode,
//     List<String>? types,
//   }) {
//     return Result(
//       addressComponents: addressComponents ?? this.addressComponents,
//       formattedAddress: formattedAddress ?? this.formattedAddress,
//       geometry: geometry ?? this.geometry,
//       navigationPoints: navigationPoints ?? this.navigationPoints,
//       placeId: placeId ?? this.placeId,
//       plusCode: plusCode ?? this.plusCode,
//       types: types ?? this.types,
//     );
//   }

//   factory Result.fromJson(Map<String, dynamic> json) {
//     return Result(
//       addressComponents: json["address_components"] == null
//           ? []
//           : List<AddressComponent>.from(json["address_components"]!
//               .map((x) => AddressComponent.fromJson(x))),
//       formattedAddress: json["formatted_address"],
//       geometry:
//           json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
//       navigationPoints: json["navigation_points"] == null
//           ? []
//           : List<NavigationPoint>.from(json["navigation_points"]!
//               .map((x) => NavigationPoint.fromJson(x))),
//       placeId: json["place_id"],
//       plusCode: json["plus_code"] == null
//           ? null
//           : PlusCode.fromJson(json["plus_code"]),
//       types: json["types"] == null
//           ? []
//           : List<String>.from(json["types"]!.map((x) => x)),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "address_components":
//             addressComponents.map((x) => x?.toJson()).toList(),
//         "formatted_address": formattedAddress,
//         "geometry": geometry?.toJson(),
//         "navigation_points": navigationPoints.map((x) => x?.toJson()).toList(),
//         "place_id": placeId,
//         "plus_code": plusCode?.toJson(),
//         "types": types.map((x) => x).toList(),
//       };
// }

// class AddressComponent {
//   AddressComponent({
//     required this.longName,
//     required this.shortName,
//     required this.types,
//   });

//   final String? longName;
//   final String? shortName;
//   final List<String> types;

//   AddressComponent copyWith({
//     String? longName,
//     String? shortName,
//     List<String>? types,
//   }) {
//     return AddressComponent(
//       longName: longName ?? this.longName,
//       shortName: shortName ?? this.shortName,
//       types: types ?? this.types,
//     );
//   }

//   factory AddressComponent.fromJson(Map<String, dynamic> json) {
//     return AddressComponent(
//       longName: json["long_name"],
//       shortName: json["short_name"],
//       types: json["types"] == null
//           ? []
//           : List<String>.from(json["types"]!.map((x) => x)),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "long_name": longName,
//         "short_name": shortName,
//         "types": types.map((x) => x).toList(),
//       };
// }

// class Geometry {
//   Geometry({
//     required this.location,
//     required this.locationType,
//     required this.viewport,
//     required this.bounds,
//   });

//   final NortheastClass? location;
//   final String? locationType;
//   final Bounds? viewport;
//   final Bounds? bounds;

//   Geometry copyWith({
//     NortheastClass? location,
//     String? locationType,
//     Bounds? viewport,
//     Bounds? bounds,
//   }) {
//     return Geometry(
//       location: location ?? this.location,
//       locationType: locationType ?? this.locationType,
//       viewport: viewport ?? this.viewport,
//       bounds: bounds ?? this.bounds,
//     );
//   }

//   factory Geometry.fromJson(Map<String, dynamic> json) {
//     return Geometry(
//       location: json["location"] == null
//           ? null
//           : NortheastClass.fromJson(json["location"]),
//       locationType: json["location_type"],
//       viewport:
//           json["viewport"] == null ? null : Bounds.fromJson(json["viewport"]),
//       bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "location": location?.toJson(),
//         "location_type": locationType,
//         "viewport": viewport?.toJson(),
//         "bounds": bounds?.toJson(),
//       };
// }

// class Bounds {
//   Bounds({
//     required this.northeast,
//     required this.southwest,
//   });

//   final NortheastClass? northeast;
//   final NortheastClass? southwest;

//   Bounds copyWith({
//     NortheastClass? northeast,
//     NortheastClass? southwest,
//   }) {
//     return Bounds(
//       northeast: northeast ?? this.northeast,
//       southwest: southwest ?? this.southwest,
//     );
//   }

//   factory Bounds.fromJson(Map<String, dynamic> json) {
//     return Bounds(
//       northeast: json["northeast"] == null
//           ? null
//           : NortheastClass.fromJson(json["northeast"]),
//       southwest: json["southwest"] == null
//           ? null
//           : NortheastClass.fromJson(json["southwest"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "northeast": northeast?.toJson(),
//         "southwest": southwest?.toJson(),
//       };
// }

// class NortheastClass {
//   NortheastClass({
//     required this.lat,
//     required this.lng,
//   });

//   final double? lat;
//   final double? lng;

//   NortheastClass copyWith({
//     double? lat,
//     double? lng,
//   }) {
//     return NortheastClass(
//       lat: lat ?? this.lat,
//       lng: lng ?? this.lng,
//     );
//   }

//   factory NortheastClass.fromJson(Map<String, dynamic> json) {
//     return NortheastClass(
//       lat: json["lat"],
//       lng: json["lng"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "lat": lat,
//         "lng": lng,
//       };
// }

// class NavigationPoint {
//   NavigationPoint({
//     required this.location,
//   });

//   final NavigationPointLocation? location;

//   NavigationPoint copyWith({
//     NavigationPointLocation? location,
//   }) {
//     return NavigationPoint(
//       location: location ?? this.location,
//     );
//   }

//   factory NavigationPoint.fromJson(Map<String, dynamic> json) {
//     return NavigationPoint(
//       location: json["location"] == null
//           ? null
//           : NavigationPointLocation.fromJson(json["location"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "location": location?.toJson(),
//       };
// }

// class NavigationPointLocation {
//   NavigationPointLocation({
//     required this.latitude,
//     required this.longitude,
//   });

//   final double? latitude;
//   final double? longitude;

//   NavigationPointLocation copyWith({
//     double? latitude,
//     double? longitude,
//   }) {
//     return NavigationPointLocation(
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//     );
//   }

//   factory NavigationPointLocation.fromJson(Map<String, dynamic> json) {
//     return NavigationPointLocation(
//       latitude: json["latitude"],
//       longitude: json["longitude"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "latitude": latitude,
//         "longitude": longitude,
//       };
// }
