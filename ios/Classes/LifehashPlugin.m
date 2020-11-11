#import "LifehashPlugin.h"
#if __has_include(<lifehash/lifehash-Swift.h>)
#import <lifehash/lifehash-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lifehash-Swift.h"
#endif

@implementation LifehashPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLifehashPlugin registerWithRegistrar:registrar];
}
@end
