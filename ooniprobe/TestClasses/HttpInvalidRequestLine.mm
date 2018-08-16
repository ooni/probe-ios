#import "HttpInvalidRequestLine.h"

@implementation HttpInvalidRequestLine : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_invalid_request_line";
        self.measurement.test_name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::HttpInvalidRequestLineTest test;
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)json {
    /*
     onEntry method for http invalid request line test, check "tampering" key
     null => failed
     true => anomalous
     */
    if (json.test_keys.tampering == NULL)
        [self.measurement setIs_failed:true];
    else
        self.measurement.is_anomaly = json.test_keys.tampering.value;
    
    [super onEntry:json];
}


@end
