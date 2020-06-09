#import "NdtTest.h"

@implementation NdtTest : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"ndt";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
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
    NSString *site = [json.test_keys.server.site substringToIndex:3];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Airports" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    if ([dict objectForKey:site]){
        json.test_keys.server_name = json.test_keys.server.site;
        json.test_keys.server_country = [dict objectForKey:site];
    }
}

-(int)getRuntime{
    return 45;
}

@end
