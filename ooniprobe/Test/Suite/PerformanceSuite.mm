#import "PerformanceSuite.h"

@implementation PerformanceSuite


-(id) init {
    self = [super init];
    if (self) {
        [self initResult:nil];
        [self.result setTest_group_name:@"performance"];
        if ([SettingsUtility getSettingWithName:@"run_ndt"]){
            [self addTest:@"ndt"];
        }
        if ([SettingsUtility getSettingWithName:@"run_dash"]){
            [self addTest:@"dash"];
        }
    }
    return self;
}

-(id) initWithTest:(NSString*)test_name andResult:(Result*)result{
    self = [super init];
    if (self) {
        [self initResult:result];
        [self.result setTest_group_name:@"performance"];
        [self addTest:test_name];
    }
    return self;
}

-(void)runTestSuite {
    [super runTestSuite];
}

@end
