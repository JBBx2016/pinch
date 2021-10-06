#import "PinchPlugin.h"
#import <pinch/pinch-Swift.h>

@implementation PinchPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPinchPlugin registerWithRegistrar:registrar];
}
@end
