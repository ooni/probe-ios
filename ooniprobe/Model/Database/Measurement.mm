#import "Measurement.h"
#import "Result.h"
#import "TestUtility.h"

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

-(void)getExplorerUrl:(void (^)(NSString*))successcb error:(void (^)(NSError*))errorcb {
    NSLog(@"%@ getExplorerUrl",self.Id);
    NSMutableString *path = [NSMutableString stringWithFormat:@"https://api.ooni.io/api/v1/measurements?report_id=%@",
                      self.report_id];
    if ([self.test_name isEqualToString:@"web_connectivity"])
        [path appendString:[NSString stringWithFormat:@"&input=%@",
                            self.url_id.url]];
    NSURL *url = [NSURL URLWithString:path];
    NSURLSessionDataTask *downloadTask =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (error != nil){
             errorcb(error);
             return;
         }
         else {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
             if (error != nil){
                 errorcb(error);
                 return;
             }
             NSArray *resultsArray = [dic objectForKey:@"results"];
             //TODO symbolize somehow empty array
             if ([resultsArray count] > 0){
                 errorcb([NSError errorWithDomain:@"io.ooni.api"
                                           code:100
                                       userInfo:@{NSLocalizedDescriptionKey:@"Error.JsonEmpty"
                                                  }]);
                 return;
             }
             successcb([[resultsArray objectAtIndex:0] objectForKey:@"measurement_url"]);
         }
    }];
    [downloadTask resume];
}

@end
