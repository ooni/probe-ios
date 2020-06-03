#import <Foundation/Foundation.h>
#import <mkall/MKOrchestra.h>
#import "OrchestraTask.h"
#import "OrchestraResults.h"
#import "MKOrchestraResultsAdapter.h"

@interface MKOrchestraTaskAdapter : NSObject <OrchestraTask>

- (id)initWithSoftwareName:softwareName softwareVersion:softwareVersion supportedTests:supportedTests deviceToken:deviceToken secretsFile:secretsFile;

@property (nonatomic, strong) MKOrchestraTask* task;

@end
