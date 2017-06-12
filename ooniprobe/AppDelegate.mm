// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "AppDelegate.h"
#import "NotificationService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultPreferences" ofType:@"plist"]]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: color_off_white, NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSansOT-Bold" size:18], NSFontAttributeName, nil]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"FiraSansOT-Bold" size:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    CrashlyticsKit.delegate = self;
    [Fabric with:@[[Crashlytics class]]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NotificationService sharedNotificationService] registerNotifications:@"TEST_TOKEN"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first_run"])
        [self registerNotifications];
    return YES;
}

- (void)registerNotifications{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token: %@",token);
    [[NotificationService sharedNotificationService] registerNotifications:token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo) {
        if ([userInfo objectForKey:@"aps"]){
            if([[userInfo objectForKey:@"aps"] objectForKey:@"badge"])
                [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
        }
        UIApplicationState state = [application applicationState];
        if (state == UIApplicationStateActive)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notifications", nil) message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //TODO start your long running bg task here
}

- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL))completionHandler {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completionHandler([[[NSUserDefaults standardUserDefaults] objectForKey:@"send_crash"] boolValue]);
    }];
}

#pragma mark - PBRevealViewController Delegate
    
- (BOOL)revealControllerPanGestureShouldBegin:(PBRevealViewController *)revealController direction:(PBRevealControllerPanDirection)direction
    {
        if ([[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode] isEqualToString:@"ar"]){
            if (direction == PBRevealControllerPanDirectionLeft){
                if ([revealController isRightViewOpen])
                    return NO;
                else
                    return YES;
            }
            else {
                if ([revealController isRightViewOpen])
                    return YES;
                else
                    return NO;
            }
        }
        if (direction == PBRevealControllerPanDirectionLeft) {
            if (direction == PBRevealControllerPanDirectionLeft){
                if ([revealController isLeftViewOpen])
                    return YES;
                else
                    return NO;
            }
            else {
                if ([revealController isLeftViewOpen])
                    return NO;
                else
                    return YES;
            }

        }
        return YES;
    }
    
@end
