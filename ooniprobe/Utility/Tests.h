#import <Foundation/Foundation.h>
#import "NetworkMeasurement.h"
//deprecated

@interface Tests : NSObject
@property (strong, nonatomic) NSMutableArray *availableNetworkMeasurements;
+ (id)currentTests;
- (void)loadAvailableMeasurements;
- (NetworkMeasurement*)getTestWithName:(NSString*)testName;
+ (int)checkAnomaly:(NSDictionary*)test_keys;
+ (NSArray*)getItems:(NSString*)json_file;
@end
