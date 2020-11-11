#import "Options.h"
#import "SettingsUtility.h"
#import "VersionUtility.h"

@implementation Options

- (id)init {
    self = [super init];
    if (self) {
        //TODO remove these options in the future
        BOOL include_ip = FALSE;
        BOOL include_asn = TRUE;
        BOOL include_cc = TRUE;
        BOOL upload_results = [SettingsUtility getSettingWithName:@"upload_results"];
        NSString *software_version = [VersionUtility get_software_version];
        self.save_real_probe_ip = [NSNumber numberWithBool:include_ip];
        self.save_real_probe_asn = [NSNumber numberWithBool:include_asn];
        self.save_real_probe_cc = [NSNumber numberWithBool:include_cc];
        self.no_collector = [NSNumber numberWithBool:!upload_results];
        self.software_name = SOFTWARE_NAME;
        self.software_version = software_version;
        self.randomize_input = [NSNumber numberWithBool:FALSE];
        self.no_file_report  = [NSNumber numberWithBool:TRUE];
    }
    return self;
}

@end
