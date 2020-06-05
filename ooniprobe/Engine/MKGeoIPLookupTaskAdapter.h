#import <Foundation/Foundation.h>
#import <mkall/MKGeoIPLookup.h>
#import "GeoIPLookupTask.h"
#import "GeoIPLookupResults.h"
#import "MKGeoIPLookupResultsAdapter.h"

@interface MKGeoIPLookupTaskAdapter : NSObject <GeoIPLookupTask>

@property (nonatomic, strong) MKGeoIPLookupTask* task;

@end
