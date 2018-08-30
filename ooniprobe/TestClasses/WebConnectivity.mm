#import "WebConnectivity.h"

@implementation WebConnectivity : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"WebConnectivity";
        self.measurement.test_name = self.name;
    }
    return self;
}

-(void) runTest {
    [super initCommon];
    NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    //TODO check this is not from ooni run
    self.settings.options.max_runtime = max_runtime;
    self.settings.name = self.name;
    
    //mk::nettests::WebConnectivityTest test;
    self.entryIdx = 0;
    if (!self.settings.inputs)
        self.settings.inputs = [TestUtility getUrlsTest];
    /*Url *currentUrl = [self.inputs objectAtIndex:self.entryIdx];
    self.measurement.url_id.url = currentUrl.url;
    self.measurement.url_id.category_code = currentUrl.categoryCode;
    */
    /*if ([self.inputs count] > 0) {
        for (Url* input in self.inputs) {
            test.add_input([input.url UTF8String]);
        }
    }*/
    [super runTest];
}

-(void)onEntry:(JsonResult*)json {
    //TODO add category and country code
    Url *url = [Url new];
    url.url = json.input;
    url.category_code = @"GAME";
    url.country_code = @"IT";
    //url.category_code = [TestUtility getUrl:json.input];
    self.measurement.url_id = [url createOrReturn];
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
    if (testKeys.blocking == NULL)
        [self.measurement setIs_failed:true];
    else
        self.measurement.is_anomaly = ![testKeys.blocking isEqualToString:@"0"];
    
}

    @end
