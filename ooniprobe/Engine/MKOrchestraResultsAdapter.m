#import "MKOrchestraResultsAdapter.h"

@implementation MKOrchestraResultsAdapter

- (id)initWithResults:(MKOrchestraResults*)results {
    self = [super init];
    if (self) {
        self.results = results;
    }
    return self;
}

- (BOOL) isGood {
    return [self.results good];
}

- (NSString*) logs {
    return [self.results logs];
}

@end
