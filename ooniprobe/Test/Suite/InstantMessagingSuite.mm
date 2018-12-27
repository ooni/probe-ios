#import "InstantMessagingSuite.h"

@implementation InstantMessagingSuite
-(id) init {
    self = [super init];
    if (self) {
        [super initResult:nil];
        [self.result setTest_group_name:@"instant_messaging"];
        if ([SettingsUtility getSettingWithName:@"test_whatsapp"]){
            [self addTest:@"whatsapp"];
        }
        if ([SettingsUtility getSettingWithName:@"test_telegram"]){
            [self addTest:@"telegram"];
        }
        if ([SettingsUtility getSettingWithName:@"test_facebook_messenger"]){
            [self addTest:@"facebook_messenger"];
        }
        [self.result save];
    }
    return self;
}

-(id) initWithTest:(NSString*)test_name andResult:(Result*)result{
    self = [super init];
    if (self) {
        [super initResult:result];
        [self.result setTest_group_name:@"instant_messaging"];
        [self addTest:test_name];
    }
    return self;
}

-(void)runTestSuite {
    [super runTestSuite];
}

@end
