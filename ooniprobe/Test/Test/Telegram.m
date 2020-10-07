#import "Telegram.h"

@implementation Telegram : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"telegram";
    }
    return self;
}


-(void) runTest {
    [super prepareRun];
    [super runTest];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     if "telegram_http_blocking", "telegram_tcp_blocking", "telegram_web_status" are null => failed
     if either "telegram_http_blocking" or "telegram_tcp_blocking" is true, OR if "telegram_web_status" is "blocked" => anomalous
     */
    if (json.test_keys.telegram_http_blocking == NULL || json.test_keys.telegram_tcp_blocking == NULL || json.test_keys.telegram_web_status == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = [json.test_keys.telegram_http_blocking boolValue] || [json.test_keys.telegram_tcp_blocking boolValue] || [json.test_keys.telegram_web_status isEqualToString:@"blocked"];
    [super onEntry:json obj:measurement];
}

-(int)getRuntime{
    return 10;
}

@end
