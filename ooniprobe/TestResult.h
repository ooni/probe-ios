//
//  TestResult.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 29/01/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestResult : NSObject

@property (strong, nonatomic) NSString *input;
@property (assign, nonatomic) int anomaly;

@end
