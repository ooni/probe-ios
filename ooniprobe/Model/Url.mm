#import "Url.h"

@implementation Url

-(id) initWithUrl:(NSString*)url category:(NSString*)categoryCode{
    self = [super init];
    if (self) {
        self.url = url;
        self.categoryCode = categoryCode;
    }
    return self;
}

@end
