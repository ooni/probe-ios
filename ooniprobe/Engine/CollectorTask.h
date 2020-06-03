#import <Foundation/Foundation.h>
#import "CollectorResults.h"

/** CollectorTask is a task that interacts with the OONI collector */
@protocol CollectorTask

/** maybeDiscoverAndSubmit submits a measurement and returns the
 * results. This method will automatically discover a collector, if
 * none is specified. */
- (id<CollectorResults>) maybeDiscoverAndSubmit:(NSString*)measurement
                                 withTimeout:(long)timeout;

@end
