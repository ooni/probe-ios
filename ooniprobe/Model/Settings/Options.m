#import "Options.h"
#import "SettingsUtility.h"
#import "VersionUtility.h"
#import <mkall/MKResources.h>

@implementation Options

- (id)init {
    self = [super init];
    if (self) {
        BOOL include_ip = [SettingsUtility getSettingWithName:@"include_ip"];
        BOOL include_asn = [SettingsUtility getSettingWithName:@"include_asn"];
        BOOL include_cc = [SettingsUtility getSettingWithName:@"include_cc"];
        BOOL upload_results = [SettingsUtility getSettingWithName:@"upload_results"];
        NSString *software_version = [VersionUtility get_software_version];

        self.ca_bundle_path = [MKResources getCABundlePath];
        self.geoip_country_path = [MKResources getMMDBCountryPath];
        self.geoip_asn_path = [MKResources getMMDBASNPath];
        self.save_real_probe_ip = [NSNumber numberWithBool:include_ip];
        self.save_real_probe_asn = [NSNumber numberWithBool:include_asn];
        self.save_real_probe_cc = [NSNumber numberWithBool:include_cc];
        self.no_collector = [NSNumber numberWithBool:!upload_results];
        self.software_name = @"ooniprobe-ios";
        self.software_version = software_version;
        self.randomize_input = [NSNumber numberWithBool:FALSE];
    }
    return self;
}

@end
