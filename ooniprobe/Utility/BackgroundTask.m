#import "BackgroundTask.h"
#import "Engine.h"
#import "VersionUtility.h"
#import "SettingsUtility.h"

@implementation BackgroundTask

+ (void)configure {
    [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:taskID
                                                          usingQueue:nil
                                                       launchHandler:^(BGTask *task) {
        [self scheduleLocalNotifications];
        [self handleAppRefreshTask:task];
    }];
    [self scheduleAppRefresh];
}

+ (void)scheduleLocalNotifications {
    //do things
}

/*
 https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler?language=objc
 https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/extending_your_app_s_background_execution_time?language=objc
 https://www.andyibanez.com/posts/modern-background-tasks-ios13/
 */

//https://stackoverflow.com/questions/58149980/ios-13-objective-c-background-task-request
//https://stackoverflow.com/questions/62026107/how-to-get-use-bgtask-in-objective-c-with-ios-13background-fetch
+ (void)handleAppRefreshTask:(BGTask *)task {
    // Schedule a new refresh task
    [self scheduleAppRefresh];
    task.expirationHandler = ^{
      NSLog(@"WARNING: expired before finish was executed.");
    };
    [self checkIn];
    [task setTaskCompletedWithSuccess:YES];
}

+ (void)scheduleAppRefresh {
    BGAppRefreshTaskRequest *request = [[BGAppRefreshTaskRequest alloc] initWithIdentifier:taskID];
    //request.requiresNetworkConnectivity = true;
    //request.requiresExternalPower = false;
    request.earliestBeginDate = [NSDate dateWithTimeIntervalSinceNow:2*60];
    NSError *error = NULL;
    BOOL success = [[BGTaskScheduler sharedScheduler] submitTaskRequest:request error:&error];
    if (!success) {
        NSLog(@"Failed to submit request: %@",error);
    }
}

+ (void) checkIn {
    //Download urls and then alloc class
    NSError *error;
    PESession* session = [[PESession alloc] initWithConfig:
                          [Engine getDefaultSessionConfigWithSoftwareName:SOFTWARE_NAME
                                                          softwareVersion:[VersionUtility get_software_version]
                                                                   logger:[LoggerArray new]]
                                                                    error:&error];
    if (error != nil) {
        return;
    }
    // Updating resources with no timeout because we don't know for sure how much
    // it will take to download them and choosing a timeout may prevent the operation
    // to ever complete. (Ideally the user should be able to interrupt the process
    // and there should be no timeout here.)
    [session maybeUpdateResources:[session newContext] error:&error];
    if (error != nil) {
        return;
    }
    OONIContext *ooniContext = [session newContextWithTimeout:30];
    OONICheckInConfig *config = [[OONICheckInConfig alloc] initWithSoftwareName:SOFTWARE_NAME
                                                                softwareVersion:[VersionUtility get_software_version]
                                                                     categories:[SettingsUtility getSitesCategoriesEnabled]];
    OONICheckInResults *results = [session checkIn:ooniContext config:config error:&error];
    if (error != nil) {
        //[self onError:error];
        return;
    }    
    for (OONIURLInfo* current in results.webConnectivity.urls){
        NSLog(@"Got url %@", current.url);
    }
}

/*
 TODO
 - Create preference to enable this
 - Enable background on enable preference.
 - Disable background on disable preference.
 - Be sure background works on phone reboot?
 - Function for checkin that also run test
 */
@end
