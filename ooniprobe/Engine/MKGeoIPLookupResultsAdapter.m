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

- (NSString*) getProbeIP  {
    return self.results.probeIP;
}

- (NSString*) getProbeASN {
    return self.results.probeASN;
}

- (NSString*) getProbeCC {
    return self.results.probeCC;
}

- (NSString*) getProbeOrg {
    return self.results.probeOrg;
}

- (NSString*) getLogs {
    return self.results.logs;
}

@end
