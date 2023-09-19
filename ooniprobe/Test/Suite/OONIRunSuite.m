#import "OONIRunSuite.h"
#import "TestDescriptor.h"

@implementation OONIRunSuite
- (id)initWithDescriptor:(TestDescriptor *)descriptor {
    self = [super init];
    if (self) {
        self.dataUsage = @"~ 8 MB";
        self.name = @"ooni-run";
        self.descriptor = descriptor;
    }
    return self;
}


@end
