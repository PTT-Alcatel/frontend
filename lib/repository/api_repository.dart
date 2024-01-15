// Class responsible to communicate with api_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
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
  Future<List<BubbleBack>> getBubbles() async {
    final http.Response response = await apiService.getBubbles();
    final List<dynamic> data = json.decode(response.body);
    return data.map((e) => BubbleBack.fromMap(e)).toList();
  }

  @override
  Future updateBubble() {
    // TODO: implement updateBubble
    throw UnimplementedError();
  }
}
