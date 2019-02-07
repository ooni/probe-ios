#import "MiddleBoxesSuite.h"

@implementation MiddleBoxesSuite

-(id) init {
    self = [super init];
    if (self) {
        self.dataUsage = @"< 1 MB";
        self.name = @"middle_boxes";
    }
    return self;
}

- (NSArray*)getTestList {
    if ([self.testList count] == 0){
        if ([SettingsUtility getSettingWithName:@"run_http_invalid_request_line"])
            [self.testList addObject:[[HttpInvalidRequestLine alloc] init]];
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"])
            [self.testList addObject:[[HttpHeaderFieldManipulation alloc] init]];
    }
    return super.getTestList;
}
@end
