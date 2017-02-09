// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>
#import "NetworkMeasurement.h"

@interface Tests : NSObject
@property (strong, nonatomic) NSMutableArray *availableNetworkMeasurements;
+ (id)currentTests;
- (void) loadAvailableMeasurements;
- (NetworkMeasurement*)getTestWithName:(NSString*)testName;
+ (int)checkAnomaly:(NSDictionary*)test_keys;
+ (NSArray*)getItems:(NSString*)json_file;
@end
