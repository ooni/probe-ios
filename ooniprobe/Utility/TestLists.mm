#import "TestLists.h"
#import "NTYCSVTable.h"
#include <measurement_kit/ooni.hpp>

@implementation TestLists

+ (NSArray*)getUrls{
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    NSArray *global_urls = [self getUrlsForCountry:@"global"];
    [urls addObjectsFromArray:global_urls];
    NSArray *local_urls = [self getUrlsForCountry:@"ru"];
    if (local_urls != nil)
        [urls addObjectsFromArray:local_urls];
    //NSLog(@"url %@", urls);
    return urls;
}

+ (NSArray*)getUrlsForCountry:(NSString*)country_code {
    if ([[NSBundle mainBundle] pathForResource:country_code ofType:@"csv"] != nil){
        NSURL *csvURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:country_code ofType:@"csv"]]];
        NTYCSVTable *table = [[NTYCSVTable alloc] initWithContentsOfURL:csvURL];
        NSArray *url = table.columns[@"url"];
        return url;
    }
    return nil;
}


@end
