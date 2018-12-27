#import <Foundation/Foundation.h>
#import "AbstractSuite.h"

@interface WebsitesSuite : AbstractSuite
-(id)initWithUrls:(NSArray*)urls andResult:(Result*)result;
-(void)runTestSuite;
-(void)setMaxRuntime;

@end
