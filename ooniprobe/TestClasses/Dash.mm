#import "Dash.h"

@implementation Dash : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"dash";
        self.settings.name = [LocalizationUtility getMKNameForTest:self.name];
        if (![SettingsUtility getSettingWithName:@"dash_server_auto"]){
            self.settings.options.server = [[NSUserDefaults standardUserDefaults] objectForKey:@"dash_server"];
            self.settings.options.port = [[NSUserDefaults standardUserDefaults] objectForKey:@"dash_server_port"];
        }
    }
    return self;
}

-(void) runTest {
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     onEntry method for dash test, check "failure" key
     !=null => failed
     */
    measurement.is_failed = json.test_keys.failure == NULL ? false : true;
    [super onEntry:json obj:measurement];
}

@end
