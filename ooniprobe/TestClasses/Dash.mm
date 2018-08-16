#import "Dash.h"

@implementation Dash : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"dash";
        self.measurement.test_name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::DashTest test;
    if (![SettingsUtility getSettingWithName:@"dash_server_auto"]){
        test.set_option("server", [[[NSUserDefaults standardUserDefaults] objectForKey:@"dash_server"] UTF8String]);
        test.set_option("port", [[[NSUserDefaults standardUserDefaults] objectForKey:@"dash_server_port"] UTF8String]);
    }
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)json {
    /*
     onEntry method for dash test, check "failure" key
     !=null => failed
     */
    self.measurement.is_failed = json.test_keys.failure == NULL ? false : true;
    [super onEntry:json];
}

@end
