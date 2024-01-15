class Bubble {
  int bubble_GUID;
  String name;
  String topic;
  double latitude;
  double longitude;
  String creatorId;

  Bubble({
    this.bubble_GUID = 0,
    this.name = '',
    this.topic = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.creatorId = '',
  });

  factory Bubble.fromMap(Map<String, dynamic> map) {
    return Bubble(
      bubble_GUID: map['bubble_GUID'],
      name: map['name'] as String,
      topic: map['topic'] as String,
      latitude: double.parse(map['latitude']),
      longitude: double.parse(map['longitude']),
      creatorId: map['creator'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bubble_GUID': bubble_GUID,
      'name': name,
      'topic': topic,
      'latitude': latitude,
      'longitude': longitude,
      'creator': creatorId,
    };
  }
}

class BubbleBack {
  int bubble_GUID;
  String name;
  String topic;
  double latitude;
  double longitude;
  String creatorId;

  BubbleBack({
    this.bubble_GUID = 0,
    this.name = '',
    this.topic = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.creatorId = '',
  });

  factory BubbleBack.fromMap(Map<String, dynamic> map) {
    return BubbleBack(
      bubble_GUID: map['bubble_GUID'],
      name: map['name'] as String,
      latitude: double.parse(map['latitude']),
      longitude: double.parse(map['longitude']),
      creatorId: map['creator'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bubble_GUID': bubble_GUID,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'creator': creatorId,
    };
  }
}
