#import "Settings.h"
#import "ReachabilityManager.h"
#import "SettingsUtility.h"
#import "InCodeMappingProvider.h"
#import "Engine.h"
#import "ProxySettings.h"

@implementation Settings

- (id)init {
    self = [super init];
    if (self) {
        self.annotations = [[NSMutableDictionary alloc] initWithDictionary:@{@"network_type" : [[ReachabilityManager sharedManager] getStatus]}];
        self.disabled_events = @[@"status.queued", @"status.update.websites", @"failure.report_close"];
        self.log_level = [SettingsUtility getVerbosity];
        self.options = [Options new];
        self.state_dir = [Engine getStateDir];
        self.assets_dir = [Engine getAssetsDir];
        self.temp_dir = [Engine getTempDir];
        self.version = [NSNumber numberWithInt:1];
        self.proxy = [[[ProxySettings alloc] init] getProxyString];
        self.tunnel_dir = [Engine getTunnelDir];
    }
    return self;
}

-(NSDictionary*)dictionary{
    ObjectMapper *mapper = [[ObjectMapper alloc] init];
    return [mapper dictionaryFromObject:self];
}

-(NSString*)serialization {
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary] options:0 error:nil];
    if (jsonData != nil)
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return nil;
}

-(NSString *)taskName {
    return [self name];
}

@end
