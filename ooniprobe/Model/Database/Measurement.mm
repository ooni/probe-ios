#import "Measurement.h"
#import "Result.h"
#import "TestUtility.h"

@implementation Measurement
@dynamic test_name, start_time, runtime, is_done, is_uploaded, is_failed, failure_msg, is_upload_failed, upload_failure_msg, is_rerun, report_id, url_id, measurement_id, test_keys, is_anomaly, result_id;

@synthesize testKeysObj = _testKeysObj;

+ (NSDictionary *)defaultValuesForEntity {
    return @{@"start_time": [NSDate date]};
}

+ (SRKResultSet*)notUploadedMeasurements {
    return [[[Measurement query] where:@"is_failed = 0 AND (is_uploaded = 0 || report_id IS NULL)"] fetch];
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

@end
