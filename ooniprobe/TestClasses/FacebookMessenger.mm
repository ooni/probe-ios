#import "FacebookMessenger.h"

@implementation FacebookMessenger : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
    }
    return self;
}

-(void) runTest {
    [super initCommon];
    [super runTest];
}

/*
 if "facebook_tcp_blocking", "facebook_dns_blocking" are null => failed
 if "facebook_tcp_blocking" or "facebook_dns_blocking" are true => anomalous
 */
-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    //NSDictionary *testKeys = jsonResult.test_keys;
    //set anomaly if either "facebook_tcp_blocking" or "facebook_dns_blocking" is true
    if (json.test_keys.facebook_tcp_blocking == NULL || json.test_keys.facebook_dns_blocking == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = [json.test_keys.facebook_tcp_blocking boolValue] || [json.test_keys.facebook_dns_blocking boolValue];
    [super onEntry:json obj:measurement];
}

@end
