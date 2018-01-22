#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TestStorage.h"
#import "UIBarButtonItem+Badge.h"

@interface AboutViewController : UIViewController
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UIButton *learnMoreButton;
@property (nonatomic, strong) IBOutlet UIButton *ppButton;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;

@end
