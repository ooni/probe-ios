#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "Result.h"

@interface Header1MBViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *headerTitle;

@end
