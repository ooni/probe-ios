#import "Telegram.h"

@implementation Telegram : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"telegram";
        self.measurement.test_name = self.name;
    }
    return self;
}


-(void) runTest {
    mk::nettests::TelegramTest test;
    [super initCommon];
}

-(void)onEntry:(JsonResult*)json {
    /*
     if "telegram_http_blocking", "telegram_tcp_blocking", "telegram_web_status" are null => failed
     if either "telegram_http_blocking" or "telegram_tcp_blocking" is true, OR if "telegram_web_status" is "blocked" => anomalous
     */
    //NSDictionary *testKeys = jsonResult.test_keys;
    if (json.test_keys.telegram_http_blocking == NULL || json.test_keys.telegram_tcp_blocking == NULL || json.test_keys.telegram_web_status == NULL)
        [self.measurement setIs_failed:true];
    else
        self.measurement.is_anomaly = [json.test_keys.telegram_http_blocking boolValue] || [json.test_keys.telegram_tcp_blocking boolValue] || [json.test_keys.telegram_web_status isEqualToString:@"blocked"];
    
    [super onEntry:json];
}


@end
