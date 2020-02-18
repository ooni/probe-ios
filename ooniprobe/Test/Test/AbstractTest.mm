#import "Tests.h"

#import "VersionUtility.h"
#import "ReachabilityManager.h"
#import "NSDictionary+Safety.h"
#import "EventResult.h"
#import "ExceptionUtility.h"
#import <mkall/MKAsyncTask.h>

@implementation AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.backgroundTask = UIBackgroundTaskInvalid;
        self.measurements = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id)initTest:(NSString*)testName{
    if ([testName isEqualToString:@"web_connectivity"])
        self = [[WebConnectivity alloc] init];
    else if ([testName isEqualToString:@"whatsapp"])
        self = [[Whatsapp alloc] init];
    else if ([testName isEqualToString:@"telegram"])
        self = [[Telegram alloc] init];
    else if ([testName isEqualToString:@"facebook_messenger"])
        self = [[FacebookMessenger alloc] init];
    else if ([testName isEqualToString:@"http_invalid_request_line"])
        self = [[HttpInvalidRequestLine alloc] init];
    else if ([testName isEqualToString:@"http_header_field_manipulation"])
        self = [[HttpHeaderFieldManipulation alloc] init];
    else if ([testName isEqualToString:@"ndt"])
        self = [[NdtTest alloc] init];
    else if ([testName isEqualToString:@"dash"])
        self = [[Dash alloc] init];
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
    [measurement save];
    return measurement;
}

-(void)prepareRun{
    self.settings = [Settings new];
    self.settings.name = [LocalizationUtility getMKNameForTest:self.name];
}

-(void)runTest{
    if(self.annotation)
        [self.settings.annotations setObject:@"ooni-run" forKey:@"origin"];
    NSDictionary *settings = [self.settings getSettingsDictionary];
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       MKAsyncTask *task = [MKAsyncTask start:settings];
                       while (![task done]){
                           // Extract an event from the task queue and unmarshal it.
                           NSDictionary *evinfo = [task waitForNextEvent];
                           if (evinfo == nil) {
                               break;
                           }
                           NSLog(@"Got event: %@", evinfo);
                           InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
                           ObjectMapper *mapper = [[ObjectMapper alloc] init];
                           mapper.mappingProvider = mappingProvider;
                           EventResult *event = [mapper objectFromSource:evinfo toInstanceOfClass:[EventResult class]];
                           if (event.key == nil || event.value == nil) {
                               break;
                           }
                           if ([event.key isEqualToString:@"status.started"]) {
                               //[self updateProgressBar:0];
                           }
                           else if ([event.key isEqualToString:@"status.measurement_start"]) {
                               if (event.value.idx == nil || event.value.input == nil) {
                                   break;
                               }
                               Measurement *measurement = [self createMeasurementObject];
                               if ([event.value.input length] != 0){
                                   measurement.url_id = [Url getUrl:event.value.input];
                                   [measurement save];
                               }
                               [self.measurements setObject:measurement forKey:event.value.idx];
                           }
                           else if ([event.key isEqualToString:@"status.geoip_lookup"]) {
                               //Save Network info
                               [self saveNetworkInfo:event.value];
                           }
                           else if ([event.key isEqualToString:@"log"]) {
                               [self updateLogs:event.value];
                           }
                           else if ([event.key isEqualToString:@"status.progress"]) {
                               [self updateProgress:event.value];
                           }
                           else if ([event.key isEqualToString:@"measurement"]) {
                               [self onEntryCreate:event.value];
                           }
                           else if ([event.key isEqualToString:@"status.report_create"]) {
                               //Save report_id
                               self.reportId = event.value.report_id;
                           }
                           else if ([event.key isEqualToString:@"failure.report_create"]) {
                               /*
                                every measure should be resubmitted
                                substitute report_id in the json
                                int mk_submit_report(const char *report_as_json);
                                "value": {"failure": "<failure_string>"}
                                */
                           }
                           else if ([event.key isEqualToString:@"status.measurement_submission"]) {
                               [self setUploaded:true idx:event.value.idx failure:nil];
                           }
                           else if ([event.key isEqualToString:@"failure.measurement_submission"]) {
                               //this is called in case of failure.report_create with a specific error
                               [self setUploaded:false idx:event.value.idx failure:event.value.failure];
                           }
                           else if ([event.key isEqualToString:@"status.measurement_done"]) {
                               //probabilmente da usare per indicare misura finita
                               if (event.value.idx == nil) {
                                   break;
                               }
                               Measurement *measurement = [self.measurements objectForKey:event.value.idx];
                               if (measurement != nil){
                                   measurement.is_done = true;
                                   [measurement save];
                               }
                           }
                           else if ([event.key isEqualToString:@"status.end"]) {
                               //update d.down e d.up
                               if (event.value.downloaded_kb == nil || event.value.uploaded_kb == nil) {
                                   break;
                               }
                               [self.result setData_usage_down:self.result.data_usage_down+[event.value.downloaded_kb doubleValue]];
                               [self.result setData_usage_up:self.result.data_usage_up+[event.value.uploaded_kb doubleValue]];
                           }
                           else if ([event.key isEqualToString:@"failure.startup"]) {
                               self.result.failure_msg = event.value.failure;
                               [self.result save];
                           }
                           else if ([event.key isEqualToString:@"bug.json_dump"]) {
                               [ExceptionUtility recordError:@"json_dump" code:0 userInfo:[event.value dictionary]];
                           }
                           else {
                               NSLog(@"unused event: %@", evinfo);
                           }
                       }
                       // Notify the main thread that the task is now complete
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self testEnded];
                       });
                   });
}

-(void)updateLogs:(Value *)value{
    NSString *message = value.message;
    if (message == nil) {
        return;
    }
    [TestUtility writeString:message toFile:[TestUtility getFileNamed:[self.result getLogFile:self.name]]];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:message forKey:@"log"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLog" object:nil userInfo:noteInfo];
    });
}

-(void)updateProgress:(Value *)value {
    NSNumber *percentage = value.percentage;
    NSString *message = value.message;
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

-(void)setUploaded:(BOOL)value idx:(NSNumber*)idx failure:(NSString*)failure{
    if (idx == nil) {
        return;
    }
    Measurement *measurement = [self.measurements objectForKey:idx];
    if (measurement != nil){
        measurement.is_uploaded = value;
        //if is not uploaded reset report_ids
        if (!value){
            [measurement setReport_id:@""];
            measurement.is_upload_failed = true;
        }
        if (failure != nil)
            measurement.upload_failure_msg = failure;
        [measurement save];
    }
}

-(void)saveNetworkInfo:(Value *)value{
    if (value == nil) return;
    NSString *probe_ip = value.probe_ip;
    NSString *probe_asn = value.probe_asn;
    NSString *probe_cc = value.probe_cc;
    NSString *probe_network_name = value.probe_network_name;
    if (self.result != NULL && self.result.network_id == NULL)
        [self.result setNetwork_id:[Network checkExistingNetworkWithAsn:probe_asn networkName:probe_network_name ip:probe_ip cc:probe_cc networkType:[[ReachabilityManager sharedManager] getStatus]]];
}

-(void)onEntryCreate:(Value*)value {
    NSString *str = value.json_str;
    NSNumber *idx = value.idx;
    if (idx == nil) return;
    Measurement *measurement = [self.measurements objectForKey:idx];
    if (str != nil && measurement != nil) {
        NSError *error;
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error != nil) {
            NSLog(@"Error parsing JSON: %@", error);
            [measurement setIs_failed:true];
            [measurement save];
            return;
        }
        [TestUtility writeString:str toFile:[TestUtility getFileNamed:[measurement getReportFile]]];

        InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
        ObjectMapper *mapper = [[ObjectMapper alloc] init];
        mapper.mappingProvider = mappingProvider;

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
        [mappingProvider mapFromDictionaryKey:@"tampering" toPropertyKey:@"tampering" forClass:[TestKeys class] withTransformer:^id(id currentNode, id parentNode) {
            return [[Tampering alloc] initWithValue:currentNode];
        }];
        JsonResult *json = [mapper objectFromSource:jsonDic toInstanceOfClass:[JsonResult class]];
        [self onEntry:json obj:measurement];
        [measurement save];
        [self.result save];
    }
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    if (json.test_start_time != nil){
        [self.result setStart_time:json.test_start_time];
    }
    if (json.measurement_start_time != nil){
        [measurement setStart_time:json.measurement_start_time];
    }
    [measurement setRuntime:[json.test_runtime floatValue]];
    [self.result addRuntime:[json.test_runtime floatValue]];
    [measurement setTestKeysObj:json.test_keys];
}

-(void)testEnded{
    //NSLog(@"%@ testEnded", self.name);
    [self.delegate testEnded:self];
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    //[self updateProgressBar:1];
}

-(int)getRuntime{
    return 0;
}

@end
