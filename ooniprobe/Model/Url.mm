#import "Url.h"

@implementation Url
@dynamic url, category_code, country_code;

- (Url*)createOrReturn{
    //query table for url with url.
    //if exists return
    //else create
    SRKQuery *query = [[Url query] where:@"url = ? AND category_code = ? AND country_code = ?" parameters:@[self.url, self.category_code, self.country_code]];
    if ([query count] > 0){
        //[self dealloc];
        //TODO scenario if exists and category or country is different, update
        SRKResultSet *urls = [query fetch];
        return [urls objectAtIndex:0];
    }
    else {
        /*
         Network *network = [Network new];
         network.network_name = current.network_name;
         network.ip = current.ip;
         network.asn = current.asn;
         network.country_code = current.country_code;
         network.network_type = current.network_type;
         */
        [self commit];
        return self;
    }

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
