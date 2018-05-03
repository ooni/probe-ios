#import "FacebookMessenger.h"

@implementation FacebookMessenger : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}

-(void) runTest {
    mk::nettests::FacebookMessengerTest test;
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        int blocking = MEASUREMENT_OK;
        // FB: red blocking if either "facebook_tcp_blocking" or "facebook_dns_blocking" is true
        NSArray *keys = [[NSArray alloc] initWithObjects:@"facebook_tcp_blocking", @"facebook_dns_blocking", nil];
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
        [super updateBlocking:blocking];
        [self.measurement save];
    }
}

@end
