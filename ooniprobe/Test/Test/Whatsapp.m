#import "Whatsapp.h"

@implementation Whatsapp : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"whatsapp";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     if "whatsapp_endpoints_status", "whatsapp_web_status", "registration_server" are null => failed
     if "whatsapp_endpoints_status" or "whatsapp_web_status" or "registration_server_status" are "blocked" => anomalous
     */
    if (json.test_keys.whatsapp_endpoints_status == NULL || json.test_keys.whatsapp_web_status == NULL || json.test_keys.registration_server_status == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = [json.test_keys.whatsapp_endpoints_status isEqualToString:BLOCKED] || [json.test_keys.whatsapp_web_status isEqualToString:BLOCKED] || [json.test_keys.registration_server_status isEqualToString:BLOCKED];
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 10;
}

@end
