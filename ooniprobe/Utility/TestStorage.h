#import <Foundation/Foundation.h>
#import "NetworkMeasurement.h"
#import "Tests.h"

@interface TestStorage : NSObject

+ (NSArray*)get_tests;

+ (NSArray*)get_tests_rev;

+ (void)add_test:(NetworkMeasurement*)test;

+ (NSArray*)remove_test:(NSNumber*)test_id;

+ (NSArray*)remove_test_atindex:(long)index;

+ (NetworkMeasurement*)get_test_atindex:(long)index;

+ (void)set_completed:(NSNumber*)test_id;

+ (void)set_entry:(NSNumber*)test_id;

+ (void)set_anomaly:(NSNumber*)test_id :(int)anomaly;

+ (void)set_viewed:(NSNumber*)test_id;

+ (void)set_all_viewed;

+ (BOOL)new_tests;

+ (void)remove_all_tests;

@end
