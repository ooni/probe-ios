#import <Foundation/Foundation.h>

/** CollectorResults contains the results of speaking with the OONI collector. */
@protocol CollectorResults

/** isGood returns whether we succeded. */
- (BOOL)isGood;

/** reason returns the reason for failure. */
- (NSString*)reason;

/** logs returns the logs as one-or-more newline-separated
 * lines containing only UTF-8 characters. */
- (NSString*)logs;

/** updatedSerializedMeasurement returns the serialized measurement
 * where all the fields that should have been updated, e.g., the
 * report ID, have already been updated with the new values provided
 * by the OONI collector as part of resubmitting. */
- (NSString*)updatedSerializedMeasurement;

/** updatedReportID returns the updated report ID. */
- (NSString*)updatedReportID;

@end
