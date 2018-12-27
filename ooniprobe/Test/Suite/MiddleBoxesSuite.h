#import <Foundation/Foundation.h>
#import "AbstractSuite.h"

@interface MiddleBoxesSuite : AbstractSuite
-(id)initWithTest:(NSString*)test_name andResult:(Result*)result;
-(void)runTestSuite;

@end
