#import "TestLists.h"
#import "NTYCSVTable.h"
#include <measurement_kit/ooni.hpp>
#include <measurement_kit/ooni/orchestrate.hpp>

@implementation TestLists

+ (id)sharedTestLists
{
    static TestLists *sharedTestLists = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTestLists = [[self alloc] init];
    });
    return sharedTestLists;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self getCC];
    }
    return self;
}

- (NSArray*)getUrls{
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    NSArray *global_urls = [self getUrlsForCountry:@"global"];
    [urls addObjectsFromArray:global_urls];
    NSArray *local_urls = [self getUrlsForCountry:[self.probe_cc lowercaseString]];
    if (local_urls != nil)
        [urls addObjectsFromArray:local_urls];
    //NSLog(@"url %@", urls);
    return urls;
}

- (NSArray*)getUrlsForCountry:(NSString*)country_code {
    if ([[NSBundle mainBundle] pathForResource:country_code ofType:@"csv"] != nil){
        NSURL *csvURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:country_code ofType:@"csv"]]];
        NTYCSVTable *table = [[NTYCSVTable alloc] initWithContentsOfURL:csvURL];
        NSArray *url = table.columns[@"url"];
        return url;
    }
    return nil;
}

- (void)getCC {
    //TODO refactor all mk helper functions into a class
    //This will be done with the next release as this class is going to be deleted
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *geoip_asn_path = [bundle pathForResource:@"GeoIPASNum" ofType:@"dat"];
    NSString *geoip_country_path = [bundle pathForResource:@"GeoIP" ofType:@"dat"];
    mk::ooni::orchestrate::Client client;
    client.logger = mk::Logger::global();
    client.geoip_asn_path = [geoip_asn_path UTF8String];
    client.geoip_country_path = [geoip_country_path UTF8String];
    client.settings = {};
    client.find_location([client, self]
                         (mk::Error &&error, std::string probe_asn,
                          std::string probe_cc) mutable {
                             if (error) {
                                 mk::warn("cannot find location");
                                 return;
                             }
                             self.probe_cc = [NSString stringWithFormat:@"%s", probe_cc.c_str()];
                             self.probe_asn = [NSString stringWithFormat:@"%s", probe_asn.c_str()];
                             client.probe_asn = probe_asn;
                             client.probe_cc = probe_cc;
                             client.logger->warn("probe_asn: %s", client.probe_asn.c_str());
                             client.logger->warn("probe_cc: %s", client.probe_cc.c_str());
                     });
}

@end
