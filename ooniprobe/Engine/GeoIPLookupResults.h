#import <Foundation/Foundation.h>

/** GeoIPLookupResults contains the results of a GeoIP lookup */
@protocol GeoIPLookupResults

/** isGood returns whether we succeeded. */
- (BOOL) isGood;

/** probeIP returns the probe IP. */
- (NSString*) probeIP;

/** probeASN returns the probe ASN. */
- (NSString*) probeASN;

/** probeCC returns the probe CC. */
- (NSString*) probeCC;

/** probeOrg returns the probe ASN organization. */
- (NSString*) probeOrg;

/** logs returns the logs as one or more newline separated
 * lines containing only UTF-8 characters. */
- (NSString*) logs;

@end
