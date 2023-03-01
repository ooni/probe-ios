#import "LoggeriOS.h"
#define TAG_ENGINE @"engine"
#import <CocoaLumberjack/CocoaLumberjack.h>
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@implementation LoggeriOS

- (void) debug:(NSString*) message {
    NSLog(@"%@: debug: %@", TAG_ENGINE, message);
    DDLogDebug(@"%@: debug: %@", TAG_ENGINE, message);
}

- (void) info:(NSString*) message {
    NSLog(@"%@: info: %@", TAG_ENGINE, message);
    DDLogInfo(@"%@: info: %@", TAG_ENGINE, message);
}

- (void) warn:(NSString*) message {
    NSLog(@"%@: warn: %@", TAG_ENGINE, message);
    DDLogWarn(@"%@: warn: %@", TAG_ENGINE, message);
}

@end
