#import "FacebookMessenger.h"

@implementation FacebookMessenger : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::FacebookMessengerTest test;
    [super initCommon:test];
}

/*
 if "facebook_tcp_blocking", "facebook_dns_blocking" are null => failed
 if "facebook_tcp_blocking" or "facebook_dns_blocking" are true => anomalous
 */
-(void)onEntry:(JsonResult*)json {
    //NSDictionary *testKeys = jsonResult.test_keys;
    //set anomaly if either "facebook_tcp_blocking" or "facebook_dns_blocking" is true
    if (json.test_keys.facebook_tcp_blocking == NULL || json.test_keys.facebook_dns_blocking == NULL)
        [self.measurement setState:measurementFailed];
    else {
        [self.measurement setState:measurementDone];
        self.measurement.anomaly = [json.test_keys.facebook_tcp_blocking boolValue] || [json.test_keys.facebook_dns_blocking boolValue];
    }
    [super onEntry:json];
/*
    NSArray *checkKeys = [[NSArray alloc] initWithObjects:@"facebook_tcp_blocking", @"facebook_dns_blocking", nil];
    for (NSString *key in checkKeys) {
        if ([keys objectForKey:key]){
            if ([keys objectForKey:key] == [NSNull null]) {
                if (self.measurement.state != measurementFailed)
                    [self.measurement setState:measurementFailed];
            }
            else if ([[keys objectForKey:key] boolValue]) {
                [self.measurement setAnomaly:YES];
            }
        }
    }
 */
    //[super updateSummary];
    //[self setTestSummary:keys :checkKeys];
    //[self.measurement save];
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
    //[self.result save];
}

@end
