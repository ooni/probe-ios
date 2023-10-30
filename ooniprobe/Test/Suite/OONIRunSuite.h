#import "AbstractSuite.h"
#import "TestDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface OONIRunSuite : AbstractSuite

@property(nonatomic, strong) TestDescriptor *descriptor;

- (id)initWithDescriptor:(TestDescriptor *)descriptor;

-(void)newResult;

@end

NS_ASSUME_NONNULL_END
