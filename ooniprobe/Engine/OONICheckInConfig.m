#import "OONICheckInConfig.h"

@implementation OONICheckInConfig

- (id) initWithSoftwareName:(NSString*)softwareName
            softwareVersion:(NSString*)softwareVersion
                 categories:(NSArray*)categories {
    self = [super init];
    if (self) {
        // TODO(aanorbel): we should avoid always setting charging
        // to true and onWiFi to true
        self.charging = true;
        self.onWiFi = true;
        self.platform = @"iOS";
        // TODO(aanorbel): we should avoid always setting runType to timed
        self.runType = @"timed";
        self.softwareName = softwareName;
        self.softwareVersion = softwareVersion;
        self.webConnectivity = [[OonimkallCheckInConfigWebConnectivity alloc] init];
        for (NSString* category in categories) {
            [self.webConnectivity addCategory:category];
        }
    }
    return self;
}

- (OonimkallCheckInConfig*) toOonimkallCheckInConfig {
    OonimkallCheckInConfig* c = [[OonimkallCheckInConfig alloc] init];
    c.charging = self.charging;
    c.onWiFi = self.onWiFi;
    c.platform = self.platform;
    c.runType = self.runType;
    c.softwareName = self.softwareName;
    c.softwareVersion = self.softwareVersion;
    c.webConnectivity = self.webConnectivity;
    return c;
}

@end
