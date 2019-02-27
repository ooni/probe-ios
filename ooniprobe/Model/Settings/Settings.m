#import "Settings.h"
#import "ReachabilityManager.h"
#import "SettingsUtility.h"
#import "InCodeMappingProvider.h"

@implementation Settings

- (id)init {
    self = [super init];
    if (self) {
        self.annotations = @{@"network_type" : [[ReachabilityManager sharedManager] getStatus]};
        self.disabled_events = @[@"status.queued", @"status.update.websites", @"failure.report_close"];
        self.log_level = [SettingsUtility getVerbosity];
        self.options = [Options new];
    }
    return self;
}

-(NSDictionary*)getSettingsDictionary{
    return [self dictionary];
}

@end
