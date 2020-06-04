#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>
#import "ExperimentTask.h"

@interface OONIProbeEngineTaskAdapter : NSObject <ExperimentTask>

- (id)initWithTask:(OonimkallTask*)task;

@property (nonatomic, strong) OonimkallTask* task;

@end
