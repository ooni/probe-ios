// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>

/*Include header from test*/
#include <measurement_kit/ooni.hpp>

#include <measurement_kit/common.hpp>

@interface NetworkMeasurement : NSObject

@property NSString *name;
@property NSNumber *test_id;
@property NSString *status;
@property BOOL finished;
@property NSMutableArray *logLines;
@property mk::Settings options;

-(void) run;
@end


@interface HTTPInvalidRequestLine : NetworkMeasurement
@end

@interface DNSInjection : NetworkMeasurement
@end

@interface TCPConnect : NetworkMeasurement
@end
