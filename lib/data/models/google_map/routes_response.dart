class RoutesResponse {
  RoutesResponse({required this.routes, required this.geocodingResults});

  final List<Route> routes;
  final GeocodingResults? geocodingResults;

  RoutesResponse copyWith({
    List<Route>? routes,
    GeocodingResults? geocodingResults,
  }) {
    return RoutesResponse(
      routes: routes ?? this.routes,
      geocodingResults: geocodingResults ?? this.geocodingResults,
    );
  }

  factory RoutesResponse.fromJson(Map<String, dynamic> json) {
    return RoutesResponse(
      routes: json["routes"] == null
          ? []
          : List<Route>.from(json["routes"]!.map((x) => Route.fromJson(x))),
      geocodingResults: json["geocodingResults"] == null
          ? null
          : GeocodingResults.fromJson(json["geocodingResults"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "routes": routes.map((x) => x.toJson()).toList(),
    "geocodingResults": geocodingResults?.toJson(),
  };
}

class GeocodingResults {
  GeocodingResults({required this.origin, required this.destination});

  final Destination? origin;
  final Destination? destination;

  GeocodingResults copyWith({Destination? origin, Destination? destination}) {
    return GeocodingResults(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }

  factory GeocodingResults.fromJson(Map<String, dynamic> json) {
    return GeocodingResults(
      origin: json["origin"] == null
          ? null
          : Destination.fromJson(json["origin"]),
      destination: json["destination"] == null
          ? null
          : Destination.fromJson(json["destination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "origin": origin?.toJson(),
    "destination": destination?.toJson(),
  };
}

class Destination {
  Destination({
    required this.geocoderStatus,
    required this.type,
    required this.placeId,
    required this.partialMatch,
  });

  final PolylineDetails? geocoderStatus;
  final List<String> type;
  final String? placeId;
  final bool? partialMatch;

  Destination copyWith({
    PolylineDetails? geocoderStatus,
    List<String>? type,
    String? placeId,
    bool? partialMatch,
  }) {
    return Destination(
      geocoderStatus: geocoderStatus ?? this.geocoderStatus,
      type: type ?? this.type,
      placeId: placeId ?? this.placeId,
      partialMatch: partialMatch ?? this.partialMatch,
    );
  }

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      geocoderStatus: json["geocoderStatus"] == null
          ? null
          : PolylineDetails.fromJson(json["geocoderStatus"]),
      type: json["type"] == null
          ? []
          : List<String>.from(json["type"]!.map((x) => x)),
      placeId: json["placeId"],
      partialMatch: json["partialMatch"],
    );
  }

  Map<String, dynamic> toJson() => {
    "geocoderStatus": geocoderStatus?.toJson(),
    "type": type.map((x) => x).toList(),
    "placeId": placeId,
    "partialMatch": partialMatch,
  };
}

class PolylineDetails {
  PolylineDetails({required this.json});
  final Map<String, dynamic> json;

  factory PolylineDetails.fromJson(Map<String, dynamic> json) {
    return PolylineDetails(json: json);
  }

  Map<String, dynamic> toJson() => {};
}

class Route {
  Route({
    required this.legs,
    required this.distanceMeters,
    required this.duration,
    required this.staticDuration,
    required this.polyline,
    required this.description,
    required this.warnings,
    required this.viewport,
    required this.travelAdvisory,
    required this.localizedValues,
    required this.routeLabels,
    required this.polylineDetails,
  });

  final List<Leg> legs;
  final int? distanceMeters;
  final String? duration;
  final String? staticDuration;
  final Polyline? polyline;
  final String? description;
  final List<String> warnings;
  final Viewport? viewport;
  final PolylineDetails? travelAdvisory;
  final LegLocalizedValues? localizedValues;
  final List<String> routeLabels;
  final PolylineDetails? polylineDetails;

  Route copyWith({
    List<Leg>? legs,
    int? distanceMeters,
    String? duration,
    String? staticDuration,
    Polyline? polyline,
    String? description,
    List<String>? warnings,
    Viewport? viewport,
    PolylineDetails? travelAdvisory,
    LegLocalizedValues? localizedValues,
    List<String>? routeLabels,
    PolylineDetails? polylineDetails,
  }) {
    return Route(
      legs: legs ?? this.legs,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      duration: duration ?? this.duration,
      staticDuration: staticDuration ?? this.staticDuration,
      polyline: polyline ?? this.polyline,
      description: description ?? this.description,
      warnings: warnings ?? this.warnings,
      viewport: viewport ?? this.viewport,
      travelAdvisory: travelAdvisory ?? this.travelAdvisory,
      localizedValues: localizedValues ?? this.localizedValues,
      routeLabels: routeLabels ?? this.routeLabels,
      polylineDetails: polylineDetails ?? this.polylineDetails,
    );
  }

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      legs: json["legs"] == null
          ? []
          : List<Leg>.from(json["legs"]!.map((x) => Leg.fromJson(x))),
      distanceMeters: json["distanceMeters"],
      duration: json["duration"],
      staticDuration: json["staticDuration"],
      polyline: json["polyline"] == null
          ? null
          : Polyline.fromJson(json["polyline"]),
      description: json["description"],
      warnings: json["warnings"] == null
          ? []
          : List<String>.from(json["warnings"]!.map((x) => x)),
      viewport: json["viewport"] == null
          ? null
          : Viewport.fromJson(json["viewport"]),
      travelAdvisory: json["travelAdvisory"] == null
          ? null
          : PolylineDetails.fromJson(json["travelAdvisory"]),
      localizedValues: json["localizedValues"] == null
          ? null
          : LegLocalizedValues.fromJson(json["localizedValues"]),
      routeLabels: json["routeLabels"] == null
          ? []
          : List<String>.from(json["routeLabels"]!.map((x) => x)),
      polylineDetails: json["polylineDetails"] == null
          ? null
          : PolylineDetails.fromJson(json["polylineDetails"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "legs": legs.map((x) => x.toJson()).toList(),
    "distanceMeters": distanceMeters,
    "duration": duration,
    "staticDuration": staticDuration,
    "polyline": polyline?.toJson(),
    "description": description,
    "warnings": warnings.map((x) => x).toList(),
    "viewport": viewport?.toJson(),
    "travelAdvisory": travelAdvisory?.toJson(),
    "localizedValues": localizedValues?.toJson(),
    "routeLabels": routeLabels.map((x) => x).toList(),
    "polylineDetails": polylineDetails?.toJson(),
  };
}

class Leg {
  Leg({
    required this.distanceMeters,
    required this.duration,
    required this.staticDuration,
    required this.polyline,
    required this.startLocation,
    required this.endLocation,
    required this.steps,
    required this.localizedValues,
  });

  final int? distanceMeters;
  final String? duration;
  final String? staticDuration;
  final Polyline? polyline;
  final Location? startLocation;
  final Location? endLocation;
  final List<Step> steps;
  final LegLocalizedValues? localizedValues;

  Leg copyWith({
    int? distanceMeters,
    String? duration,
    String? staticDuration,
    Polyline? polyline,
    Location? startLocation,
    Location? endLocation,
    List<Step>? steps,
    LegLocalizedValues? localizedValues,
  }) {
    return Leg(
      distanceMeters: distanceMeters ?? this.distanceMeters,
      duration: duration ?? this.duration,
      staticDuration: staticDuration ?? this.staticDuration,
      polyline: polyline ?? this.polyline,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      steps: steps ?? this.steps,
      localizedValues: localizedValues ?? this.localizedValues,
    );
  }

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      distanceMeters: json["distanceMeters"],
      duration: json["duration"],
      staticDuration: json["staticDuration"],
      polyline: json["polyline"] == null
          ? null
          : Polyline.fromJson(json["polyline"]),
      startLocation: json["startLocation"] == null
          ? null
          : Location.fromJson(json["startLocation"]),
      endLocation: json["endLocation"] == null
          ? null
          : Location.fromJson(json["endLocation"]),
      steps: json["steps"] == null
          ? []
          : List<Step>.from(json["steps"]!.map((x) => Step.fromJson(x))),
      localizedValues: json["localizedValues"] == null
          ? null
          : LegLocalizedValues.fromJson(json["localizedValues"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "distanceMeters": distanceMeters,
    "duration": duration,
    "staticDuration": staticDuration,
    "polyline": polyline?.toJson(),
    "startLocation": startLocation?.toJson(),
    "endLocation": endLocation?.toJson(),
    "steps": steps.map((x) => x.toJson()).toList(),
    "localizedValues": localizedValues?.toJson(),
  };
}

class Location {
  Location({required this.latLng});

  final High? latLng;

  Location copyWith({High? latLng}) {
    return Location(latLng: latLng ?? this.latLng);
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latLng: json["latLng"] == null ? null : High.fromJson(json["latLng"]),
    );
  }

  Map<String, dynamic> toJson() => {"latLng": latLng?.toJson()};
}

class High {
  High({required this.latitude, required this.longitude});

  final double? latitude;
  final double? longitude;

  High copyWith({double? latitude, double? longitude}) {
    return High(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory High.fromJson(Map<String, dynamic> json) {
    return High(latitude: json["latitude"], longitude: json["longitude"]);
  }

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class LegLocalizedValues {
  LegLocalizedValues({
    required this.distance,
    required this.duration,
    required this.staticDuration,
  });

  final Distance? distance;
  final Distance? duration;
  final Distance? staticDuration;

  LegLocalizedValues copyWith({
    Distance? distance,
    Distance? duration,
    Distance? staticDuration,
  }) {
    return LegLocalizedValues(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      staticDuration: staticDuration ?? this.staticDuration,
    );
  }

  factory LegLocalizedValues.fromJson(Map<String, dynamic> json) {
    return LegLocalizedValues(
      distance: json["distance"] == null
          ? null
          : Distance.fromJson(json["distance"]),
      duration: json["duration"] == null
          ? null
          : Distance.fromJson(json["duration"]),
      staticDuration: json["staticDuration"] == null
          ? null
          : Distance.fromJson(json["staticDuration"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "distance": distance?.toJson(),
    "duration": duration?.toJson(),
    "staticDuration": staticDuration?.toJson(),
  };
}

class Distance {
  Distance({required this.text});

  final String? text;

  Distance copyWith({String? text}) {
    return Distance(text: text ?? this.text);
  }

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(text: json["text"]);
  }

  Map<String, dynamic> toJson() => {"text": text};
}

class Polyline {
  Polyline({required this.encodedPolyline});

  final String? encodedPolyline;

  Polyline copyWith({String? encodedPolyline}) {
    return Polyline(encodedPolyline: encodedPolyline ?? this.encodedPolyline);
  }

  factory Polyline.fromJson(Map<String, dynamic> json) {
    return Polyline(encodedPolyline: json["encodedPolyline"]);
  }

  Map<String, dynamic> toJson() => {"encodedPolyline": encodedPolyline};
}

class Step {
  Step({
    required this.distanceMeters,
    required this.staticDuration,
    required this.polyline,
    required this.startLocation,
    required this.endLocation,
    required this.navigationInstruction,
    required this.localizedValues,
    required this.travelMode,
  });

  final int? distanceMeters;
  final String? staticDuration;
  final Polyline? polyline;
  final Location? startLocation;
  final Location? endLocation;
  final NavigationInstruction? navigationInstruction;
  final StepLocalizedValues? localizedValues;
  final String? travelMode;

  Step copyWith({
    int? distanceMeters,
    String? staticDuration,
    Polyline? polyline,
    Location? startLocation,
    Location? endLocation,
    NavigationInstruction? navigationInstruction,
    StepLocalizedValues? localizedValues,
    String? travelMode,
  }) {
    return Step(
      distanceMeters: distanceMeters ?? this.distanceMeters,
      staticDuration: staticDuration ?? this.staticDuration,
      polyline: polyline ?? this.polyline,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      navigationInstruction:
          navigationInstruction ?? this.navigationInstruction,
      localizedValues: localizedValues ?? this.localizedValues,
      travelMode: travelMode ?? this.travelMode,
    );
  }

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      distanceMeters: json["distanceMeters"],
      staticDuration: json["staticDuration"],
      polyline: json["polyline"] == null
          ? null
          : Polyline.fromJson(json["polyline"]),
      startLocation: json["startLocation"] == null
          ? null
          : Location.fromJson(json["startLocation"]),
      endLocation: json["endLocation"] == null
          ? null
          : Location.fromJson(json["endLocation"]),
      navigationInstruction: json["navigationInstruction"] == null
          ? null
          : NavigationInstruction.fromJson(json["navigationInstruction"]),
      localizedValues: json["localizedValues"] == null
          ? null
          : StepLocalizedValues.fromJson(json["localizedValues"]),
      travelMode: json["travelMode"],
    );
  }

  Map<String, dynamic> toJson() => {
    "distanceMeters": distanceMeters,
    "staticDuration": staticDuration,
    "polyline": polyline?.toJson(),
    "startLocation": startLocation?.toJson(),
    "endLocation": endLocation?.toJson(),
    "navigationInstruction": navigationInstruction?.toJson(),
    "localizedValues": localizedValues?.toJson(),
    "travelMode": travelMode,
  };
}

class StepLocalizedValues {
  StepLocalizedValues({required this.distance, required this.staticDuration});

  final Distance? distance;
  final Distance? staticDuration;

  StepLocalizedValues copyWith({Distance? distance, Distance? staticDuration}) {
    return StepLocalizedValues(
      distance: distance ?? this.distance,
      staticDuration: staticDuration ?? this.staticDuration,
    );
  }

  factory StepLocalizedValues.fromJson(Map<String, dynamic> json) {
    return StepLocalizedValues(
      distance: json["distance"] == null
          ? null
          : Distance.fromJson(json["distance"]),
      staticDuration: json["staticDuration"] == null
          ? null
          : Distance.fromJson(json["staticDuration"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "distance": distance?.toJson(),
    "staticDuration": staticDuration?.toJson(),
  };
}

class NavigationInstruction {
  NavigationInstruction({required this.maneuver, required this.instructions});

  final String? maneuver;
  final String? instructions;

  NavigationInstruction copyWith({String? maneuver, String? instructions}) {
    return NavigationInstruction(
      maneuver: maneuver ?? this.maneuver,
      instructions: instructions ?? this.instructions,
    );
  }

  factory NavigationInstruction.fromJson(Map<String, dynamic> json) {
    return NavigationInstruction(
      maneuver: json["maneuver"],
      instructions: json["instructions"],
    );
  }

  Map<String, dynamic> toJson() => {
    "maneuver": maneuver,
    "instructions": instructions,
  };
}

class Viewport {
  Viewport({required this.low, required this.high});

  final High? low;
  final High? high;

  Viewport copyWith({High? low, High? high}) {
    return Viewport(low: low ?? this.low, high: high ?? this.high);
  }

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      low: json["low"] == null ? null : High.fromJson(json["low"]),
      high: json["high"] == null ? null : High.fromJson(json["high"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "low": low?.toJson(),
    "high": high?.toJson(),
  };
}
