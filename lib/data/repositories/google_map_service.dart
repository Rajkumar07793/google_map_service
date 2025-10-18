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

class GoogleMapService {
  final ApiClient apiClient = ApiClient(baseUrl: ApiUriConstants.gMapBaseUrl);
  final ApiClient apiClientV2 = ApiClient(
    baseUrl: ApiUriConstants.gMapV2BaseUrl,
  );
  final String apiKey;
  Map<String, String> headers() => {
    'X-Goog-FieldMask': '*',
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
  };
  GoogleMapService(this.apiKey);

  Future<PlacesResponse> queryAutocomplete(String input) async {
    final response = await apiClient.get(
      ApiUriConstants.gMapQueryAutocomplete(input, apiKey),
    );
    return PlacesResponse.fromJson(response);
  }

  Future<PlaceDetailResponse> placeDetail(String placeId) async {
    final response = await apiClient.get(
      ApiUriConstants.gMapPlaceDetail(placeId, apiKey),
    );
    return PlaceDetailResponse.fromJson(response);
  }

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
      // Optional extras for better results
      "travelMode": "DRIVE", // or WALK, BICYCLE, etc.
      "computeAlternativeRoutes": true,
    };

    final response = await apiClientV2.post(
      ApiUriConstants.gMapGetRoutes,
      headers: headers(),
      body: body,
    );

    return RoutesResponse.fromJson(response);
  }

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

  /// Converts a CircleAvatar widget into BitmapDescriptor for Google Maps,
  /// with fallback to a default image if loading fails.
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

    // Draw outer border
    final Paint borderPaint = Paint()..color = borderColor;
    canvas.drawCircle(Offset(radius, radius), radius, borderPaint);

    // Clip the canvas to a circle
    final Path clipPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(radius, radius),
          radius: radius - borderWidth,
        ),
      );
    canvas.clipPath(clipPath);

    ui.Image? image;

    try {
      final ImageProvider imageProvider = NetworkImage(imageUrl);
      final completer = Completer<ImageInfo>();

      final ImageStreamListener listener = ImageStreamListener(
        (ImageInfo info, _) {
          if (!completer.isCompleted) completer.complete(info);
        },
        onError: (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        },
      );

      final stream = imageProvider.resolve(const ImageConfiguration());
      stream.addListener(listener);

      final imageInfo = await completer.future;
      image = imageInfo.image;
      stream.removeListener(listener);
    } catch (e) {
      print('⚠️ Failed to load image: $e');
    }

    // If loading failed, use fallback image
    if (image == null) {
      final ImageProvider fallbackProvider = const NetworkImage(
        'https://i.pravatar.cc/150?img=1',
      );
      final completer = Completer<ImageInfo>();

      fallbackProvider
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener((ImageInfo info, _) {
              if (!completer.isCompleted) completer.complete(info);
            }),
          );
      final fallbackInfo = await completer.future;
      image = fallbackInfo.image;
    }

    // Draw image inside clipped circle
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

    // Convert canvas to bytes
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final ByteData? byteData = await markerAsImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  // /// Converts a CircleAvatar widget into BitmapDescriptor for Google Maps
  // Future<BitmapDescriptor> createCustomMarker(
  //   String imageUrl, {
  //   double size = 120,
  //   double borderWidth = 6,
  //   Color borderColor = Colors.white,
  // }) async {
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);

  //   final double radius = size / 2;

  //   // Draw outer border
  //   final Paint borderPaint = Paint()..color = borderColor;
  //   canvas.drawCircle(Offset(radius, radius), radius, borderPaint);

  //   // Clip the canvas to a circle
  //   final Path clipPath = Path()
  //     ..addOval(Rect.fromCircle(
  //         center: Offset(radius, radius), radius: radius - borderWidth));
  //   canvas.clipPath(clipPath);

  //   // Load network image
  //   final ImageProvider imageProvider = NetworkImage(imageUrl);
  //   final completer = Completer<ImageInfo>();
  //   imageProvider.resolve(const ImageConfiguration()).addListener(
  //     ImageStreamListener((ImageInfo info, _) {
  //       completer.complete(info);
  //     }),
  //   );
  //   final imageInfo = await completer.future;
  //   final ui.Image image = imageInfo.image;

  //   // Draw image inside clipped circle
  //   paintImage(
  //     canvas: canvas,
  //     rect: Rect.fromLTWH(borderWidth, borderWidth, size - 2 * borderWidth,
  //         size - 2 * borderWidth),
  //     image: image,
  //     fit: BoxFit.cover,
  //   );

  //   // Convert canvas to marker
  //   final ui.Image markerAsImage = await pictureRecorder
  //       .endRecording()
  //       .toImage(size.toInt(), size.toInt());
  //   final ByteData? byteData =
  //       await markerAsImage.toByteData(format: ui.ImageByteFormat.png);

  //   return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  // }

  LatLngBounds? getLatLngBoundFromSourceAndDest({
    PlaceDetails? source,
    PlaceDetails? destination,
  }) {
    if (source == null || destination == null) return null;
    final LatLng src = source.geometry!.location!.toLatLng();
    final LatLng dst = destination.geometry!.location!.toLatLng();
    // ✅ Fit camera to bounds of route
    final bounds = LatLngBounds(
      southwest: LatLng(
        src.latitude < dst.latitude ? src.latitude : dst.latitude,
        src.longitude < dst.longitude ? src.longitude : dst.longitude,
      ),
      northeast: LatLng(
        src.latitude > dst.latitude ? src.latitude : dst.latitude,
        src.longitude > dst.longitude ? src.longitude : dst.longitude,
      ),
    );
    return bounds;
  }

  /// Returns a BitmapDescriptor for use as a Google Map marker.
  /// Supports both `.svg` and `.png` assets automatically.
  Future<BitmapDescriptor> bitmapDescriptorFromAsset(
    BuildContext context,
    String assetName, {
    double width = 64,
  }) async {
    if (assetName.toLowerCase().endsWith('.svg')) {
      throw Exception("Unsupported asset format");
      // return _bitmapDescriptorFromSvgAsset(context, assetName, width: width);
    } else if (assetName.toLowerCase().endsWith('.png')) {
      return _bitmapDescriptorFromPngAsset(assetName, width: width);
    } else {
      throw Exception(
        "Unsupported asset format: $assetName (only .svg or .png)",
      );
    }
  }

  // Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
  //   BuildContext context,
  //   String assetName, {
  //   double width = 64,
  // }) async {
  //   // 1. Load the raw SVG string
  //   final String svgString =
  //       await DefaultAssetBundle.of(context).loadString(assetName);

  //   // 2. Parse the SVG into a renderable object (don't type it as DrawableRoot)
  //   final picture =  svg.SvgPicture.string(svgString);

  //   // 3. Convert parsed SVG to a ui.Picture and then to ui.Image
  //   //    pass a size so it scales correctly
  //   // final ui.Picture picture = svgRoot.toPicture(
  //   //   size: Size(width, width),
  //   // );

  //   final ui.Image image = await picture.toImage(width.toInt(), width.toInt());

  //   // 4. Convert to PNG bytes and make BitmapDescriptor
  //   final ByteData? bytes =
  //       await image.toByteData(format: ui.ImageByteFormat.png);
  //   return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  // }

  /// Convert a PNG asset into a BitmapDescriptor
  Future<BitmapDescriptor> _bitmapDescriptorFromPngAsset(
    String assetName, {
    double width = 64,
  }) async {
    final ByteData data = await rootBundle.load(assetName);
    final Uint8List bytes = data.buffer.asUint8List();

    // Resize image to specified width if needed
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

  // 🔵 Add this method for cluster count markers
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

    // Draw background circle
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
