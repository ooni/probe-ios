//
//  NetworkMeasurement.h
//  libight_ios
//
//  Created by x on 3/5/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

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
@property NSMutableArray *logLines;
@property ight::common::settings::Settings options;
@property NetworkManager *manager;

-(void) run;
-(void) loop;
-(void) break_loop;

-(void) setupLogger;

@end


@interface HTTPInvalidRequestLine : NetworkMeasurement
@end

@interface DNSInjection : NetworkMeasurement
@end

@interface TCPConnect : NetworkMeasurement
@end
