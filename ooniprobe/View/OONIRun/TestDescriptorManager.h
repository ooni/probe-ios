//
//  TestDescriptorManager.h
//  ooniprobe
//
//  Created by Norbel Ambanumben on 19/09/2023.
//  Copyright © 2023 OONI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestDescriptorManager : NSObject
+ (void)fetchDescriptorFromRunId:(long)runId onSuccess:(void (^)(TestDescriptor *))successcb onError:(void (^)(NSError *))errorcb;
+ (NSArray*)getTestObjects;

@end

NS_ASSUME_NONNULL_END
