#import "Measurement.h"
#import "Result.h"
#import "TestUtility.h"
#import "NetworkSession.h"

@implementation Measurement
@dynamic test_name, start_time, runtime, is_done, is_uploaded, is_failed, failure_msg, is_upload_failed, upload_failure_msg, is_rerun, report_id, url_id, test_keys, is_anomaly, result_id;

@synthesize testKeysObj = _testKeysObj;

+ (NSDictionary *)defaultValuesForEntity {
    return @{@"start_time": [NSDate date]};
}

+ (SRKResultSet*)notUploadedMeasurements {
    return [[[Measurement query] where:NOT_UPLOADED_QUERY] fetch];
}

+ (NSArray*)measurementsWithJson {
    NSMutableArray *measurementsJson = [NSMutableArray new];
    SRKResultSet* results = [[[Measurement query] where:UPLOADED_QUERY] fetch];
    for (Measurement *measurement in results){
        if ([measurement hasReportFile])
            [measurementsJson addObject:measurement];
    }
    return measurementsJson;
}

/*
    Three scenarios:
    I'm running the test, I start the empty summary, I add stuff and save
    I'm running the test, there is data in the summary, I add stuff and save
 I have to get the sum(no(nonatomic) natomic) mary of an old test and don't modify it
*/
- (TestKeys*)testKeysObj{
    if (!_testKeysObj){
        if (self.test_keys){
            NSError *error;
            NSData *data = [self.test_keys dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error != nil) {
                NSLog(@"Error parsing JSON: %@", error);
                _testKeysObj = [[TestKeys alloc] init];
            }
            _testKeysObj = [TestKeys objectFromDictionary:jsonDic];
        }
        else
            _testKeysObj = [[TestKeys alloc] init];
    }
    return _testKeysObj;
}

- (void)setTestKeysObj:(TestKeys *)testKeysObj{
    _testKeysObj = testKeysObj;
    self.test_keys = [self.testKeysObj getJsonStr];
}

-(BOOL)hasReportFile{
    return [TestUtility fileExists:[self getReportFile]];
}

-(BOOL)hasLogFile{
    return [TestUtility fileExists:[self getLogFile]];
}

-(NSString*)getReportFile{
    //LOGS: resultID_test_name.log
    return [NSString stringWithFormat:@"%@-%@.json",  self.Id, self.test_name];
}

-(NSString*)getLogFile{
    //JSON: measurementID_test_name.log
    return [self.result_id getLogFile:self.test_name];
}

-(NSString*)getLocalizedStartTime{
    //from https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/InternationalizingLocaleData/InternationalizingLocaleData.html
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:self.start_time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    return localizedDateTime;
}

-(void)save{
    [self commit];
    /*
    NSLog(@"---- START LOGGING MEASUREMENT OBJECT----");
    NSLog(@"%@", self);
    NSLog(@"---- END LOGGING MEASUREMENT OBJECT----");
     */
}

-(void)setReRun{
    self.is_rerun = TRUE;
    [TestUtility removeFile:[self getLogFile]];
    [TestUtility removeFile:[self getReportFile]];
    [self save];
}

-(void)deleteObject{
    [TestUtility removeFile:[self getLogFile]];
    [TestUtility removeFile:[self getReportFile]];
    [self remove];
}

-(void)getExplorerUrl:(void (^)(NSString*))successcb onError:(void (^)(NSError*))errorcb {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.ooni.io";
    components.path = @"/api/v1/measurements";
    NSURLQueryItem *reportIdItem = [NSURLQueryItem
                                    queryItemWithName:@"report_id"
                                    value:self.report_id];
    //web_connectivity is the only test using input for now
    if ([self.test_name isEqualToString:@"web_connectivity"]){
        NSURLQueryItem *urlItem = [NSURLQueryItem
                                   queryItemWithName:@"input"
                                   value:self.url_id.url];
        components.queryItems = @[ reportIdItem, urlItem ];
    }
    else
        components.queryItems = @[ reportIdItem ];

    NSURL *url = components.URL;
    NSURLSessionDataTask *downloadTask = [[NetworkSession getSession]
     dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         [self getExplorerUrlCallback:data response:response error:error
                          onSuccess:successcb onError:errorcb];
     }];
    [downloadTask resume];
}

- (void)getExplorerUrlCallback:(NSData *)data
                    response:(NSURLResponse *)response
                       error:(NSError *)error
                   onSuccess:(void (^)(NSString*))successcb
                     onError:(void (^)(NSError*))errorcb {
    if (error != nil) {
        errorcb(error);
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        errorcb(error);
        return;
    }
    NSArray *resultsArray = [dic objectForKey:@"results"];
    /*
     Checking if the array is longer than 1.
     https://github.com/ooni/probe-ios/pull/293#discussion_r302136014
     */
    if ([resultsArray count] != 1 ||
        ![[resultsArray objectAtIndex:0] objectForKey:@"measurement_url"]) {
        errorcb([NSError errorWithDomain:@"io.ooni.api"
                                    code:ERR_JSON_EMPTY
                                userInfo:@{NSLocalizedDescriptionKey:@"Modal.Error.JsonEmpty"
                                           }]);
        return;
    }
    successcb([[resultsArray objectAtIndex:0] objectForKey:@"measurement_url"]);
}

-(BOOL)isMiddleBoxes{
    if ([self.test_name isEqualToString:@"http_invalid_request_line"] ||
    [self.test_name isEqualToString:@"http_header_field_manipulation"])
        return true;
    return false;
}

@end
