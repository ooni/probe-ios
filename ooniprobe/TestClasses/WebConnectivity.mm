#import "WebConnectivity.h"

@implementation WebConnectivity : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
        self.measurement.name = self.name;
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
    Url *currentUrl = [self.inputs objectAtIndex:self.entryIdx];
    self.measurement.input = currentUrl.url;
    self.measurement.category = currentUrl.category_code;
    
    if (self.max_runtime_enabled){
        test.set_option("max_runtime", [max_runtime doubleValue]);
    }
    if ([self.inputs count] > 0) {
        for (Url* input in self.inputs) {
            test.add_input([input.url UTF8String]);
        }
    }
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:[TestUtility getFileName:self.measurement ext:@"json"] atomically:YES];
        int blocking = MEASUREMENT_FAILURE;
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        if (keys)
            [self checkBlocking:keys];
        [super updateBlocking:blocking];
        [self.measurement save];
        //create new measurement entry if web_connectivity test
        //TODO this case doesn not handle the timeout @sbs
        self.entryIdx++;
        if (self.entryIdx < [self.inputs count]){
            [super createMeasurementObject];
            [super updateCounter];
            Url *currentUrl = [self.inputs objectAtIndex:self.entryIdx];
            self.measurement.input = currentUrl.url;
            self.measurement.category = currentUrl.category_code;
        }
    }
}

- (int)checkBlocking:(NSDictionary*)keys{
    /*
     null => anomaly, (orange
     false => not blocked, (green)
     string (dns, tcp-ip, http-failure, http-diff) => blocked (red)
     */
    id element = [keys objectForKey:@"blocking"];
    int blocking = MEASUREMENT_OK;
    if ([keys objectForKey:@"blocking"] == [NSNull null]) {
        blocking = MEASUREMENT_FAILURE;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        blocking = MEASUREMENT_BLOCKED;
    }
    return blocking;
}

@end
