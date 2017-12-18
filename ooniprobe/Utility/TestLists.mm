#import "TestLists.h"
#import "NTYCSVTable.h"
#include <measurement_kit/ooni.hpp>
#include <measurement_kit/ooni/orchestrate.hpp>

@implementation TestLists

+ (id)sharedTestLists {
    static TestLists *sharedTestLists = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTestLists = [[self alloc] init];
    });
    return sharedTestLists;
}

-(id)init {
    self = [super init];
    if(self)
    {
        self.probe_cc = @"";
        self.probe_asn = @"";
    }
    return self;
}

- (NSArray*)getUrls {
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    NSArray *global_urls = [self getUrlsForCountry:@"global"];
    [urls addObjectsFromArray:global_urls];
    return urls;
}

//DEPRECATED
- (NSArray*)getUrlsForCountry:(NSString*)country_code {
    if ([[NSBundle mainBundle] pathForResource:country_code ofType:@"csv"] != nil){
        NSURL *csvURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",
                     [[NSBundle mainBundle] pathForResource:country_code ofType:@"csv"]]];
        NTYCSVTable *table = [[NTYCSVTable alloc] initWithContentsOfURL:csvURL];
        NSArray *url = table.columns[@"url"];
        return url;
    }
    return nil;
}

//DEPRECATED
- (void)updateCC_async {
    //TODO refactor all mk helper functions into a class
    //This will be done with the next release as this class is going to be deleted
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *geoip_asn_path = [bundle pathForResource:@"GeoIPASNum" ofType:@"dat"];
    NSString *geoip_country_path = [bundle pathForResource:@"GeoIP" ofType:@"dat"];
    mk::ooni::find_location([geoip_country_path UTF8String],
                            [geoip_asn_path UTF8String],{},
                            mk::Logger::global(),
                            [self]
                            (mk::Error &&error, std::string probe_asn,
                             std::string probe_cc) mutable {
                                if (error) {
                                    mk::warn("cannot find location: %s", error.what());
                                    return;
                                }
                                self.probe_cc = [NSString stringWithFormat:@"%s", probe_cc.c_str()];
                                self.probe_asn = [NSString stringWithFormat:@"%s", probe_asn.c_str()];
                                mk::info("probe_asn: %s", probe_asn.c_str());
                                mk::info("probe_cc: %s", probe_cc.c_str());
                            });
}

@end
