#import "Tor.h"

@implementation Tor

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"tor";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    if (json.test_keys == NULL) {
        measurement.is_failed = true;
        return;
    }
    measurement.is_anomaly = (([json.test_keys.dir_port_accessible doubleValue] <= 0 && [json.test_keys.dir_port_total doubleValue] > 0) ||
            ([json.test_keys.obfs4_accessible doubleValue] <= 0 && [json.test_keys.obfs4_total doubleValue] > 0) ||
            ([json.test_keys.or_port_dirauth_accessible doubleValue] <= 0 && [json.test_keys.or_port_dirauth_total doubleValue] > 0) ||
            ([json.test_keys.or_port_accessible doubleValue] <= 0 && [json.test_keys.or_port_total doubleValue] > 0));
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 40;
}

@end
