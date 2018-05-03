#import "Telegram.h"

@implementation Telegram : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"telegram";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}


-(void) runTest {
    mk::nettests::TelegramTest test;
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        int blocking = MEASUREMENT_OK;
        /*
         for telegram: red if either "telegram_http_blocking" or "telegram_tcp_blocking" is true, OR if ""telegram_web_status" is "blocked"
         the "*_failure" keys for telegram and whatsapp might indicate a test failure / anomaly
         */
        NSArray *keys = [[NSArray alloc] initWithObjects:@"telegram_http_blocking", @"telegram_tcp_blocking", nil];
        for (NSString *key in keys) {
            if ([[json objectForKey:@"test_keys"] objectForKey:key]){
                if ([[json objectForKey:@"test_keys"] objectForKey:key] == [NSNull null]) {
                    if (blocking < MEASUREMENT_FAILURE)
                        blocking = MEASUREMENT_FAILURE;
                }
                else if ([[[json objectForKey:@"test_keys"] objectForKey:key] boolValue]) {
                    blocking = MEASUREMENT_BLOCKED;
                }
            }
        }
        if ([[json objectForKey:@"test_keys"] objectForKey:@"telegram_web_status"]){
            if ([[json objectForKey:@"test_keys"] objectForKey:@"telegram_web_status"] == [NSNull null]) {
                if (blocking < MEASUREMENT_FAILURE)
                    blocking = MEASUREMENT_FAILURE;
            }
            else if ([[[json objectForKey:@"test_keys"] objectForKey:@"telegram_web_status"] isEqualToString:@"blocked"]) {
                blocking = MEASUREMENT_BLOCKED;
            }
        }
        [super updateBlocking:blocking];
        [self.measurement save];
    }
}

@end
