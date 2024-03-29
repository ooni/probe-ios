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
    if (json.test_keys == NULL || json.test_keys.transport_status == NULL) {
        measurement.is_failed = true;
        return;
    }
    bool isTransportBlocked = [json.test_keys.transport_status[@"openvpn"]  isEqualToString:BLOCKED] || [json.test_keys.transport_status[@"obfs4"]  isEqualToString:BLOCKED];
    measurement.is_anomaly = !json.test_keys.ca_cert_status.boolValue || json.test_keys.api_failure != nil || isTransportBlocked;
    [super onEntry:json obj:measurement];

}

-(int)getRuntime{
    return 15;
}

@end
