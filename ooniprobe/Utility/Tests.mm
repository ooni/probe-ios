#import "Tests.h"

@implementation Tests

+ (id)currentTests
{
    static Tests *currentTests = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentTests = [[self alloc] init];
    });
    return currentTests;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.availableNetworkMeasurements = [[NSMutableArray alloc] init];
        [self loadAvailableMeasurements];
    }
    return self;
}

- (void) loadAvailableMeasurements {
    [self.availableNetworkMeasurements removeAllObjects];
    
    WebConnectivity2 *web_connectivityMeasurement = [[WebConnectivity2 alloc] init];
    [self.availableNetworkMeasurements addObject:web_connectivityMeasurement];
    
    HTTPInvalidRequestLine2 *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine2 alloc] init];
    [self.availableNetworkMeasurements addObject:http_invalid_request_lineMeasurement];
    
    HttpHeaderFieldManipulation2 *http_header_field_manipulationMeasurement = [[HttpHeaderFieldManipulation2 alloc] init];
    [self.availableNetworkMeasurements addObject:http_header_field_manipulationMeasurement];

    NdtTest2 *ndt_testMeasurement = [[NdtTest2 alloc] init];
    [self.availableNetworkMeasurements addObject:ndt_testMeasurement];

    Dash2 *dash = [[Dash2 alloc] init];
    [self.availableNetworkMeasurements addObject:dash];
    
    Whatsapp2 *whatsapp = [[Whatsapp2 alloc] init];
    [self.availableNetworkMeasurements addObject:whatsapp];
    
    Telegram2 *telegram = [[Telegram2 alloc] init];
    [self.availableNetworkMeasurements addObject:telegram];
    
    FacebookMessenger2 *facebook_messenger = [[FacebookMessenger2 alloc] init];
    [self.availableNetworkMeasurements addObject:facebook_messenger];

}

- (NetworkMeasurement*)getTestWithName:(NSString*)testName{
    for (NetworkMeasurement *current in self.availableNetworkMeasurements){
        if ([current.name isEqualToString:testName])
            return current;
    }
    return nil;
}

+ (int)checkAnomaly:(NSDictionary*)test_keys{
    /*null => anomal = 1,
     false => anomaly = 0,
     stringa (dns, tcp-ip, http-failure, http-diff) => anomaly = 2
     
     Return values:
     0 == OK,
     1 == orange,
     2 == red
     */
    id element = [test_keys objectForKey:@"blocking"];
    int anomaly = 0;
    if ([test_keys objectForKey:@"blocking"] == [NSNull null]) {
        anomaly = 1;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        anomaly = 2;
    }
    return anomaly;
}

+ (NSArray*)getItems:(NSString*)json_file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:json_file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *content = @"";
    if([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        //Cut out the last \n
        if ([content length] > 0) {
            content = [content substringToIndex:[content length]-1];
        }
    }
    return [content componentsSeparatedByString:@"\n"];
}

@end
