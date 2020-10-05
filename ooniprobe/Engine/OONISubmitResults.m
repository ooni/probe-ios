#import "OONISubmitResults.h"

@implementation OONISubmitResults

- (id) initWithResults:(OonimkallSubmitMeasurementResults*)r {
    self = [super init];
    if (self) {
        self.updatedMeasurement = r.updatedMeasurement;
        self.updatedReportID = r.updatedReportID;
    }
    return self;
}

@end
