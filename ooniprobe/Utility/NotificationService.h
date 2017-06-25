// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>
#import "ReachabilityManager.h"
#import "Tests.h"

@interface NotificationService : NSObject
+ (id)sharedNotificationService;
- (void)registerNotifications;

@property (strong, nonatomic) NSString *geoip_country_path;
@property (strong, nonatomic) NSString *geoip_asn_path;
@property (strong, nonatomic) NSString *platform;
@property (strong, nonatomic) NSString *software_name;
@property (strong, nonatomic) NSString *software_version;
@property (strong, nonatomic) NSArray *supported_tests;
@property (strong, nonatomic) NSString *network_type;
@property (strong, nonatomic) NSString *available_bandwidth;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *language;

@end
