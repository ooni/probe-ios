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
    if ([self.testList count] == 0){
        if ([SettingsUtility getSettingWithName:@"run_ndt"])
            [self.testList addObject:[[NdtTest alloc] init]];
        if ([SettingsUtility getSettingWithName:@"run_dash"])
            [self.testList addObject:[[Dash alloc] init]];
        if ([SettingsUtility getSettingWithName:@"run_http_invalid_request_line"])
            [self.testList addObject:[[HttpInvalidRequestLine alloc] init]];
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"])
            [self.testList addObject:[[HttpHeaderFieldManipulation alloc] init]];
    }
    return super.getTestList;
}
@end
