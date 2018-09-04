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
        self.measurements = [[NSMutableDictionary alloc] init];
        self.settings = [Settings new];
        //self.settings.log_filepath = [TestUtility getFileNamed:[self.result getLogFile:self.name]];
    }
    return self;
}

- (Measurement*)createMeasurementObject{
    Measurement *measurement = [Measurement new];
    if (self.result != NULL)
        [measurement setResult_id:self.result];
    if (self.name != NULL)
        [measurement setTest_name:self.name];
    if (self.reportId != NULL)
        [measurement setReport_id:self.reportId];
    if (self.network != NULL)
        [measurement setNetwork_id:self.network];
    [measurement save];
    return measurement;
}

/*
- (void)setResultOfMeasurement:(Result *)result{
    self.result = result;
    [self.measurement setResult_id:self.result];
}
*/

-(void)runTest{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       NSLog(@"%@", [self.settings getSerializedSettings]);
                       mk_unique_task taskp{mk_nettest_start([[self.settings getSerializedSettings] UTF8String])};
                       while (!mk_task_is_done(taskp.get())) {
                           // Extract an event from the task queue and unmarshal it.
                           NSDictionary *evinfo = wait_for_next_event(taskp);
                           if (evinfo == nil) {
                               break;
                           }
                           NSLog(@"Got event: %@", evinfo);
                           NSString *key = [evinfo objectForKey:@"key"];
                           NSDictionary *value = [evinfo objectForKey:@"value"];
                           if (key == nil || value == nil) {
                               return;
                           }
                           if ([key isEqualToString:@"status.started"]) {
                               //[self updateProgressBar:0];
                           }
                           else if ([key isEqualToString:@"status.measurement_start"]) {
                               NSNumber *idx = [value objectForKey:@"idx"];
                               NSString *input = [value objectForKey:@"input"];
                               //Create measurement obj and add it in the dictionary
                               //TODO set input
                               //TODO add category and country code
                               /*Url *url = [Url new];
                               url.url = json.input;
                               url.category_code = @"GAME";
                               url.country_code = @"IT";
                               //url.category_code = [TestUtility getUrl:json.input];
                               self.measurement.url_id = [url createOrReturn];
                                */
                               [self.measurements setObject:[self createMeasurementObject] forKey:idx];
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
                               self.reportId = [value objectForKey:@"report_id"];
                           }
                           else if ([key isEqualToString:@"status.measurement_submission"]) {
                               [self setUploaded:true idx:[value objectForKey:@"idx"]];
                           }
                           else if ([key isEqualToString:@"failure.measurement_submission"]) {
                               [self setUploaded:false idx:[value objectForKey:@"idx"]];
                           }
                           else if ([key isEqualToString:@"status.measurement_done"]) {
                               //probabilmente da usare per indicare misura finita
                               NSNumber *idx = [value objectForKey:@"idx"];
                               Measurement *measurement = [self.measurements objectForKey:idx];
                               if (measurement != nil){
                                   measurement.is_done = true;
                                   [measurement save];
                               }
                           }
                           else if ([key isEqualToString:@"status.end"]) {
                               //update d.down e d.up
                               NSNumber *down = [value objectForKey:@"downloaded_kb"];
                               NSString *up = [value objectForKey:@"uploaded_kb"];
                               [self.result setData_usage_down:self.result.data_usage_down+[down doubleValue]];
                               [self.result setData_usage_up:self.result.data_usage_up+[up doubleValue]];
                           }
                           else if ([key isEqualToString:@"failure.startup"]) {
                               //TODO chiudi schermata test? NO
                               //runnare il prossimo?
                           } else {
                               NSLog(@"unused event: %@", evinfo);
                           }

                           // Notify the main thread about the latest event.
                           /*dispatch_async(dispatch_get_main_queue(), ^{
                               [[NSNotificationCenter defaultCenter]
                                postNotificationName:@"event" object:nil userInfo:evinfo];
                           });*/
                       }
                       // Notify the main thread that the task is now complete
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self testEnded];
                           //[[NSNotificationCenter defaultCenter]  postNotificationName:@"test_complete" object:nil];
                       });
                   });
}

-(void)updateLogs:(NSDictionary *)value{
    NSString *message = [value objectForKey:@"message"];
    if (message == nil) {
        return;
    }
    //TODO manage the case the test is re run
    //[self writeString:message toFile:[TestUtility getFileNamed:[self.result getLogFile:self.name]]];

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
    //NSLog(@"%@", [NSString stringWithFormat:@"Progress: %.1f%%", progress * 100.0]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:[NSNumber numberWithDouble:progress] forKey:@"prog"];
        [noteInfo setObject:self.name forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgress" object:nil userInfo:noteInfo];
    });
}

-(void)setUploaded:(BOOL)value idx:(NSNumber*)idx{
    Measurement *measurement = [self.measurements objectForKey:idx];
    if (measurement != nil){
        measurement.is_uploaded = value;
        [measurement save];
    }
}
-(void)saveNetworkInfo:(NSDictionary *)value{
    NSString *probe_ip = [value objectForKey:@"probe_ip"];
    NSString *probe_asn = [value objectForKey:@"probe_asn"];
    NSString *probe_cc = [value objectForKey:@"probe_cc"];
    NSString *probe_network_name = [value objectForKey:@"probe_network_name"];
/*
    Network *network = [Network new];
    [network setNetwork_type:[[ReachabilityManager sharedManager] getStatus]];
    //empty object are empty not null, maybe we should save them anyway without checking
    
    //if the user doesn't want to share asn leave null on the db object
    //if (probe_asn && [SettingsUtility getSettingWithName:@"include_asn"]){
        [network setAsn:probe_asn];
        [network setNetwork_name:probe_network_name];
    //}
    //if (probe_cc && [SettingsUtility getSettingWithName:@"include_cc"])
        [network setCountry_code:probe_cc];
    
    //if (probe_ip && [SettingsUtility getSettingWithName:@"include_ip"])
        [network setIp:probe_ip];
    
    //[network commit];
    //[self.measurement setNetwork_id:network];
    */
    self.network = [Network checkExistingAsn:probe_asn name:probe_network_name ip:probe_ip cc:probe_cc type:[[ReachabilityManager sharedManager] getStatus]];
    //TODO how to set network for every measurement
    //[self.measurement setNetwork_id:network];
}

-(void)onEntryCreate:(NSDictionary*)value {
    NSString *str = [value objectForKey:@"json_str"];
    NSNumber *idx = [value objectForKey:@"idx"];
    Measurement *measurement = [self.measurements objectForKey:idx];
    if (str != nil && measurement != nil) {
        NSError *error;
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error != nil) {
            NSLog(@"Error parsing JSON: %@", error);
            [measurement setIs_failed:true];
            [measurement save];
            //[self.result save];
            return;
        }
        //if ([self.name isEqualToString:@"web_connectivity"]){
        //[data writeToFile:[TestUtility getFileName:measurement ext:@"json"] atomically:YES];
        //}
        [self writeString:str toFile:[TestUtility getFileNamed:[measurement getReportFile]]];

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
        [self onEntry:json obj:measurement];
        [measurement save];
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

-(void)writeString:(NSString*)str toFile:(NSString*)fileName{
    NSError *error;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (fileHandle){
        //TODO add @"\n"
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:fileName atomically:YES];
        /*
        [str writeToFile:fileName
                  atomically:NO
                    encoding:NSStringEncodingConversionAllowLossy
                       error:&error];
         */
    }
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    [self.result setStart_time:json.test_start_time];
    [measurement setStart_time:json.test_start_time];
    [measurement setRuntime:[json.test_runtime floatValue]];
    [self.result addRuntime:[json.test_runtime floatValue]];
    [measurement setTestKeysObj:json.test_keys];
}

-(void)testEnded{
    //NSLog(@"%@ testEnded", self.name);
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    //[self updateProgressBar:1];
    [self.delegate testEnded:self];
}

@end
