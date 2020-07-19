#import "AppDelegate.h"
#import "DictionaryUtility.h"
#import "OoniRunViewController.h"
#import "MessageUtility.h"
#import "Result.h"
#import "TestRunningViewController.h"
#import "SettingsUtility.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([self isUITestingEnabled])
        [self copyDBTesting];
        
    [SharkORM setDelegate:self];
    [SharkORM openDatabaseNamed:@"OONIProbe"];    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultPreferences" ofType:@"plist"]]];

    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"FiraSans-Regular" size:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [NavigationBarUtility setDefaults];
    
#ifdef RELEASE
    CrashlyticsKit.delegate = self;
    [Fabric with:@[[Crashlytics class]]];
#endif

    application.statusBarStyle = UIStatusBarStyleLightContent;
    NSMutableDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notification) {
        [self handleNotification:notification :application];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token: %@",token);
#ifdef RELEASE
    [SettingsUtility set_push_token:token];
#endif
}

//TODO-COUNTLY maybe remove
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        NSLog(@"Permission not Granted by user");
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registeredForNotifications" object:self];
    }
}

//TODO-COUNTLY remove
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo) {
        if ([userInfo objectForKey:@"aps"]){
            if([[userInfo objectForKey:@"aps"] objectForKey:@"badge"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
                });
            }
        }
        [self handleNotification:userInfo :application];
    }
}

//TODO-COUNTLY remove
-(void)handleNotification:(NSDictionary*)userInfo :(UIApplication *)application{
    NSString *type = [userInfo objectForKey:@"type"];
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
            [MessageUtility alertWithTitle:nil
                                   message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                    inView:self.window.rootViewController];
    }
    else {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
    }
}

-(BOOL)isUITestingEnabled{
    if ([[NSProcessInfo processInfo].arguments containsObject:@"enable_ui_testing"]) {
        return true;
    }
    return false;
}

-(void)copyDBTesting{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"OONIProbe.db"];
    //Remove database if already there
    if ([fileManager fileExistsAtPath:txtPath] == YES) {
        [fileManager removeItemAtPath:txtPath error:&error];
    }
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"OONIProbe" ofType:@"db"];
    [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    });
    //Called in case the user disable notifications from iOS panel
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"notifications_enabled"];
    if ([TestUtility canCallDeleteJson])
        [TestUtility deleteUploadedJsons];
    [TestUtility deleteOldLogs];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkTestEnded" object:nil];
}

//Handles ooni:// links
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self handleUrlScheme:url];
    return YES;
}

//Handles http(s) links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        [self handleUrlScheme:userActivity.webpageURL];
    }
    return YES;
}

-(void)handleUrlScheme:(NSURL*)url{
    if ([self.window.rootViewController.presentedViewController isKindOfClass:[TestRunningViewController class]])
        [MessageUtility showToast:NSLocalizedString(@"OONIRun.TestRunningError", nil) inView:self.window.rootViewController.presentedViewController.view];
    else {
        [self showOONIRun:url];
    }
}

-(void)showOONIRun:(NSURL*)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"OONIRun" bundle: nil];
        UINavigationController *nvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"oonirun_nav"];
        OoniRunViewController *rvc = (OoniRunViewController*)[nvc.viewControllers objectAtIndex:0];
        NSString *fixedURL = [url.absoluteString stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
        [rvc setUrl:[NSURL URLWithString:fixedURL]];
        if (self.window.rootViewController.view.window != nil)
            //only main view controller is visible
            [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
        else {
            //main view controller is not in the window hierarchy, so overlay window was presented already, reloading parameters
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTest" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
        }
    });
}

- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL))completionHandler {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completionHandler([[[NSUserDefaults standardUserDefaults] objectForKey:@"send_crash"] boolValue]);
    }];
}

// database delegates
- (void)databaseError:(SRKError *)error {
    NSLog(@"DB error: %@", error.errorMessage);
}

@end
