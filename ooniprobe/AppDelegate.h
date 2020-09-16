#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SRKDelegate, UNUserNotificationCenterDelegate> {
    NSMutableArray *links;
}

@property (strong, nonatomic) UIWindow *window;

@end
