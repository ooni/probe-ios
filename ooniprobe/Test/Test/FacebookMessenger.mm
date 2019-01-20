#import "FacebookMessenger.h"

@implementation FacebookMessenger : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
        self.settings.name = [LocalizationUtility getMKNameForTest:self.name];
    }
    return self;
}

-(void) runTest {
    [super runTest];
}

/*
 if "facebook_tcp_blocking", "facebook_dns_blocking" are null => failed
 if "facebook_tcp_blocking" or "facebook_dns_blocking" are true => anomalous
 */
-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    //set anomaly if either "facebook_tcp_blocking" or "facebook_dns_blocking" is true
    if (json.test_keys.facebook_tcp_blocking == NULL || json.test_keys.facebook_dns_blocking == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = [json.test_keys.facebook_tcp_blocking boolValue] || [json.test_keys.facebook_dns_blocking boolValue];
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 10;
}

@end
