// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>
#import "NetworkMeasurement.h"

@interface TestStorage : NSObject

+ (NSArray*)get_tests;

+ (void)add_test:(NetworkMeasurement*)test;

+ (NSArray*)remove_test:(NSNumber*)test_id;

+ (NSArray*)remove_test_atindex:(long)index;

+ (NetworkMeasurement*)get_test_atindex:(long)index;

+ (void)set_completed:(NSNumber*)test_id;

+ (void)remove_all_tests;

@end
