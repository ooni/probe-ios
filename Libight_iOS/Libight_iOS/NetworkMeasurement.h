//
//  NetworkMeasurement.h
//  libight_ios
//
//  Created by x on 3/5/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>

/*Include header from test*/
#include "ooni/dns_injection.hpp"
#include "ooni/http_invalid_request_line.hpp"
#include "ooni/tcp_connect.hpp"

#include "common/poller.h"
#include "common/log.hpp"
#include "common/utils.hpp"

@interface NetworkMeasurement : NSObject

@property NSString *name;
@property NSString *status;
@property NSMutableArray *logLines;
@property ight::common::Settings options;

-(void) run;
-(void) setupLogger;

@end


@interface HTTPInvalidRequestLine : NetworkMeasurement
@end

@interface DNSInjection : NetworkMeasurement
@end

@interface TCPConnect : NetworkMeasurement
@end
