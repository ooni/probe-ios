#import <Foundation/Foundation.h>
#import <mkall/MKReporter.h>
#import "CollectorTask.h"
#import "MKReporterResultsAdapter.h"

@interface MKReporterTaskAdapter : NSObject <CollectorTask>

- (id)initWithSoftwareName:(NSString*)softwareName softwareVersion:(NSString*)softwareVersion;

@property (nonatomic, strong) MKReporterTask* task;

@end
