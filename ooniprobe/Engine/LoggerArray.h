#import "OONILogger.h"

/** LoggerArray is a logger that writes logs into an array. */
@interface LoggerArray : NSObject <OONILogger>

@property (nonatomic, strong) NSMutableArray* array;

@end
