#import "TestDescriptor.h"

@implementation TestDescriptor
- (id)init {
    self = [super init];
    if (self) {
        self.enabled = true;
    }
    return self;
}
@end