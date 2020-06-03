#import <Foundation/Foundation.h>
#import <mkall/MKOrchestra.h>
#import "OrchestraTask.h"
#import "OrchestraResults.h"
#import "MKOrchestraResultsAdapter.h"

@interface MKOrchestraTaskAdapter : NSObject <OrchestraTask>

@property (nonatomic, strong) MKOrchestraTask* task;

@end
