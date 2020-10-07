#import "OONIGeolocateResults.h"

@implementation OONIGeolocateResults

- (id) initWithResults:(OonimkallGeolocateResults*)r {
    self = [super init];
    if (self) {
        self.ASN = r.asn;
        self.country = r.country;
        self.IP = r.ip;
        self.org = r.org;
    }
    return self;
}

@end
