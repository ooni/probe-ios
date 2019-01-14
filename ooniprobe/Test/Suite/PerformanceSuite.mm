#import "PerformanceSuite.h"

@implementation PerformanceSuite


-(id) init {
    self = [super init];
    if (self) {
        self.dataUsage = @"5 - 200 MB";
        self.name = @"performance";
    }
    return self;
}

- (NSArray*)getTestList {
    if (self.testList == nil){
        self.testList = [[NSMutableArray alloc] init];
        if ([SettingsUtility getSettingWithName:@"run_ndt"])
            [self.testList addObject:[[NdtTest alloc] init]];
        if ([SettingsUtility getSettingWithName:@"run_dash"])
            [self.testList addObject:[[Dash alloc] init]];
    }
    return super.getTestList;
}
@end
