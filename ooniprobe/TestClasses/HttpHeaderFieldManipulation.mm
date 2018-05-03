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
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        int blocking = MEASUREMENT_OK;
        /*
         onEntry method for HttpHeaderFieldManipulation test
         if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
         otherwise the keys in the "tampering" object will be checked, if any of them is TRUE, then anomaly will be set to 2 (red)
         */
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        if ([keys objectForKey:@"failure"] != [NSNull null])
            blocking = MEASUREMENT_FAILURE;
        else {
            NSDictionary *tampering = [keys objectForKey:@"tampering"];
            NSArray *chcekKeys = [[NSArray alloc]initWithObjects:@"header_field_name", @"header_field_number", @"header_field_value", @"header_name_capitalization", @"request_line_capitalization", @"total", nil];
            for (NSString *key in chcekKeys) {
                if ([tampering objectForKey:key] &&
                    [tampering objectForKey:key] != [NSNull null] &&
                    [[tampering objectForKey:key] boolValue]) {
                    blocking = MEASUREMENT_BLOCKED;
                }
            }
        }
        [super updateBlocking:blocking];
        [self.measurement save];
    }
}

@end
