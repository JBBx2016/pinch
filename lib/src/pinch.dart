import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pinch/pinch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pinch {
  static const MethodChannel _channel =
      const MethodChannel('com.fluxloop.pinch/sdk');

  static Future<bool?> setApiKey(String apiKey) =>
      _channel.invokeMethod('setApiKey', {"apiKey": apiKey});
  static Future<bool?> setProductionMode(bool inProduction) =>
      _channel.invokeMethod('setProductionMode', {"enabled": inProduction});
  static Future<bool?> setMessagingId(String messagingId) =>
      _channel.invokeMethod('setMessagingId', {"messagingId": messagingId});

  static Future<bool?> start() => _channel.invokeMethod('start');
  static Future<bool?> startBluetoothProvider() =>
      _channel.invokeMethod('startBluetoothProvider');
  static Future<bool?> startLocationProvider() =>
      _channel.invokeMethod('startLocationProvider');
  static Future<bool?> startMotionProvider() =>
      _channel.invokeMethod('startMotionProvider');

  static Future<bool?> stop() => _channel.invokeMethod('stop');
  static Future<bool?> stopBluetoothProvider() =>
      _channel.invokeMethod('stopBluetoothProvider');
  static Future<bool?> stopLocationProvider() =>
      _channel.invokeMethod('stopLocationProvider');
  static Future<bool?> stopMotionProvider() =>
      _channel.invokeMethod('stopMotionProvider');

  static Future<bool?> addCustomEvent(String type, String json) =>
      _channel.invokeMethod('addCustomEvent', {"json": json, "type": type});
  static Future<bool?> setMetadata(String type, String json) =>
      _channel.invokeMethod('setMetadata', {"json": json, "type": type});
  static Future<bool?> sendDemographicProfile(int birthYear, String gender) =>
      _channel.invokeMethod(
          'sendDemographicProfile', {"birthYear": birthYear, "gender": gender});

  static Future<bool?> setLogLevel(int logLevel) =>
      _channel.invokeMethod('setLogLevel', {"logLevel": logLevel});

  static Future<String?> getPrivacyTermsUrl() =>
      _channel.invokeMethod('getPrivacyTermsUrl');
  static Future<String?> getPrivacyDashboard(PinchConsent consent) => _channel
      .invokeMethod('getPrivacyDashboard', {"consentId": consent.value});
  static Future<bool?> grant(PinchConsent consent) =>
      _channel.invokeMethod('grant', {"consentId": consent.value});
  static Future<bool?> revoke(PinchConsent consent) =>
      _channel.invokeMethod('revoke', {"consentId": consent.value});
  static Future<bool?> deleteCollectedData() =>
      _channel.invokeMethod('deleteCollectedData');
  static Future<List<int>?> getGrantedConsents() =>
      _channel.invokeMethod('getGrantedConsents');
  static Future<bool?> setAdid(String adid) =>
      _channel.invokeMethod('setAdid', {"adid": adid});

  static Future<bool?> requestBluetoothPermission() =>
      _channel.invokeMethod('requestBluetoothPermission');
  static Future<bool?> requestMotionPermission() =>
      _channel.invokeMethod('requestBluetoothPermission');

  static Future<List<PinchMessage>> getMessages() async {
    var dashboardUrl = await getPrivacyDashboard(PinchConsent.analytics);
    var urlParts = dashboardUrl!.split("?key=");
    if (urlParts.length != 2) return [];
    var apiKey = await _channel.invokeMethod('getApiKey') as String;

    var key = urlParts[1];
    var url = "https://api.pinch.services/api/v1/messaging/messages";

    var res = await http.get(Uri.parse(url),
        headers: {"Authorization": "SHA256 $key", "Api-Key": apiKey});

    if (res.statusCode == 200) {
      var msgObjects = jsonDecode(res.body) as List;
      List<PinchMessage> pinchMessages =
          msgObjects.map((msgJson) => PinchMessage.fromJson(msgJson)).toList();
      return pinchMessages;
    } else {
      return List<PinchMessage>.empty();
    }
    //var msgArray = await _channel.invokeMethod('getMessages');
    //return new List();
  }
}
