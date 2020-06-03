#import <Foundation/Foundation.h>
#import "OrchestraResults.h"

/** OrchestraTask is a task for interacting with the OONI orchestra */
@protocol OrchestraTask

/** setAvailableBandwidth sets the bandwidth that a probe is
 * available to commit to running measurements. */
- (void) setAvailableBandwidth:(NSString*) value;

/** setCABundlePath sets the path of the CA bundle to use. */
- (void) setCABundlePath:(NSString*) value;

/** setGeoIPCountryPath sets the path of the MaxMind country database. */
- (void) setGeoIPCountryPath:(NSString*) value;

/** setGeoIPASNPath sets the path of the MaxMind ASN database. */
- (void) setGeoIPASNPath:(NSString*) value;

/** setLanguage sets the device's language. */
- (void) setLanguage:(NSString*) value;

/** setNetworkType sets the current network type. */
- (void) setNetworkType:(NSString*) value;

/** setPlatform sets the device's platform */
- (void) setPlatform:(NSString*) value;

/** setProbeASN sets the ASN in which we are. */
- (void) setProbeASN:(NSString*) value;

/** setProbeCC sets the country code in which we are. */
- (void) setProbeCC:(NSString*) value;

/** setProbeFamily sets an identifier for a group of probes. */
- (void) setProbeFamily:(NSString*) value;

/** setProbeTimezone sets the timezone of the probe. */
- (void) setProbeTimezone:(NSString*) value;

/** setRegistryURL sets the base URL to contact the registry. */
- (void) setRegistryURL:(NSString*) value;

/** setTimeout sets the number of seconds after which
 * outstanding requests are aborted. */
- (void) setTimeout:(long) value;

/** updateOrRegister will either update the status of the probe with
 * the registry, or register the probe with the registry, depending
 * on whether we did already register or not. */
- (id<OrchestraResults>) updateOrRegister;

@end
