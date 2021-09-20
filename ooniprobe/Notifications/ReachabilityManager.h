#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;
+ (ReachabilityManager *)sharedManager;
- (NSString*)getStatus;
- (BOOL)noInternetAccess;
- (BOOL)isWifi;
- (BOOL)isVPNConnected;
@end
