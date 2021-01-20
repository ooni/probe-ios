#import "CircumventionSuite.h"

@implementation CircumventionSuite

-(id) init {
    self = [super init];
    if (self) {
        self.dataUsage = @"< 1 MB";
        self.name = @"circumvention";
    }
    return self;
}

- (NSArray*)getTestList {
    if ([self.testList count] == 0){
        if ([SettingsUtility getSettingWithName:@"test_psiphon"])
            [self.testList addObject:[[Psiphon alloc] init]];
        if ([SettingsUtility getSettingWithName:@"test_tor"])
            [self.testList addObject:[[Tor alloc] init]];
        if ([SettingsUtility getSettingWithName:@"test_riseupvpn"])
            [self.testList addObject:[[RiseupVPN alloc] init]];
    }
    return super.getTestList;
}

@end
