#import <Foundation/Foundation.h>

/** GeoIPLookupResults contains the results of a GeoIP lookup */
@protocol GeoIPLookupResults

/** isGood returns whether we succeeded. */
- (BOOL) isGood;

/** getProbeIP returns the probe IP. */
- (NSString*) getProbeIP;

/** getProbeASN returns the probe ASN. */
- (NSString*) getProbeASN;

/** getProbeCC returns the probe CC. */
- (NSString*) getProbeCC;

/** getProbeOrg returns the probe ASN organization. */
- (NSString*) getProbeOrg;

/** getLogs returns the logs as one or more newline separated
 * lines containing only UTF-8 characters. */
- (NSString*) getLogs;

@end
