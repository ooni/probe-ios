#import "NdtTest.h"

@implementation NdtTest : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"ndt";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}


-(void) runTest {
    mk::nettests::NdtTest test;
    if (![SettingsUtility getSettingWithName:@"ndt_server_auto"]){
        test.set_option("server", [[[NSUserDefaults standardUserDefaults] objectForKey:@"ndt_server"] UTF8String]);
        test.set_option("port", [[[NSUserDefaults standardUserDefaults] objectForKey:@"ndt_server_port"] UTF8String]);
    }
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)json {
    [self calculateServerName:json];
    self.measurement.state = json.test_keys.failure == NULL ? measurementDone : measurementFailed;
    [super onEntry:json];
    /*
     onEntry method for ndt test, check "failure" key
     !=null => failed
     */
    //TestKeys *testKeys = json.test_keys;
    //if (testKeys.failure != NULL)
    //    [self.measurement setState:measurementFailed];

    //[super updateSummary];
    //[self setTestSummary:keys];
    //[self.measurement save];
}

-(void)calculateServerName:(JsonResult*)json{
    if (json.test_keys.server_address != NULL){
        NSString *server_address = json.test_keys.server_address;
        NSArray *arr = [server_address componentsSeparatedByString:@"."];
        if ([arr count] > 3){
            NSString *server_name = [arr objectAtIndex:3];
            json.test_keys.server_name = server_name;
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Airports" ofType:@"plist"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            if ([dict objectForKey:[server_name substringToIndex:3]])
                json.test_keys.server_country = [dict objectForKey:[server_name substringToIndex:3]];
        }
    }
}

-(void)setTestSummary:(NSDictionary*)keys{
    Summary *summary = [self.result getSummary];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    if ([keys safeObjectForKey:@"server_address"]){
        NSString *server_address = [keys safeObjectForKey:@"server_address"];
        [values setObject:server_address forKey:@"server_address"];
        NSArray *arr = [server_address componentsSeparatedByString:@"."];
        if ([arr count] > 3){
            NSString *server_name = [arr objectAtIndex:3];
            [values setObject:server_name forKey:@"server_name"];
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Airports" ofType:@"plist"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            if ([dict objectForKey:[server_name substringToIndex:3]])
                [values setObject:[dict objectForKey:[server_name substringToIndex:3]] forKey:@"server_country"];
        }
    }

    NSDictionary *simple = [keys safeObjectForKey:@"simple"];
    if ([simple safeObjectForKey:@"upload"]){
        [values setObject:[simple safeObjectForKey:@"upload"] forKey:@"upload"];
    }
    if ([simple safeObjectForKey:@"download"]){
        [values setObject:[simple safeObjectForKey:@"download"] forKey:@"download"];
    }
    if ([simple safeObjectForKey:@"ping"]){
        [values setObject:[simple safeObjectForKey:@"ping"] forKey:@"ping"];
    }
    NSDictionary *advanced = [keys safeObjectForKey:@"advanced"];
    if ([advanced safeObjectForKey:@"packet_loss"]){
        [values setObject:[advanced safeObjectForKey:@"packet_loss"] forKey:@"packet_loss"];
    }
    if ([advanced safeObjectForKey:@"out_of_order"]){
        [values setObject:[advanced safeObjectForKey:@"out_of_order"] forKey:@"out_of_order"];
    }
    if ([advanced safeObjectForKey:@"avg_rtt"]){
        [values setObject:[advanced safeObjectForKey:@"avg_rtt"] forKey:@"avg_rtt"];
    }
    if ([advanced safeObjectForKey:@"max_rtt"]){
        [values setObject:[advanced safeObjectForKey:@"max_rtt"] forKey:@"max_rtt"];
    }
    if ([advanced safeObjectForKey:@"mss"]){
        [values setObject:[advanced safeObjectForKey:@"mss"] forKey:@"mss"];
    }
    if ([advanced safeObjectForKey:@"timeouts"]){
        [values setObject:[advanced safeObjectForKey:@"timeouts"] forKey:@"timeouts"];
    }
    [summary.json setValue:values forKey:self.name];
    //[self.result save];
}

@end
