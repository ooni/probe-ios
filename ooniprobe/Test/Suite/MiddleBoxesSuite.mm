#import "MiddleBoxesSuite.h"

@implementation MiddleBoxesSuite

-(id) init {
    self = [super init];
    if (self) {
        [self initResult:nil];
        [self.result setTest_group_name:@"middle_boxes"];
        if ([SettingsUtility getSettingWithName:@"run_http_invalid_request_line"]){
            [self addTest:@"http_invalid_request_line"];
        }
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"]){
            [self addTest:@"http_header_field_manipulation"];
        }
    }
    return self;
}

-(id) initWithTest:(NSString*)test_name andResult:(Result*)result{
    self = [super init];
    if (self) {
        [self initResult:result];
        [self.result setTest_group_name:@"middle_boxes"];
        [self addTest:test_name];
    }
    return self;
}

-(void)runTestSuite {
    [super runTestSuite];
}

@end
