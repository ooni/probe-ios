#import "NetworkTest.h"

@implementation NetworkTest

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.result = [[Result alloc] init];
    [self.result setStartTime:[NSDate date]];
    self.mkNetworkTests = [[NSMutableArray alloc] init];
    return self;
}

-(void)run {
    //Is it order guaranteed?
    for (MKNetworkTest *current in self.mkNetworkTests){
        [current run];
    }
}

-(void)testEnded:(MKNetworkTest*)test{
    NSLog(@"CALLBACK test_ended %@", test.name);
    //TODO cosa mi serve? test name o object.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"testEnded" object:nil];

    //TODO build json somehow
    [self.result setJson:@""];
    [self.mkNetworkTests removeObject:test];
    //if last test
    if ([self.mkNetworkTests count] == 0){
        NSLog(@"ALL test_ended");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkTestEnded" object:nil];
        [self.result setEndTime:[NSDate date]];
        //self.done = true;
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

        if ([SettingsUtility getSettingWithName:@"test_whatsapp"]){
            Whatsapp *whatsapp = [[Whatsapp alloc] init];
            [whatsapp setDelegate:self];
            [whatsapp setResultId:self.result.uniqueId];
            [whatsapp setIdx:0];
            [self.mkNetworkTests addObject:whatsapp];
        }
        if ([SettingsUtility getSettingWithName:@"test_telegram"]){
            Telegram *telegram = [[Telegram alloc] init];
            [telegram setDelegate:self];
            [telegram setResultId:self.result.uniqueId];
            [telegram setIdx:1];
            [self.mkNetworkTests addObject:telegram];
        }
        if ([SettingsUtility getSettingWithName:@"test_facebook"]){
            FacebookMessenger *facebookMessenger = [[FacebookMessenger alloc] init];
            [facebookMessenger setDelegate:self];
            [facebookMessenger setResultId:self.result.uniqueId];
            [facebookMessenger setIdx:2];
            [self.mkNetworkTests addObject:facebookMessenger];
        }
        //TODO what to do if no tests are enabled
        [self.result setName:@"instant_messaging"];
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
        WebConnectivity *webConnectivity = [[WebConnectivity alloc] init];
        [webConnectivity setDelegate:self];
        //[web_connectivityMeasurement setMax_runtime_enabled:YES];
        //web_connectivityMeasurement.inputs = [[TestLists sharedTestLists] getUrls];
        [webConnectivity setResultId:self.result.uniqueId];
        [self.mkNetworkTests addObject:webConnectivity];
        [webConnectivity setIdx:0];
        [self.result setName:@"websites"];
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
        if ([SettingsUtility getSettingWithName:@"run_http_invalid_request_line"]){
            HttpInvalidRequestLine *httpInvalidRequestLine = [[HttpInvalidRequestLine alloc] init];
            [httpInvalidRequestLine setDelegate:self];
            [httpInvalidRequestLine setResultId:self.result.uniqueId];
            [httpInvalidRequestLine setIdx:0];
            [self.mkNetworkTests addObject:httpInvalidRequestLine];
        }
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"]){
            HttpHeaderFieldManipulation *httpHeaderFieldManipulation = [[HttpHeaderFieldManipulation alloc] init];
            [httpHeaderFieldManipulation setDelegate:self];
            [httpHeaderFieldManipulation setResultId:self.result.uniqueId];
            [httpHeaderFieldManipulation setIdx:1];
            [self.mkNetworkTests addObject:httpHeaderFieldManipulation];
        }
        [self.result setName:@"middle_boxes"];
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
        if ([SettingsUtility getSettingWithName:@"run_ndt"]){
            NdtTest *ndtTest = [[NdtTest alloc] init];
            [ndtTest setDelegate:self];
            [ndtTest setResultId:self.result.uniqueId];
            [ndtTest setIdx:0];
            [self.mkNetworkTests addObject:ndtTest];
        }
        if ([SettingsUtility getSettingWithName:@"run_dash"]){
            Dash *dash = [[Dash alloc] init];
            [dash setDelegate:self];
            [dash setResultId:self.result.uniqueId];
            [dash setIdx:1];
            [self.mkNetworkTests addObject:dash];
        }
        [self.result setName:@"performance"];
    }
    return self;
}

-(void)run {
    [super run];
}
@end
