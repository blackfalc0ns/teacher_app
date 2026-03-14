
/// Helper class for extracting location data from Google Maps iframe strings
class LocationHelper {
  /// Extract latitude and longitude from Google Maps iframe string
  /// Returns a map with 'lat' and 'lng' keys, or null if extraction fails
  static Map<String, double>? extractLatLngFromIframe(String? iframeString) {
    if (iframeString == null || iframeString.isEmpty) return null;

    try {
      // Pattern to match !3d{lat}!2d{lng} in the iframe src
      final regex = RegExp(r'!3d([\d.-]+)!.*?!2d([\d.-]+)');
      final match = regex.firstMatch(iframeString);

      if (match != null) {
        final lat = double.tryParse(match.group(1) ?? '');
        final lng = double.tryParse(match.group(2) ?? '');
        if (lat != null && lng != null) {
          return {'lat': lat, 'lng': lng};
        }
      }

      // Alternative pattern: pb=!1m14!1m8!1m3!1d...!2d{lng}!3d{lat}
      final altRegex = RegExp(r'!2d([\d.-]+)!3d([\d.-]+)');
      final altMatch = altRegex.firstMatch(iframeString);

      if (altMatch != null) {
        final lng = double.tryParse(altMatch.group(1) ?? '');
        final lat = double.tryParse(altMatch.group(2) ?? '');
        if (lat != null && lng != null) {
          return {'lat': lat, 'lng': lng};
        }
      }
    } catch (e) {
      //debug////print('Error extracting lat/lng: $e');
    }
    return null;
  }
}
