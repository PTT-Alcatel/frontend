import 'package:geolocator/geolocator.dart';

abstract class Locator {
  Future<Position> getCurrentLocation();
  Future<bool> verifyPermission();
}
