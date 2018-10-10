#import "NdtTest.h"

@implementation NdtTest : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"ndt";
        self.settings.name = [LocalizationUtility getMKNameForTest:self.name];
    }
    return self;
}

-(void) runTest {
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     onEntry method for ndt test, check "failure" key
     !=null => failed
     */
    measurement.is_failed = json.test_keys.failure == NULL ? false : true;
    [self calculateServerName:json];
    [super onEntry:json obj:measurement];
}

-(void)calculateServerName:(JsonResult*)json{
    if (json.test_keys.server_address != NULL){
        NSString *server_address = json.test_keys.server_address;
        NSArray *arr = [server_address componentsSeparatedByString:@"."];
        if ([arr count] > 3){
            NSString *server_name = [arr objectAtIndex:3];
            json.test_keys.server_name = server_name;
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Airports" ofType:@"plist"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            if ([dict objectForKey:[server_name substringToIndex:3]])
                json.test_keys.server_country = [dict objectForKey:[server_name substringToIndex:3]];
        }
    }
}

@end
