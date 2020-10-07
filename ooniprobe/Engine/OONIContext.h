#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

/** OONIContext is the context for long running tasks. */
@interface OONIContext : NSObject

@property (nonatomic, strong) OonimkallContext* ctx;

- (id) initWithContext:(OonimkallContext*)ctx;
- (void) cancel;

@end
