#import "OONICheckInResults.h"

@implementation OONICheckInResults

- (id) initWithResults:(OonimkallCheckInInfo*)r {
    self = [super init];
    if (self) {
        self.webConnectivity = [[OONICheckInInfoWebConnectivity alloc] initWithURLInfo:r.webConnectivity];
    }
    return self;
}

@end

@implementation OONICheckInInfoWebConnectivity

- (id) initWithURLInfo:(OonimkallCheckInInfoWebConnectivity*)r {
    self = [super init];
    if (self) {
        self.reportID = r.reportID;
        self.urls = [NSMutableArray new];
        for (int i = 0; i < r.size; i++) {
            [self.urls addObject:[[OONIURLInfo alloc] initWithURLInfo:[r at:i]]];
        }
    }
    return self;
}

@end
