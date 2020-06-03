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

- (void) setCABundlePath:(NSString*) path {
    //NOT USED
}

- (void) setCountryDBPath:(NSString*) path {
    //NOT USED
}

- (void) setASNDBPath:(NSString*) path {
    //NOT USED
}

- (id<GeoIPLookupResults>) perform {
    return [[MKGeoIPLookupResultsAdapter alloc]
            initWithResults:[self.task perform]];
}

@end
