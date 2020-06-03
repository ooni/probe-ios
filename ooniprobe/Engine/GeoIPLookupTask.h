#import <Foundation/Foundation.h>
#import "GeoIPLookupResults.h"

/** GeoIPLookupTask performs a GeoIP lookup */
@protocol GeoIPLookupTask

/** setTimeout sets the number of seconds after which pending
 * requests are aborted by the underlying engine. */
- (void) setTimeout:(long) timeout;

/** setCABundlePath sets the path of the CA bundle to use. */
- (void) setCABundlePath:(NSString*) path;

/** setCountryDBPath sets the path of the MaxMind country
 * database to use. */
- (void) setCountryDBPath:(NSString*) path;

/** setASNDBPath sets the path of the MaxMind ASN
 * database to use. */
- (void) setASNDBPath:(NSString*) path;

/** perform performs a GeoIP lookup with current settings. */
- (id<GeoIPLookupResults>) perform;

@end
