#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SRKDelegate> {
    NSMutableArray *links;
}

@property (strong, nonatomic) UIWindow *window;

@end
