class Bubble {
  String id;
  String name;
  String? topic;
  double latitude;
  double longitude;
  String creatorId;

  Bubble({
    this.id = '',
    this.name = '',
    this.topic = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.creatorId = '',
  });

  factory Bubble.fromMap(Map<Object?, Object?> map) {
    return Bubble(
      id: map['id'] as String,
      name: map['name'] as String,
      topic: map['topic'] as String,
      creatorId: map['creatorId'] as String,
    );
  }

  // Only used for the backend
  factory Bubble.fromJson(Map<String, dynamic> json) {
    return Bubble(
      id: json['bubble_GUID'] as String,
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      creatorId: json['creator'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bubble_GUID': id,
      'name': name,
      'topic': topic,
      'latitude': latitude,
      'longitude': longitude,
      'creator': creatorId,
    };
  }
}
