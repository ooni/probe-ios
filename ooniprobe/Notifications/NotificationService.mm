#import "NotificationService.h"
#import "VersionUtility.h"
#import "TestUtility.h"
#import "Engine.h"
#import "SettingsUtility.h"

@implementation NotificationService

+ (void)updateClient{
    @synchronized(self)
    {
        // thread-safe code
        NSString *device_token = [SettingsUtility get_push_token];        
        id<OrchestraTask> task = [Engine orchestraTaskWithSoftwareName:SOFTWARE_NAME
                                    softwareVersion:[VersionUtility get_software_version]
                                    supportedTests:[TestUtility getTestsArray]
                                    deviceToken:device_token
                                    secretsFile:[self make_path]
                                 ];
        //TODO ORCHESTRA when orchestrate
        //[client setAvailableBandwidth:@"10110111"];
        [task setLanguage:[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]];
        [task setNetworkType:[[ReachabilityManager sharedManager] getStatus]];
        [task setPlatform:@"ios"];
        //TODO ORCHESTRA - TIMEZONE
        //[client setProbeTimezone:[NSTimeZone localTimeZone].abbreviation];
        [task setRegistryURL:NOTIFICATION_SERVER];
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
