#import "MKReporterTaskAdapter.h"

@implementation MKReporterTaskAdapter

- (id)initWithSoftwareName:(NSString*)softwareName softwareVersion:(NSString*)softwareVersion {
    self = [super init];
    if (self) {
        self.task = [[MKReporterTask alloc] initWithSoftwareName:softwareName softwareVersion:softwareVersion];
    }
    return self;
}

- (id<CollectorResults>) maybeDiscoverAndSubmit:(NSString*)measurement
                                    withTimeout:(long)timeout{
    return [[MKReporterResultsAdapter alloc]
            initWithResults:[self.task submit:measurement uploadTimeout:timeout]];
}

@end
