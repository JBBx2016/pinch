package com.fluxloop.pinch

import com.fluxloop.pinch.common.logging.LogLevel
import com.fluxloop.pinch.common.model.DemographicProfile
import com.fluxloop.pinch.sdk.Pinch
import com.fluxloop.pinch.sdk.PinchMetrics
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class PinchPlugin : FlutterPlugin, MethodCallHandler {
    private var methodChannel: MethodChannel? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "start" -> {
                    Pinch.start()
                    result.success(true)
                }
                "stop" -> {
                    Pinch.stop()
                    result.success(true)
                }
                "setMessagingId" -> {
                    val messagingId: String? = call.argument("messagingId")
                    Pinch.messagingId = messagingId
                    result.success(true)
                }
                "addCustomEvent" -> {
                    val type: String? = call.argument("type")
                    val json: String? = call.argument("json")
                    if (type == null || json == null) {
                        result.error("Received invalid data", call.method, null);
                    } else {
                        Pinch.addCustomEvent(type, json)
                        result.success(true)
                    }
                }
                "setMetadata" -> {
                    val type: String? = call.argument("type")
                    val json: String? = call.argument("json")
                    if (type == null || json == null) {
                        result.error("Received invalid data", call.method, null);
                    } else {
                        Pinch.setMetadata(type, json)
                        result.success(true)
                    }
                }
                "sendDemographicProfile" -> {
                    val birthYear: Int? = call.argument("birthYear")
                    val gender: String? = call.argument("gender")
                    if (birthYear == null || gender == null) {
                        result.error("Received invalid data", call.method, null);
                    } else {
                        val finalGender = when (gender) {
                            "male" -> DemographicProfile.Gender.MALE
                            "female" -> DemographicProfile.Gender.FEMALE
                            "unknown" -> DemographicProfile.Gender.UNKNOWN
                            else -> DemographicProfile.Gender.UNKNOWN
                        }
                        Pinch.sendDemographicProfile(DemographicProfile(birthYear = birthYear, gender = finalGender))
                        result.success(true)
                    }
                }
                "getStarted" -> {
                    result.success(Pinch.started)
                }
                "metric" -> {
                    sendMetric(call, result)
                }
                "setLogLevel" -> setLogLevel(call, result)
                "getPrivacyTermsUrl" -> result.success(Pinch.privacyTermsUrl)
                "getPrivacyDashboard" -> getPrivacyDashboard(call, result)
                "grant" -> grant(call, result)
                "revoke" -> revoke(call, result)
                "deleteCollectedData" -> Pinch.deleteCollectedData { result.success(it) }
                "getGrantedConsents" -> getGrantedConsents(result)
                "getApiKey" -> result.success(Pinch.apiKey)
                "setAdid" -> result.success(true)
                "startBluetoothProvider" -> {
                    Pinch.start(arrayOf(Pinch.Provider.BLUETOOTH))
                    result.success(true)
                }
                "startMotionProvider" -> {
                    Pinch.start(arrayOf(Pinch.Provider.MOTION))
                    result.success(true)
                }
                "startLocationProvider" -> {
                    Pinch.start(arrayOf(Pinch.Provider.LOCATION))
                    result.success(true)
                }
                "stopBluetoothProvider" -> {
                    Pinch.stop(arrayOf(Pinch.Provider.BLUETOOTH))
                    result.success(true)
                }
                "stopMotionProvider" -> {
                    Pinch.stop(arrayOf(Pinch.Provider.MOTION))
                    result.success(true)
                }
                "stopLocationProvider" -> {
                    Pinch.stop(arrayOf(Pinch.Provider.LOCATION))
                    result.success(true)
                }
                "requestBluetoothPermission" -> result.success(true)
                "requestMotionPermission" -> result.success(true)
                "getEnabledProviders" -> getEnabledProviders(result)
                "getActivityEvents" -> {
                    val fromTime: Long? = call.argument("fromTime")
                    val toTime: Long? = call.argument("toTime")
                    if (fromTime == null || toTime == null) {
                        result.error("Received invalid data", call.method, null);
                    } else {
                        getActivityEvents(fromTime, toTime, result)
                        result.success(true)
                    }
                }
                "anonymizeLocation" -> {
                    val latitude: Double? = call.argument("latitude")
                    val longitude: Double? = call.argument("longitude")
                    if (latitude == null || longitude == null || (latitude == 0.0 && longitude == 0.0)) {
                        result.error("Received invalid arguments", call.method, null)
                    } else {
                        anonymizeLocation(latitude, longitude, result)
                    }
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("Exception encountered", call.method, e)
        }
    }


    private fun getGrantedConsents(result: Result) {
        val consents = arrayListOf<Int>()
        for (consent in Pinch.grantedConsents) {
            when (consent) {
                Pinch.Consent.ANALYTICS -> consents.add(1)
                Pinch.Consent.SURVEYS -> consents.add(2)
                Pinch.Consent.CAMPAIGNS -> consents.add(3)
                Pinch.Consent.ADS -> consents.add(4)
            }
        }
        return result.success(consents.toList())
    }

    private fun getEnabledProviders(result: Result) {
        val providers = arrayListOf<String>()
        for (provider in Pinch.enabledProviders) {
            when (provider) {
                Pinch.Provider.LOCATION -> providers.add("location")
                Pinch.Provider.BLUETOOTH -> providers.add("bluetooth")
                Pinch.Provider.MOTION -> providers.add("motion")
            }
        }
        return result.success(providers.toList())
    }

    private fun getActivityEvents(fromTime: Long, toTime: Long, result: Result) {
        Pinch.getActivityEvents(fromTime, toTime) { activityEvents ->
            result.success(activityEvents)
        }
    }

    private fun anonymizeLocation(latitude: Double, longitude: Double, result: Result) {
        Pinch.anonymizeLocation(latitude, longitude) { locationId -> result.success(locationId)}
    }

    private fun setLogLevel(call: MethodCall, result: Result) {
        when (call.argument("logLevel") as Int?) {
            0 -> Pinch.logLevel = LogLevel.EMPTY
            1 -> Pinch.logLevel = LogLevel.TRACE
            2 -> Pinch.logLevel = LogLevel.VERBOSE
            3 -> Pinch.logLevel = LogLevel.WARNING
            4 -> Pinch.logLevel = LogLevel.INFO
            else -> {
                result.error("Invalid logLevel supplied", call.method, null)
                return
            }
        }
        return result.success(true)
    }

    private fun getPrivacyDashboard(call: MethodCall, result: Result) {
        when (call.argument<Int?>("consentId")) {
            1 -> result.success(Pinch.getPrivacyDashboard(Pinch.Consent.ANALYTICS))
            2 -> result.success(Pinch.getPrivacyDashboard(Pinch.Consent.SURVEYS))
            3 -> result.success(Pinch.getPrivacyDashboard(Pinch.Consent.CAMPAIGNS))
            4 -> result.success(Pinch.getPrivacyDashboard(Pinch.Consent.ADS))
            else -> result.success(Pinch.getPrivacyDashboard(Pinch.Consent.ANALYTICS))
        }
    }

    private fun grant(call: MethodCall, result: Result) {
        when (call.argument<Int?>("consentId")) {
            1 -> Pinch.grant(arrayOf(Pinch.Consent.ANALYTICS))
            2 -> Pinch.grant(arrayOf(Pinch.Consent.SURVEYS))
            3 -> Pinch.grant(arrayOf(Pinch.Consent.CAMPAIGNS))
            4 -> Pinch.grant(arrayOf(Pinch.Consent.ADS))
            else -> result.error("Invalid consent supplied", call.method, null)
        }
        result.success(true)
    }

    private fun revoke(call: MethodCall, result: Result) {
        when (call.argument<Int?>("consentId")) {
            1 -> Pinch.revoke(arrayOf(Pinch.Consent.ANALYTICS)) { result.success(it) }
            2 -> Pinch.revoke(arrayOf(Pinch.Consent.SURVEYS)) { result.success(it) }
            3 -> Pinch.revoke(arrayOf(Pinch.Consent.CAMPAIGNS)) { result.success(it) }
            4 -> Pinch.revoke(arrayOf(Pinch.Consent.ADS)) { result.success(it) }
            else -> result.error("Invalid consent supplied", call.method, null)
        }
    }

    private fun sendMetric(call: MethodCall, result: Result) {
        var failed = false
        val type: Int? = call.argument("type")
        val action: Int? = call.argument("action")

        if (type == null || action == null) {
            result.success(false)
            return
        }

        // 1 == Onboarding
        val version: String? = call.argument("version")
        val requestType: Int? = call.argument("requestType")
        val accepted: Boolean? = call.argument("accepted")

        if (type == 1) {
            when (action) {
                1 -> PinchMetrics.Onboarding.notified(version = version ?: "0")
                2 -> PinchMetrics.Onboarding.notificationDismissed()
                3 -> PinchMetrics.Onboarding.started(version = version ?: "0")
                4, 5 -> {
                    if (requestType == null || accepted == null) {
                        failed = true
                    } else {
                        val requestedType = getRequestType(requestType)
                        if (requestedType != null) {
                            if (type == 4) {
                                PinchMetrics.Onboarding.requestedPermission(requestedType, accepted)
                            } else if (type == 5) {
                                PinchMetrics.Onboarding.requestedRuntimePermission(requestedType, accepted)
                            }
                        } else {
                            failed = true
                        }
                    }
                }
                6 -> PinchMetrics.Onboarding.cancelled()
                7 -> PinchMetrics.Onboarding.completed()
                else -> failed = true
            }
        }
        result.success(!failed)
    }

    private fun getRequestType(requestType: Int): PinchMetrics.Onboarding.RequestType? {
        return when (requestType) {
            1 -> PinchMetrics.Onboarding.RequestType.LOCATION
            2 -> PinchMetrics.Onboarding.RequestType.WIFI
            3 -> PinchMetrics.Onboarding.RequestType.BLUETOOTH
            4 -> PinchMetrics.Onboarding.RequestType.MOTION
            6 -> PinchMetrics.Onboarding.RequestType.SURVEYS
            7 -> PinchMetrics.Onboarding.RequestType.ANALYTICS
            8 -> PinchMetrics.Onboarding.RequestType.CAMPAIGNS
            9 -> PinchMetrics.Onboarding.RequestType.ADS
            10 -> PinchMetrics.Onboarding.RequestType.BIRTH_YEAR
            11 -> PinchMetrics.Onboarding.RequestType.GENDER
            12 -> PinchMetrics.Onboarding.RequestType.PINCH
            else -> null
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "com.fluxloop.pinch/sdk")
        methodChannel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }
}
