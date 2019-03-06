#import "WebConnectivity.h"
#import "MessageUtility.h"

@implementation WebConnectivity : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    if (self.inputs == nil || [self.inputs count] == 0){
        //Download urls and then alloc class
        [TestUtility downloadUrls:^(NSArray *urls) {
            if (urls != nil && [urls count] > 0){
                [self setUrls:urls];
                [self setDefaultMaxRuntime];
                [super runTest];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showError" object:nil];
                [super testEnded];
            }
        }];
    }
    else {
        [self setUrls:self.inputs];
        [super runTest];
    }
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     null => failed
     false => not blocked
     string (dns, tcp-ip, http-failure, http-diff) => anomalous
     */
    if (json.test_keys.blocking == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = ![json.test_keys.blocking isEqualToString:@"0"];
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    if (self.settings.options.max_runtime != nil){
        return 30 + [self.settings.options.max_runtime intValue];
    }
    else if (self.settings.inputs != nil)
        return 30 + (int)[self.settings.inputs count] * 5;
    else {
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        return 30 + [max_runtime intValue];
    }
}

-(void)setUrls:(NSArray*)inputs{
    self.settings.inputs = inputs;
    self.inputs = nil;
}

-(void)setDefaultMaxRuntime {
    NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    self.settings.options.max_runtime = max_runtime;
}

@end
