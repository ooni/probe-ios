#import "OONIURLInfo.h"

@implementation OONIURLInfo

- (id) initWithURLInfo:(OonimkallURLInfo*)urlInfo {
    self = [super init];
    if (self) {
        self.url = urlInfo.url;
        self.category_code = urlInfo.categoryCode;
        self.country_code = urlInfo.countryCode;
    }
    return self;
}

@end
