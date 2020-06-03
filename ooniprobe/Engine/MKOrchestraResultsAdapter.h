#import <Foundation/Foundation.h>
#import <mkall/MKOrchestra.h>
#import "OrchestraResults.h"

@interface MKOrchestraResultsAdapter : NSObject <OrchestraResults>

- (id)initWithResults:(MKOrchestraResults*)results;

@property (nonatomic, strong) MKOrchestraResults* results;

@end
