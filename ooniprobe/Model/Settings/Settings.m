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
    }
    return self;
}

-(NSDictionary*)getSettingsDictionary{
    ObjectMapper *mapper = [[ObjectMapper alloc] init];
    return [mapper dictionaryFromObject:self];
}

@end
