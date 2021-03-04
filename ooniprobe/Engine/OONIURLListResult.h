#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>
#import "OONIURLInfo.h"

/** URLListResult contains the URLs returned from the FetchURL API. */
@interface OONIURLListResult : NSObject

@property (nonatomic, strong) NSMutableArray *urls;

- (id) initWithResults:(OonimkallURLListResult*)r;

@end
