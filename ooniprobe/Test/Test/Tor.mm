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
    //TODO
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    //TODO
    return 0;
}

@end
