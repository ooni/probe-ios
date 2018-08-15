#import "Url.h"

@implementation Url

-(id) initWithUrl:(NSString*)url category:(NSString*)categoryCode{
    self = [super init];
    if (self) {
        self.url = url;
        self.category_code = categoryCode;
        self.country_code = @"";
    }
    return self;
}

-(id) initWithUrl:(NSString*)url category:(NSString*)categoryCode country:(NSString*)countryCode{
    self = [super init];
    if (self) {
        self.url = url;
        self.category_code = categoryCode;
        self.country_code = countryCode;
    }
    return self;
}

@end
