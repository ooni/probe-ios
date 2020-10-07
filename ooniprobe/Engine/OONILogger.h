#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

/** OONILogger is the logger used by a OONISession. */
@protocol OONILogger

/** debug emits a debug message */
- (void) debug:(NSString*) message;

/** info emits an informational message */
- (void) info:(NSString*) message;

/** warn emits a warning message */
- (void) warn:(NSString*) message;

@end
