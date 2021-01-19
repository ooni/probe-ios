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
}

-(int)getRuntime{
    return 15;
}

@end
