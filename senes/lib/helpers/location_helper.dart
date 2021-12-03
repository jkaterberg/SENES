import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    //Check if app has correct permissions. If it doesn't, nicely ask for them
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // We have correct permissions
    return true;
  }
}
