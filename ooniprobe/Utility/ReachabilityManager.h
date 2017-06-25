// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "NotificationService.h"

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;
+ (ReachabilityManager *)sharedManager;
- (NSString*)getStatus;
@end
