#import "NetworkTest.h"

@implementation NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.mkNetworkTests = [[NSMutableArray alloc] init];
        self.measurementIdx = 0;
    }
    return self;
}

-(void)initResult:(Result*)result{
    if (result != nil)
        self.result = result;
    else
        self.result = [Result new];
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

-(void)initCommon:(MKNetworkTest*)test{
    [test setDelegate:self];
    [test setResult:self.result];
    [self.mkNetworkTests addObject:test];
}

-(void)runTestSuite {
    for (MKNetworkTest *current in self.mkNetworkTests){
        [current runTest];
    }
}

-(void)testEnded:(MKNetworkTest*)test{
    NSLog(@"CALLBACK test_ended %@", test.name);
    [self.mkNetworkTests removeObject:test];
    [self.result save];
    self.measurementIdx++;
    //if last test
    if ([self.mkNetworkTests count] == 0){
        NSLog(@"ALL test_ended");
        [self.result setIs_done:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkTestEnded" object:nil];
        if ([SettingsUtility getSettingWithName:@"notifications_enabled"] && [SettingsUtility getSettingWithName:@"notifications_completion"])
            [self showNotification];
    }
}

- (void)showNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = [NSString stringWithFormat:@"%@ %@", [LocalizationUtility getNameForTest:self.result.test_group_name], NSLocalizedString(@"Notification.FinishedRunning", nil)];
        [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    });
}

@end

@implementation WCNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self initResult:nil];
        [self.result setTest_group_name:@"websites"];
        [self addTest:@"web_connectivity"];
    }
    return self;
}

-(id) initWithUrls:(NSArray*)urls andResult:(Result*)result{
    self = [super init];
    if (self) {
        [self initResult:result];
        [self.result setTest_group_name:@"websites"];
        [self addTest:@"web_connectivity"];
        [self setUrls:urls];
    }
    return self;
}

-(void)setUrls:(NSArray*)inputs{
    if([self.mkNetworkTests count] > 0){
        WebConnectivity *wc = [self.mkNetworkTests objectAtIndex:0];
        wc.settings.inputs = inputs;
    }
}

-(void)setMaxRuntime {
    if([self.mkNetworkTests count] > 0){
        WebConnectivity *wc = [self.mkNetworkTests objectAtIndex:0];
        //TODO-2.0 handle max runtime in a better way
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        wc.settings.options.max_runtime = max_runtime;
    }
}


-(void)runTestSuite {
    [super runTestSuite];
}

@end
@implementation IMNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self initResult:nil];
        [self.result setTest_group_name:@"instant_messaging"];
        if ([SettingsUtility getSettingWithName:@"test_whatsapp"]){
            [self addTest:@"whatsapp"];
        }
        if ([SettingsUtility getSettingWithName:@"test_telegram"]){
            [self addTest:@"telegram"];
        }
        if ([SettingsUtility getSettingWithName:@"test_facebook_messenger"]){
            [self addTest:@"facebook_messenger"];
        }
        [self.result save];
    }
    return self;
}

-(id) initWithTest:(NSString*)test_name andResult:(Result*)result{
    self = [super init];
    if (self) {
        [self initResult:result];
        [self.result setTest_group_name:@"middle_boxes"];
        [self addTest:test_name];
    }
    return self;
}

-(void)runTestSuite {
    [super runTestSuite];
}

@end

@implementation MBNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self initResult:nil];
        [self.result setTest_group_name:@"middle_boxes"];
        if ([SettingsUtility getSettingWithName:@"run_http_invalid_request_line"]){
            [self addTest:@"http_invalid_request_line"];
        }
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"]){
            [self addTest:@"http_header_field_manipulation"];
        }
    }
    return self;
}

-(id) initWithTest:(NSString*)test_name andResult:(Result*)result{
    self = [super init];
    if (self) {
        [self initResult:result];
        [self.result setTest_group_name:@"middle_boxes"];
        [self addTest:test_name];
    }
    return self;
}

-(void)runTestSuite {
    [super runTestSuite];
}

@end

@implementation SPNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self initResult:nil];
        [self.result setTest_group_name:@"performance"];
        if ([SettingsUtility getSettingWithName:@"run_ndt"]){
            [self addTest:@"ndt"];
        }
        if ([SettingsUtility getSettingWithName:@"run_dash"]){
            [self addTest:@"dash"];
        }
    }
    return self;
}

-(id) initWithTest:(NSString*)test_name andResult:(Result*)result{
    self = [super init];
    if (self) {
        [self initResult:result];
        [self.result setTest_group_name:@"middle_boxes"];
        [self addTest:test_name];
    }
    return self;
}

-(void)runTestSuite {
    [super runTestSuite];
}
@end
