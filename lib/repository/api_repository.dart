// Class responsible to communicate with api_service.dart

import 'dart:convert';

import 'package:pushtotalk/interfaces/api.dart';
import 'package:pushtotalk/classes/bubble.dart';
import 'package:pushtotalk/services/api_service.dart';

class ApiRepository implements Api {
  ApiService apiService = ApiService();

  @override
  Future createBubble(Bubble bubble) {
    return apiService.createBubble(bubble);
  }

  @override
  Future deleteBubble() {
    // TODO: implement deleteBubble
    throw UnimplementedError();
  }

  @override
  Future<List<Bubble>> getBubbles() async {
    var response = await apiService.getBubbles();
    var body = response.body;
    var jsonBody = jsonDecode(body);
    List<Bubble> bubbles =
        jsonBody.map<Bubble>((json) => Bubble.fromJson(json)).toList();
    return bubbles;
  }

  @override
  Future updateBubble() {
    // TODO: implement updateBubble
    throw UnimplementedError();
  }
}
