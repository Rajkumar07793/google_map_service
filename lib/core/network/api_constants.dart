/// A utility class that defines constants and helper methods for
/// building and managing Google Map and API endpoint URIs.
///
/// This class provides a centralized place for all Google Maps–related
/// endpoints (Directions, Geocoding, Places, etc.), along with custom
/// application endpoints such as temporary ride APIs.
///
/// Usage example:
/// ```dart
/// final url = ApiUriConstants.gMapDir('origin=NYC&destination=Boston');
/// ```
///
/// Author: Your Name
/// Package: google_map_service
class ApiUriConstants {
  /// Returns standard headers for HTTP requests.
  ///
  /// Includes `Content-Type: application/json`.
  static Future<Map<String, String>> headers() async => <String, String>{
    "Content-Type": "application/json",
  };

  // ---------------------------------------------------------------------------
  // Google Map (Web-based endpoints)
  // ---------------------------------------------------------------------------

  /// Builds a Google Maps direction URI.
  ///
  /// Example:
  /// ```dart
  /// ApiUriConstants.gMapDir('origin=NYC&destination=Boston');
  /// ```
  /// Returns: `/dir/?api=1&origin=NYC&destination=Boston`
  static String gMapDir(String parameters) => "/dir/?api=1&$parameters";

  /// Builds a Google Maps URI to display a map centered on given parameters.
  ///
  /// Example:
  /// ```dart
  /// ApiUriConstants.gMapDisplayAMap('center=40.748817,-73.985428&zoom=12');
  /// ```
  static String gMapDisplayAMap(String parameters) =>
      "/@?api=1&map_action=map&$parameters";

  /// Builds a Google Maps URI to display a Street View panorama.
  ///
  /// Example:
  /// ```dart
  /// ApiUriConstants.gMapDisplayAStreetViewPanorama('viewpoint=46.414382,10.013988');
  /// ```
  static String gMapDisplayAStreetViewPanorama(String parameters) =>
      "/@?api=1&map_action=pano&$parameters";

  // ---------------------------------------------------------------------------
  // Google Maps Legacy (v1)
  // ---------------------------------------------------------------------------

  /// Base URL for legacy Google Maps REST APIs.
  static const String gMapBaseUrl = "https://maps.googleapis.com/maps";

  /// Builds a URI for the Google Places Query Autocomplete API.
  ///
  /// Example:
  /// ```dart
  /// ApiUriConstants.gMapQueryAutocomplete('pizza', 'YOUR_API_KEY');
  /// ```
  static String gMapQueryAutocomplete(String parameters, String gMapKey) =>
      "/api/place/queryautocomplete/json?input=$parameters&key=$gMapKey";

  /// Builds a URI for retrieving detailed place information.
  ///
  /// Example:
  /// ```dart
  /// ApiUriConstants.gMapPlaceDetail('ChIJN1t_tDeuEmsRUsoyG83frY4', 'YOUR_API_KEY');
  /// ```
  static String gMapPlaceDetail(String parameters, String gMapKey) =>
      "/api/place/details/json?place_id=$parameters&key=$gMapKey";

  /// Builds a URI for reverse geocoding by latitude and longitude.
  ///
  /// Example:
  /// ```dart
  /// ApiUriConstants.gMapPlaceDetailByGeocode('37.4219983,-122.084', 'YOUR_API_KEY');
  /// ```
  static String gMapPlaceDetailByGeocode(String parameters, String gMapKey) =>
      "/api/geocode/json?latlng=$parameters&key=$gMapKey";

  // ---------------------------------------------------------------------------
  // Google Maps V2 (Routes API)
  // ---------------------------------------------------------------------------

  /// Base URL for Google Maps Routes API (v2).
  static const String gMapV2BaseUrl = "https://routes.googleapis.com";

  /// Endpoint for computing directions and routes via Routes API v2.
  static const String gMapGetRoutes = "/directions/v2:computeRoutes";

  // ---------------------------------------------------------------------------
  // Temporary Ride APIs (Custom Backend)
  // ---------------------------------------------------------------------------

  /// Endpoint to create a temporary ride.
  static const String createTempRide = '/api/user/create_temp_ride';

  /// Endpoint to match temporary rides for users.
  static const String matchTempRide = '/api/user/match_temp_rides';

  /// Endpoint to send a ride request for a temporary ride.
  static const String sendRequest = '/api/user/send_tempRide_request';

  /// Endpoint to accept or reject a temporary ride request.
  static const String acceptRejectRequest =
      '/api/user/accept_reject_temp_ride_request';

  /// Endpoint to list all temporary ride requests.
  static const String listAllRequests = '/api/user/list_ride_request_v1';

  /// Endpoint to retrieve the details of a specific ride request.
  static const String requestDetail = '/api/user/ride_request_details';

  /// Endpoint to retrieve a user’s temporary ride details.
  static const String userTempRideDetails = '/api/user/temp_ride_details';
}
