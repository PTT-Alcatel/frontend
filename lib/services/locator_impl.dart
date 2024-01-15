import 'package:geolocator/geolocator.dart';
import 'package:pushtotalk/interfaces/locator.dart';

class LocatorImp implements Locator {
  @override
  Future<Position> getCurrentLocation() async {
    /// Determine the current position of the device.
    ///
    /// When the location services are not enabled or permissions
    /// are denied the `Future` will return an error.
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> isLocationNearFromMe(
      {required Position myPosition,
      required Position otherPosition,
      required double distance}) async {
    double distanceInMeters = Geolocator.distanceBetween(myPosition.latitude,
        myPosition.longitude, otherPosition.latitude, otherPosition.longitude);
    return distanceInMeters <= distance;
  }

  @override
  Future<bool> verifyPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Future.error('Location permissions are denied');
        return false;
      }
    }
    return true;
  }
}
