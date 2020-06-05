#import <Foundation/Foundation.h>
#import <mkall/MKGeoIPLookup.h>
#import "GeoIPLookupResults.h"

@interface MKGeoIPLookupResultsAdapter : NSObject <GeoIPLookupResults>

- (id)initWithResults:(MKGeoIPLookupResults*)results;

@property (nonatomic, strong) MKGeoIPLookupResults* results;

@end
