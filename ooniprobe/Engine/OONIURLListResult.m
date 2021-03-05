#import "OONIURLListResult.h"

@implementation OONIURLListResult

- (id) initWithResults:(OonimkallURLListResult*)r {
    self = [super init];
    if (self) {
        self.urls = [NSMutableArray new];
        for (int i = 0; i < r.size; i++) {
            [self.urls addObject:[[OONIURLInfo alloc] initWithURLInfo:[r at:i]]];
        }
    }
    return self;
}

@end
