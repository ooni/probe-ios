#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "TestUtility.h"
#import "Result.h"

/**
* @deprecated
* Is not possible to run a MiddleBoxesSuite anymore
* so the Header1MBViewController is not gonna be shown for new tests
*/
__deprecated
@interface Header1MBViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *headerTitle;

@end
