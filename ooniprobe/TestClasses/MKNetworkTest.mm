#import "MKNetworkTest.h"

#import "VersionUtility.h"
#import "ReachabilityManager.h"

@implementation MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.backgroundTask = UIBackgroundTaskInvalid;
        [self createMeasurementObject];
    }
    return self;
}

- (void)createMeasurementObject{
    self.measurement = [Measurement new];
    //If needed for the second measurement object (websites)
    if (self.result != NULL)
        [self.measurement setResult_id:self.result];
    if (self.name != NULL)
        [self.measurement setTest_name:self.name];
    [self.measurement save];
}

- (void)setResultOfMeasurement:(Result *)result{
    self.result = result;
    [self.measurement setResult_id:self.result];
}

- (void) initCommon:(mk::nettests::BaseTest&) test{
    BOOL include_ip = [SettingsUtility getSettingWithName:@"include_ip"];
    BOOL include_asn = [SettingsUtility getSettingWithName:@"include_asn"];
    BOOL include_cc = [SettingsUtility getSettingWithName:@"include_cc"];
    BOOL upload_results = [SettingsUtility getSettingWithName:@"upload_results"];
    NSString *software_version = [VersionUtility get_software_version];
    NSString *geoip_asn = [[NSBundle mainBundle] pathForResource:@"GeoIPASNum" ofType:@"dat"];
    NSString *geoip_country = [[NSBundle mainBundle] pathForResource:@"GeoIP" ofType:@"dat"];
    self.progress = 0;

    //Configuring common test parameters
    test.set_option("geoip_country_path", [geoip_country UTF8String]);
    test.set_option("geoip_asn_path", [geoip_asn UTF8String]);
    test.set_option("save_real_probe_ip", include_ip);
    test.set_option("save_real_probe_asn", include_asn);
    test.set_option("save_real_probe_cc", include_cc);
    test.set_option("no_collector", !upload_results);
    test.set_option("software_name", [@"ooniprobe-ios" UTF8String]);
    test.set_option("software_version", [software_version UTF8String]);
    test.set_error_filepath([[TestUtility getFileName:self.measurement ext:@"log"] UTF8String]);
    if (![self.name isEqualToString:@"web_connectivity"])
        test.set_output_filepath([[TestUtility getFileName:self.measurement ext:@"json"] UTF8String]);
    test.set_verbosity([SettingsUtility getVerbosity]);
    //TODO keep?
    //test.add_annotation("network_type", [self.measurement.networkType UTF8String]);
    test.on_log([self](uint32_t type, const char *s) {
        [self sendLog:[NSString stringWithFormat:@"%s", s]];
    });
    test.on_begin([self]() {
        [self updateProgress:0];
    });
    test.on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    });
    test.on_overall_data_usage([self](mk::DataUsage d) {
        [self.result setData_usage_down:self.result.data_usage_down+(long)d.down];
        [self.result setData_usage_up:self.result.data_usage_up+(long)d.up];
    });
    test.on_entry([self](std::string s) {
        [self onEntryCreate:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

-(void)sendLog:(NSString*)log{
    NSLog(@"on_log %@", log);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:log forKey:@"log"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLog" object:nil userInfo:noteInfo];
    });
}

-(void)updateProgress:(double)prog {
    self.progress = prog;
    NSLog(@"%@", [NSString stringWithFormat:@"Progress: %.1f%%", prog * 100.0]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:[NSNumber numberWithInt:self.idx] forKey:@"index"];
        [noteInfo setObject:[NSNumber numberWithDouble:prog] forKey:@"prog"];
        [noteInfo setObject:self.name forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgress" object:nil userInfo:noteInfo];
    });
}

-(void)onEntryCreate:(const char*)str {
    if (str != nil) {
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error != nil) {
            NSLog(@"Error parsing JSON: %@", error);
            [self.measurement setIs_failed:true];
            [self.measurement save];
            //[self.result save];
            return;
        }
        if ([self.name isEqualToString:@"web_connectivity"]){
            NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
            [data writeToFile:[TestUtility getFileName:self.measurement ext:@"json"] atomically:YES];
        }

        InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
        ObjectMapper *mapper = [[ObjectMapper alloc] init];
        mapper.mappingProvider = mappingProvider;
        
        //JsonResult *json = [JsonResult objectFromDictionary:json];
        
        /*
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
         //[mappingProvider setDefaultDateFormatter:dateFormatter];
         //[mappingProvider setDateFormatter:dateFormatter forPropertyKey:@"test_start_time" andClass:[JsonResult class]];
         //[mappingProvider setDateFormatter:dateFormatter forPropertyKey:@"measurement_start_time" andClass:[JsonResult class]];
         //[mappingProvider setDateFormatter:dateFormatter forProperty:@"test_start_time" andClass:[JsonResult class]];
         //[mappingProvider setDateFormatter:dateFormatter forProperty:@"measurement_start_time" andClass:[JsonResult class]];
         */
        
        //Hack to add UTC format to dates
        [mappingProvider mapFromDictionaryKey:@"measurement_start_time" toPropertyKey:@"measurement_start_time" forClass:[JsonResult class] withTransformer:^id(id currentNode, id parentNode) {
            NSString *currentDateStr = [NSString stringWithFormat:@"%@Z", (NSString*)currentNode];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
            return [dateFormatter dateFromString:currentDateStr];
        }];
        [mappingProvider mapFromDictionaryKey:@"test_start_time" toPropertyKey:@"test_start_time" forClass:[JsonResult class] withTransformer:^id(id currentNode, id parentNode) {
            NSString *currentDateStr = [NSString stringWithFormat:@"%@Z", (NSString*)currentNode];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
            return [dateFormatter dateFromString:currentDateStr];
        }];
        //[mappingProvider mapFromDictionaryKey:@"simple" toPropertyKey:@"simple" forClass:[TestKeys class]];
        //[mappingProvider mapFromDictionaryKey:@"advanced" toPropertyKey:@"advanced" forClass:[TestKeys class]];
        //[mappingProvider mappingInfoForClass:[Simple class] andDictionaryKey:@"simple"];
        [mappingProvider mapFromDictionaryKey:@"tampering" toPropertyKey:@"tampering" forClass:[TestKeys class] withTransformer:^id(id currentNode, id parentNode) {
            return [[Tampering alloc] initWithValue:currentNode];
        }];
        JsonResult *json = [mapper objectFromSource:jsonDic toInstanceOfClass:[JsonResult class]];
        /*
         NSLog(@"probe_cc:%@   test_runtime:%@  tampering:%@",
         json.probe_cc,
         json.test_runtime,
         json.test_keys.tampering ? @"Yes" : @"No");
         */
        [self onEntry:json];
        [self.measurement save];
        [self.result save];
    }
    if ([self.name isEqualToString:@"web_connectivity"]){
        //create new measurement entry if web_connectivity test
        //TODO-SBS this case doesn not handle the timeout
        //move creation of new object in status.measurement_start (mk 0.9)
        self.entryIdx++;
        if (self.entryIdx < [self.inputs count]){
            [self createMeasurementObject];
            //Url *currentUrl = [self.inputs objectAtIndex:self.entryIdx];
            //self.measurement.url_id.url = currentUrl.url;
            //self.measurement.url_id.category_code = currentUrl.categoryCode;
        }
    }
}

-(void)onEntry:(JsonResult*)json{
    //TODO check if I still need these checks
    if (json.test_start_time)
        [self.result setStart_time:json.test_start_time];
    if (json.measurement_start_time)
        [self.measurement setStart_time:json.test_start_time];
    if (json.test_runtime){
        [self.measurement setRuntime:[json.test_runtime floatValue]];
        [self.result addRuntime:[json.test_runtime floatValue]];
    }

    //TODO move on another callback
    Network *network = [Network new];
    [network setNetwork_type:[[ReachabilityManager sharedManager] getStatus]];
    //if the user doesn't want to share asn leave null on the db object
    if (json.probe_asn && [SettingsUtility getSettingWithName:@"include_asn"])
        //TODO-SBS asn name
        [network setAsn:json.probe_asn];
        [network setNetwork_name:@"Vodafone"];
    
    if (json.probe_cc && [SettingsUtility getSettingWithName:@"include_cc"])
        [network setCountry_code:json.probe_cc];
    
    if (json.probe_ip && [SettingsUtility getSettingWithName:@"include_ip"])
        [network setIp:json.probe_ip];
    
    [network commit];
    [self.measurement setNetwork_id:network];
    //[self.measurement setNetwork_id:[network createOrReturn]];
    
    //TODO move on another callback
    if (json.report_id)
        [self.measurement setReport_id:json.report_id];
    
    if (json.test_keys)
        [self.measurement setTestKeysObj:json.test_keys];
}

-(void)run {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self.measurement save];
}

-(void)testEnded{
    //NSLog(@"%@ testEnded", self.name);
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    //[self.measurement setState:measurementDone];
    [self updateProgress:1];
    [self.measurement save];
    [self.delegate testEnded:self];
}

@end
