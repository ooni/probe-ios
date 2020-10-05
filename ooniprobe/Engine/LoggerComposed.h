#import "OONILogger.h"

/** LoggerComposed allows to compose two loggers */
@interface LoggerComposed : NSObject <OONILogger>

@property (nonatomic, strong) id<OONILogger> left;
@property (nonatomic, strong) id<OONILogger> right;

- (id) initWithLeft:(id<OONILogger>)left right:(id<OONILogger>)right;

@end
