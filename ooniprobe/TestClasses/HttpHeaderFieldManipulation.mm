#import "HttpHeaderFieldManipulation.h"

@implementation HttpHeaderFieldManipulation : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_header_field_manipulation";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::HttpHeaderFieldManipulationTest test;
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)json {
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
    //TestKeys *testKeys = json.test_keys;
    if (json.test_keys.failure != NULL && json.test_keys.tampering == NULL)
        [self.measurement setState:measurementFailed];
    else {
        [self.measurement setState:measurementDone];
        self.measurement.anomaly = json.test_keys.tampering.value;
    }
    [super onEntry:json];

    /*
    if (testKeys.failure != [NSNull null])
        [self.measurement setState:measurementFailed];
    else {
        NSDictionary *tampering = [keys objectForKey:@"tampering"];
        NSArray *chcekKeys = [[NSArray alloc]initWithObjects:@"header_field_name", @"header_field_number", @"header_field_value", @"header_name_capitalization", @"request_line_capitalization", @"total", nil];
        for (NSString *key in chcekKeys) {
            if ([tampering objectForKey:key] &&
                [tampering objectForKey:key] != [NSNull null] &&
                [[tampering objectForKey:key] boolValue]) {
                [self.measurement setAnomaly:YES];
            }
        }
    }
     */
    //[super updateSummary];
    //[self.measurement save];
}

@end
