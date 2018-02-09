#import "NetworkTest.h"

@implementation NetworkTest

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.result = [Result new];
    //[self.result setStartTime:[NSDate date]];
    //[self.result setDone:NO];
    self.mkNetworkTests = [[NSMutableArray alloc] init];
    return self;
}

-(void)run {
    //Is it order guaranteed?
    for (MKNetworkTest *current in self.mkNetworkTests){
        [current run];
    }
}

-(void)initCommon:(MKNetworkTest*)test{
    [test setDelegate:self];
    [test setResult:self.result];
    [self.mkNetworkTests addObject:test];
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
        [self.result setEndTime:[NSDate date]];
        [self.result setDone:YES];
    }
    [self.result save];
}

//TODO delegate on_test_ended for every test
@end

@implementation IMNetworkTest : NetworkTest


-(id) init {
    self = [super init];
    if (self) {
        //[self setName:@"IMNetworkTest"];
        [self.result setName:@"instant_messaging"];
        if ([SettingsUtility getSettingWithName:@"test_whatsapp"]){
            Whatsapp *whatsapp = [[Whatsapp alloc] init];
            [whatsapp setIdx:0];
            [self initCommon:whatsapp];
        }
        if ([SettingsUtility getSettingWithName:@"test_telegram"]){
            Telegram *telegram = [[Telegram alloc] init];
            [telegram setIdx:1];
            [self initCommon:telegram];
        }
        if ([SettingsUtility getSettingWithName:@"test_facebook"]){
            FacebookMessenger *facebookMessenger = [[FacebookMessenger alloc] init];
            [facebookMessenger setIdx:2];
            [self initCommon:facebookMessenger];
        }
        //TODO what to do if no tests are enabled
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
        WebConnectivity *webConnectivity = [[WebConnectivity alloc] init];
        NSMutableArray *urls = [[NSMutableArray alloc] initWithObjects:@"http://www.google.it", @"http://www.wikipedia.org", @"http://www.reddit.com", nil];
        webConnectivity.inputs = urls;
        [webConnectivity setMax_runtime_enabled:YES];
        [webConnectivity setIdx:0];
        [self initCommon:webConnectivity];
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
            HttpInvalidRequestLine *httpInvalidRequestLine = [[HttpInvalidRequestLine alloc] init];
            [httpInvalidRequestLine setIdx:0];
            [self initCommon:httpInvalidRequestLine];
        }
        else if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"]){
            HttpHeaderFieldManipulation *httpHeaderFieldManipulation = [[HttpHeaderFieldManipulation alloc] init];
            [httpHeaderFieldManipulation setIdx:1];
            [self initCommon:httpHeaderFieldManipulation];
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
            NdtTest *ndtTest = [[NdtTest alloc] init];
            [ndtTest setIdx:0];
            [self initCommon:ndtTest];
        }
        else if ([SettingsUtility getSettingWithName:@"run_dash"]){
            Dash *dash = [[Dash alloc] init];
            [dash setIdx:1];
            [self initCommon:dash];
        }
    }
    return self;
}

-(void)run {
    [super run];
}
@end
