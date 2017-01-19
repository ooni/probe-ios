//
//  Tests.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 19/01/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import "Tests.h"

@implementation Tests

+ (id)currentTests
{
    static Tests *currentTests = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentTests = [[self alloc] init];
    });
    return currentTests;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.availableNetworkMeasurements = [[NSMutableArray alloc] init];
        [self loadAvailableMeasurements];
    }
    return self;
}

- (void) loadAvailableMeasurements {
    [self.availableNetworkMeasurements removeAllObjects];
    
    WebConnectivity *web_connectivityMeasurement = [[WebConnectivity alloc] init];
    [self.availableNetworkMeasurements addObject:web_connectivityMeasurement];
    
    HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
    [self.availableNetworkMeasurements addObject:http_invalid_request_lineMeasurement];
    
    NdtTest *ndt_testMeasurement = [[NdtTest alloc] init];
    [self.availableNetworkMeasurements addObject:ndt_testMeasurement];
}
@end
