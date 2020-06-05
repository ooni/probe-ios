#import <Foundation/Foundation.h>
#import <mkall/MKReporter.h>
#import "CollectorResults.h"

@interface MKReporterResultsAdapter : NSObject <CollectorResults>

- (id)initWithResults:(MKReporterResults*)results;

@property (nonatomic, strong) MKReporterResults* results;

@end

