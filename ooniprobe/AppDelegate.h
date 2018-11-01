#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <SharkORM/SharkORM.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CrashlyticsDelegate, SRKDelegate> {
    NSMutableArray *links;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *urlsList;

@end
