#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

/**
 * OONISubmitResults contains the results of a single measurement submission
 * to the OONI backends using the OONI collector API.
 */
@interface OONISubmitResults : NSObject

/** updatedMeasurement is a copy of the original measurement
 * in which the report ID has been updated. */
@property (nonatomic, strong) NSString* updatedMeasurement;

/** updatedReportID returns the updated report ID. */
@property (nonatomic, strong) NSString* updatedReportID;

- (id) initWithResults:(OonimkallSubmitMeasurementResults*)r;
@end
