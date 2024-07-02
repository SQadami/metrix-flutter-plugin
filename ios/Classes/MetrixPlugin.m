#import "MetrixPlugin.h"
#if __has_include(<metrix_analytics/metrix_analytics-Swift.h>)
#import <metrix_analytics/metrix_analytics-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "metrix_analytics-Swift.h"
#endif

@implementation MetrixPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMetrixPlugin registerWithRegistrar:registrar];
}
@end
