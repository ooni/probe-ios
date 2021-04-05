#import "BackgroundTask.h"
#import "Engine.h"
#import "VersionUtility.h"
#import "SettingsUtility.h"
#import "OONIApi.h"
#import "TestUtility.h"
#import "Suite.h"
#import "Tests.h"

@implementation BackgroundTask

+ (void)configure {
    [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:taskID
                                                          usingQueue:nil
                                                       launchHandler:^(BGTask *task) {
        [self handleCheckInTask:task];
    }];
    //TODO
    /*
    if ([SettingsUtility isAutomatedTestEnabled])
        [self scheduleCheckIn];
     */
}

/*
 https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler?language=objc
 https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/extending_your_app_s_background_execution_time?language=objc
 https://www.andyibanez.com/posts/modern-background-tasks-ios13/
 */

//https://stackoverflow.com/questions/58149980/ios-13-objective-c-background-task-request
//https://stackoverflow.com/questions/62026107/how-to-get-use-bgtask-in-objective-c-with-ios-13background-fetch
+ (void)handleCheckInTask:(BGTask *)task {
    // Schedule a new refresh task
    [self scheduleCheckIn];
    task.expirationHandler = ^{
      NSLog(@"WARNING: expired before finish was executed.");
    };
    [self checkIn];
    [task setTaskCompletedWithSuccess:YES];
}

+ (void)scheduleCheckIn {
    BGAppRefreshTaskRequest *request = [[BGAppRefreshTaskRequest alloc] initWithIdentifier:taskID];
    //TODO
    //request.requiresNetworkConnectivity = true;
    //request.requiresExternalPower = false;
    request.earliestBeginDate = [NSDate dateWithTimeIntervalSinceNow:2*60];
    NSError *error = NULL;
    BOOL success = [[BGTaskScheduler sharedScheduler] submitTaskRequest:request error:&error];
    if (!success) {
        NSLog(@"Failed to submit request: %@",error);
    }
}

+ (void)checkIn {
    NSString *testName = @"web_connectivity";
    NSString *testSuiteName = [TestUtility getCategoryForTest:testName];
    AbstractSuite *testSuite = [[AbstractSuite alloc] initSuite:testSuiteName];
    AbstractTest *test = [[AbstractTest alloc] initTest:testName];
    [test setAnnotation:YES];
    [testSuite setTestList:[NSMutableArray arrayWithObject:test]];

    [OONIApi checkIn:^(NSArray *urls) {
        if ([testSuiteName isEqualToString:@"websites"] && [urls count] > 0)
            [(WebConnectivity*)test setUrls:urls];
        [(WebConnectivity*)test disableMaxRuntime];
    } onError:^(NSError *error) {
        NSLog(@"Failed call checkIn API: %@",error);
    }];
    [testSuite runTestSuite];
}

/*
 TODO
 - Create preference to enable this
 - Enable background on enable preference.
 - Disable background on disable preference.
 - Be sure background works on phone reboot?
 */
@end
