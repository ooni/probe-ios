#import "LoggerComposed.h"

@implementation LoggerComposed
- (id) initWithLeft:(id<OONILogger>)left right:(id<OONILogger>)right {
    self = [super init];
    if (self) {
        self.left = left;
        self.right = right;
    }
    return self;
}

- (void) debug:(NSString*) message {
    [self.left debug:message];
    [self.right debug:message];
}

- (void) info:(NSString*) message {
    [self.left info:message];
    [self.right info:message];
}

- (void) warn:(NSString*) message {
    [self.left warn:message];
    [self.right warn:message];
}

@end
