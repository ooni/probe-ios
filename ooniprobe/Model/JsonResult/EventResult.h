#import <Foundation/Foundation.h>
#import "Value.h"

@interface EventResult : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) Value *value;

@end
