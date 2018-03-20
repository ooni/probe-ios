#import "Url.h"

@implementation Url

-(id) initWithUrl:(NSString*)url category:(NSString*)category_code{
    self = [super init];
    if (self) {
        self.url = url;
        self.category_code = category_code;
    }
    return self;
}

@end
