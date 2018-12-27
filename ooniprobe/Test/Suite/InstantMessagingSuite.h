#import <Foundation/Foundation.h>
#import "AbstractSuite.h"

@interface InstantMessagingSuite : AbstractSuite
-(id)initWithTest:(NSString*)test_name andResult:(Result*)result;
-(void)runTestSuite;

@end
