// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "PBRevealViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CrashlyticsDelegate,PBRevealViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerNotifications;

@end

