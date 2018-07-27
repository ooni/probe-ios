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
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)json {
    /*
     onEntry method for dash test, check "failure" key
     !=null => failed
     */
    //TestKeys *testKeys = json.test_keys;
    //if (testKeys.failure != NULL)
    //    [self.measurement setState:measurementFailed];
    self.measurement.state = json.test_keys.failure == NULL ? measurementDone : measurementFailed;
    [super onEntry:json];

    //TODO controllali
    //[super updateSummary];
    
    //Summary *summary = [self.result getSummary];
    //[summary.json setValue:testKeys forKey:self.name];
    //[self setTestSummary:testKeys];
    //[self.measurement save];
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
    //[self.result save];
}

@end
