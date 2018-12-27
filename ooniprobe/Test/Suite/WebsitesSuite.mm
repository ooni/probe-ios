#import "WebsitesSuite.h"

@implementation WebsitesSuite

-(id) init {
    self = [super init];
    if (self) {
        [super initResult:nil];
        [self.result setTest_group_name:@"websites"];
        [self addTest:@"web_connectivity"];
    }
    return self;
}

-(id) initWithUrls:(NSArray*)urls andResult:(Result*)result{
    self = [super init];
    if (self) {
        [super initResult:result];
        [self.result setTest_group_name:@"websites"];
        [self addTest:@"web_connectivity"];
        [self setUrls:urls];
    }
    return self;
}

-(void)setUrls:(NSArray*)inputs{
    if([self.testList count] > 0){
        WebConnectivity *wc = [self.testList objectAtIndex:0];
        wc.settings.inputs = inputs;
    }
}

-(void)setMaxRuntime {
    if([self.testList count] > 0){
        WebConnectivity *wc = [self.testList objectAtIndex:0];
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        wc.settings.options.max_runtime = max_runtime;
    }
}

-(void)runTestSuite {
    [super runTestSuite];
}
@end
