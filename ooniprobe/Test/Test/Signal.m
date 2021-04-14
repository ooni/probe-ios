#import "Signal.h"

@implementation Signal

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"signal";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    measurement.is_failed = [json.test_keys.signal_backend_status length] == 0;
    measurement.is_anomaly = [json.test_keys.signal_backend_status isEqualToString:BLOCKING];
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 10;
}

@end
