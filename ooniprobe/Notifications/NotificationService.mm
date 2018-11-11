#import "NotificationService.h"
#include <measurement_kit/common.hpp>
#import "VersionUtility.h"
#import "TestUtility.h"
#import "MKOrchestra.h"

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
        NSBundle *bundle = [NSBundle mainBundle];
        platform = @"ios";
        software_name = @"ooniprobe-ios";
        software_version = [VersionUtility get_software_version];
        supported_tests = [TestUtility getTestsArray];
        network_type = [[ReachabilityManager sharedManager] getStatus];
        language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    }
    return self;
}


- (void)updateClient{
    @synchronized(self)
    {
        // thread-safe code
        if (device_token == nil) return;
        MKOrchestraClient *client = [[MKOrchestraClient alloc] init];
        //TODO-2.2 when orchestrate
        //[client setAvailableBandwidth:@"10110111"];
        [client setDeviceToken:device_token];
        [client setLanguage:language];
        [client setNetworkType:network_type];
        [client setPlatform:@"iOS"];
        //TODO2.1
        //[client setProbeTimezone:[NSTimeZone localTimeZone].abbreviation];
        [client setRegistryURL:NOTIFICATION_SERVER];
        [client setSecretsFile:[self make_path]];
        [client setSoftwareName:software_name];
        [client setSoftwareVersion:software_version];
        for (NSString *s in supported_tests) {
            [client addSupportedTest:s];
        }
        [client setTimeout:14];
    }
}

-(NSString*)make_path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory,
                          @"orchestrator_secret.json"];
    return fileName;
}

+ (void)registerUserNotification{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

@end
