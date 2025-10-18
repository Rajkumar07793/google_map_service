# 🗺️ Google Map Service for Flutter

A **complete Flutter package** that wraps and simplifies Google Maps APIs into a clean, service-based architecture.  
It provides easy-to-use methods for map interactions, directions, geocoding, places, and distance calculations — all using the official Google Maps Platform.

---

## 🚀 Features

- 🧭 **Map Initialization** – Effortlessly display and control Google Maps widgets.  
- 📍 **Markers & Polylines Management** – Add, update, and remove markers and polylines dynamically.  
- 🗺️ **Geocoding / Reverse Geocoding** – Convert between coordinates and addresses.  
- 🧠 **Places API Integration** – Search, autocomplete, and get detailed place info.  
- 🛣️ **Directions API** – Get routes, distances, and durations between two or more locations.  
- 📏 **Distance Matrix API** – Calculate travel distance and time for multiple origins/destinations.  
- 🌍 **Custom Map Styles** – Apply dark/light/custom themes easily.  
- ⚡ **Async, Null-safe, and Well-structured** – Built for modern Flutter and Dart.

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  google_map_service: ^0.0.1
```

Then run:
```bash
flutter pub get
```

---

## 🔑 Setup

1. **Enable Google APIs**

   Make sure the following APIs are enabled on your Google Cloud Console:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Geocoding API
   - Places API
   - Directions API
   - Distance Matrix API

2. **Add your API key**

   In your `AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE" />
   ```

   In your `AppDelegate.swift` (iOS):
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```

3. **Initialize the service**

   ```dart
   import 'package:google_map_service/google_map_service.dart';

   final mapService = GoogleMapService(apiKey: 'YOUR_API_KEY_HERE');
   ```

---

## 🧩 API Usage

### 🗺️ Displaying a Google Map

```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  ),
  onMapCreated: mapService.onMapCreated,
  markers: mapService.markers,
  polylines: mapService.polylines,
);
```

---

### 📍 Add a Marker

```dart
mapService.addMarker(
  id: 'marker1',
  position: LatLng(37.7749, -122.4194),
  title: 'San Francisco',
  snippet: 'California',
);
```

---

### 🧭 Get Directions

```dart
final route = await mapService.getDirections(
  origin: LatLng(37.7749, -122.4194),
  destination: LatLng(34.0522, -118.2437),
);

mapService.addPolylineFromDirections(route);
```

---

### 🌍 Geocode an Address

```dart
final coordinates = await mapService.geocodeAddress('1600 Amphitheatre Parkway, Mountain View, CA');
```

### 📫 Reverse Geocode a Coordinate

```dart
final address = await mapService.reverseGeocode(LatLng(37.4219999, -122.0840575));
```

---

### 🧠 Place Autocomplete

```dart
final results = await mapService.autocompletePlaces('Eiffel Tower');
```

---

## ⚙️ Configuration Options

```dart
GoogleMapService(
  apiKey: 'YOUR_API_KEY',
  language: 'en',
  region: 'US',
  mapStyle: MapStyle.dark,
);
```

---

## 📘 Example App

See `/example` folder for a complete Flutter demo using all APIs.

Run:
```bash
flutter run example/
```

---

## 🧪 Testing

Mock services are included for unit testing.

```dart
final mockService = MockGoogleMapService();
```

---

## 🔐 Permissions

Add these permissions in your `AndroidManifest.xml` and `Info.plist`:

- **Android:**
  ```xml
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  ```

- **iOS:**
  ```xml
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>This app needs access to your location.</string>
  ```

---

## 🧰 Supported Platforms

- ✅ Android  
- ✅ iOS  
- ✅ Web (limited APIs – requires JS Maps SDK)

---

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

---

## 💡 Contributing

Pull requests are welcome!  
Please make sure to:
- Write clear commit messages.
- Add documentation and test coverage for new features.

---

## 🏁 Roadmap

- [ ] Support for custom map overlays  
- [ ] Offline maps support  
- [ ] Route optimization  
- [ ] Street View integration  

---

## 👨‍💻 Author

**Raj kumar Patel**  
Flutter Developer | Open Source Contributor  
📧 [rajkumar07793@gmail.com](mailto:rajkumar07793@gmail.com)
