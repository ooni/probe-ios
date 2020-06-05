#import <Foundation/Foundation.h>
#import <mkall/MKAsyncTask.h>
#import "ExperimentTask.h"

@interface MKExperimentTaskAdapter : NSObject <ExperimentTask>

- (id)initWithTask:(MKAsyncTask*)task;

@property (nonatomic, strong) MKAsyncTask* task;

@end
