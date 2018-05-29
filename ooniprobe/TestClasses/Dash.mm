#import "Dash.h"

@implementation Dash : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"dash";
        self.measurement.name = self.name;
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
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        int blocking = MEASUREMENT_OK;
        /*
         onEntry method for ndt and dash test
         if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
         */
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        if ([keys objectForKey:@"failure"] != [NSNull null])
            blocking = MEASUREMENT_FAILURE;
        [super updateBlocking:blocking];
        [self setTestSummary:keys];
        [self.measurement save];
    }
}

-(void)setTestSummary:(NSDictionary*)keys{
    Summary *summary = [self.result getSummary];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    NSDictionary *simple = [keys safeObjectForKey:@"simple"];
    if ([simple safeObjectForKey:@"median_bitrate"]){
        [values setObject:[simple safeObjectForKey:@"median_bitrate"] forKey:@"median_bitrate"];
    }
    if ([simple safeObjectForKey:@"min_playout_delay"]){
        [values setObject:[simple safeObjectForKey:@"min_playout_delay"] forKey:@"min_playout_delay"];
    }
    [summary.json setValue:values forKey:self.name];
    [self.result save];
}

@end
