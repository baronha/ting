#import "Ting.h"

#import <ting-Swift.h>

@implementation Ting

RCT_EXPORT_MODULE()


RCT_REMAP_METHOD(toast, options:(NSDictionary *)options)
{
  [self toast:options];
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTingSpecJSI>(params);
}
#endif

- (void)toast:(NSDictionary *)options {
    [TingModule toast:options];
}

- (void)alert:(NSDictionary *)options {
    [TingModule alert:options];
}

- (void)dismissAlert {
    [TingModule dismissAlert];
}

@end
