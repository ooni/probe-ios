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

-(id)initWithUrl:(NSString*)url{
    return [self initWithUrl:url category:@"MISC" country:@"XX"];
}

+ (Url*)getUrl:(NSString*)url{
    SRKQuery *query = [[Url query] where:@"url = ?" parameters:@[url]];
    if ([query count] > 0){
        SRKResultSet *urls = [query fetch];
        return [urls objectAtIndex:0];
    }
    return nil;
}

+ (Url*)checkExistingUrl:(NSString*)input{
    return [self checkExistingUrl:input categoryCode:@"MISC" countryCode:@"XX"];
}

+ (Url*)checkExistingUrl:(NSString*)input categoryCode:(NSString*)categoryCode countryCode:(NSString*)countryCode{
    Url *url = [self getUrl:input];
    if (url == nil){
        url = [[Url alloc] initWithUrl:input category:categoryCode country:countryCode];
        [url commit];
    }
    else if (
             (![url.category_code isEqualToString:categoryCode] && ![categoryCode isEqualToString:@"MISC"]) ||
             (![url.country_code isEqualToString:countryCode] && ![countryCode isEqualToString:@"XX"])){
        url.category_code = categoryCode;
        url.country_code = countryCode;
        [url commit];
    }
    return url;
}


@end
