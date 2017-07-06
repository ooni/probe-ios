// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "NotificationService.h"
#include <measurement_kit/ooni.hpp>

@implementation NotificationService
@synthesize geoip_asn_path, geoip_country_path, platform, software_name, software_version, supported_tests, network_type, available_bandwidth, device_token, language;

+ (id)sharedNotificationService
{
    static NotificationService *sharedNotificationService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNotificationService = [[self alloc] init];
    });
    return sharedNotificationService;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        /*
         "probe_cc": "IT",
         "probe_asn": "AS0",
         "platform": "android",
         "software_name": "ooniprobe-android",
         "software_version": "0.1.1",
         "supported_tests": ["tcp_connect", "web_connectivity"],
         "network_type": "wifi",
         "available_bandwidth": "100",
         "token": "TOKEN_ID"
         */
        NSBundle *bundle = [NSBundle mainBundle];
        geoip_asn_path = [bundle pathForResource:@"GeoIPASNum" ofType:@"dat"];
        geoip_country_path = [bundle pathForResource:@"GeoIP" ofType:@"dat"];
        platform = @"ios";
        software_name = @"ooniprobe-ios";
        software_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSMutableArray *supported_tests_ar = [[NSMutableArray alloc] init];
        Tests *currentTests = [Tests currentTests];
        for (NetworkMeasurement *nm in currentTests.availableNetworkMeasurements){
            [supported_tests_ar addObject:nm.name];
        }
        supported_tests = supported_tests_ar;
        network_type = [[ReachabilityManager sharedManager] getStatus];
        language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    }
    
    return self;
}


- (void)registerNotifications{
    //device_token = current_token;
    NSLog(@"token %@",device_token);
    NSLog(@"platform %@", platform);
    NSLog(@"software_name %@", software_name);
    NSLog(@"software_version %@", software_version);
    NSLog(@"supported_tests %@", supported_tests);
    NSLog(@"network_type %@", network_type);
    NSLog(@"language %@",language);

    std::vector<std::string> supported_tests_list;
    for (NSString *s in supported_tests) {
        supported_tests_list.push_back([s UTF8String]);
    }

    mk::ooni::orchestrate::Client client;
    client.logger->set_verbosity(MK_LOG_DEBUG2); // FIXME not for production
    client.geoip_country_path = [geoip_country_path UTF8String];
    client.geoip_asn_path = [geoip_asn_path UTF8String];
    client.platform = [platform UTF8String];
    client.software_name = [software_name UTF8String];
    client.software_version = [software_version UTF8String];
    client.supported_tests = supported_tests_list;
    client.network_type = [network_type UTF8String];
    client.language = [language UTF8String];
    
    // FIXME: this string is `nil` hence the crash when calling UTF8String
    //client.available_bandwidth = [available_bandwidth UTF8String];
    client.device_token = [device_token UTF8String];
    client.registry_url = mk::ooni::orchestrate::testing_registry_url();
    std::string secrets_path = [[self make_path] UTF8String];

    client.find_location([client, secrets_path = std::move(secrets_path)]
                         (mk::Error &&error, std::string probe_asn,
                          std::string probe_cc) mutable {
        if (error) {
            mk::warn("cannot find location");
            return;
        }
        client.probe_asn = probe_asn;
        client.probe_cc = probe_cc;
        mk::ooni::orchestrate::Auth auth;
        // Assumption: if we can load the secrets path then we have
        // already registered the probe, otherwise we need to register
        // the probe and we don't need to call update afterwards.
        if (auth.load(secrets_path) != mk::NoError()) {
            client.register_probe(
                  mk::ooni::orchestrate::Auth::make_password(),
                    [client, secrets_path = std::move(secrets_path)]
                      (mk::Error &&error, mk::ooni::orchestrate::Auth &&auth) {
                if (error) {
                    client.logger->warn("Register terminated with error: %s",
                                        error.as_ooni_error().c_str());
                    return;
                }
                if (auth.dump(secrets_path) != mk::NoError()) {
                    client.logger->warn("Cannot write secrets_path: %s",
                                        error.as_ooni_error().c_str());
                    return;
                }
            });
            return;
        }
        client.update(std::move(auth), [client,
                                        secrets_path = std::move(secrets_path)]
                    (mk::Error &&error, mk::ooni::orchestrate::Auth &&auth) {
            if (error) {
                client.logger->warn("Update terminated with error: %s",
                                    error.as_ooni_error().c_str());
                return;
            }
            if (auth.dump(secrets_path) != mk::NoError()) {
                client.logger->warn("Cannot write secrets_path: %s",
                                    error.as_ooni_error().c_str());
                return;
            }
      });
    });
}

-(NSString*)make_path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory,
                          @"orchestrator_secret.json"];
    return fileName;
}

@end
