#import "NotificationService.h"
#import "VersionUtility.h"
#import "TestUtility.h"
#import <mkall/MKOrchestra.h>
#import "SettingsUtility.h"

@implementation NotificationService

+ (void)updateClient{
    @synchronized(self)
    {
        // thread-safe code
        NSString *device_token = [SettingsUtility get_push_token];
        MKOrchestraClient *client = [[MKOrchestraClient alloc] init];
        //TODO ORCHESTRA when orchestrate
        //[client setAvailableBandwidth:@"10110111"];
        [client setDeviceToken:device_token];
        [client setLanguage:[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]];
        [client setNetworkType:[[ReachabilityManager sharedManager] getStatus]];
        [client setPlatform:@"ios"];
        //TODO ORCHESTRA - TIMEZONE
        //[client setProbeTimezone:[NSTimeZone localTimeZone].abbreviation];
        [client setRegistryURL:NOTIFICATION_SERVER];
        [client setSecretsFile:[self make_path]];
        [client setSoftwareName:@"ooniprobe-ios"];
        [client setSoftwareVersion:[VersionUtility get_software_version]];
        for (NSString *s in [TestUtility getTestsArray]) {
            [client addSupportedTest:s];
        }
        [client setTimeout:14];
    }
}

+ (NSString*)make_path {
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
