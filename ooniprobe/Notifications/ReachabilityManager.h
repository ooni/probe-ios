#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "NotificationService.h"

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;
+ (ReachabilityManager *)sharedManager;
- (NSString*)getStatus;
- (BOOL)noInternetAccess;
@end
