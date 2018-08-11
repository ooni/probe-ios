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
    //TODO check if serverName is stored
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

//TODO
-(void)setTestSummary:(NSDictionary*)keys{
    TestKeys *testKeys = [self.measurement getTestKeys];
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
}

@end
