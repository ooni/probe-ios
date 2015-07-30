// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>

/*Include header from test*/
#include "ight/ooni/dns_injection.hpp"
#include "ight/ooni/http_invalid_request_line.hpp"
#include "ight/ooni/tcp_connect.hpp"

#include "ight/common/poller.hpp"
#include "ight/common/log.hpp"
#include "ight/common/utils.hpp"

#include "NetworkManager.h"

@interface NetworkMeasurement : NSObject

@property NSString *name;
@property NSNumber *test_id;
@property NSString *status;
@property BOOL finished;
@property NSMutableArray *logLines;
@property ight::common::settings::Settings options;
@property NetworkManager *manager;

-(void) run;
@end


@interface HTTPInvalidRequestLine : NetworkMeasurement
@end

@interface DNSInjection : NetworkMeasurement
@end

@interface TCPConnect : NetworkMeasurement
@end
