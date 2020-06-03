#import "MKReporterTaskAdapter.h"

@implementation MKReporterTaskAdapter

- (id)init {
    self = [super init];
    if (self) {
        self.task = [MKReporterTask new];
    }
    return self;
}

- (id<CollectorResults>) maybeDiscoverAndSubmit:(NSString*)measurement
                                    withTimeout:(long)timeout{
    return [[MKReporterResultsAdapter alloc]
            initWithResults:[self.task submit:measurement uploadTimeout:timeout]];
}

@end
