#import <Foundation/Foundation.h>
#import "GeoIPLookupResults.h"

/** GeoIPLookupTask performs a GeoIP lookup */
@protocol GeoIPLookupTask

/** setTimeout sets the number of seconds after which pending
 * requests are aborted by the underlying engine. */
- (void) setTimeout:(long) timeout;

/** perform performs a GeoIP lookup with current settings. */
- (id<GeoIPLookupResults>) perform;

@end
