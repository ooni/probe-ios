#import "WebsitesSuite.h"

@implementation WebsitesSuite

-(id) init {
    self = [super init];
    if (self) {
        self.dataUsage = @"~ 8 MB";
        self.name = @"websites";
    }
    return self;
}

-(void)setUrls:(NSArray*)inputs{
    if([[self getTestList] count] > 0){
        WebConnectivity *wc = [self.testList objectAtIndex:0];
        wc.settings.inputs = inputs;
    }
}

-(void)setDefaultMaxRuntime {
    if([[self getTestList] count] > 0){
        WebConnectivity *wc = [self.testList objectAtIndex:0];
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        wc.settings.options.max_runtime = max_runtime;
    }
}

- (NSArray*)getTestList {
    if ([self.testList count] == 0){
        [self.testList addObject:[[WebConnectivity alloc] init]];
    }
    return super.getTestList;
}

@end
