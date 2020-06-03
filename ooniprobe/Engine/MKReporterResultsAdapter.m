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
    return self.results.good;
}

- (NSString*)getReason {
    return self.results.reason;
}

- (NSString*)getLogs {
    return self.results.logs;
}

- (NSString*)getUpdatedSerializedMeasurement {
    return self.results.updatedSerializedMeasurement;
}

- (NSString*)getUpdatedReportID {
    return self.results.updatedReportID;
}

@end
