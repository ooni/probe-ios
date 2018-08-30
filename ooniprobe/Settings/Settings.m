#import "Settings.h"

@implementation Settings

- (id)init {
    self = [super init];
    if (self) {
        //self.annotations = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[self.measurement.networkType UTF8String] forKey:@"network_type"]];
        self.options = [Options new];
    }
    return self;
}

@end
