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
    bool isTransportBlocked = [json.test_keys.transport_status[@"openvpn"]  isEqual: @"blocked"] || [json.test_keys.transport_status[@"obfs4"]  isEqual: @"blocked"];

    measurement.is_anomaly = !json.test_keys.ca_cert_status.boolValue || json.test_keys.api_failure != nil || isTransportBlocked;
    [super onEntry:json obj:measurement];

}

-(int)getRuntime{
    return 15;
}

@end
