#import "MKGeoIPLookupResultsAdapter.h"

@implementation MKGeoIPLookupResultsAdapter

- (id)initWithResults:(MKGeoIPLookupResults*)results {
    self = [super init];
    if (self) {
        self.results = results;
    }
    return self;
}

- (BOOL) isGood {
    return self.results.good;
}

- (NSString*) probeIP  {
    return self.results.probeIP;
}

- (NSString*) probeASN {
    return self.results.probeASN;
}

- (NSString*) probeCC {
    return self.results.probeCC;
}

- (NSString*) probeOrg {
    return self.results.probeOrg;
}

- (NSString*) logs {
    return self.results.logs;
}

@end
