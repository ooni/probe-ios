#import "PELoggerAdapter.h"

@implementation PELoggerAdapter

- (id)initWithLogger:(id<OONILogger>)logger {
    self = [super init];
    if (self) {
        self.logger = logger;
    }
    return self;
}

- (void) debug:(NSString*) message {
    [self.logger debug:message];
}

- (void) info:(NSString*) message {
    [self.logger info:message];
}

- (void) warn:(NSString*) message {
    [self.logger warn:message];
}

@end
