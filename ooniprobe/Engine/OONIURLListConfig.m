#import "OONIURLListConfig.h"

@implementation OONIURLListConfig

- (OonimkallURLListConfig*) toOonimkallURLListConfig {
    OonimkallURLListConfig* c = [[OonimkallURLListConfig alloc] init];
    c.limit = self.limit;
    c.countryCode = self.countryCode;
    for (NSString* category in self.categories) {
        [c addCategory:category];
    }
    return c;
}

@end
