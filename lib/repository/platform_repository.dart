import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pushtotalk/classes/bubble.dart';
import 'package:pushtotalk/classes/rainbow_user.dart';

// Used as a bridge between Flutter and Kotlin code

class PlatformRepository {
  static const platform = MethodChannel('flutter.native/helper');

  Future<bool> isRainbowSdkInitialized() async {
    bool result = false;
    try {
      result = await platform.invokeMethod("isRainbowSdkInitialized", {});
    } on PlatformException catch (e) {
      debugPrint("ERROR -> ${e.message}");
    }
    return result;
  }

  Future<bool> login(String email, String password) async {
    bool result = false;
    try {
      result = await platform.invokeMethod("login", {
        "email": email,
        "password": password,
      });
    } on PlatformException catch (e) {
      debugPrint("ERROR -> ${e.message}");
    }
    return result;
  }

  Future<bool> logout() async {
    bool result = false;
    try {
      result = await platform.invokeMethod("logout", {});
    } on PlatformException catch (e) {
      debugPrint("ERROR -> ${e.message}");
    }
    return result;
  }

  Future<RainbowUser> getRainbowUser() async {
    Map<Object?, Object?> result = {};
    try {
      result = await platform.invokeMethod("getRainbowUser", {});
    } on PlatformException catch (e) {
      debugPrint("ERROR -> ${e.message}");
    }
    return RainbowUser.fromMap(result);
  }

  // TODO1 : Method to create / modify / delete bubbles

  Future<Bubble> createBubble(String name, String topic) async {
    try {
      Map<Object?, Object?> result =
          await platform.invokeMethod("createBubble", {
        "name": name,
        "topic": topic,
      });

      return Bubble.fromMap(result);
    } on PlatformException catch (e) {
      // Handle the platform exception, show a snackbar, etc.
      throw Exception("Error creating bubble: ${e.message}");
    }
  }

  Future<List<Map<String, String>>> getRainbowBubbles() async {
    try {
      // The result will be a List of Maps after this call
      final List<dynamic> result =
          await platform.invokeMethod('getRainbowBubbles');

      // Convert each item in the list to a Map<String, String>
      return result.map((dynamic item) {
        return Map<String, String>.from(item as Map);
      }).toList();
    } on PlatformException catch (e) {
      throw Exception("Error getting bubbles: ${e.message}");
    }
  }
}
