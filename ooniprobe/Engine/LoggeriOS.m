#import "LoggeriOS.h"
#define TAG_ENGINE @"engine"

@implementation LoggeriOS

- (void) debug:(NSString*) message {
    NSLog(@"%@: debug: %@", TAG_ENGINE, message);
}

- (void) info:(NSString*) message {
    NSLog(@"%@: info: %@", TAG_ENGINE, message);
}

- (void) warn:(NSString*) message {
    NSLog(@"%@: warn: %@", TAG_ENGINE, message);
}

@end
