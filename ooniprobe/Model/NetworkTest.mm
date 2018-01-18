#import "NetworkTest.h"

@implementation NetworkTest

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.result = [[Result alloc] init];
    [self.result setStartTime:[NSDate date]];
    self.mk_network_tests = [[NSMutableArray alloc] init];
    return self;
}

-(void)run {
    for (MKNetworkTest *current in self.mk_network_tests){
        [current run];
    }
}

-(void)test_ended {
    NSLog(@"CALLBACK test_ended");
    //TODO cosa mi serve? test name o object.
    
    //TODO build json somehow
    [self.result setJson:@""];
    
    //if last test
    if (true){
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
            [self.mk_network_tests addObject:whatsapp];
        }
        if ([SettingsUtility getSettingWithName:@"test_telegram"]){
            Telegram *telegram = [[Telegram alloc] init];
            [telegram setDelegate:self];
            [telegram setResultId:self.result.uniqueId];
            [self.mk_network_tests addObject:telegram];
        }
        if ([SettingsUtility getSettingWithName:@"test_facebook"]){
            FacebookMessenger *facebook_messenger = [[FacebookMessenger alloc] init];
            [facebook_messenger setDelegate:self];
            [facebook_messenger setResultId:self.result.uniqueId];
            [self.mk_network_tests addObject:facebook_messenger];
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
        WebConnectivity *web_connectivityMeasurement = [[WebConnectivity alloc] init];
        //[web_connectivityMeasurement setMax_runtime_enabled:YES];
        //web_connectivityMeasurement.inputs = [[TestLists sharedTestLists] getUrls];
        [web_connectivityMeasurement setResultId:self.result.uniqueId];
        [self.mk_network_tests addObject:web_connectivityMeasurement];
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
            HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
            [http_invalid_request_lineMeasurement setResultId:self.result.uniqueId];
            [self.mk_network_tests addObject:http_invalid_request_lineMeasurement];
        }
        if ([SettingsUtility getSettingWithName:@"run_http_header_field_manipulation"]){
            HttpHeaderFieldManipulation *http_header_field_manipulationMeasurement = [[HttpHeaderFieldManipulation alloc] init];
            [http_header_field_manipulationMeasurement setResultId:self.result.uniqueId];
            [self.mk_network_tests addObject:http_header_field_manipulationMeasurement];
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
            NdtTest *ndt_testMeasurement = [[NdtTest alloc] init];
            [ndt_testMeasurement setResultId:self.result.uniqueId];
            [self.mk_network_tests addObject:ndt_testMeasurement];
        }
        if ([SettingsUtility getSettingWithName:@"run_dash"]){
            Dash *dash = [[Dash alloc] init];
            [dash setResultId:self.result.uniqueId];
            [self.mk_network_tests addObject:dash];
        }
        [self.result setName:@"performance"];
    }
    return self;
}

-(void)run {
    [super run];
}
@end
