#import "AbstractTest.h"

@interface WebConnectivity : AbstractTest
@property NSArray *inputs;
-(void)setUrls:(NSArray*)inputs;
-(void)disableMaxRuntime;
@end
