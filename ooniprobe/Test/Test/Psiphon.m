#import "Psiphon.h"

@implementation Psiphon

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"psiphon";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    measurement.is_anomaly = json.test_keys.failure == NULL ? false : true;
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 20;
}

@end
