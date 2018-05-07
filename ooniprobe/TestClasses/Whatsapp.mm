#import "Whatsapp.h"

@implementation Whatsapp : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"whatsapp";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::WhatsappTest test;
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        int blocking = MEASUREMENT_OK;
        // whatsapp: red if "whatsapp_endpoints_status" or "whatsapp_web_status" or "registration_server" are "blocked"
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        NSArray *checkKeys = [[NSArray alloc] initWithObjects:@"whatsapp_endpoints_status", @"whatsapp_web_status", @"registration_server_status", nil];
        for (NSString *key in checkKeys) {
            if ([keys objectForKey:key]){
                if ([keys objectForKey:key] == [NSNull null]) {
                    if (blocking < MEASUREMENT_FAILURE)
                        blocking = MEASUREMENT_FAILURE;
                }
                else if ([[keys objectForKey:key] isEqualToString:@"blocked"]) {
                    blocking = MEASUREMENT_BLOCKED;
                }
            }
        }
        [super updateBlocking:blocking];
        [self setTestSummary:keys :checkKeys];
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
