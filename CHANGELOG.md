## 0.0.3

### 🧩 Enhancements & Documentation

- Added **comprehensive documentation comments** across all core files for better IDE support and pub.dev visibility:
  - `ApiException` — detailed explanations for each exception type.
  - `HTTPStatusCodes` — documented all constants with clear usage context.
  - `LocationExt` — added inline docs and examples for location-to-LatLng conversions.
  - `handleException` — complete logic walkthrough and DartDoc-style comments.
- Improved **error handling clarity** with descriptive messages and categorized logging.
- Ensured **consistent DartDoc formatting** across the package for `dartdoc` compatibility.
- Refined **internal API response validation** for better developer experience.

---

## 0.0.2

### ✨ Updates & Improvements

- Added **full DartDoc-style documentation** for all classes and methods.  
- Implemented **custom marker utilities**:
  - `createCustomMarker` for circular network avatars  
  - `bitmapDescriptorFromAsset` for `.png` and `.svg` assets  
  - `createClusterMarker` for cluster markers with counts  
- Added **LatLngBounds helper** for fitting map camera to source and destination.  
- Updated **ApiClient** with complete documentation for:
  - GET, POST, PUT, DELETE requests  
  - Multipart POST requests  
  - Automatic JSON encoding and centralized exception handling  
- Improved logging and error handling in network requests.  
- Refined package architecture for easier usage and integration in Flutter apps.  

---

## 0.0.1

### 🎉 Initial Release

- Added core **Google Map Service** architecture for Flutter.  
- Implemented APIs for:
  - Map initialization and control  
  - Marker and polyline management  
  - Geocoding and reverse geocoding  
  - Directions and Distance Matrix API  
  - Place Autocomplete and Place Details  
- Included example Flutter app for demonstration.  
- Added **MIT License**, documentation (`README.md`), and code-level comments.  
