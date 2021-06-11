#import "BackgroundTask.h"
#import "Engine.h"
#import "VersionUtility.h"
#import "SettingsUtility.h"
#import "OONIApi.h"
#import "TestUtility.h"
#import "Suite.h"
#import "Tests.h"
#import "ReachabilityManager.h"

@implementation BackgroundTask

+ (void)configure API_AVAILABLE(ios(13.0)) {
    [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:taskID
                                                          usingQueue:nil
                                                       launchHandler:^(BGTask *task) {
        [self scheduleLocalNotification];
        [self handleCheckInTask:task];
    }];
}

/*
 https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler?language=objc
 https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/extending_your_app_s_background_execution_time?language=objc
 https://www.andyibanez.com/posts/modern-background-tasks-ios13/
 */

//https://stackoverflow.com/questions/58149980/ios-13-objective-c-background-task-request
//https://stackoverflow.com/questions/62026107/how-to-get-use-bgtask-in-objective-c-with-ios-13background-fetch

//https://uynguyen.github.io/2020/09/26/Best-practice-iOS-background-processing-Background-App-Refresh-Task/

+ (void)handleCheckInTask:(BGTask *)task  API_AVAILABLE(ios(13.0)){
    // Schedule a new task
    [self scheduleCheckIn];
    task.expirationHandler = ^{
      NSLog(@"WARNING: expired before finish was executed.");
    };
    [self checkIn];
    [task setTaskCompletedWithSuccess:YES];
}

+ (void)scheduleCheckIn API_AVAILABLE(ios(13.0)) {
    BGProcessingTaskRequest *request = [[BGProcessingTaskRequest alloc] initWithIdentifier:taskID];
    //BGAppRefreshTaskRequest *request = [[BGAppRefreshTaskRequest alloc] initWithIdentifier:taskID];
    request.requiresNetworkConnectivity = true;
    request.requiresExternalPower = [SettingsUtility testChargingOnly];
    request.earliestBeginDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
    NSError *error = NULL;
    BOOL success = [[BGTaskScheduler sharedScheduler] submitTaskRequest:request error:&error];
    if (!success) {
        NSLog(@"Failed to submit request: %@",error);
    }
}

+ (void)checkIn {
    if ([SettingsUtility testWifiOnly] &&
        ![[ReachabilityManager sharedManager] isWifi])
    return;
    
    //Other two states: UIDeviceBatteryStateCharging and UIDeviceBatteryStateFull
    if ([SettingsUtility testChargingOnly] &&
        [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged)
        return;

    NSString *testName = @"web_connectivity";
    NSString *testSuiteName = [TestUtility getCategoryForTest:testName];
    AbstractSuite *testSuite = [[AbstractSuite alloc] initSuite:testSuiteName];
    [testSuite setStoreDB:NO];
    AbstractTest *test = [[AbstractTest alloc] initTest:testName];
    [test setStoreDB:NO];
    [test setAnnotation:YES];
    [testSuite setTestList:[NSMutableArray arrayWithObject:test]];

    [OONIApi checkIn:^(NSArray *urls) {
        if ([urls count] == 0)
            return;
        if ([testSuiteName isEqualToString:@"websites"] && [urls count] > 0)
            [(WebConnectivity*)test setInputs:urls];
        [(WebConnectivity*)test disableMaxRuntime];
    } onError:^(NSError *error) {
        NSLog(@"Failed call checkIn API: %@",error);
    }];
    [SettingsUtility incrementAutorun];
    [SettingsUtility updateAutorunDate];
    [testSuite runTestSuite];
}

+ (void)cancelCheckIn API_AVAILABLE(ios(13.0)){
    [[BGTaskScheduler sharedScheduler] cancelTaskRequestWithIdentifier:taskID];
}

+ (void)scheduleLocalNotification{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = @"Start CheckIn";
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
