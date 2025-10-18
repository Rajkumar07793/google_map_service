import 'package:equatable/equatable.dart';
import 'package:example/bloc/map_bloc/map_event.dart';
import 'package:google_map_service/data/models/google_map/place_detail_response.dart';
import 'package:google_map_service/data/models/google_map/places_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends Equatable {
  final Set<Marker> markers;
  final Set<Marker> rideMarkers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final CameraPosition? cameraPosition;
  final LatLngBounds? cameraBounds;
  final PlacesResponse? places;
  final PlaceDetails? source;
  final PlaceDetails? destination;
  final MapEvent? event;
  final Marker? selectedMarker;

  const MapState({
    this.markers = const {},
    this.rideMarkers = const {},
    this.polylines = const {},
    this.circles = const {},
    this.cameraPosition,
    this.cameraBounds,
    this.places,
    this.source,
    this.destination,
    this.event,
    this.selectedMarker,
  });

  MapState copyWith({
    Set<Marker>? markers,
    Set<Marker>? rideMarkers,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    CameraPosition? cameraPosition,
    LatLngBounds? cameraBounds,
    PlacesResponse? places,
    PlaceDetails? source,
    PlaceDetails? destination,
    MapEvent? event,
    Marker? selectedMarker,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      rideMarkers: rideMarkers ?? this.rideMarkers,
      polylines: polylines ?? this.polylines,
      circles: circles ?? this.circles,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      cameraBounds: cameraBounds ?? this.cameraBounds,
      places: places ?? this.places,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      event: event ?? this.event,
      selectedMarker: selectedMarker ?? this.selectedMarker,
    );
  }

  @override
  List<Object?> get props => [
    markers,
    rideMarkers,
    polylines,
    circles,
    cameraPosition,
    cameraBounds,
    places,
    source,
    destination,
    event,
    selectedMarker,
  ];
}

// class SelectedSourceState extends MapState {
//   final PlaceDetails airport;
//   const SelectedSourceState(this.airport);
//   @override
//   List<Object?> get props => [airport];
// }

// class SelectedDestinationState extends MapState {
//   final PlaceDetails airport;
//   const SelectedDestinationState(this.airport);
//   @override
//   List<Object?> get props => [airport];
// }

// class MarkerTappedState extends MapState {
//   final Marker marker;
//   const MarkerTappedState(this.marker);
//   @override
//   List<Object?> get props => [marker];
// }
