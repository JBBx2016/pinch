import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pinch/src/pinch_enums.dart';

class PinchMetrics {
  static const MethodChannel _channel =
      const MethodChannel('com.fluxloop.pinch/sdk');
  static const type = 1;

  static Future<bool?> onboardingNotified(String onboardingVersion) => _channel.invokeMethod('metric', {"type": type, "version": onboardingVersion, "action": 1});

  static Future<bool?> onboardingNotificationDismissed() => _channel.invokeMethod('metric', {"type": type, "action": 2});

  static Future<bool?> onboardingStarted(String onboardingVersion) => _channel.invokeMethod('metric', {"type": type, "action": 3, "version": onboardingVersion});

  static Future<bool?> onboardingRequestedPermission(RequestType requestType, bool accepted) => _channel.invokeMethod('metric', {"type": type, "action": 4, "requestType": requestType.value, "accepted": accepted});

  static Future<bool?> onboardingRequestedRuntimePermission(RequestType requestType, bool accepted) => _channel.invokeMethod('metric', {"type": type, "action": 5, "requestType": requestType.value, "accepted": accepted});

  static Future<bool?> onboardingCancelled() => _channel.invokeMethod('metric', {"type": type, "action": 6});

  static Future<bool?> onboardingCompleted() => _channel.invokeMethod('metric', {"type": type, "action": 7});
}
