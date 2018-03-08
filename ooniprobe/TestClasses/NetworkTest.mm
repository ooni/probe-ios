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

-(id) initWithMeasurement:(Measurement*)existingMeasurement {
    self = [super init];
    if (self) {
        self.result = existingMeasurement.result;
        self.mkNetworkTests = [[NSMutableArray alloc] init];
        [self addTest:existingMeasurement.name];
        //TODO set input for web_connectivity
        [existingMeasurement remove];
    }
    return self;
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
        [webConnectivity setMax_runtime_enabled:YES];
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
    [test setIdx:[self.mkNetworkTests count]];
    [test setDelegate:self];
    [test setResultOfMeasurement:self.result];
    [self.mkNetworkTests addObject:test];
}

-(void)run {
    //TODO should never happen
    /*if ([self.mkNetworkTests count] == 0)
        [MessageUtility alertWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"cant deactivate", nil) inView:self.view];
     */
    for (MKNetworkTest *current in self.mkNetworkTests){
        [current run];
    }
}



-(void)testEnded:(MKNetworkTest*)test{
    NSLog(@"CALLBACK test_ended %@", test.name);
    //TODO build json somehow
    [self.result setSummary:@""];
    [self.mkNetworkTests removeObject:test];
    
    //if last test
    if ([self.mkNetworkTests count] == 0){
        NSLog(@"ALL test_ended");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkTestEnded" object:nil];
        [self.result setDone:YES];
    }
    [self.result save];
}

@end

@implementation IMNetworkTest : NetworkTest


-(id) init {
    self = [super init];
    if (self) {
        [self.result setName:@"instant_messaging"];
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

-(void)run {
    [super run];
}

@end

@implementation WCNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self.result setName:@"websites"];
        [self addTest:@"web_connectivity"];
    }
    return self;
}

-(void)run {
    [super run];
}

@end

@implementation MBNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self.result setName:@"middle_boxes"];
        if ([SettingsUtility getSettingWithName:@"run_http_invalid_request_line"]){
            [self addTest:@"http_invalid_request_line"];
        }
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"]){
            [self addTest:@"http_header_field_manipulation"];
        }
    }
    return self;
}

-(void)run {
    [super run];
}

@end

@implementation SPNetworkTest : NetworkTest

-(id) init {
    self = [super init];
    if (self) {
        [self.result setName:@"performance"];
        if ([SettingsUtility getSettingWithName:@"run_ndt"]){
            [self addTest:@"ndt"];
        }
        if ([SettingsUtility getSettingWithName:@"run_dash"]){
            [self addTest:@"dash"];
        }
    }
    return self;
}

-(void)run {
    [super run];
}
@end
