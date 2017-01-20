//
//  Tests.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 19/01/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkMeasurement.h"

@interface Tests : NSObject
@property (strong, nonatomic) NSMutableArray *availableNetworkMeasurements;
+ (id)currentTests;
- (void) loadAvailableMeasurements;
- (NetworkMeasurement*)getTestWithName:(NSString*)testName;
@end
