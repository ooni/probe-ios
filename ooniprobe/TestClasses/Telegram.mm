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
        /*
         for telegram: red if either "telegram_http_blocking" or "telegram_tcp_blocking" is true, OR if ""telegram_web_status" is "blocked"
         the "*_failure" keys for telegram and whatsapp might indicate a test failure / anomaly
         */
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        NSArray *checkKeys = [[NSArray alloc] initWithObjects:@"telegram_http_blocking", @"telegram_tcp_blocking", nil];
        for (NSString *key in checkKeys) {
            if ([keys objectForKey:key]){
                if ([keys objectForKey:key] == [NSNull null]) {
                    if (self.measurement.state != measurementFailed)
                        [self.measurement setState:measurementFailed];
                }
                else if ([[keys objectForKey:key] boolValue]) {
                    [self.measurement setAnomaly:YES];
                }
            }
        }
        if ([keys objectForKey:@"telegram_web_status"]){
            if ([keys objectForKey:@"telegram_web_status"] == [NSNull null]) {
                if (self.measurement.state != measurementFailed)
                    [self.measurement setState:measurementFailed];
            }
            else if ([[keys objectForKey:@"telegram_web_status"] isEqualToString:@"blocked"]) {
                [self.measurement setAnomaly:YES];
            }
        }
        [super updateSummary];
        [self setTestSummary:keys :[[NSArray alloc] initWithObjects:@"telegram_http_blocking", @"telegram_tcp_blocking", @"telegram_web_status", nil]];
        [self.measurement save];
    }
}

-(void)setTestSummary:(NSDictionary*)keys :(NSArray*)checkKeys{
    Summary *summary = [self.result getSummary];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    for (NSString *key in checkKeys) {
        if ([keys safeObjectForKey:key]){
            [values setObject:[keys objectForKey:key] forKey:key];
        }
    }
    [summary.json setValue:values forKey:self.name];
    [self.result save];
}

@end
