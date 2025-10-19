import 'dart:async';

import 'package:example/bloc/map_bloc/map_event.dart';
import 'package:example/bloc/map_bloc/map_state.dart';
import 'package:example/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_service/core/extensions/location_ext.dart';
import 'package:google_map_service/data/models/google_map/marker_type.dart';
// import 'package:google_map_service/data/models/google_map/bitmap.dart';
import 'package:google_map_service/data/models/google_map/place_detail_response.dart';
import 'package:google_map_service/google_map_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GoogleMapService mapRepo;
  final LocationService locationService = LocationService();
  PlaceDetails? source;
  PlaceDetails? destination;
  BitmapDescriptor? _locationMarkerIcon;
  // ClusterManager<Ride>? clusterManager;

  CameraPosition? cameraPosition;
  BitmapDescriptor get loadLocationMarkerIcon => BitmapDescriptor.defaultMarker;

  MapBloc(this.mapRepo) : super(const MapState()) {
    on<LoadMap>(_onLoadMap);
    on<AddMarker>(_onAddMarker);
    // on<AddRideMarkers>(_onAddRideMarkers);
    on<AddPolyline>(_onAddPolylines);
    on<SearchGooglePlaces>(_onSearchGooglePlaces);
    on<SelectSourceEvent>(_onSelectSourceEvent);
    on<SelectDestinationEvent>(_onSelectDestinationEvent);
    on<GetPlaceDetailByGeocode>(_onGetDetailByGeocode);
    on<OnMarkerTapped>(_onMarkerTapped);
    on<ClearSource>(_onClearSource);
    on<ClearDestination>(_onClearDestination);
    // on<UpdateClusterMarkers>(_onUpdateClusterMarkers);
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    final Position position = await locationService.determinePosition();
    debugPrint("Current Position: ${position.latitude}, ${position.longitude}");

    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    );
    if (source == null && destination == null) {
      cameraPosition = initialCameraPosition;
    }

    final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
      source: source,
      destination: destination,
    );

    emit(
      state.copyWith(
        // markers: initialMarkers,
        // polylines: initialPolylines,
        // circles: initialCircles,
        cameraPosition: cameraPosition,
        cameraBounds: bounds,
        event: event,
      ),
    );
    if (source != null && destination != null) {
      add(AddPolyline(source: source, destination: destination));
    }
    _locationMarkerIcon ??= loadLocationMarkerIcon;
  }

  Future<void> _onAddMarker(AddMarker event, Emitter<MapState> emit) async {
    final BitmapDescriptor icon = event.image != null
        ? await mapRepo.createCustomMarker(event.image!)
        : _locationMarkerIcon ?? BitmapDescriptor.defaultMarker;
    final marker = event.marker.copyWith(iconParam: icon);
    final updatedMarkers = Set<Marker>.from(state.markers)..add(marker);
    emit(state.copyWith(markers: updatedMarkers, event: event));
  }

  // Future<void> _onAddRideMarkers(
  //   AddRideMarkers event,
  //   Emitter<MapState> emit,
  // ) async {
  //   // Initialize cluster manager
  //   // clusterManager = ClusterManager<Ride>(
  //   //   event.rides,
  //   //   (Set<Marker> newMarkers) async {
  //   //     add(UpdateClusterMarkers(newMarkers));
  //   //   },
  //   //   markerBuilder: _buildClusterMarker,
  //   //   levels: [1, 3, 5, 8, 10, 12, 14, 16, 18],
  //   // );

  //   final rideMarkers = <Marker>{};

  //   for (final ride in event.rides) {
  //     // final coords =
  //     //     ride.userId?.location?.toLatLng(reverse: false); //coord of user
  //     final coords = ride.startLocation?.toLatLng(); //coord of start of ride
  //     // if (coords == null || coords.length < 2) continue;

  //     // Create custom marker with rider’s photo
  //     final BitmapDescriptor markerIcon = await mapRepo.createCustomMarker(
  //       (ride.userId?.photo?.isNotEmpty ?? false)
  //           ? ride.userId?.photo ?? ""
  //           : "https://i.pravatar.cc/150?img=1", // fallback
  //       size: 120,
  //       borderWidth: 6,
  //       borderColor: Colors.white,
  //     );

  //     rideMarkers.add(
  //       Marker(
  //         // clusterManagerId: ClusterManagerId(MarkerType.rideUser.name),
  //         markerId: MarkerId("${MarkerType.rideUser.name}_${ride.id}"),
  //         position: coords!,
  //         icon: markerIcon,
  //         infoWindow: InfoWindow(
  //           title:
  //               "${ride.userId?.firstname ?? ""} ${ride.userId?.lastname ?? ""}",
  //           snippet: ride.startAddress ?? "",
  //         ),
  //       ),
  //     );
  //   }
  //   final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
  //     source: source,
  //     destination: destination,
  //   );

  //   emit(
  //     state.copyWith(
  //       rideMarkers: rideMarkers,
  //       event: event,
  //       cameraBounds: bounds,
  //     ),
  //   );
  // }

  Future<void> _onAddPolylines(
    AddPolyline event,
    Emitter<MapState> emit,
  ) async {
    final source = event.source;
    final destination = event.destination;

    final LatLng src = source!.geometry!.location!.toLatLng();
    final LatLng dst = destination!.geometry!.location!.toLatLng();

    // ✅ Fetch routes (may include multiple alternatives)
    final routeResponse = await mapRepo.getRoutes(
      source: source,
      destination: destination,
    );

    final Set<Polyline> polylines = {};

    if (routeResponse.routes.isNotEmpty) {
      for (int i = 0; i < routeResponse.routes.length; i++) {
        final route = routeResponse.routes[i];
        final points = mapRepo.decodePolyline(
          route.polyline?.encodedPolyline ?? "",
        );

        // Assign unique color or style for each route
        final polylineColor = i == 0 ? Colors.black : Colors.black45;

        polylines.add(
          Polyline(
            polylineId: PolylineId("route_$i"),
            points: points,
            color: polylineColor,
            width: i == 0 ? 2 : 2, // main route thicker
            patterns: i == 0 ? [] : [PatternItem.dash(20), PatternItem.dash(1)],
            zIndex: i == 0 ? 1 : 0,
          ),
        );
      }
    } else {
      // fallback: straight line if API fails
      polylines.add(
        Polyline(
          polylineId: const PolylineId("fallback_route"),
          points: [src, dst],
          color: Colors.black,
          width: 2,
        ),
      );
    }

    // ✅ Circles for source & destination
    final circles = {
      Circle(
        circleId: CircleId("source_circle_${src.latitude}_${src.longitude}"),
        center: src,
        radius: 300,
        fillColor: Colors.green.withValues(alpha: 0.2),
        strokeColor: Colors.green,
        strokeWidth: 1,
      ),
      Circle(
        circleId: CircleId("dest_circle_${dst.latitude}_${dst.longitude}"),
        center: dst,
        radius: 300,
        fillColor: Colors.red.withValues(alpha: 0.2),
        strokeColor: Colors.red,
        strokeWidth: 1,
      ),
    };

    // ✅ Adjust camera to include both source & destination
    final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
      source: source,
      destination: destination,
    );

    // ✅ Emit new state with multiple polylines
    emit(
      state.copyWith(
        polylines: polylines,
        circles: circles,
        cameraBounds: bounds,
        event: event,
      ),
    );
  }

  Future<void> _onSearchGooglePlaces(
    SearchGooglePlaces event,
    Emitter<MapState> emit,
  ) async {
    final places = await mapRepo.queryAutocomplete(event.query);
    emit(
      state.copyWith(
        // polylines: state.polylines,
        // circles: state.circles,
        // cameraPosition: state.cameraPosition,
        // markers: state.markers,
        places: places,
        event: event,
      ),
    );
  }

  /// Select an airport from the list (store in state)
  Future<void> _onSelectSourceEvent(
    SelectSourceEvent event,
    Emitter<MapState> emit,
  ) async {
    final placeResponse = await mapRepo.placeDetail(event.place.placeId ?? "");
    source = placeResponse.result;

    if (source != null && destination != null) {
      add(AddPolyline(source: source, destination: destination));
    }

    // ✅ Create new source marker
    final sourceMarker = Marker(
      markerId: MarkerId("${MarkerType.source.name}_${source?.placeId}"),
      position: source!.geometry!.location!.toLatLng(),
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      icon: _locationMarkerIcon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title:
            source?.name ??
            source?.addressComponents?.firstOrNull?.shortName ??
            "",
        snippet: source?.formattedAddress,
      ),
    );

    // ✅ Remove old source marker (if any)
    final updatedMarkers = replaceMarker(
      currentMarkers: state.markers,
      type: MarkerType.source,
      newMarker: sourceMarker,
    );

    // ✅ Add the new source marker
    updatedMarkers.add(sourceMarker);

    // ✅ Compute camera bounds
    final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
      source: source,
      destination: destination,
    );

    // ✅ Emit new state
    emit(
      state.copyWith(
        source: source,
        event: event,
        markers: updatedMarkers,
        cameraBounds: bounds,
      ),
    );
  }

  /// Select an airport from the list (store in state)
  Future<void> _onSelectDestinationEvent(
    SelectDestinationEvent event,
    Emitter<MapState> emit,
  ) async {
    final placeResponse = await mapRepo.placeDetail(event.place.placeId ?? "");
    destination = placeResponse.result;
    if (source != null && destination != null) {
      add(AddPolyline(source: source, destination: destination));
    }

    final destinationMarker = Marker(
      // clusterManagerId: ClusterManagerId(MarkerType.source.name),
      markerId: MarkerId("${MarkerType.destination.name}_${source?.placeId}"),
      position: destination!.geometry!.location!.toLatLng(),
      icon: _locationMarkerIcon ?? BitmapDescriptor.defaultMarker,
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title:
            destination?.name ??
            destination?.addressComponents?.firstOrNull?.shortName ??
            "",
        snippet: destination?.formattedAddress,
      ),
    );

    final updatedMarkers = replaceMarker(
      currentMarkers: state.markers,
      type: MarkerType.destination,
      newMarker: destinationMarker,
    );

    // ✅ Fit camera to bounds of route
    final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
      source: source,
      destination: destination,
    );
    emit(
      state.copyWith(
        destination: destination,
        event: event,
        cameraBounds: bounds,
        markers: updatedMarkers,
      ),
    );
  }

  FutureOr<void> _onGetDetailByGeocode(
    GetPlaceDetailByGeocode event,
    Emitter<MapState> emit,
  ) async {
    final places = await mapRepo.placeDetailByGeocode(event.latLng);
    final place = places.results.firstOrNull;

    if (place == null) return;

    // Create a marker for this location
    final marker = Marker(
      markerId: MarkerId(
        "${event.isSource ? MarkerType.source.name : MarkerType.destination.name}_${place.placeId}",
      ),
      position: event.latLng,
      // icon: BitmapDescriptor.defaultMarkerWithHue(
      //   event.isSource ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
      // ),
      icon: _locationMarkerIcon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title:
            place.name ?? place.addressComponents?.firstOrNull?.shortName ?? "",
        snippet: place.formattedAddress,
      ),
    );

    // Update source/destination
    if (event.isSource) {
      source = place;
    } else {
      destination = place;
    }

    // Build updated marker set
    final updatedMarkers = <Marker>{...state.markers};

    if (event.isSource) {
      // 🔹 Replace any existing source marker with the new one
      updatedMarkers.removeWhere(
        (m) => m.markerId.value.startsWith(MarkerType.source.name),
      );
      updatedMarkers.add(marker);
    } else {
      // 🔹 Remove destination marker if exists, else add new one
      updatedMarkers.removeWhere(
        (m) => m.markerId.value.startsWith(MarkerType.destination.name),
      );
      updatedMarkers.add(marker);
    }

    // 🔹 Optionally add polyline if both are selected
    if (source != null && destination != null) {
      add(AddPolyline(source: source, destination: destination));
    }

    // 🔹 Update camera bounds if both markers exist
    final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
      source: source,
      destination: destination,
    );

    emit(
      state.copyWith(
        source: source,
        destination: destination,
        event: event,
        cameraBounds: bounds,
        markers: updatedMarkers,
      ),
    );
  }

  Future<void> _onMarkerTapped(
    OnMarkerTapped event,
    Emitter<MapState> emit,
  ) async {
    // Emit a state that tells UI to show a view for this marker
    emit(state.copyWith(selectedMarker: event.marker, event: event));
  }

  Set<Marker> replaceMarker({
    required Set<Marker> currentMarkers,
    required MarkerType type,
    required Marker newMarker,
  }) {
    final updated = <Marker>{...currentMarkers};
    updated.removeWhere((m) => m.markerId.value.startsWith(type.name));
    updated.add(newMarker);
    return updated;
  }

  FutureOr<void> _onClearSource(ClearSource event, Emitter<MapState> emit) {
    source = null;
    final updatedMarkers = <Marker>{...state.markers};
    updatedMarkers.removeWhere(
      (m) => m.markerId.value.startsWith(MarkerType.source.name),
    );
    // final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
    //   source: source,
    //   destination: destination,
    // );
    emit(
      state.copyWith(
        source: source,
        polylines: {},
        circles: {},
        markers: updatedMarkers,
        cameraBounds: null,
        event: event,
      ),
    );
  }

  FutureOr<void> _onClearDestination(
    ClearDestination event,
    Emitter<MapState> emit,
  ) {
    destination = null;
    final updatedMarkers = <Marker>{...state.markers};
    updatedMarkers.removeWhere(
      (m) => m.markerId.value.startsWith(MarkerType.destination.name),
    );
    // final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
    //   source: source,
    //   destination: destination,
    // );
    emit(
      state.copyWith(
        destination: destination,
        polylines: {},
        circles: {},
        markers: updatedMarkers,
        cameraBounds: null,
        event: event,
      ),
    );
  }

  // Future<Marker> _buildClusterMarker<ClusterItem>(Cluster<Ride> cluster) async {
  //   if (cluster.isMultiple) {
  //     // Create a cluster icon (showing number of rides)
  //     final BitmapDescriptor icon = await mapRepo.createClusterMarker(
  //       clusterCount: cluster.count,
  //       // cluster.items.first.userId?.photo ?? "https://i.pravatar.cc/150?img=1",
  //     );

  //     return Marker(
  //       markerId: MarkerId("cluster_${cluster.getId()}"),
  //       position: cluster.location,
  //       icon: icon,
  //     );
  //   } else {
  //     // Single ride marker
  //     final ride = cluster.items.first;
  //     final photo = (ride.userId?.photo?.isNotEmpty ?? false)
  //         ? ride.userId!.photo!
  //         : "https://i.pravatar.cc/150?img=1";

  //     final BitmapDescriptor markerIcon = await mapRepo.createCustomMarker(
  //       photo,
  //       size: 120,
  //       borderWidth: 6,
  //       borderColor: AppColor.whiteColor,
  //     );

  //     return Marker(
  //       markerId: MarkerId("${MarkerType.rideUser.name}_${ride.id}"),
  //       position: ride.userId!.location!.toLatLng(reverse: false),
  //       icon: markerIcon,
  //       infoWindow: InfoWindow(
  //         title:
  //             "${ride.userId?.firstname ?? ""} ${ride.userId?.lastname ?? ""}",
  //         snippet: ride.startAddress ?? "",
  //       ),
  //     );
  //   }
  // }

  // FutureOr<void> _onUpdateClusterMarkers(
  //   UpdateClusterMarkers event,
  //   Emitter<MapState> emit,
  // ) {
  //   final bounds = mapRepo.getLatLngBoundFromSourceAndDest(
  //     source: source,
  //     destination: destination,
  //   );
  //   // Update the map markers initially
  //   emit(
  //     state.copyWith(
  //       rideMarkers: event.markers,
  //       event: event,
  //       cameraBounds: bounds,
  //     ),
  //   );
  //   clusterManager?.updateMap();
  // }
}
