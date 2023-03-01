#import <XCTest/XCTest.h>
#import "Settings.h"
#import "Engine.h"
#import "JsonResult.h"
#import "EventResult.h"
#import "TestUtility.h"
#define CLIENT_URL @"https://api.ooni.io"
#import <CocoaLumberjack/CocoaLumberjack.h>
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface WebConnectivityTest : XCTestCase

@end

@implementation WebConnectivityTest
Settings *settings;
id<OONIMKTask> task;

- (void)setUp {
    settings = [Settings new];
    settings.name = @"WebConnectivity";
    settings.options.max_runtime = [NSNumber numberWithInt:10];
    settings.inputs = [NSArray arrayWithObject:@"http://mail.google.com"];
    settings.options.no_collector = false;
    [settings.annotations setObject:@"integration-test" forKey:@"origin"];
    settings.options.probe_services_base_url = CLIENT_URL;
}

- (void)tearDown {
}

- (void)testWebConnectivity {
    BOOL submitted = false;
    NSString *report_id_1 = @"r1";
    NSString *report_id_2 = @"r2";
    NSError *error;
    
    task = [Engine startExperimentTaskWithSettings:settings error:&error];
    if (error != nil)
        XCTAssert(false);
    while (![task isDone]){
        // Extract an event from the task queue and unmarshal it.
        NSDictionary *evinfo = [task waitForNextEvent:nil];
        if (evinfo == nil) {
            break;
        }
        NSLog(@"Got event: %@", evinfo);
        DDLogInfo(@"Got event: %@", evinfo);
        InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
        ObjectMapper *mapper = [[ObjectMapper alloc] init];
        mapper.mappingProvider = mappingProvider;
        EventResult *event = [mapper objectFromSource:evinfo toInstanceOfClass:[EventResult class]];
        if (event.key == nil || event.value == nil) {
            break;
        }
        if ([event.key isEqualToString:@"status.report_create"]) {
            report_id_1 = event.value.report_id;
        }
        else if ([event.key isEqualToString:@"measurement"]) {
            NSError *error;
            NSData *data = [event.value.json_str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error != nil) {
                XCTAssert(false);
            }
            JsonResult *jr = [TestUtility jsonResultfromDic:jsonDic];
            XCTAssertNotNil(jr);
            report_id_2 = jr.report_id;
            if (jr.test_keys.blocking == NULL) {
                XCTAssert(false);
            }
        }
        else if ([event.key isEqualToString:@"failure.report_create"] ||
                 [event.key isEqualToString:@"failure.measurement_submission"] ||
                 [event.key isEqualToString:@"failure.startup"]) {
            XCTAssert(false);
        }
        else if ([event.key isEqualToString:@"status.measurement_submission"]) {
            submitted = true;
        }
        else {
            NSLog(@"unused event: %@", evinfo);
            DDLogInfo(@"unused event: %@", evinfo);
        }
    }
    XCTAssertTrue([report_id_1 isEqualToString:report_id_2]);
    XCTAssertTrue(submitted);
}


@end
