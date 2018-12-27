#import "AbstractSuite.h"

@implementation AbstractSuite

-(id) init {
    self = [super init];
    if (self) {
        self.backgroundTask = UIBackgroundTaskInvalid;
        self.testList = [[NSMutableArray alloc] init];
        self.measurementIdx = 0;
    }
    return self;
}

-(void)initResult:(Result*)result{
    if (result != nil)
        self.result = result;
    else {
        self.result = [Result new];
        //The Result object needs to be saved to have an Id, needed for log
        [self.result save];
    }
}

-(void)addTest:(NSString*)testName{
    if ([testName isEqualToString:@"whatsapp"]){
        Whatsapp *whatsapp = [[Whatsapp alloc] init];
        [self initCommon:whatsapp];
    }
    else if ([testName isEqualToString:@"telegram"]){
        Telegram *telegram = [[Telegram alloc] init];
        [self initCommon:telegram];
    }
    else if ([testName isEqualToString:@"facebook_messenger"]){
        FacebookMessenger *facebookMessenger = [[FacebookMessenger alloc] init];
        [self initCommon:facebookMessenger];
    }
    else if ([testName isEqualToString:@"web_connectivity"]){
        WebConnectivity *webConnectivity = [[WebConnectivity alloc] init];
        [self initCommon:webConnectivity];
    }
    else if ([testName isEqualToString:@"http_invalid_request_line"]){
        HttpInvalidRequestLine *httpInvalidRequestLine = [[HttpInvalidRequestLine alloc] init];
        [self initCommon:httpInvalidRequestLine];
    }
    else if ([testName isEqualToString:@"http_header_field_manipulation"]){
        HttpHeaderFieldManipulation *httpHeaderFieldManipulation = [[HttpHeaderFieldManipulation alloc] init];
        [self initCommon:httpHeaderFieldManipulation];
    }
    else if ([testName isEqualToString:@"ndt"]){
        NdtTest *ndtTest = [[NdtTest alloc] init];
        [self initCommon:ndtTest];
    }
    else if ([testName isEqualToString:@"dash"]){
        Dash *dash = [[Dash alloc] init];
        [self initCommon:dash];
    }
}

-(void)initCommon:(AbstractTest*)test{
    [test setDelegate:self];
    [test setResult:self.result];
    [self.testList addObject:test];
}

-(void)runTestSuite {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    for (AbstractTest *current in self.testList){
        [current runTest];
    }
}

-(void)testEnded:(AbstractTest*)test{
    NSLog(@"CALLBACK test_ended %@", test.name);
    [self.testList removeObject:test];
    [self.result save];
    self.measurementIdx++;
    //if last test
    if ([self.testList count] == 0){
        NSLog(@"ALL test_ended");
        [self.result setIs_done:YES];
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive){
            if ([SettingsUtility getSettingWithName:@"notifications_enabled"] && [SettingsUtility getSettingWithName:@"notifications_completion"])
                [self showNotification];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkTestEnded" object:nil];
    }
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
}

- (void)showNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"%@ %@", [LocalizationUtility getNameForTest:self.result.test_group_name], NSLocalizedString(@"Notification.FinishedRunning", nil)];
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

-(int)getRuntime{
    int runtime = 0;
    for (AbstractTest *current in self.testList){
        runtime+=[current getRuntime];
    }
    return runtime;
}

@end
