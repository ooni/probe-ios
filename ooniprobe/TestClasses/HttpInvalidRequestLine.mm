#import "HttpInvalidRequestLine.h"

@implementation HttpInvalidRequestLine : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_invalid_request_line";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::HttpInvalidRequestLineTest test;
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        /*
         onEntry method for http invalid request line test, check "tampering" key
         null => failed
         true => anomalous
         */
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        if ([keys objectForKey:@"tampering"]){
            //this case shouldn't happen
            if ([keys objectForKey:@"tampering"] == [NSNull null])
                [self.measurement setState:measurementFailed];
            else if ([[keys objectForKey:@"tampering"] boolValue])
                [self.measurement setAnomaly:YES];
        }
        [super updateSummary];
        [self setTestSummary:keys];
        [self.measurement save];
    }
}

-(void)setTestSummary:(NSDictionary*)keys{
    Summary *summary = [self.result getSummary];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    if ([keys safeObjectForKey:@"sent"]){
        [values setObject:[keys safeObjectForKey:@"sent"] forKey:@"sent"];
    }
    if ([keys safeObjectForKey:@"received"]){
        [values setObject:[keys safeObjectForKey:@"received"] forKey:@"received"];
    }
    [summary.json setValue:values forKey:self.name];
    [self.result save];
}

@end
