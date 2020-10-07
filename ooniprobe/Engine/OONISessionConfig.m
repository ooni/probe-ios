#import "OONISessionConfig.h"
#import "PELoggerAdapter.h"

@implementation OONISessionConfig

- (OonimkallSessionConfig*) toOonimkallSessionConfig {
    OonimkallSessionConfig* c = [[OonimkallSessionConfig alloc] init];
    c.assetsDir = self.assetsDir;
    c.logger = [[PELoggerAdapter alloc] initWithLogger:self.logger];
    c.probeServicesURL = self.probeServicesURL;
    c.softwareName = self.softwareName;
    c.softwareVersion = self.softwareVersion;
    c.stateDir = self.stateDir;
    c.tempDir = self.tempDir;
    c.verbose = self.verbose;
    return c;
}

@end
