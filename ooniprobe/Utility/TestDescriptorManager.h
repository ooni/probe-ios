#import <Foundation/Foundation.h>
#import "DescriptorResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestDescriptorManager : NSObject

+ (void)fetchDescriptorFromRunId:(long)runId onSuccess:(void (^)(OONIRunDescriptor *))successcb onError:(void (^)(NSError *))errorcb;

+ (NSArray*)getTestObjects;

@end

NS_ASSUME_NONNULL_END
