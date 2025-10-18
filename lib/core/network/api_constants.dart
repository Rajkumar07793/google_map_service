class ApiUriConstants {
  static Future<Map<String, String>> headers() async => <String, String>{
    // "Authorization": "Bearer ${await SharedPref.getToken()}",
    "Content-Type": "application/json",
  };

  //Google map
  // static const gMapBaseUrl = "https://www.google.com/maps";
  // static gMapSearch(String parameters) => "/search/?api=1&$parameters";
  static gMapDir(String parameters) => "/dir/?api=1&$parameters";
  static gMapDisplayAMap(String parameters) =>
      "/@?api=1&map_action=map&$parameters";
  static gMapDisplayAStreetViewPanorama(String parameters) =>
      "/@?api=1&map_action=pano&$parameters";

  //Google Map Legacy
  static const String gMapBaseUrl = "https://maps.googleapis.com/maps";
  static gMapQueryAutocomplete(String parameters, String gMapKey) =>
      "/api/place/queryautocomplete/json?input=$parameters&key=$gMapKey";
  static gMapPlaceDetail(String parameters, String gMapKey) =>
      "/api/place/details/json?place_id=$parameters&key=$gMapKey";
  static gMapPlaceDetailByGeocode(String parameters, String gMapKey) =>
      "/api/geocode/json?latlng=$parameters&key=$gMapKey";

  //Google Map V2
  static const String gMapV2BaseUrl = "https://routes.googleapis.com";
  static const String gMapGetRoutes = "/directions/v2:computeRoutes";

  //temp ride (user match repo)
  static const String createTempRide = '/api/user/create_temp_ride';
  static const String matchTempRide = '/api/user/match_temp_rides';
  static const String sendRequest = '/api/user/send_tempRide_request';
  static const String acceptRejectRequest =
      '/api/user/accept_reject_temp_ride_request';
  static const String listAllRequests = '/api/user/list_ride_request_v1';
  static const String requestDetail = '/api/user/ride_request_details';
  static const String userTempRideDetails = '/api/user/temp_ride_details';
}
