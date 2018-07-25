#import "Whatsapp.h"

@implementation Whatsapp : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"whatsapp";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::WhatsappTest test;
    if ([SettingsUtility getSettingWithName:@"test_whatsapp_extensive"]){
        test.set_option("all_endpoints", YES);
    }
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)json {
    [super onEntry:json];
    /*
     if "whatsapp_endpoints_status", "whatsapp_web_status", "registration_server" are null => failed
     if "whatsapp_endpoints_status" or "whatsapp_web_status" or "registration_server_status" are "blocked" => anomalous
     */
    //TestKeys *testKeys = jsonResult.test_keys;
    if (json.test_keys.whatsapp_endpoints_status == NULL || json.test_keys.whatsapp_web_status == NULL || json.test_keys.registration_server_status == NULL)
        [self.measurement setState:measurementFailed];
    else {
        [self.measurement setState:measurementDone];
        self.measurement.anomaly = [json.test_keys.whatsapp_endpoints_status isEqualToString:@"blocked"] || [json.test_keys.whatsapp_web_status isEqualToString:@"blocked"] || [json.test_keys.registration_server_status isEqualToString:@"blocked"];
    }
    /*
    NSArray *checkKeys = [[NSArray alloc] initWithObjects:@"whatsapp_endpoints_status", @"whatsapp_web_status", @"registration_server_status", nil];
    for (NSString *key in checkKeys) {
        if ([keys objectForKey:key]){
            if ([keys objectForKey:key] == [NSNull null]) {
                if (self.measurement.state != measurementFailed)
                    [self.measurement setState:measurementFailed];
            }
            else if ([[keys objectForKey:key] isEqualToString:@"blocked"]) {
                [self.measurement setAnomaly:YES];
            }
        }
    }
     */
    [super updateSummary];
    //[self setTestSummary:keys :checkKeys];
    [self.measurement save];
}

-(void)setTestSummary:(NSDictionary*)keys :(NSArray*)checkKeys{
    Summary *summary = [self.result getSummary];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    for (NSString *key in checkKeys) {
        if ([keys safeObjectForKey:key]){
            [values setObject:[keys objectForKey:key] forKey:key];
        }
    }
    [summary.json setValue:values forKey:self.name];
    [self.result save];
}

@end
