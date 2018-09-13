#import "Url.h"

@implementation Url
@dynamic url, category_code, country_code;

-(id)initWithUrl:(NSString*)url category:(NSString*)categoryCode country:(NSString*)countryCode{
    self = [super init];
    if (self) {
        self.url = url;
        self.category_code = categoryCode;
        self.country_code = countryCode;
    }
    return self;
}

-(void)updateCategory:(NSString*)category cc:(NSString*)countryCode{
    [self setCountry_code:countryCode];
    [self setCategory_code:category];
    [self commit];
}

+ (Url*)getUrl:(NSString*)url{
    SRKQuery *query = [[Url query] where:@"url = ?" parameters:@[url]];
    if ([query count] > 0){
        SRKResultSet *urls = [query fetch];
        return [urls objectAtIndex:0];
    }
    //TODO should never happen
    return nil;
}
@end
