#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import <UserNotifications/UserNotifications.h>
@import Flutter;

@interface AppDelegate : FlutterAppDelegate <UIApplicationDelegate, SRKDelegate, UNUserNotificationCenterDelegate>
    @property  NSMutableArray *links;
    @property (nonatomic,strong) FlutterEngine *flutterEngine;
    @property (strong, nonatomic) UIWindow *window;

@end
