#import <Foundation/Foundation.h>
#import "AbstractSuite.h"

@interface WebsitesSuite : AbstractSuite
-(void)setDefaultMaxRuntime;
-(void)setUrls:(NSArray*)inputs;
@end
