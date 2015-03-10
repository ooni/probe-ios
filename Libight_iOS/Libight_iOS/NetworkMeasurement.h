//
//  NetworkMeasurement.h
//  libight_ios
//
//  Created by x on 3/5/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkMeasurement : NSObject

@property NSString *name;
@property NSString *status;
@property (readonly) void *(*run)();

@end


@interface HTTPInvalidRequestLine : NetworkMeasurement
@end

@interface DNSInjection : NetworkMeasurement
@end

@interface TCPConnect : NetworkMeasurement
@end
