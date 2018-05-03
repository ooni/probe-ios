#import "NdtTest.h"

@implementation NdtTest : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"ndt";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self runTest];
}


-(void) runTest {
    mk::nettests::NdtTest test;
    test.on_entry([self](std::string s) {
        [self onEntry:s.c_str()];
    });
    [super initCommon:test];
    //TODO when setting server check first ndt_server_auto
}

-(void)onEntry:(const char*)str {
    NSDictionary *json = [super onEntryCommon:str];
    if (json){
        int blocking = MEASUREMENT_OK;
        /*
         onEntry method for ndt and dash test
         if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
         */
        NSDictionary *keys = [json safeObjectForKey:@"test_keys"];
        if ([keys objectForKey:@"failure"] != [NSNull null])
            blocking = MEASUREMENT_FAILURE;
        if ([keys objectForKey:@"simple"]){
            Summary *summary = [self.result getSummary];
            [summary.json setValue:[keys objectForKey:@"simple"] forKey:self.name];
        }
        [super updateBlocking:blocking];
        [self setTestSummary:keys];
        [self.measurement save];
    }
}

-(void)setTestSummary:(NSDictionary*)keys{
    Summary *summary = [self.result getSummary];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    //TODO calculate server_name and server_country
    if ([keys safeObjectForKey:@"server_address"]){
        [values setObject:[keys safeObjectForKey:@"server_address"] forKey:@"server_address"];
    }
    
    NSDictionary *simple = [keys safeObjectForKey:@"simple"];
    if ([simple safeObjectForKey:@"upload"]){
        [values setObject:[simple safeObjectForKey:@"upload"] forKey:@"upload"];
    }
    if ([simple safeObjectForKey:@"download"]){
        [values setObject:[simple safeObjectForKey:@"download"] forKey:@"download"];
    }
    if ([simple safeObjectForKey:@"ping"]){
        [values setObject:[simple safeObjectForKey:@"ping"] forKey:@"ping"];
    }
    NSDictionary *advanced = [keys safeObjectForKey:@"advanced"];
    if ([advanced safeObjectForKey:@"server_address"]){
        [values setObject:[advanced safeObjectForKey:@"server_address"] forKey:@"server_address"];
    }
    if ([advanced safeObjectForKey:@"packet_loss"]){
        [values setObject:[advanced safeObjectForKey:@"packet_loss"] forKey:@"packet_loss"];
    }
    if ([advanced safeObjectForKey:@"out_of_order"]){
        [values setObject:[advanced safeObjectForKey:@"out_of_order"] forKey:@"out_of_order"];
    }
    if ([advanced safeObjectForKey:@"avg_rtt"]){
        [values setObject:[advanced safeObjectForKey:@"avg_rtt"] forKey:@"avg_rtt"];
    }
    if ([advanced safeObjectForKey:@"max_rtt"]){
        [values setObject:[advanced safeObjectForKey:@"max_rtt"] forKey:@"max_rtt"];
    }
    if ([advanced safeObjectForKey:@"mss"]){
        [values setObject:[advanced safeObjectForKey:@"mss"] forKey:@"mss"];
    }
    if ([advanced safeObjectForKey:@"timeouts"]){
        [values setObject:[advanced safeObjectForKey:@"timeouts"] forKey:@"timeouts"];
    }
    [summary.json setValue:values forKey:self.name];
    [self.result save];
}

@end
