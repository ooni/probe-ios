#import "HttpInvalidRequestLine.h"

@implementation HttpInvalidRequestLine : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_invalid_request_line";
    }
    return self;
}

-(void) runTest {
    [super initCommon];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     onEntry method for http invalid request line test, check "tampering" key
     null => failed
     true => anomalous
     */
    if (json.test_keys.tampering == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = json.test_keys.tampering.value;
    [super onEntry:json obj:measurement];
}


@end
