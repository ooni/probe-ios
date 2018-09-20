#import "HttpHeaderFieldManipulation.h"

@implementation HttpHeaderFieldManipulation : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_header_field_manipulation";
        self.settings.name = [LocalizationUtility getMKNameForTest:self.name];
    }
    return self;
}

-(void) runTest {
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     onEntry method for http header field manipulation test, check "failure" key
     null => failed
     true => anomalous
     then the keys in the "tampering" object will be checked, if any of them is not null and TRUE, then test is anomalous
     tampering {
     header_field_name
     header_field_number
     header_field_value
     header_name_capitalization
     request_line_capitalization
     total
     }
     */
    if (json.test_keys.failure != NULL && json.test_keys.tampering == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = json.test_keys.tampering.value;    
    [super onEntry:json obj:measurement];
}

@end
