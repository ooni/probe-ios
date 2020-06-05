#import "MKReporterResultsAdapter.h"

@implementation MKReporterResultsAdapter

- (id)initWithResults:(MKReporterResults*)results {
    self = [super init];
    if (self) {
        self.results = results;
    }
    return self;
}

- (BOOL)isGood {
    return [self.results good];
}

- (NSString*)reason {
    return [self.results reason];
}

- (NSString*)logs {
    return [self.results logs];
}

- (NSString*)updatedSerializedMeasurement {
    return [self.results updatedSerializedMeasurement];
}

- (NSString*)updatedReportID {
    return [self.results updatedReportID];
}

@end
