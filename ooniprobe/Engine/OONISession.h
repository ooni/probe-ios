#import <Foundation/Foundation.h>
#import "OONIContext.h"
#import "OONIGeolocateResults.h"
#import "OONISubmitResults.h"
#import "OONICheckInResults.h"
#import "OONICheckInConfig.h"

/**
 * OONISession contains shared state for running experiments and/or other
 * related task (e.g. geolocation). Note that a OONISession is not meant to
 * be a long running instance. The expected usage is that you create a new
 * session, use it immediately, and then forget about it.
 */
@protocol OONISession
/** geolocate returns the probe geolocation. */
- (OONIGeolocateResults*) geolocate:(OONIContext*) ctx error:(NSError **)error;

/** newContext creates a new OONIContext instance. */
- (OONIContext*) newContext;

/**
 * newContextWithTimeout creates a new OONIContext instance that times
 * out after the specified number of seconds. A zero or negative timeout
 * is equivalent to create a OONIContext without a timeout.
 */
- (OONIContext*) newContextWithTimeout:(long)timeout;

/** submit submits a measurement and returns the submission results. */
- (OONISubmitResults*) submit:(OONIContext*) ctx measurement:(NSString*) measurement error:(NSError **)error;

/** checkIn function is called by probes asking if there are tests to be run
 * The config argument contains the mandatory settings.
 * Returns the list of tests to run and the URLs, on success, or an explanatory error, in case of failure.
 */
- (OONICheckInResults*) checkIn:(OONIContext*) ctx config:(OONICheckInConfig*) config error:(NSError **)error;

@end
