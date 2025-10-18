import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_service/core/extensions/location_ext.dart';
import 'package:google_map_service/core/network/api_client.dart';
import 'package:google_map_service/core/network/api_constants.dart';
import 'package:google_map_service/data/models/google_map/place_detail_by_geocode_response.dart';
import 'package:google_map_service/data/models/google_map/place_detail_response.dart';
import 'package:google_map_service/data/models/google_map/places_response.dart';
import 'package:google_map_service/data/models/google_map/routes_response.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

/// A service class that provides all major Google Maps functionalities
/// for Flutter applications using the official Google Maps Platform APIs.
///
/// This service includes:
/// - Autocomplete & Place Details
/// - Reverse Geocoding
/// - Directions & Routes
/// - Bitmap Marker utilities
/// - Polyline decoding
/// - Cluster marker generation
///
/// Example:
/// ```dart
/// final mapService = GoogleMapService('YOUR_API_KEY');
/// final result = await mapService.queryAutocomplete('Eiffel Tower');
/// ```
class GoogleMapService {
  /// HTTP client for legacy Google Maps API requests.
  final ApiClient apiClient = ApiClient(baseUrl: ApiUriConstants.gMapBaseUrl);

  /// HTTP client for new Google Maps Routes API (v2) requests.
  final ApiClient apiClientV2 = ApiClient(
    baseUrl: ApiUriConstants.gMapV2BaseUrl,
  );

  /// The Google Maps API key used for authentication.
  final String apiKey;

  /// Standard headers used in API requests.
  Map<String, String> headers() => {
    'X-Goog-FieldMask': '*',
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
  };

  /// Creates a [GoogleMapService] instance with a given [apiKey].
  GoogleMapService(this.apiKey);

  // ---------------------------------------------------------------------------
  // GOOGLE PLACES AUTOCOMPLETE & DETAILS
  // ---------------------------------------------------------------------------

  /// Fetches place predictions based on an input query using the
  /// **Google Places Autocomplete API**.
  ///
  /// Example:
  /// ```dart
  /// final response = await mapService.queryAutocomplete('coffee near London');
  /// ```
  Future<PlacesResponse> queryAutocomplete(String input) async {
    final response = await apiClient.get(
      ApiUriConstants.gMapQueryAutocomplete(input, apiKey),
    );
    return PlacesResponse.fromJson(response);
  }

  /// Retrieves detailed information about a place using its `placeId`.
  ///
  /// Example:
  /// ```dart
  /// final place = await mapService.placeDetail('ChIJN1t_tDeuEmsRUsoyG83frY4');
  /// ```
  Future<PlaceDetailResponse> placeDetail(String placeId) async {
    final response = await apiClient.get(
      ApiUriConstants.gMapPlaceDetail(placeId, apiKey),
    );
    return PlaceDetailResponse.fromJson(response);
  }

  /// Performs reverse geocoding to retrieve address details
  /// for a given [LatLng] coordinate.
  ///
  /// Example:
  /// ```dart
  /// final address = await mapService.placeDetailByGeocode(LatLng(37.7749, -122.4194));
  /// ```
  Future<PlaceDetailByGeocodeResponse> placeDetailByGeocode(
    LatLng latlng,
  ) async {
    final response = await apiClient.get(
      ApiUriConstants.gMapPlaceDetailByGeocode(
        "${latlng.latitude},${latlng.longitude}",
        apiKey,
      ),
    );
    return PlaceDetailByGeocodeResponse.fromJson(response);
  }

  // ---------------------------------------------------------------------------
  // ROUTES & DIRECTIONS API (V2)
  // ---------------------------------------------------------------------------

  /// Fetches route information between a [source] and [destination]
  /// using the **Google Maps Directions API (v2)**.
  ///
  /// Includes distance, duration, and polyline information.
  ///
  /// Example:
  /// ```dart
  /// final route = await mapService.getRoutes(
  ///   source: sourcePlace,
  ///   destination: destinationPlace,
  /// );
  /// ```
  Future<RoutesResponse> getRoutes({
    PlaceDetails? source,
    PlaceDetails? destination,
  }) async {
    final body = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": source?.geometry?.location?.lat,
            "longitude": source?.geometry?.location?.lng,
          },
        },
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": destination?.geometry?.location?.lat,
            "longitude": destination?.geometry?.location?.lng,
          },
        },
      },
      "travelMode": "DRIVE",
      "computeAlternativeRoutes": true,
    };

    final response = await apiClientV2.post(
      ApiUriConstants.gMapGetRoutes,
      headers: headers(),
      body: body,
    );

    return RoutesResponse.fromJson(response);
  }

  // ---------------------------------------------------------------------------
  // POLYLINE DECODING
  // ---------------------------------------------------------------------------

  /// Decodes an encoded polyline string into a list of [LatLng] coordinates.
  ///
  /// Example:
  /// ```dart
  /// final points = mapService.decodePolyline(encodedPolyline);
  /// ```
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  // ---------------------------------------------------------------------------
  // CUSTOM MARKERS
  // ---------------------------------------------------------------------------

  /// Converts a network image into a circular [BitmapDescriptor] marker.
  ///
  /// If the image fails to load, a fallback avatar is used.
  ///
  /// Example:
  /// ```dart
  /// final markerIcon = await mapService.createCustomMarker(imageUrl);
  /// ```
  Future<BitmapDescriptor> createCustomMarker(
    String imageUrl, {
    double size = 120,
    double borderWidth = 6,
    Color borderColor = Colors.white,
  }) async {
    log(imageUrl);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double radius = size / 2;

    // Draw border
    final Paint borderPaint = Paint()..color = borderColor;
    canvas.drawCircle(Offset(radius, radius), radius, borderPaint);

    // Clip circle
    final Path clipPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(radius, radius),
          radius: radius - borderWidth,
        ),
      );
    canvas.clipPath(clipPath);

    ui.Image? image;

    // Try to load image
    try {
      final ImageProvider imageProvider = NetworkImage(imageUrl);
      final completer = Completer<ImageInfo>();
      final listener = ImageStreamListener(
        (ImageInfo info, _) => completer.complete(info),
        onError: (error, stackTrace) =>
            completer.completeError(error, stackTrace),
      );
      final stream = imageProvider.resolve(const ImageConfiguration());
      stream.addListener(listener);
      final imageInfo = await completer.future;
      image = imageInfo.image;
      stream.removeListener(listener);
    } catch (e) {
      print('⚠️ Failed to load image: $e');
    }

    // Fallback image
    if (image == null) {
      final ImageProvider fallback = const NetworkImage(
        'https://i.pravatar.cc/150?img=1',
      );
      final completer = Completer<ImageInfo>();
      fallback
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener(
              (ImageInfo info, _) => completer.complete(info),
            ),
          );
      final fallbackInfo = await completer.future;
      image = fallbackInfo.image;
    }

    // Draw image
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        borderWidth,
        borderWidth,
        size - 2 * borderWidth,
        size - 2 * borderWidth,
      ),
      image: image,
      fit: BoxFit.cover,
    );

    // Convert to bytes
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final ByteData? byteData = await markerAsImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  // ---------------------------------------------------------------------------
  // MAP BOUND CALCULATION
  // ---------------------------------------------------------------------------

  /// Returns a [LatLngBounds] that fits both source and destination points.
  ///
  /// Used to adjust the camera to show both markers in view.
  LatLngBounds? getLatLngBoundFromSourceAndDest({
    PlaceDetails? source,
    PlaceDetails? destination,
  }) {
    if (source == null || destination == null) return null;
    final LatLng src = source.geometry!.location!.toLatLng();
    final LatLng dst = destination.geometry!.location!.toLatLng();

    return LatLngBounds(
      southwest: LatLng(
        src.latitude < dst.latitude ? src.latitude : dst.latitude,
        src.longitude < dst.longitude ? src.longitude : dst.longitude,
      ),
      northeast: LatLng(
        src.latitude > dst.latitude ? src.latitude : dst.latitude,
        src.longitude > dst.longitude ? src.longitude : dst.longitude,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BITMAP FROM ASSETS
  // ---------------------------------------------------------------------------

  /// Loads a `.png` or `.svg` asset and converts it into a [BitmapDescriptor].
  ///
  /// Currently only supports `.png` assets.
  Future<BitmapDescriptor> bitmapDescriptorFromAsset(
    BuildContext context,
    String assetName, {
    double width = 64,
  }) async {
    if (assetName.toLowerCase().endsWith('.svg')) {
      throw Exception("Unsupported asset format");
    } else if (assetName.toLowerCase().endsWith('.png')) {
      return _bitmapDescriptorFromPngAsset(assetName, width: width);
    } else {
      throw Exception(
        "Unsupported asset format: $assetName (only .svg or .png)",
      );
    }
  }

  /// Converts a PNG asset into a resizable [BitmapDescriptor].
  Future<BitmapDescriptor> _bitmapDescriptorFromPngAsset(
    String assetName, {
    double width = 64,
  }) async {
    final ByteData data = await rootBundle.load(assetName);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width.toInt(),
    );
    final ui.FrameInfo fi = await codec.getNextFrame();

    final ByteData? resizedBytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(resizedBytes!.buffer.asUint8List());
  }

  // ---------------------------------------------------------------------------
  // CLUSTER MARKER CREATION
  // ---------------------------------------------------------------------------

  /// Generates a circular cluster marker displaying the number of grouped markers.
  ///
  /// Example:
  /// ```dart
  /// final clusterIcon = await mapService.createClusterMarker(clusterCount: 8);
  /// ```
  Future<BitmapDescriptor> createClusterMarker({
    required int clusterCount,
    double size = 120,
    Color color = Colors.blue,
  }) async {
    final PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = color;

    final double radius = size / 2;
    final Offset center = Offset(radius, radius);

    // Draw background
    canvas.drawCircle(center, radius, paint);

    // Draw count text
    final textPainter = TextPainter(
      text: TextSpan(
        text: clusterCount.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size / 3,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final img = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
