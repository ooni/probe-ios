#import "MKNetworkTest.h"

#import "VersionUtility.h"
#import "ReachabilityManager.h"

static NSDictionary *wait_for_next_event(mk_unique_task &taskp) {
    mk_unique_event eventp{mk_task_wait_for_next_event(taskp.get())};
    if (!eventp) {
        NSLog(@"Cannot extract event");
        return nil;
    }
    const char *s = mk_event_serialize(eventp.get());
    if (s == nullptr) {
        NSLog(@"Cannot serialize event");
        return nil;
    }
    // Here it's important to specify freeWhenDone because we control
    // the lifecycle of the data object using `eventp`.
    NSData *data = [NSData dataWithBytesNoCopy:(void *)s length:strlen(s)
                                  freeWhenDone:NO];
    NSError *error = nil;
    NSDictionary *evinfo = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:&error];
    if (error != nil) {
        NSLog(@"Cannot parse serialized JSON event");
        return nil;
    }
    return evinfo;
}

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

- (void) initCommon{
    self.settings = [Settings new];
    self.settings.log_filepath = [TestUtility getFileName:self.measurement ext:@"log"];
    //TODO remove and save file on the fly
    if (![self.name isEqualToString:@"web_connectivity"])
        self.settings.output_filepath = [TestUtility getFileName:self.measurement ext:@"json"];
}

-(void)runTest{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self.measurement save];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       mk_unique_task taskp{mk_nettest_start([[self.settings getSerializedSettings] UTF8String])};
                       while (!mk_task_is_done(taskp.get())) {
                           // Extract an event from the task queue and unmarshal it.
                           NSDictionary *evinfo = wait_for_next_event(taskp);
                           if (evinfo == nil) {
                               break;
                           }
                           NSLog(@"Got event: %@", evinfo); // Uncomment when debugging
                           NSString *key = [evinfo objectForKey:@"key"];
                           NSDictionary *value = [evinfo objectForKey:@"value"];
                           if (key == nil || value == nil) {
                               return;
                           }
                           if ([key isEqualToString:@"status.started"]) {
                               [self updateProgressBar:0];
                           }
                           else if ([key isEqualToString:@"status.measurement_start"]) {
                               /*
                                "- Creare oggetto measurement
                                - Salvare input nel db
                                (assegna categoria random)"
                                */
                           }
                           else if ([key isEqualToString:@"status.geoip_lookup"]) {
                               //Save Network info
                               [self saveNetworkInfo:value];
                           }
                           else if ([key isEqualToString:@"log"]) {
                               [self updateLogs:value];
                           }
                           else if ([key isEqualToString:@"status.progress"]) {
                               [self updateProgress:value];
                           }
                           else if ([key isEqualToString:@"measurement"]) {
                               [self onEntryCreate:value];
                           }
                           else if ([key isEqualToString:@"status.report_create"]) {
                               //Save report_id
                               NSString *report_id = [value objectForKey:@"report_id"];
                               [self.measurement setReport_id:report_id];
                           }
                           else if ([key isEqualToString:@"status.measurement_submission"]) {
                               //write uploaded on db (check failure.measurement_submission)
                           }
                           else if ([key isEqualToString:@"status.measurement_done"]) {
                               //probabilmente da usare per indicare misura finita
                           }
                           else if ([key isEqualToString:@"status.end"]) {
                               //update d.down e d.up
                               NSNumber *down = [value objectForKey:@"downloaded_kb"];
                               NSString *up = [value objectForKey:@"uploaded_kb"];
                               [self.result setData_usage_down:self.result.data_usage_down+[down doubleValue]];
                               [self.result setData_usage_up:self.result.data_usage_up+[up doubleValue]];
                           }
                           else if ([key isEqualToString:@"failure.startup"]) {
                               //TODO chiudi schermata test?
                               //runnare il prossimo?
                           } else {
                               NSLog(@"unused event: %@", evinfo);
                           }

                           // Notify the main thread about the latest event.
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [[NSNotificationCenter defaultCenter]
                                postNotificationName:@"event" object:nil userInfo:evinfo];
                           });
                       }
                       // Notify the main thread that the task is now complete
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [[NSNotificationCenter defaultCenter]
                            postNotificationName:@"test_complete" object:nil];
                       });
                   });
    
    /*
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
*/
}

-(void)updateLogs:(NSDictionary *)value{
    NSString *message = [value objectForKey:@"message"];
    if (message == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:message forKey:@"log"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLog" object:nil userInfo:noteInfo];
    });
}

-(void)updateProgress:(NSDictionary *)value {
    NSNumber *percentage = [value objectForKey:@"percentage"];
    NSString *message = [value objectForKey:@"message"];
    if (percentage == nil || message == nil) {
        return;
    }
    [self updateProgressBar:[percentage doubleValue]];
}

-(void)updateProgressBar:(double)progress{
    NSLog(@"%@", [NSString stringWithFormat:@"Progress: %.1f%%", progress * 100.0]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:[NSNumber numberWithInt:self.idx] forKey:@"index"];
        [noteInfo setObject:[NSNumber numberWithDouble:progress] forKey:@"prog"];
        [noteInfo setObject:self.name forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgress" object:nil userInfo:noteInfo];
    });
}

-(void)saveNetworkInfo:(NSDictionary *)value{
    NSString *probe_ip = [value objectForKey:@"probe_ip"];
    NSString *probe_asn = [value objectForKey:@"probe_asn"];
    NSString *probe_cc = [value objectForKey:@"probe_cc"];
    NSString *probe_network_name = [value objectForKey:@"probe_network_name"];

    Network *network = [Network new];
    [network setNetwork_type:[[ReachabilityManager sharedManager] getStatus]];
    //**empty object are empty not null, maybe we should save them anyway without checking**
    
    //if the user doesn't want to share asn leave null on the db object
    if (probe_asn && [SettingsUtility getSettingWithName:@"include_asn"]){
        //TODO-SBS asn name
        [network setAsn:probe_asn];
        [network setNetwork_name:probe_network_name];
    }
    if (probe_cc && [SettingsUtility getSettingWithName:@"include_cc"])
        [network setCountry_code:probe_cc];
    
    if (probe_ip && [SettingsUtility getSettingWithName:@"include_ip"])
        [network setIp:probe_ip];
    
    //[network commit];
    //[self.measurement setNetwork_id:network];
    [self.measurement setNetwork_id:[network createOrReturn]];
}

-(void)onEntryCreate:(NSDictionary*)value {
    NSString *str = [value objectForKey:@"json_str"];
    NSNumber *idx = [value objectForKey:@"idx"];
    if (str != nil) {
        NSError *error;
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error != nil) {
            NSLog(@"Error parsing JSON: %@", error);
            [self.measurement setIs_failed:true];
            [self.measurement save];
            //[self.result save];
            return;
        }
        if ([self.name isEqualToString:@"web_connectivity"]){
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
    /*
    if ([self.name isEqualToString:@"web_connectivity"]){
        //create new measurement entry if web_connectivity test
        //TODO-SBS this case doesn not handle the timeout
        //move creation of new object in status.measurement_start (mk 0.9)
        self.entryIdx++;
        if (self.entryIdx < [self.settings.inputs count]){
            [self createMeasurementObject];
            //Url *currentUrl = [self.inputs objectAtIndex:self.entryIdx];
            //self.measurement.url_id.url = currentUrl.url;
            //self.measurement.url_id.category_code = currentUrl.categoryCode;
        }
    }
     */
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
    if (json.report_id)
        [self.measurement setReport_id:json.report_id];
    
    if (json.test_keys)
        [self.measurement setTestKeysObj:json.test_keys];
}

-(void)testEnded{
    //NSLog(@"%@ testEnded", self.name);
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    self.measurement.is_done = true;
    //[self.measurement setState:measurementDone];
    [self updateProgressBar:1];
    [self.measurement save];
    [self.delegate testEnded:self];
}

@end
