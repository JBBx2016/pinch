import 'dart:ffi';

class RequestType {
  const RequestType._(this.value);

  final int value;

  static const RequestType location = RequestType._(1);
  static const RequestType wifi = RequestType._(2);
  static const RequestType bluetooth = RequestType._(3);
  static const RequestType motion = RequestType._(4);
  static const RequestType notification = RequestType._(5);
  static const RequestType surveys = RequestType._(6);
  static const RequestType analytics = RequestType._(7);
  static const RequestType campaigns = RequestType._(8);
  static const RequestType ads = RequestType._(9);
  static const RequestType birthYear = RequestType._(10);
  static const RequestType gender = RequestType._(11);
  static const RequestType pinch = RequestType._(12);

  static const List<RequestType> values = <RequestType>[
    location,
    wifi,
    bluetooth,
    motion,
    notification,
    surveys,
    analytics,
    campaigns,
    ads,
    birthYear,
    gender,
    pinch
  ];

  static const List<int> _names = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  @override
  String toString() => 'RequestType.${_names[value]}';
}

class ActivityType {
  const ActivityType._(this.value);

  final int value;

  static const ActivityType vehicle = ActivityType._(0);
  static const ActivityType bicycle = ActivityType._(1);
  static const ActivityType foot = ActivityType._(2);
  static const ActivityType running = ActivityType._(8);
  static const ActivityType still = ActivityType._(3);
  static const ActivityType walking = ActivityType._(7);
  static const ActivityType unknown = ActivityType._(4);

  static const List<ActivityType> values = <ActivityType>[
    vehicle,
    bicycle,
    foot,
    running,
    still,
    walking,
    unknown
  ];

  static const List<int> _names = <int>[0, 1, 2, 8, 3, 7, 4];

  @override
  String toString() => 'ActivityType.${_names[value]}';
}

class PinchConsent {
  const PinchConsent._(this.value);

  final int value;

  static const PinchConsent analytics = PinchConsent._(1);
  static const PinchConsent surveys = PinchConsent._(2);
  static const PinchConsent campaigns = PinchConsent._(3);
  static const PinchConsent ads = PinchConsent._(4);

  static const List<PinchConsent> values = <PinchConsent>[
    analytics,
    surveys,
    campaigns,
    ads
  ];

  static const List<int> _names = <int>[1, 2, 3, 4];

  @override
  String toString() => 'PinchConsent.${_names[value]}';
}

class ActivityEvent {
  ActivityType type;
  Int64 startTime;
  Int64 endTime;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  int distance;
  int airDistance;
  int maxDistance;
  Int64 eventSavedTime;

  ActivityEvent(
      this.type,
      this.startTime,
      this.endTime,
      this.startLatitude,
      this.startLongitude,
      this.endLatitude,
      this.endLongitude,
      this.distance,
      this.airDistance,
      this.maxDistance,
      this.eventSavedTime);

  factory ActivityEvent.fromJson(dynamic json) {
    return ActivityEvent(
      ActivityType._(json["type"] as int),
      json["startTime"] as Int64,
      json["endTime"] as Int64,
      json["startLatitude"] as double,
      json["startLongitude"] as double,
      json["endLatitude"] as double,
      json["endLongitude"] as double,
      json["distance"] as int,
      json["airDistance"] as int,
      json["maxDistance"] as int,
      json["eventSavedTime"] as Int64,
    );
  }
}

class PinchMessage {
  String url;
  int expiry;
  int created;
  String title;
  String body;
  String imgUrl;
  String deliveryId;
  String messageId;
  bool opened;

  PinchMessage(this.url, this.expiry, this.created, this.title, this.body,
      this.imgUrl, this.deliveryId, this.messageId, this.opened);

  factory PinchMessage.fromJson(dynamic json) {
    return PinchMessage(
        json["url"] as String,
        json["expireTime"] as int,
        json["timestamp"] as int,
        json["messageTitle"] as String,
        json["messageBody"] as String,
        json["messageImageUrl"] as String,
        json["deliveryId"] as String,
        json["messageId"] as String,
        json["opened"] as bool);
  }

  @override
  String toString() {
    return '{${this.url}, ${this.expiry}, ${this.created}, ${this.title}, ${this.body}, ${this.imgUrl}, ${this.deliveryId}, ${this.messageId}, ${this.opened}}';
  }
}
