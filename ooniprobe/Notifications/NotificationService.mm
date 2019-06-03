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
        MKOrchestraTask *task = [[MKOrchestraTask alloc] init];
        //TODO ORCHESTRA when orchestrate
        //[client setAvailableBandwidth:@"10110111"];
        [task setDeviceToken:device_token];
        [task setLanguage:[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]];
        [task setNetworkType:[[ReachabilityManager sharedManager] getStatus]];
        [task setPlatform:@"ios"];
        //TODO ORCHESTRA - TIMEZONE
        //[client setProbeTimezone:[NSTimeZone localTimeZone].abbreviation];
        [task setRegistryURL:NOTIFICATION_SERVER];
        [task setSecretsFile:[self make_path]];
        [task setSoftwareName:SOFTWARE_NAME];
        [task setSoftwareVersion:[VersionUtility get_software_version]];
        for (NSString *s in [TestUtility getTestsArray]) {
            [task addSupportedTest:s];
        }
        [task setTimeout:DEFAULT_TIMEOUT];
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
