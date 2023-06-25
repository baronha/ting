
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNTingSpec.h"

@interface Ting : NSObject <NativeTingSpec>
#else

#import <React/RCTBridgeModule.h>

@interface Ting : NSObject <RCTBridgeModule>
#endif

@end
