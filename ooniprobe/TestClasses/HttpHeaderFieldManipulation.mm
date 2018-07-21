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
    /*
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });*/
    [super initCommon:test];
}

-(void)onEntry:(JsonResult*)jsonResult {
    [super onEntry:jsonResult];
    if (jsonResult){
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
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        if ([keys objectForKey:@"failure"] != [NSNull null])
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
        [super updateSummary];
        [self.measurement save];
    }
}

@end
