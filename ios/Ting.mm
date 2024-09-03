#import "Ting.h"

#if __has_include("ting-Swift.h")
    #import <ting-Swift.h>
#else
    // When using use_frameworks! :linkage => :static in Podfile
    #import <Ting/Ting-Swift.h>
#endif

@implementation Ting

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(toast, oldToast:(NSDictionary *)options)
{
  [self toast:options];
}

RCT_REMAP_METHOD(alert, oldAlert:(NSDictionary *)options)
{
  [self alert:options];
}

RCT_REMAP_METHOD(dismissAlert, oldDismissAlert)
{
  [self dismissAlert];
}

RCT_REMAP_METHOD(setup, oldSetup:(NSDictionary *)options)
{
  [self setup:options];
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

- (void)setup:(NSDictionary *)options {
    [TingModule setup:options];
}

- (void)dismissAlert {
    [TingModule dismissAlert];
}

@end
