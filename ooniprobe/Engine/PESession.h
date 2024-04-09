#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>
#import "OONISession.h"
#import "OONISessionConfig.h"
#import "DescriptorResponse.h"

@interface PESession : NSObject <OONISession>

- (id)initWithConfig:(OONISessionConfig *)config error:(NSError **)error;

- (OONIContext*) newContext;

- (OONIRunDescriptor*) ooniRunFetch:(OONIContext*) ctx id:(long) id error:(NSError **)error;

@property (nonatomic, strong) OonimkallSession* session;

@end
