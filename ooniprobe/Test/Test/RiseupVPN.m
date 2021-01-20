#import "RiseupVPN.h"

@implementation RiseupVPN

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"riseupvpn";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    measurement.is_anomaly = json.test_keys.api_failure != nil && json.test_keys.ca_cert_status && json.test_keys.failing_gateways == nil;
    [super onEntry:json obj:measurement];

}

-(int)getRuntime{
    return 15;
}

@end
