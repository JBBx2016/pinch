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

  static const List<int> _names = <int>[
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12
  ];

  @override
  String toString() => 'RequestType.${_names[value]}';
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

  static const List<int> _names = <int>[
    1,
    2,
    3,
    4
  ];

  @override
  String toString() => 'PinchConsent.${_names[value]}';
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

  PinchMessage(this.url, this.expiry, this.created, this.title, this.body, this.imgUrl, this.deliveryId, this.messageId, this.opened);

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
      json["opened"] as bool
    );
  }

  @override
  String toString() {
    return '{${this.url}, ${this.expiry}, ${this.created}, ${this.title}, ${this.body}, ${this.imgUrl}, ${this.deliveryId}, ${this.messageId}, ${this.opened}}';
  }
}
