#import "WebConnectivity.h"

@implementation WebConnectivity : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
        self.measurement.test_name = self.name;
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
    [super onEntry:json];
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

    @end
