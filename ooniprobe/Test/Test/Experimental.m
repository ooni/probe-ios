#import "Experimental.h"

@implementation Experimental

-(id) initWithName:(NSString*)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 30;
}

@end
