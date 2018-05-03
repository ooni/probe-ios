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
        [self.measurement setResult:self.result];
    if (self.name != NULL)
        [self.measurement setName:self.name];
    [self.measurement save];
}

-(void)updateCounter{
    Summary *summary = [self.result getSummary];
    summary.totalMeasurements++;
    summary.failedMeasurements++;
    [self.result setSummary];
    [self.result save];
}

- (void)setResultOfMeasurement:(Result *)result{
    self.result = result;
    [self.measurement setResult:self.result];
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
    self.max_runtime_enabled = TRUE;
    [self.result setNetworkType:[[ReachabilityManager sharedManager] getStatus]];
    [self.measurement setNetworkType:[[ReachabilityManager sharedManager] getStatus]];

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
    //TODO remove
    //NSLog(@"FILE set_output_filepath %@", [TestUtility getFileName:self.measurement ext:@"json"]);
    test.set_verbosity([SettingsUtility getVerbosity]);
    test.add_annotation("network_type", [self.measurement.networkType UTF8String]);
    test.on_log([self](uint32_t type, const char *s) {
        [self sendLog:[NSString stringWithFormat:@"%s", s]];
    });
    test.on_begin([self]() {
        [self updateCounter];
        [self updateProgress:0];
    });
    test.on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    });
    test.on_overall_data_usage([self](mk::DataUsage d) {
        [self.result setDataUsageDown:self.result.dataUsageDown+(long)d.down];
        [self.result setDataUsageUp:self.result.dataUsageUp+(long)d.up];
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
    NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%", prog * 100.0];
    NSLog(@"%@", os);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:[NSNumber numberWithInt:self.idx] forKey:@"index"];
        [noteInfo setObject:[NSNumber numberWithDouble:prog] forKey:@"prog"];
        [noteInfo setObject:self.name forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgress" object:nil userInfo:noteInfo];
    });
}

-(NSDictionary*)onEntryCommon:(const char*)str{
    if (str != nil) {
        //TODO Lo startdate ti consiglio di prenderlo dal primo `onEntry` ?
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = MEASUREMENT_OK;
        if (error != nil) {
            NSLog(@"Error parsing JSON: %@", error);
            blocking = MEASUREMENT_FAILURE;
            [self updateBlocking:blocking];
            return nil;
        }
        if ([json safeObjectForKey:@"test_start_time"])
            [self.result setStartTimeWithUTCstr:[json safeObjectForKey:@"test_start_time"]];
        if ([json safeObjectForKey:@"measurement_start_time"])
            [self.measurement setStartTimeWithUTCstr:[json safeObjectForKey:@"measurement_start_time"]];
        if ([json safeObjectForKey:@"test_runtime"]){
            [self.measurement setDuration:[[json safeObjectForKey:@"test_runtime"] floatValue]];
            [self.result addDuration:[[json safeObjectForKey:@"test_runtime"] floatValue]];
        }
        //if the user doesn't want to share asn leave null on the db object
        if ([json safeObjectForKey:@"probe_asn"] && [SettingsUtility getSettingWithName:@"include_asn"]){
            [self.measurement setAsnAndCalculateName:[json objectForKey:@"probe_asn"]];
            if (self.result.asn == nil){
                [self.result setAsnAndCalculateName:[json objectForKey:@"probe_asn"]];
                [self.result save];
            }
            else {
                if (![self.result.asn isEqualToString:self.measurement.asn])
                    NSLog(@"Something's wrong");
            }
        }
        if ([json safeObjectForKey:@"probe_cc"] && [SettingsUtility getSettingWithName:@"include_cc"]){
            [self.measurement setCountry:[json objectForKey:@"probe_cc"]];
            if (self.result.country == nil){
                [self.result setCountry:[json objectForKey:@"probe_cc"]];
                [self.result save];
            }
            else {
                if (![self.result.country isEqualToString:self.measurement.country])
                    NSLog(@"Something's wrong");
            }
        }
        if ([json safeObjectForKey:@"probe_ip"] && [SettingsUtility getSettingWithName:@"include_ip"]){
            [self.measurement setIp:[json objectForKey:@"probe_ip"]];
            if (self.result.ip == nil){
                [self.result setIp:[json objectForKey:@"probe_ip"]];
                [self.result save];
            }
            else {
                if (![self.result.ip isEqualToString:self.measurement.ip])
                    NSLog(@"Something's wrong");
            }
        }
        if ([json safeObjectForKey:@"report_id"])
            [self.measurement setReportId:[json objectForKey:@"report_id"]];
        
        return json;
    }
    return nil;
}

-(void)updateBlocking:(int)blocking{
    [self.measurement setBlocking:blocking];
    Summary *summary = [self.result getSummary];
    //TODO how to count failed? will they appear here?
    if (blocking != MEASUREMENT_FAILURE){
        summary.failedMeasurements--;
        if (blocking == MEASUREMENT_OK)
            summary.okMeasurements++;
        else if (blocking == MEASUREMENT_BLOCKED)
            summary.blockedMeasurements++;
        [self.result setSummary];
        [self.result save];
    }
}

-(void)run {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self.measurement setState:measurementActive];
    [self.measurement save];
}

-(void)testEnded{
    NSLog(@"%@ testEnded", self.name);
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    [self.measurement setState:measurementDone];
    [self updateProgress:1];
    [self.measurement save];
    [self.delegate testEnded:self];
}

@end
