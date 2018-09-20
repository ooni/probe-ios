#import "NSDictionary+Safety.h"

@implementation NSDictionary (Safety)

- (id)safeObjectForKey:(id)aKey {
    NSObject *object = self[aKey];
    
    if (object == nil) {
        return @"";
    }

    if (object == [NSNull null]) {
        return @"";
    }
    
    return object;
}

@end
