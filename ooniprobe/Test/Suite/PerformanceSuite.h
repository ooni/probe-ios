#import <Foundation/Foundation.h>
#import "AbstractSuite.h"

@interface PerformanceSuite : AbstractSuite
-(id)initWithTest:(NSString*)test_name andResult:(Result*)result;
-(void)runTestSuite;

@end
