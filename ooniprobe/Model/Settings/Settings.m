#import "Settings.h"
#import "ReachabilityManager.h"
#import "SettingsUtility.h"
#import "InCodeMappingProvider.h"

@implementation Settings

- (id)init {
    self = [super init];
    if (self) {
        BOOL include_asn = [SettingsUtility getSettingWithName:@"include_asn"];
        if (include_asn)
            self.annotations = [[NSMutableDictionary alloc] initWithDictionary:@{@"network_type" : [[ReachabilityManager sharedManager] getStatus]}];
        self.disabled_events = @[@"status.queued", @"status.update.websites", @"failure.report_close"];
        self.log_level = [SettingsUtility getVerbosity];
        self.options = [Options new];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.state_dir = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"state"]];
        self.assets_dir = [documentsDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"assets"]];
        self.temp_dir = NSTemporaryDirectory();
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
