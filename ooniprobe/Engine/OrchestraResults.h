#import <Foundation/Foundation.h>

/** OrchestraResults contains the results of speaking with OONI orchestra. */
@protocol OrchestraResults 

/** isGood indicates whether we succeeded. */
- (BOOL) isGood;

/** logs returns the logs as one or more UTF-8 lines of text. */
- (NSString*) logs;

@end
