#import <Foundation/Foundation.h>
#import <mkall/MKReporter.h>
#import "CollectorTask.h"
#import "MKReporterResultsAdapter.h"

@interface MKReporterTaskAdapter : NSObject <CollectorTask>

@property (nonatomic, strong) MKReporterTask* task;

@end
