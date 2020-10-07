#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>
#import "OONISession.h"
#import "OONISessionConfig.h"

@interface PESession : NSObject <OONISession>

- (id)initWithConfig:(OONISessionConfig *)config error:(NSError **)error;

@property (nonatomic, strong) OonimkallSession* session;

@end
