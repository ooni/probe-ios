#import "MKOrchestraTaskAdapter.h"

@implementation MKOrchestraTaskAdapter

- (id)initWithSoftwareName:softwareName softwareVersion:softwareVersion supportedTests:supportedTests deviceToken:deviceToken secretsFile:secretsFile {
    self = [super init];
    if (self) {
        self.task = [[MKOrchestraTask alloc] initWithSoftwareName:softwareName
                                                  softwareVersion:softwareVersion
                                                   supportedTests:supportedTests
                                                      deviceToken:deviceToken
                                                      secretsFile:secretsFile];
    }
    return self;
}


- (void) setAvailableBandwidth:(NSString*) value {
    [self.task setAvailableBandwidth:value];
}

- (void) setLanguage:(NSString*) value {
    [self.task setLanguage:value];
}

- (void) setNetworkType:(NSString*) value {
    [self.task setNetworkType:value];
}

- (void) setPlatform:(NSString*) value {
    [self.task setPlatform:value];
}

- (void) setProbeASN:(NSString*) value {
    [self.task setProbeASN:value];
}

- (void) setProbeCC:(NSString*) value {
    [self.task setProbeCC:value];
}

- (void) setProbeFamily:(NSString*) value {
    [self.task setProbeFamily:value];
}

- (void) setProbeTimezone:(NSString*) value {
    [self.task setProbeTimezone:value];
}

- (void) setRegistryURL:(NSString*) value {
    [self.task setRegistryURL:value];
}

- (void) setTimeout:(long) value {
    [self.task setTimeout:value];
}

- (id<OrchestraResults>) updateOrRegister {
    return [[MKOrchestraResultsAdapter alloc]
            initWithResults:[self.task updateOrRegister]];
}

@end
