#import "WebsitesSuite.h"

@implementation WebsitesSuite

-(id) init {
    self = [super init];
    if (self) {
        self.dataUsage = @"~ 8 MB";
        self.name = @"websites";
    }
    return self;
}

- (NSArray*)getTestList {
    if ([self.testList count] == 0){
        [self.testList addObject:[[WebConnectivity alloc] init]];
    }
    return super.getTestList;
}

@end
