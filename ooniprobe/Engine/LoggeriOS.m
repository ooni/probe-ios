#import "LoggeriOS.h"
#define TAG_ENGINE @"engine"

@implementation LoggeriOS

- (void) debug:(NSString*) message {
    NSLog(@"%@ %@", TAG_ENGINE, message);
}

- (void) info:(NSString*) message {
    NSLog(@"%@ %@", TAG_ENGINE, message);
}

- (void) warn:(NSString*) message {
    NSLog(@"%@ %@", TAG_ENGINE, message);
}

@end
