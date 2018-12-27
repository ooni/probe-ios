#import "Dash.h"

@implementation Dash : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"dash";
        self.settings.name = [LocalizationUtility getMKNameForTest:self.name];
    }
    return self;
}

-(void) runTest {
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     onEntry method for dash test, check "failure" key
     !=null => failed
     */
    measurement.is_failed = json.test_keys.failure == NULL ? false : true;
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 45;
}

@end
