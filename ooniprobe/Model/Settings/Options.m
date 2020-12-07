#import "Options.h"
#import "SettingsUtility.h"
#import "VersionUtility.h"

@implementation Options

- (id)init {
    self = [super init];
    if (self) {
        BOOL upload_results = [SettingsUtility getSettingWithName:@"upload_results"];
        NSString *software_version = [VersionUtility get_software_version];
        self.no_collector = [NSNumber numberWithBool:!upload_results];
        self.software_name = SOFTWARE_NAME;
        self.software_version = software_version;
    }
    return self;
}

@end
