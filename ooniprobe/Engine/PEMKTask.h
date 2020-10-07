#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>
#import "OONIMKTask.h"

@interface PEMKTask : NSObject <OONIMKTask>

- (id)initWithTask:(OonimkallTask*)task;

@property (nonatomic, strong) OonimkallTask* task;

@end
