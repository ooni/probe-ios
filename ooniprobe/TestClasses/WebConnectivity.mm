#import "WebConnectivity.h"

@implementation WebConnectivity : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    mk::nettests::WebConnectivityTest test;
    self.entryIdx = 0;
    if (!self.inputs)
        self.inputs = [TestUtility getUrlsTest];
    /*Url *currentUrl = [self.inputs objectAtIndex:self.entryIdx];
    self.measurement.input = currentUrl.url;
    self.measurement.category = currentUrl.categoryCode;
    */
    if (self.max_runtime_enabled){
        test.set_option("max_runtime", [max_runtime doubleValue]);
    }
    if ([self.inputs count] > 0) {
        for (Url* input in self.inputs) {
            test.add_input([input.url UTF8String]);
        }
    }
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)json {
    self.measurement.input = json.input;
    self.measurement.category = [TestUtility getCategoryForUrl:self.measurement.input];
    [self setBlocking:json.test_keys];
    //[self setTestSummary:json.test_keys];

    /*
    if (json.test_keys){
        //TODO
        [self setBlocking:json.test_keys];
        //[self setTestSummary:json.test_keys];
    }
    else
        [self.measurement setState:measurementFailed];
    */
    [super onEntry:json];

    //[super updateSummary];
    //[self.measurement save];
}

- (void)setBlocking:(TestKeys*)testKeys{
    /*
     null => failed
     false => not blocked
     string (dns, tcp-ip, http-failure, http-diff) => anomalous
     */
    //id element = testKeys.blocking;
    if (testKeys.blocking == NULL) {
        [self.measurement setState:measurementFailed];
    }
    else {
        [self.measurement setState:measurementDone];
        self.measurement.anomaly = ![testKeys.blocking isEqualToString:@"0"];
    }
}

-(void)setTestSummary:(NSDictionary*)keys{
    Summary *summary = [self.result getSummary];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    if ([keys safeObjectForKey:@"blocking"]){
        [values setObject:[keys safeObjectForKey:@"blocking"] forKey:@"blocking"];
    }
    if ([keys safeObjectForKey:@"accessible"]){
        [values setObject:[keys safeObjectForKey:@"accessible"] forKey:@"accessible"];
    }
    //TODO This crashes when input is nil. have to set input when measurement starts
    [summary.json setValue:values forKey:self.measurement.input];
    //[self.result save];
}
@end
