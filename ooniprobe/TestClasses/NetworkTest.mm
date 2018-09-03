#import "NetworkTest.h"

@implementation NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.result = [Result new];
        self.mkNetworkTests = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithMeasurement:(Measurement*)existingMeasurement {
    self = [super init];
    if (self) {
        self.result = existingMeasurement.result_id;
        self.mkNetworkTests = [[NSMutableArray alloc] init];
        if ([existingMeasurement.test_name isEqualToString:@"web_connectivity"]){
            Url *currentUrl = [[Url alloc] initWithUrl:existingMeasurement.url_id.url category:existingMeasurement.url_id.category_code country:@"IT"];
            [self addTest:existingMeasurement.test_name :@[currentUrl]];
        }
        else
            [self addTest:existingMeasurement.test_name :nil];
        [existingMeasurement remove];
    }
    return self;
}

-(void)addTest:(NSString*)testName :(NSArray*)urls{
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
        //TODO handle max runtime in a better way
        /*[webConnectivity setMax_runtime_enabled:YES];
        if (urls != nil){
            [webConnectivity setInputs:urls];
            [webConnectivity setMax_runtime_enabled:NO];
        }*/
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
    [test setIdx:(int)[self.mkNetworkTests count]];
    [test setDelegate:self];
    //[test setResultOfMeasurement:self.result];
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
    //if last test
    if ([self.mkNetworkTests count] == 0){
        NSLog(@"ALL test_ended");
        [self.result setIs_done:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkTestEnded" object:nil];
        //TODO basic fix to remove last measurement
        if ([self.result.test_group_name isEqualToString:@"websites"]){
            for (Measurement *current in self.result.measurements){
                if (!current.url_id.url)
                    [current remove];
            }
        }
    }
    [self.result save];
    if ([SettingsUtility getSettingWithName:@"notifications_enabled"] && [SettingsUtility getSettingWithName:@"notifications_completion"])
        [self showNotification];
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

@implementation IMNetworkTest : NetworkTest


-(id) init {
    self = [super init];
    if (self) {
        [self.result setTest_group_name:@"instant_messaging"];
        if ([SettingsUtility getSettingWithName:@"test_whatsapp"]){
            [self addTest:@"whatsapp" :nil];
        }
        if ([SettingsUtility getSettingWithName:@"test_telegram"]){
            [self addTest:@"telegram" :nil];
        }
        if ([SettingsUtility getSettingWithName:@"test_facebook_messenger"]){
            [self addTest:@"facebook_messenger" :nil];
        }
        [self.result save];
    }
    return self;
}

//TODO maybe not needed
-(void)runTestSuite {
    [super runTestSuite];
}

@end

@implementation WCNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self.result setTest_group_name:@"websites"];
        [self addTest:@"web_connectivity" :nil];
    }
    return self;
}

-(id) initWithUrls:(NSArray*)urls {
    self = [super init];
    if (self) {
        [self.result setTest_group_name:@"websites"];
        [self addTest:@"web_connectivity" :urls];
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
        [self.result setTest_group_name:@"middle_boxes"];
        if ([SettingsUtility getSettingWithName:@"run_http_invalid_request_line"]){
            [self addTest:@"http_invalid_request_line" :nil];
        }
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"]){
            [self addTest:@"http_header_field_manipulation" :nil];
        }
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
        [self.result setTest_group_name:@"performance"];
        if ([SettingsUtility getSettingWithName:@"run_ndt"]){
            [self addTest:@"ndt" :nil];
        }
        if ([SettingsUtility getSettingWithName:@"run_dash"]){
            [self addTest:@"dash" :nil];
        }
    }
    return self;
}

-(void)runTestSuite {
    [super runTestSuite];
}
@end
