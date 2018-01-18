#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "TestLists.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CrashlyticsDelegate> {
    NSMutableArray *links;
}

@property (strong, nonatomic) UIWindow *window;

@end

