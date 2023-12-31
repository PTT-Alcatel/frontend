import 'package:pushtotalk/classes/bubble.dart';

abstract class Api {
  Future<dynamic> getBubbles();
  Future<dynamic> createBubble(Bubble bubble);
  Future<dynamic> updateBubble();
  Future<dynamic> deleteBubble();
}
