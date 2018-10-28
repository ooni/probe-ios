#import "AppDelegate.h"
#import "NotificationService.h"
#import "BrowserViewController.h"
#import "DictionaryUtility.h"
#import "OoniRunViewController.h"
#import "MessageUtility.h"
#import "Result.h"
#import "TestRunningViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SharkORM setDelegate:self];
    //TODO change name before release
    [SharkORM openDatabaseNamed:@"OONISample5"];    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultPreferences" ofType:@"plist"]]];

    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSans-SemiBold" size:16], NSFontAttributeName, nil]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"FiraSans-Regular" size:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    [[UINavigationBar appearance] setTranslucent:FALSE];

    #ifdef RELEASE
    CrashlyticsKit.delegate = self;
    [Fabric with:@[[Crashlytics class]]];
    #endif

    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    //TODO-2.1 Probably don't need it anymore when implementing backgound notifications
    //https://stackoverflow.com/questions/30297594/uiapplicationlaunchoptionsremotenotificationkey-not-getting-userinfo
    //https://stackoverflow.com/questions/38969229/what-is-uiapplicationlaunchoptionsremotenotificationkey-used-for
    NSMutableDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notification) {
        [self handleNotification:notification :application];
    }

    //If old test are detected, tell the user we are deleting them, no cancel button
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tests"]){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Modal.OldTestsDetected", nil)
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self removeOldTests];
                                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new_tests"];
                                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tests"];
                                   }];
        [alert addAction:okButton];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token: %@",token);
#ifdef RELEASE
    [[NotificationService sharedNotificationService] setDevice_token:token];
    [[NotificationService sharedNotificationService] updateClient];
#endif
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        NSLog(@"Permission not Granted by user");
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registeredForNotifications" object:self];
    }
}

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

-(void)handleNotification:(NSDictionary*)userInfo :(UIApplication *)application{
    NSString *type = [userInfo objectForKey:@"type"];
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        if ([type isEqualToString:@"open_href"]){
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self openBrowser];
                                       }];
            links = [[NSMutableArray alloc] init];
            [links addObject:[[userInfo objectForKey:@"payload"] objectForKey:@"href"]];
            if ([[userInfo objectForKey:@"payload"] objectForKey:@"alt_hrefs"]){
                NSArray *alt_href = [[userInfo objectForKey:@"payload"] objectForKey:@"alt_hrefs"];
                [links addObjectsFromArray:alt_href];
            }
            [MessageUtility alertWithTitle:nil
                                   message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                  okButton:okButton
                                    inView:self.window.rootViewController];
        }
        else {
            [MessageUtility alertWithTitle:nil
                                   message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                    inView:self.window.rootViewController];
        }
    }
    else {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        if ([type isEqualToString:@"open_href"]){
            links = [[NSMutableArray alloc] init];
            [links addObject:[[userInfo objectForKey:@"payload"] objectForKey:@"href"]];
            if ([[userInfo objectForKey:@"payload"] objectForKey:@"alt_hrefs"]){
                NSArray *alt_href = [[userInfo objectForKey:@"payload"] objectForKey:@"alt_hrefs"];
                [links addObjectsFromArray:alt_href];
            }
            [self openBrowser];
        }
    }
}

-(void)openBrowser{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"OONIRun" bundle: nil];
        UINavigationController *nvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"browserNC"];
        BrowserViewController *bvc = (BrowserViewController*)[nvc.viewControllers objectAtIndex:0];
        [bvc setUrlList:links];
        [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
    });
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
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"notifications_enabled"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    });
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
        [MessageUtility showToast:@"OONIRun.TestRunningError" inView:self.window.rootViewController.presentedViewController.view];
    else {
        [self showOONIRun:url];
    }
}

-(void)showOONIRun:(NSURL*)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"OONIRun" bundle: nil];
        UINavigationController *nvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"oonirun_nav"];
        OoniRunViewController *rvc = (OoniRunViewController*)[nvc.viewControllers objectAtIndex:0];
        //OoniRunViewController *rvc = (OoniRunViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"oonirun"];
        [rvc setUrl:url];
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

-(void)removeOldTests{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *paths = [fileManager contentsOfDirectoryAtPath:documentDirPath error:nil];
    for (NSString *path in paths) {
        if ([path containsString:@".json"] || [path containsString:@".log"]) {
            // path is directory
            NSError *error;
            NSString *filePath = [documentDirPath stringByAppendingPathComponent:path];
            [fileManager removeItemAtPath:filePath error:&error];
        }
    }
}

@end
