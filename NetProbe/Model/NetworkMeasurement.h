// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*Include header from test*/
#include <measurement_kit/ooni.hpp>

#include <measurement_kit/common.hpp>

@interface NetworkMeasurement : NSObject

@property NSString *name;

@property NSNumber *test_id;
//Not used
@property NSString *status;

@property NSString *json_file;
@property NSString *log_file;
@property BOOL completed;
@property mk::Settings options;

-(void) run;
@end


@interface HTTPInvalidRequestLine : NetworkMeasurement
@end

@interface DNSInjection : NetworkMeasurement
@end

@interface TCPConnect : NetworkMeasurement
@end
