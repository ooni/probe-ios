#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "PBRevealViewController.h"
#import "TestLists.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CrashlyticsDelegate,PBRevealViewControllerDelegate> {
    NSMutableArray *links;
}

@property (strong, nonatomic) UIWindow *window;
- (void)registerNotifications;

@end

