#import "OONILogger.h"

@interface PELoggerAdapter : NSObject <OonimkallLogger>

@property (nonatomic, strong) id<OONILogger> logger;

- (id)initWithLogger:(id<OONILogger>)logger;

@end
