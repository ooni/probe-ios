// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>

@interface TestResult : NSObject

@property (strong, nonatomic) NSString *input;
@property (assign, nonatomic) int anomaly;

@end
