## 2.1.0
### Android
#### Features
* Motion activities generated on device is now accessible to developers. `getActivityEvents` returns a list of serialized events. `ActivityEvent.fromJson` can be used to deserialize these.
* Currently enabled providers can be queried with `getEnabledProviders`.


#### Bugfixes
* Fixes an issue where incorrect sensor states for bluetooth were reported
* Fixes an issue where RSSI was reported as txPower and txPower as RSSI for beacons
* Fixes an issue where access to notification channel would always be reported as available
* Fixes an issue where beacon events would not contain derived location
* Fixes an issue where uploaded events would be erroneously stored
* Fixes an issue where approximate distance traveled inside a predefined polygon would not be reported
* Marked boot listener as exported for Android 12 compliancy

#### Behaviour changes
* Marked `.start()` as deprecated.
* Marked parameter for `.getPrivacyDashboard()` as deprecated.
* Emit warning if Pinch is started without consents.
* Birthyear supplied in demographic profile is now aggregated into a 5 year interval
* Age group and gender is now periodically synchronized to cloud
* Logs when Pinch is explicitly toggled.

## 2.0.1
* Fixes crashes related to CoreData

## 2.0.0
* Updated lib for iOS
* Use SDK 2.14.0 and Flutter 2.5.0

## 1.0.1
* Updated lib for iOS

## 1.0.0

* Initial release
