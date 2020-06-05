#import "MKGeoIPLookupTaskAdapter.h"

@implementation MKGeoIPLookupTaskAdapter

- (id)init {
    self = [super init];
    if (self) {
        self.task = [MKGeoIPLookupTask new];
    }
    return self;
}

- (void) setTimeout:(long) timeout {
    [self.task setTimeout:timeout];
}

- (id<GeoIPLookupResults>) perform {
    return [[MKGeoIPLookupResultsAdapter alloc]
            initWithResults:[self.task perform]];
}

@end
