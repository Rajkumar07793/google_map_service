enum MarkerType { rideUser, source, destination }

MarkerType markerTypeFromString(String value) {
  try {
    return MarkerType.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return MarkerType.source; // or a default value like MarkerType.rideUser
  }
}
