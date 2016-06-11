//
//  TestStorage.h
//  NetProbe
//
//  Created by Lorenzo Primiterra on 11/06/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkMeasurement.h"

@interface TestStorage : NSObject

+ (NSArray*)get_tests;

+ (void)add_test:(NetworkMeasurement*)test;

+ (NSArray*)remove_test:(int)index;

+ (void)remove_all_tests;

@end
