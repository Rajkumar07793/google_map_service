import 'package:equatable/equatable.dart';
import 'package:google_map_service/data/models/google_map/place_detail_response.dart';
import 'package:google_map_service/data/models/google_map/places_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMap extends MapEvent {}

class AddMarker extends MapEvent {
  final Marker marker;
  final String? image;

  AddMarker({required this.marker, this.image});

  @override
  List<Object?> get props => [marker, image];
}

// class AddRideMarkers extends MapEvent {
//   final List<Ride> rides;

//   AddRideMarkers({required this.rides});

//   @override
//   List<Object?> get props => [rides];
// }

class AddPolyline extends MapEvent {
  final PlaceDetails? source;
  final PlaceDetails? destination;

  AddPolyline({required this.source, required this.destination});
  @override
  List<Object?> get props => [source, destination];
}

class SearchGooglePlaces extends MapEvent {
  final String query;

  SearchGooglePlaces({required this.query});
  @override
  List<Object?> get props => [query];
}

class SelectSourceEvent extends MapEvent {
  final Prediction place;
  SelectSourceEvent(this.place);

  @override
  List<Object?> get props => [place];
}

class SelectDestinationEvent extends MapEvent {
  final Prediction place;
  SelectDestinationEvent(this.place);

  @override
  List<Object?> get props => [place];
}

class GetPlaceDetailByGeocode extends MapEvent {
  final bool isSource;
  final LatLng latLng;
  GetPlaceDetailByGeocode({required this.latLng, required this.isSource});

  @override
  List<Object?> get props => [latLng, isSource];
}

class OnMarkerTapped extends MapEvent {
  final MarkerId markerId;
  final Marker marker;

  OnMarkerTapped(this.markerId, this.marker);

  @override
  List<Object?> get props => [markerId, marker];
}

class ClearDestination extends MapEvent {}

class ClearSource extends MapEvent {}

class UpdateClusterMarkers extends MapEvent {
  final Set<Marker> markers;

  UpdateClusterMarkers(this.markers);

  @override
  List<Object?> get props => [markers];
}
