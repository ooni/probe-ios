#import "WebConnectivity.h"

@implementation WebConnectivity : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
        self.settings.name = [LocalizationUtility getMKNameForTest:self.name];
        //mk::nettests::WebConnectivityTest test;
        self.entryIdx = 0;
        //if (!self.settings.inputs)
        //    self.settings.inputs = [TestUtility downloadUrls];
        /*Url *currentUrl = [self.inputs objectAtIndex:self.entryIdx];
         self.measurement.url_id.url = currentUrl.url;
         self.measurement.url_id.category_code = currentUrl.categoryCode;
         */
        /*if ([self.inputs count] > 0) {
         for (Url* input in self.inputs) {
         test.add_input([input.url UTF8String]);
         }
         }*/
    }
    return self;
}

-(void) runTest {
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     null => failed
     false => not blocked
     string (dns, tcp-ip, http-failure, http-diff) => anomalous
     */
    //id element = testKeys.blocking;
    if (json.test_keys.blocking == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = ![json.test_keys.blocking isEqualToString:@"0"];
    [super onEntry:json obj:measurement];
}

@end
