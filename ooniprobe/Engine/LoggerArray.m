#import "LoggerArray.h"

@implementation LoggerArray
- (id) init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray new];
    }
    return self;
}

- (void) debug:(NSString*) message {
    [self.array addObject:message];
}

- (void) info:(NSString*) message {
    [self.array addObject:message];
}

- (void) warn:(NSString*) message {
    [self.array addObject:message];
}

@end
