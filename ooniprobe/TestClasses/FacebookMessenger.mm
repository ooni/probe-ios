#import "FacebookMessenger.h"

@implementation FacebookMessenger : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
        self.measurement.test_name = self.name;
    }
    return self;
}

-(void) runTest {
    mk::nettests::FacebookMessengerTest test;
    [super initCommon];
}

/*
 if "facebook_tcp_blocking", "facebook_dns_blocking" are null => failed
 if "facebook_tcp_blocking" or "facebook_dns_blocking" are true => anomalous
 */
-(void)onEntry:(JsonResult*)json {
    //NSDictionary *testKeys = jsonResult.test_keys;
    //set anomaly if either "facebook_tcp_blocking" or "facebook_dns_blocking" is true
    if (json.test_keys.facebook_tcp_blocking == NULL || json.test_keys.facebook_dns_blocking == NULL)
        [self.measurement setIs_failed:true];
    else
        self.measurement.is_anomaly = [json.test_keys.facebook_tcp_blocking boolValue] || [json.test_keys.facebook_dns_blocking boolValue];
    
    [super onEntry:json];
}

@end
