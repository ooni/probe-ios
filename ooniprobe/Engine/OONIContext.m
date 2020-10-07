#import "OONIContext.h"

@implementation OONIContext

- (id) initWithContext:(OonimkallContext*)ctx {
    self = [super init];
    if (self) {
        self.ctx = ctx;
    }
    return self;
}

- (void) cancel {
    [self.ctx cancel];
}

@end
