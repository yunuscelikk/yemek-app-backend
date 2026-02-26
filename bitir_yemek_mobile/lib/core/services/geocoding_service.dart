import 'package:geocoding/geocoding.dart';

class GeocodingService {
  /// Reverse geocode coordinates to get address
  static Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

        // Build address string from available components
        final parts = <String>[];

        // Add district (subLocality) if available
        if (placemark.subLocality != null &&
            placemark.subLocality!.isNotEmpty) {
          parts.add(placemark.subLocality!);
        }
        // Fallback to locality (city district)
        else if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          parts.add(placemark.locality!);
        }

        // Add city (administrativeArea)
        if (placemark.administrativeArea != null &&
            placemark.administrativeArea!.isNotEmpty) {
          parts.add(placemark.administrativeArea!);
        }

        if (parts.isNotEmpty) {
          return parts.join(', ');
        }

        // Fallback to full address if components are not available
        return placemark.street;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
