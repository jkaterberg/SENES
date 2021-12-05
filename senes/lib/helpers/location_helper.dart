import 'package:geolocator/geolocator.dart';

class LocationHelper {
  /// Class to make doing everything with locations a little easier
  /// Potentially move all the stream and stream subscription things here?

  static Future<bool> checkPermissions() async {
    /// Check app permissions to ensure that they are sufficient for the
    /// applications use. If they are not, prompt the user to allow sufficient
    /// permissions
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
