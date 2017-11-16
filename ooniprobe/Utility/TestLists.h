#import <Foundation/Foundation.h>

@interface TestLists : NSObject

@property (strong, nonatomic) NSString *probe_cc;
@property (strong, nonatomic) NSString *probe_asn;

+ (id)sharedTestLists;
- (NSArray*)getUrls;
- (void)updateCC_async;
@end
